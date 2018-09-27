//$Id: CourseTakeInEnglishAction.java,v 1.1 2012-8-1 zhouqi Exp $
/*
 *
 * KINGSTAR MEDIA SOLUTIONS Co.,LTD. Copyright c 2005-2006. All rights reserved.
 * 
 * This source code is the property of KINGSTAR MEDIA SOLUTIONS LTD. It is intended 
 * only for the use of KINGSTAR MEDIA application development. Reengineering, reproduction
 * arose from modification of the original source, or other redistribution of this source 
 * is not permitted without written permission of the KINGSTAR MEDIA SOLUTIONS LTD.
 * 
 */
/********************************************************************************
 * @author zhouqi
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * zhouqi				2012-8-1             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.web.action.course.arrange.english;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.model.Model;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.transfer.exporter.Context;
import com.ekingstar.commons.transfer.exporter.DefaultEntityExporter;
import com.ekingstar.commons.transfer.exporter.Exporter;
import com.ekingstar.commons.utils.query.QueryRequestSupport;
import com.ekingstar.eams.system.basecode.industry.CourseTakeType;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.shufe.model.course.arrange.task.CourseTake;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.course.arrange.english.CourseTakeInEnglishPropertyExtractor;
import com.shufe.service.course.election.CreditConstraintService;
import com.shufe.util.DataRealmUtils;

/**
 * 英语等级上课名单(教学班)
 * 
 * @author zhouqi
 */
public class CourseTakeInEnglishAction extends CourseTakeInEnglishInitAction {

  protected CreditConstraintService creditConstraintService;

  protected SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setCalendarDataRealm(request, hasStdTypeCollege);
    addCollection(request, "courseTakeTypes", baseCodeService.getCodes(CourseTakeType.class));
    addCollection(request, "languageAbilitys", baseCodeService.getCodes(LanguageAbility.class));
    return forward(request);
  }

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(CourseTake.class, "courseTake");
    populateConditions(request, query);
    query.join("courseTake.student", "student");
    List<Object> conditions = QueryRequestSupport.extractConditions(request, Student.class, "student", null);
    if (CollectionUtils.isNotEmpty(conditions)) {
      query.add(conditions);
    }
    // 为了能力获取前台的查询条件故而如此，而且由于一条记录一个教学任务，故如此不会重复
    query.join("courseTake.task", "task");
    Boolean statMode = getBoolean(request, "statMode");
    query.add(new Condition("exists (from task.requirement.languageAbilities ability where ability "
        + (null == statMode || BooleanUtils.isTrue(statMode) ? "" : "!")
        + "= courseTake.student.languageAbility)"));
    String adminClassName = get(request, "adminClassName");
    if (StringUtils.isNotBlank(adminClassName)) {
      query
          .add(new Condition(
              "exists (from student.adminClasses adminClass where adminClass.name like '%' || :adminClassName || '%')",
              adminClassName));
    }
    Long languageAbilityId = getLong(request, "languageAbilityId");
    if (null != languageAbilityId) {
      query
          .add(new Condition("courseTake.student.languageAbility.id = :languageAbilityId", languageAbilityId));
    }
    DataRealmUtils.addDataRealms(query, new String[] { "student.type.id", "task.arrangeInfo.teachDepart" },
        getDataRealmsWith(getLong(request, "courseTake.student.type.id"), request));
    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(get(request, "orderBy")));
    addCollection(request, "courseTakes", utilService.search(query));
    return forward(request);
  }

  public ActionForward validStudentSearch(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    // 访问该方法的来源
    String source = get(request, "source");
    if (StringUtils.equals(source, "index")) {
      // 统计未“指定”的学生和每个学生对应未“指定”的课程
      validStudentSearchFromIndex(request);
    } else if (StringUtils.equals(source, "vacancyStat")) {
      // 统计教学班未选满的教学任务
      validStudentSearchFromVacancyStat(request);
    }
    addSingleParameter(request, "thisObject", this);
    return forward(request, "validStudentList");
  }

  /**
   * 统计未“指定”的学生和每个学生对应未“指定”的课程
   * 
   * @param request
   */
  public void validStudentSearchFromIndex(HttpServletRequest request) {
    Long calendarId = getLong(request, "courseTake.task.calendar.id");
    if (null == calendarId) {
      calendarId = getLong(request, "calendarId");
    }

    EntityQuery query = buildQueryInValidStudents(request);
    // 找出等级匹配而没有被选过的教学任务
    query
        .add(new Condition(
            "exists (from TeachTask allTask join allTask.requirement.languageAbilities languageAbility where languageAbility = student.languageAbility and not exists (from CourseTake take where take.student=student and take.task.calendar=allTask.calendar and take.task.course=allTask.course) and allTask.calendar.id = :calendarId)",
            calendarId));
    query.setLimit(getPageLimit(request));
    query.setOrders(OrderUtils.parser(get(request, "orderBy")));
    addCollection(request, "validStudents", utilService.search(query));

    addCollection(request, "realmDeparts", getDeparts(request));
    addSingleParameter(request, "calendarId", calendarId);
  }

  /**
   * 统计出未选上的课程（未选）
   * 
   * @param student
   * @param calendarId
   * @param realmDeparts
   * @return
   */
  public Collection<Course> noTakeCourseFind(Student student, Long calendarId, Collection<Object> realmDeparts) {
    return takeObjectFind(Course.class, student, calendarId, realmDeparts, false);
  }

  /**
   * 统计出未选上的教学任务（未选）
   * 
   * @param student
   * @param calendarId
   * @param realmDeparts
   * @return
   */
  public Collection<TeachTask> noTakeTaskFind(Student student, Long calendarId,
      Collection<Object> realmDeparts) {
    return takeObjectFind(TeachTask.class, student, calendarId, realmDeparts, false);
  }

  /**
   * 统计出未选或已选的课程或教学任务
   * 
   * @param <T>
   * @param clazz
   *          “课程－教学任务”标志
   * @param student
   *          只针对某个学生；若null，则为所有学生
   * @param calendarId
   * @param realmDeparts
   * @param isTake
   *          是否已选
   * @return
   */
  public <T> Collection<T> takeObjectFind(Class<T> clazz, Student student, Long calendarId,
      Collection<Object> realmDeparts, boolean isTake) {
    T obj = (T) Model.context.getEntityType(clazz).newInstance();

    EntityQuery query = new EntityQuery(TeachTask.class, "task");
    query.setFrom("from Student std,TeachTask task join task.requirement.languageAbilities ability");
    if (obj instanceof Course) {
      query.setSelect("distinct task.course");
    } else {
      query.setSelect("task");
    }
    query.add(new Condition("task.calendar.id = :curCalendarId", calendarId));
    query.add(new Condition("task.arrangeInfo.teachDepart in (:departments)", realmDeparts));
    // 所有学生，还是指定学生
    if (null == student) {
      query.add(new Condition("ability=std.languageAbility", student));
    } else {
      query.add(new Condition("ability=std.languageAbility and std=(:student)", student));
    }
    String hql = " exists (from CourseTake take where take.student=std and take.task.course=task.course and take.task.calendar=task.calendar)";
    if (isTake) {
      query.add(new Condition(hql));
    } else {
      query.add(new Condition("not " + hql));
    }
    query.add(new Condition("exists (from task.arrangeInfo.activities activity)"));
    return utilService.search(query);
  }

  /**
   * 查询某位学生未被“指定”的具体信息
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward validStudentInfo(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Student student = (Student) utilService.get(Student.class, getLong(request, "studentId"));
    addSingleParameter(request, "student", student);
    addCollection(request, "noTakeCourses",
        noTakeCourseFind(student, getLong(request, "calendarId"), getDeparts(request)));
    return forward(request);
  }

  /**
   * 列出当前某位学生可添加的教学任务（在“未选名单”页面中，点击“指定任务”，可入此）
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward addTake(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    // 当前某位学生
    Student student = (Student) utilService.get(Student.class, getLong(request, "studentId"));
    addSingleParameter(request, "student", student);

    Collection<Object> realmDeparts = getDeparts(request);
    // 当前可“指定”的教学任务
    Collection<TeachTask> noTakeTasks = noTakeTaskFind(student, getLong(request, "calendarId"), realmDeparts);
    // 过滤掉教学班人数已满、上课冲突的教学任务
    for (int i = 0; i < noTakeTasks.size(); i++) {
      TeachTask task = (TeachTask) noTakeTasks.toArray()[i];
      Integer maxStdCount = task.getTeachClass().getPlanStdCount();
      if (task.getTeachClass().getCourseTakes().size() >= (null == maxStdCount ? 0 : maxStdCount.intValue())
          || isConfictedActivityInStudent(student, task, null, realmDeparts)) {
        noTakeTasks.remove(task);
      }
    }
    addCollection(request, "noTakeTasks", noTakeTasks);

    addCollection(request, "realmDeparts", getDeparts(request));
    addSingleParameter(request, "calendar",
        teachCalendarService.getTeachCalendar(getLong(request, "calendarId")));
    // 让页面可以调用本Action的方法
    addSingleParameter(request, "thisObject", this);
    return forward(request);
  }

  /**
   * 保存“指定”上课名单
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward addTakeSave(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Student student = (Student) utilService.get(Student.class, getLong(request, "studentId"));
    TeachTask task = (TeachTask) utilService.get(TeachTask.class, getLong(request, "taskId"));

    // 保存前再次查询一次当前的教学任务的有效性，防止在“指定”后的瞬间有变
    if (task.getTeachClass().getCourseTakes().size() >= task.getTeachClass().getPlanStdCount().intValue()
        || isConfictedActivityInStudent(student, task, null, getDeparts(request))) { return redirect(request,
        "addTake", "info.action.failure", "&studentId=" + student.getId() + "&calendarId="
            + task.getCalendar().getId()); }

    // 保存“指定”上课名单
    Collection<CourseTake> takes = new ArrayList<CourseTake>();
    CourseTakeType takeType = new CourseTakeType();
    takeType.setId(new Long(CourseTakeType.USE));
    takes.add(new CourseTake(task, student, takeType));
    utilService.saveOrUpdate(takes);
    return redirect(request, "validStudentSearch", "info.action.success");
  }

  /**
   * 找到已选的教学任务
   * 
   * @param student
   * @param calendarId
   * @param realmDeparts
   * @return
   */
  public Collection<TeachTask> takeTaskFind(Student student, Long calendarId, Collection<Object> realmDeparts) {
    return takeObjectFind(TeachTask.class, student, calendarId, realmDeparts, true);
  }

  /**
   * 教学班不满统计
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward vacancyStat(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long calendarId = getLong(request, "courseTake.task.calendar.id");
    if (null == calendarId) {
      calendarId = getLong(request, "calendarId");
    }
    // 找出指定学期所有学生所选过的教学任务
    Collection<TeachTask> tasks = takeTaskFind(null, calendarId, getDeparts(request));
    // 去除教学班人数已满的教学任务
    for (int i = 0; CollectionUtils.isNotEmpty(tasks) && i < tasks.size();) {
      TeachTask task = (TeachTask) tasks.toArray()[i];
      Integer maxStdCount = task.getTeachClass().getPlanStdCount();
      if (task.getTeachClass().getCourseTakes().size() >= (null == maxStdCount ? 0 : maxStdCount.intValue())) {
        tasks.remove(task);
      } else {
        i++;
      }
    }
    addCollection(request, "tasks", tasks);
    return forward(request);
  }

  /**
   * 统计教学班未选满的教学任务
   * 
   * @param request
   */
  public void validStudentSearchFromVacancyStat(HttpServletRequest request) {
    TeachTask task = (TeachTask) utilService.get(TeachTask.class, getLong(request, "taskId"));
    addSingleParameter(request, "task", task);

    EntityQuery query = buildQueryInValidStudents(request);
    StringBuilder hql = new StringBuilder();
    hql.append("exists (");
    hql.append("  from TeachTask task where task = :task");
    hql.append("    and not exists (");
    hql.append("              from task.arrangeInfo.activities activity");
    hql.append("             where exists (");
    hql.append("                     from CourseTake take");
    hql.append("                    where take.student = student");
    hql.append("                      and exists (");
    hql.append("                            from take.task taskInTake");
    hql.append("                           where taskInTake.calendar = task.calendar");
    hql.append("                             and exists (");
    hql.append("                                   from taskInTake.arrangeInfo.activities activityInTake");
    hql.append("                                  where activity.time.year = activityInTake.time.year");
    hql.append("                                    and activity.time.weekId = activityInTake.time.weekId");
    hql.append("                                    and bitand (activity.time.validWeeksNum, activityInTake.time.validWeeksNum) > 0");
    hql.append("                                    and activity.time.startUnit <= activityInTake.time.endUnit");
    hql.append("                                    and activity.time.endUnit >= activityInTake.time.startUnit");
    hql.append("                                 )");
    hql.append("                          )");
    hql.append("                   )");
    hql.append("        )");
    hql.append(")");

    Condition condition = new Condition();
    condition.setContent(hql.toString());
    condition.addValue(task);
    query.add(condition);

    query.setLimit(getPageLimit(request));
    query.setOrders(OrderUtils.parser(get(request, "orderBy")));

    addCollection(request, "validStudents", utilService.search(query));
  }

  /**
   * 添加指定的学生到指定的教学任务中
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward addStudent(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TeachTask task = (TeachTask) utilService.get(TeachTask.class, getLong(request, "taskId"));
    Collection<Student> students = utilService.load(Student.class, "id",
        SeqStringUtil.transformToLong(get(request, "studentIds")));

    Collection<CourseTake> takes = new ArrayList<CourseTake>();
    CourseTakeType takeType = new CourseTakeType();
    takeType.setId(new Long(CourseTakeType.USE));
    for (Student student : students) {
      takes.add(new CourseTake(task, student, takeType));
    }
    utilService.saveOrUpdate(takes);
    return redirect(request, "vacancyStat", "info.action.success");
  }

  /**
   * 某任务的上课名单
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward courseTakeSearch(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TeachTask task = (TeachTask) utilService.get(TeachTask.class, getLong(request, "taskId"));
    addSingleParameter(request, "task", task);

    EntityQuery query = new EntityQuery(CourseTake.class, "take");
    query.add(new Condition("take.task = :task", task));
    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(get(request, "orderBy")));
    addCollection(request, "takes", utilService.search(query));
    return forward(request, "courseTakeList");
  }

  /**
   * 初始化前确认页面
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward initConfirm(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    // 当前要“初始化”的教学日历
    TeachCalendar calendar = teachCalendarService.getTeachCalendar(getLong(request, "calendarId"));

    // 准备(统计)要“初始化”的学生
    Collection<Student> students = validStudentsInInit(request, calendar);
    if (CollectionUtils.isEmpty(students)) { return redirect(request, "search", "info.onData.action.failure"); }
    // 准备(统计)要“初始化”的教学任务
    Collection<TeachTask> allTasks = taskInEnglish(request, calendar, getDeparts(request));
    if (CollectionUtils.isEmpty(allTasks)) { return redirect(request, "search", "info.onData.action.failure"); }

    // 输出页面上需要显示的信息
    addSingleParameter(request, "calendar", calendar);
    addCollection(request, "students", students);
    addCollection(request, "allTasks", allTasks);
    return forward(request);
  }

  protected Exporter getExporter(HttpServletRequest request, Context context) {
    Collection datas = (Collection) context.getDatas().get("items");
    Exporter exporter = new DefaultEntityExporter();
    ((DefaultEntityExporter) exporter).setAttrs(StringUtils.split(getExportKeys(request), ","));
    ((DefaultEntityExporter) exporter).setPropertyExtractor(new CourseTakeInEnglishPropertyExtractor(
        getLocale(request), getResources(request)));
    return exporter;
  }

  @Override
  protected Collection getExportDatas(HttpServletRequest request) {
    String content = get(request, "content");
    String[] contents = StringUtils.split(content, "|");

    Collection<Object[]> datas = new ArrayList<Object[]>();
    for (int i = 0; i < contents.length; i++) {
      String[] values = StringUtils.split(contents[i], "_");
      datas.add(new Object[] { utilService.get(Student.class, new Long(values[0])),
          1 == values.length ? null : utilService.get(TeachTask.class, new Long(values[1])) });
    }
    return datas;
  }

  /**
   * 寻找有效或无效的教学任务
   * 
   * @param student
   * @param curTask
   * @param tasksInStudent
   *          指定学期的历史上课教学任务（可以是过程中产生的），若为 null (区别于“空集合”)，则视为针对所有教学任务
   * @param isValid
   *          有效:true，无效:false
   * @param realmDeparts
   *          TODO
   * @return
   */
  protected Collection<TeachTask> validTaskFind(Student student, TeachTask curTask,
      Set<TeachTask> tasksInStudent, boolean isValid, Collection<Object> realmDeparts) {
    EntityQuery query = new EntityQuery(TeachTask.class, "validTask");
    // 指定要查询教学任务的教学日历
    query.add(new Condition("validTask.calendar = :curCalendarInTask", curTask.getCalendar()));
    // 找出可“指定”的教学任务（即，有效）
    if (isValid || null == curTask.getId() || null == tasksInStudent) {
      // 这些任务必须是权限范围的教学任务
      query.add(new Condition("validTask.arrangeInfo.teachDepart in (:departments)", realmDeparts));
      // 如果 isValid 为 true ，表示要找出所有指定学期有效的教学任务
      if (isValid) {
        query
            .add(new Condition(
                "not exists (from validTask.teachClass.courseTakes take) or not exists (from validTask.teachClass.courseTakes take where take.student = :student)",
                student));
        query.add(new Condition(
            "exists (from validTask.requirement.languageAbilities ability where ability = :languageAbility)",
            student.getLanguageAbility()));
        query
            .add(new Condition(
                "not exists (from CourseTake take where exists (from take.task task_ where task_.calendar = validTask.calendar and task_.course = validTask.course) and take.task != :validTask)",
                curTask));
      } else if (null != curTask.getId()) {
        // 如果为 false ，则表示以 curTask 为中心
        query.add(new Condition("validTask = :validTask", curTask));
      }
      // 或者所有教学任务(如果 isValid 为 false )
    } else {
      // 找出当前学期是否存在有无效的教学任务
      // 为空（非 null ）时，表示仅仅从数据库中查找——当前学期的上课情况
      if (CollectionUtils.isEmpty(tasksInStudent)) {
        query.add(new Condition(
            "exists (from validTask.teachClass.courseTakes take where take.student = :student)", student));
      } else {
        // 否则，表示除了从数据库中查找——当前学期的上课情况，还要包括已经有确定了上课情况
        query
            .add(new Condition(
                "exists (from validTask.teachClass.courseTakes take where take.student = :student) or validTask in (:validTasks)",
                student, tasksInStudent));
      }
    }
    // 必须是“已排课”的教学任务
    query.add(new Condition("exists (from validTask.arrangeInfo.activities validActivity)"));

    // 查找出有上课冲突或无上课冲突的教学任务
    StringBuilder hql = new StringBuilder();
    // isValid 为 true 时，表示无上课冲突的任务
    if (isValid) {
      hql.append("not exists (");
    } else {
      hql.append("exists (");
    }
    hql.append("      from validTask.arrangeInfo.activities activity");
    hql.append("     where exists (");
    hql.append("             from TeachTask taskInTake");
    hql.append("            where taskInTake.calendar = validTask.calendar");
    // 但不包括当前教学任务 curTask
    if (null != curTask.getId()) {
      hql.append("              and taskInTake != :curTask");
    }
    hql.append("              and exists (");
    hql.append("                    from taskInTake.teachClass.courseTakes take");
    hql.append("                   where take.student = :student");
    hql.append("                  )");
    hql.append("              and exists (");
    hql.append("                    from taskInTake.arrangeInfo.activities activityInTake");
    hql.append("                     where activity.time.year = activityInTake.time.year");
    hql.append("                       and activity.time.weekId = activityInTake.time.weekId");
    hql.append("                       and bitand (activity.time.validWeeksNum, activityInTake.time.validWeeksNum) > 0");
    hql.append("                       and activity.time.startUnit <= activityInTake.time.endUnit");
    hql.append("                       and activity.time.endUnit >= activityInTake.time.startUnit");
    hql.append("                  )");
    hql.append("           )");
    hql.append(")");
    Condition condition = new Condition();
    condition.setContent(hql.toString());
    if (null != curTask.getId()) {
      condition.addValue(curTask);
    }
    condition.addValue(student);
    query.add(condition);
    return utilService.search(query);
  }

  /**
   * 检查某学生当前将被分配的任务，与“指定学期的历史上课教学任务”和“刚新分配的教学任务”是否存在冲突
   * 
   * @param student
   *          TODO
   * @param curTask
   *          当前某个学生将被分配的教学任务
   * @param tasksInStudent
   *          当前的这个学生已初分配的教学任务
   * @param realmDeparts
   *          TODO
   * @return
   */
  protected boolean isConfictedActivityInStudent(Student student, TeachTask curTask,
      Set<TeachTask> tasksInStudent, Collection<Object> realmDeparts) {
    try {
      return CollectionUtils.isNotEmpty(validTaskFind(student, curTask, tasksInStudent, false, realmDeparts));
    } catch (Exception e) {
      e.printStackTrace();
      throw new RuntimeException();
    }
  }

  /**
   * 添加处理异常的情况
   * 
   * @param invalidObjects
   * @param takesInTaskMap
   *          TODO
   * @param student
   * @param task
   * @param takesInTask
   *          TODO
   * @param isConflicted
   * @param isOver
   */
  protected void addInvalidObject(List<Map<String, Object>> invalidObjects,
      Map<String, Set<Map<String, Object>>> takesInTaskMap, Student student, TeachTask task,
      Set<CourseTake> takesInTask, boolean isConflicted, boolean isOver) {
    // 先暂存对象的ID，待使用输出时转换成对应实体
    Map<String, Object> outSideMap = new HashMap<String, Object>();
    StringBuilder key = new StringBuilder();
    outSideMap.put("student", student.getId());
    key.append(outSideMap.get("student"));
    outSideMap.put("task", task.getId());
    key.append("_").append(task.getCourse().getId());
    outSideMap.put("takesInTaskSize", new Integer(null == takesInTask ? 0 : takesInTask.size()));
    outSideMap.put("isConflicted", isConflicted);
    outSideMap.put("isOver", isOver);
    Set<Map<String, Object>> takesInTasks = takesInTaskMap.get(key.toString());
    if (null == takesInTasks) {
      takesInTasks = new HashSet<Map<String, Object>>();
      takesInTaskMap.put(key.toString(), takesInTasks);
    }
    takesInTasks.add(outSideMap);
    invalidObjects.add(outSideMap);
  }

  /**
   * 准备可转换学生的教学任务（教学班）
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward changeTake(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] takeIds = SeqStringUtil.transformToLong(get(request, "courseTakeIds"));

    // 当前将要“转移”前的上课名单
    EntityQuery query = new EntityQuery(CourseTake.class, "take");
    query.add(new Condition("take.id in (:takeIds)", takeIds));
    Collection<CourseTake> takes = utilService.search(query);
    // 当前将要“转移”前上课名单的学生
    query.setSelect("distinct take.student");
    Collection<Student> students = utilService.search(query);

    // 开始组装搭配对应可“转移”的教学任务
    Collection<Map<String, Object>> tasksInStudents = new ArrayList<Map<String, Object>>();

    Collection realmDeparts = getDeparts(request);
    Set<Department> departs = new HashSet<Department>(realmDeparts);

    for (CourseTake take : takes) {
      Map<String, Object> tasksInStudent = new HashMap<String, Object>();
      tasksInStudent.put("take", take);
      Collection<TeachTask> tasks = validTaskFind(take.getStudent(), take.getTask(), null, true, realmDeparts);
      if (CollectionUtils.isNotEmpty(tasks)) {
        for (int i = 0; CollectionUtils.isNotEmpty(tasks) && i < tasks.size();) {
          TeachTask task = (TeachTask) tasks.toArray()[i];
          Integer maxStdCount = task.getTeachClass().getPlanStdCount();
          if (task.getTeachClass().getCourseTakes().size() + students.size() >= (null == maxStdCount ? 0
              : maxStdCount.intValue()) || !departs.contains(task.getArrangeInfo().getTeachDepart())) {
            tasks.remove(task);
          } else {
            i++;
          }
        }
      }
      tasksInStudent.put("tasks", tasks);
      tasksInStudents.add(tasksInStudent);
    }

    // 如何有多个学生，则取他们的交集
    if (CollectionUtils.size(tasksInStudents) > 1) {
      Map<String, Object> preDatas = (Map<String, Object>) tasksInStudents.toArray()[0];
      Collection<TeachTask> preTasks = (Collection<TeachTask>) preDatas.get("tasks");
      for (int i = 1; i < tasksInStudents.size(); i++) {
        Map<String, Object> currDatas = (Map<String, Object>) tasksInStudents.toArray()[i];
        Collection<TeachTask> currTasks = (Collection<TeachTask>) currDatas.get("tasks");

        Collection<TeachTask> results = CollectionUtils.union(preTasks, currTasks);
        // 如果交集后为“空集”，则清空这集合
        preTasks.clear();
        currTasks.clear();
        // 否则将“交集”结果插入这两个集合中
        if (CollectionUtils.isNotEmpty(results)) {
          preTasks.addAll(results);
          currTasks.addAll(results);
        }

        // 准备下一次循环
        preTasks = currTasks;
      }
    }

    addCollection(request, "tasksInStudents", tasksInStudents);

    return forward(request);
  }

  /**
   * 保存“转移”后的结果
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward changeTakeSave(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TeachTask task = (TeachTask) utilService.get(TeachTask.class, getLong(request, "taskId"));
    Collection<CourseTake> takes = utilService.load(CourseTake.class, "id",
        SeqStringUtil.transformToLong(get(request, "takeIds")));

    Set<Object> results = new HashSet<Object>();
    int takeSize = -1;
    // 修读类别：指定
    CourseTakeType takeType = new CourseTakeType();
    takeType.setId(new Long(CourseTakeType.USE));
    // 过滤生成重复上课记录的学生
    Set<Student> filterStds = new HashSet<Student>();
    for (CourseTake take : takes) {
      // 退掉之前所上的课
      TeachTask preTask = take.getTask();
      preTask.getTeachClass().getCourseTakes().remove(take);
      preTask.getTeachClass().decStdCount();
      results.add(preTask);
      if (filterStds.contains(take.getStudent())) {
        continue;
      }
      if (0 < takeSize || takeSize > preTask.getTeachClass().getCourseTakes().size()) {
        takeSize = preTask.getTeachClass().getCourseTakes().size();
      }
      // 重新指定要“转移”的课程
      results.add(new CourseTake(task, take.getStudent(), takeType));
      task.getTeachClass().setStdCount(new Integer(task.getTeachClass().getStdCount().intValue() + 1));
      // 保存已经被“指定”了的学生，不再重复“指定”
      filterStds.add(take.getStudent());
    }
    // 退课
    utilService.remove(takes);
    // 选课和更新选退课人数
    utilService.saveOrUpdate(results);

    String path = get(request, "path");
    if (StringUtils.isBlank(path)) {
      path = "search";
    } else if (StringUtils.equals(path, "courseTakeSearch")) {
      // 如果在“转移”后，发生之前被退课的课程(即，教学任务)所有的上课学生为空时，则跳转到“教学班不满统计”
      if (takeSize <= 0) {
        path = "vacancyStat";
      }
    }
    return redirect(request, path, "info.action.success");
  }

  /**
   * 删除上课名单
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward changeTakeRemove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String path = get(request, "path");
    Collection<CourseTake> takes = utilService.load(CourseTake.class, "id",
        SeqStringUtil.transformToLong(get(request, "courseTakeIds")));
    Set<TeachTask> tasks = new HashSet<TeachTask>();
    for (CourseTake take : takes) {
      TeachTask task = take.getTask();
      task.getTeachClass().setStdCount(new Integer(task.getTeachClass().getStdCount().intValue() - 1));
      tasks.add(task);
    }

    if (StringUtils.isBlank(path)) {
      path = "search";
    } else if (StringUtils.equals(path, "courseTakeSearch")) {
      // 如果在“转移”后，发生之前被退课的课程(即，教学任务)所有的上课学生为空时，则跳转到“教学班不满统计”
      takes.iterator().next().getTask().getTeachClass().getCourseTakes().removeAll(takes);
      if (takes.iterator().next().getTask().getTeachClass().getCourseTakes().size() <= 0) {
        path = "vacancyStat";
      }
    }
    utilService.saveOrUpdate(tasks);
    utilService.remove(takes);
    return redirect(request, path, "info.action.success");
  }

  public void setCreditConstraintService(CreditConstraintService creditConstraintService) {
    this.creditConstraintService = creditConstraintService;
  }
}
