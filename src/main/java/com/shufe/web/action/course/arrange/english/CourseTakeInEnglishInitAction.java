//$Id: CourseTakeInEnglishInitAction.java,v 1.1 2012-10-16 zhouqi Exp $
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
 * zhouqi				2012-10-16             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.web.action.course.arrange.english;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.eams.system.basecode.industry.CourseTakeType;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.ekingstar.eams.system.time.TimeUnit;
import com.shufe.model.course.arrange.task.CourseActivity;
import com.shufe.model.course.arrange.task.CourseTake;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.web.OutputMessage;
import com.shufe.web.OutputWebObserver;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;

/**
 * 上课名单“初始化”(为了维护方便，将一个Action拆成两个)
 * 
 * @author zhouqi
 */
public class CourseTakeInEnglishInitAction extends CalendarRestrictionSupportAction {

  /** 所有上课名单的“修读类别”为“指定” */
  protected CourseTakeType USE_COURSE_TAKE_TYPE = new CourseTakeType(new Long(CourseTakeType.USE));

  /**
   * 初始化上课名单
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward init(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    // String params = get(request, "params");

    TeachCalendar calendar = teachCalendarService.getTeachCalendar(getLong(request, "calendarId"));

    // 准备要“初始化”的学生
    Collection<Student> students = validStudentsInInit(request, calendar);
    // 如果没有符合条件学生，则不用处理了
    if (CollectionUtils.isEmpty(students)) { return redirect(request, "search", "info.onData.action.failure"); }
    // 准备要“初始化”的教学任务
    Collection<TeachTask> allTasks = taskInEnglish(request, calendar, getDeparts(request));
    // 同样，如果没有符合条件学生对应的有效教学任务，则也不用处理了
    if (CollectionUtils.isEmpty(allTasks)) { return redirect(request, "search", "info.onData.action.failure"); }

    // 准备开始处理
    MessageResources resources = getResources(request);
    Locale locale = getLocale(request);
    CourseTakeInEnglishProcessObserver ob = (CourseTakeInEnglishProcessObserver) getOutputProcessObserver(
        mapping, request, response, CourseTakeInEnglishProcessObserver.class);

    // 准备处理过程要保存结果的存储器
    Set<CourseTake> takes = new HashSet<CourseTake>();
    // 开始处理
    initProcess(resources, locale, ob, calendar, students, allTasks, takes);
    // Map<String, String> invalidObjects = initProcess(resources, locale, ob, calendar,
    // students,
    // allTasks, takes);

    // 准备结束处理进度
    // if (CollectionUtils.isNotEmpty(takes) && MapUtils.isEmpty(invalidObjects)) {
    // String caption = "处理成功结束";
    // ob.outputNotify(OutputWebObserver.warnning, new OutputMessage("", caption), true);
    // ob.outputCaption(caption);
    // builderParamsInPage(params, ob, calendar, "search", "info.action.success");
    // } else {
    // if (CollectionUtils.isEmpty(takes) && MapUtils.isEmpty(invalidObjects)) {
    // String caption = "没有可以保存的数据，准备退出";
    // ob.outputNotify(OutputWebObserver.warnning, new OutputMessage("", caption), true);
    // ob.outputCaption(caption);
    // builderParamsInPage(params, ob, calendar, "search", "info.action.failure");
    // } else {
    // request.getSession().setAttribute("outSideObjs_" + getUserId(request.getSession()),
    // invalidObjects);
    // if (CollectionUtils.isEmpty(takes)) {
    // ob.outputNotify(OutputWebObserver.warnning,
    // new OutputMessage("", "正在收集处理的结果，请勿手动切换页面"), true);
    // ob.outputCaption("正在收集处理的结果，请勿其他操作待响应");
    // builderParamsInPage(params, ob, calendar, "conflictReason",
    // "info.action.failure");
    // } else {
    // ob.outputCaption("保存成功，正收集处理结果中，请勿其他操作待响应");
    // builderParamsInPage(params, ob, calendar, "conflictReason",
    // "info.action.conflict");
    // }
    // }
    // }
    ob.outputNotify(OutputWebObserver.warnning, new OutputMessage("", "初始化处理结束！"), true);

    // 处理结束
    ob.outputNotify("</html>");
    response.getWriter().flush();
    response.getWriter().close();
    return null;
  }

  /**
   * 从系统中查出设有等级的在籍在校学生
   * 
   * @param request
   * @return
   */
  protected Collection<Student> validStudentsInInit(HttpServletRequest request, TeachCalendar calendar) {
    EntityQuery query = buildQueryInValidStudents(request);
    query
        .add(new Condition(
            "exists (from TeachTask allTask join allTask.requirement.languageAbilities languageAbility where languageAbility = student.languageAbility and not exists (from CourseTake take where take.student=student and take.task.calendar=allTask.calendar and take.task.course=allTask.course) and allTask.calendar.id = :calendarId)",
            calendar.getId()));
    return utilService.search(query);
  }

  /**
   * 找出“有效”（等级匹配、在籍在校）且符合查询条件的学生
   * 
   * @param request
   * @return
   */
  protected EntityQuery buildQueryInValidStudents(HttpServletRequest request) {
    EntityQuery stdQuery = new EntityQuery(Student.class, "student");
    populateConditions(request, stdQuery);
    stdQuery.add(new Condition("student.inSchool = true"));
    stdQuery.add(new Condition("student.active = true"));
    stdQuery.add(new Condition("student.languageAbility is not null"));
    stdQuery.add(new Condition("student.type in (:stdTypes)", getStdTypes(request)));
    stdQuery.join("student.adminClasses", "adminClass");
    String adminClassName = get(request, "adminClassName");
    if (StringUtils.isNotBlank(adminClassName)) {
      stdQuery.add(new Condition("adminClass.name like  :adminClassName", "%" + adminClassName + "%"));
    }

    stdQuery.addOrder(OrderUtils.parser("adminClass.code,student.code"));
    return stdQuery;
  }

  /**
   * 获取全部设有“语言熟练能力”的已排课教学任务
   * 
   * @param request
   * @param calendar
   * @param realmDeparts
   * @return
   */
  protected Collection<TeachTask> taskInEnglish(HttpServletRequest request, TeachCalendar calendar,
      Collection<Object> realmDeparts) {
    EntityQuery query = new EntityQuery(TeachTask.class, "task");
    populateConditions(request, query);
    query.add(new Condition("task.calendar = :calendar", calendar));
    query.add(new Condition("exists (from task.arrangeInfo.activities activity)"));
    query.add(new Condition("exists (from task.requirement.languageAbilities languageAbility)"));
    if (CollectionUtils.isEmpty(realmDeparts)) {
      query.add(new Condition("task is null"));
    } else {
      query.add(new Condition("task.arrangeInfo.teachDepart in (:departments)", realmDeparts));
    }
    String adminClassName = get(request, "adminClassName");
    if (StringUtils.isNotBlank(adminClassName)) {
      query
          .add(new Condition(
              "exists (from task.teachClass.adminClasses adminClass where adminClass.name like '%' || :adminClassName || '%')",
              adminClassName));
    }
    Long languageAbilityId = getLong(request, "languageAbilityId");
    if (null != languageAbilityId) {
      query
          .add(new Condition(
              "exists (from task.requirement.languageAbilities languageAbility where languageAbility.id = :languageAbilityId)",
              languageAbilityId));
    }
    return utilService.search(query);
  }

  /**
   * 在“初始化分配”进度结束后的跳转
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward continueInit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    return redirect(request, get(request, "toMethod"), get(request, "msg"));
  }

  /**
   * 初始化之主体处理过程
   * 
   * @param resources
   *          TODO
   * @param locale
   *          TODO
   * @param ob
   * @param students
   * @param takes
   * @param groupInTaskMap
   * @return
   */
  protected void initProcess(MessageResources resources, Locale locale,
      CourseTakeInEnglishProcessObserver ob, TeachCalendar calendar, Collection<Student> students,
      Collection<TeachTask> tasks, Set<CourseTake> takes) {
    // 所有学生所对应有效教学任务数
    int allTaskSize = tasks.size();

    // 初始化“进程条”
    ob.notifyStart("开始初始化分配(<span style=\"color:red;font-weight:bold\">当前页面切勿擅自切换以免异常</span>)",
        students.size() * allTaskSize * 2 + 8, null);
    ob.outputNotify(OutputWebObserver.good, new OutputMessage("", "读取教学日历"), true);
    ob.outputNotify(OutputWebObserver.good, new OutputMessage("", "找出符合条件的学生"), true);

    // 按“语言熟练能力”分组的教学任务
    ob.outputNotify(OutputWebObserver.good, new OutputMessage("", "准备所有学生可分配的教学任务，并按“语言熟练能力”分组"), true);
    Map<LanguageAbility, Collection<TeachTask>> groupInTaskMap = groupInEnglishTask(resources, locale, tasks);
    ob.outputNotify(OutputWebObserver.good, new OutputMessage("", "“语言熟练能力”分组结束"), true);

    ob.outputNotify(OutputWebObserver.good, new OutputMessage("", "开始分配处理..."), true);

    // 记录本次初始化的上课情况
    Map<Student, Set<Course>> coursesInStudents = new HashMap<Student, Set<Course>>();
    // 正式进入处理过程
    ob.outputNotify(OutputWebObserver.good, new OutputMessage("", "首先开始以教学班为单位进行分配..."), true);
    // Map<String, String> invalidObjects = new HashMap<String, String>();
    // 按教学班以学号升序“初始化”上课名单
    initCase(resources, locale, ob, calendar, students, allTaskSize, groupInTaskMap, coursesInStudents,
        takes, true);

    ob.outputNotify(OutputWebObserver.good, new OutputMessage("", "开始以行政班为单位进行分配..."), true);
    // 按行政班以学号升序“初始化”上课名单
    initCase(resources, locale, ob, calendar, students, allTaskSize, groupInTaskMap, coursesInStudents,
        takes, false);
  }

  /**
   * 按指定方式(isTeachClassCase)“初始化”上课名单
   * 
   * @param resources
   * @param locale
   * @param ob
   * @param calendar
   * @param students
   * @param allTaskSize
   * @param groupInTaskMap
   * @param coursesInStudents
   * @param takes
   * @param isTeachClassCase
   *          是否“教学班”方式
   */
  protected void initCase(MessageResources resources, Locale locale, CourseTakeInEnglishProcessObserver ob,
      TeachCalendar calendar, Collection<Student> students, int allTaskSize,
      Map<LanguageAbility, Collection<TeachTask>> groupInTaskMap,
      Map<Student, Set<Course>> coursesInStudents, Set<CourseTake> takes, boolean isTeachClassCase) {
    // 进行逐个处理
    int stdCount = 0;
    for (Student student : students) {
      // 开始处理第 i 个学生
      stdCount++;
      // 按第 i 个学生“语言熟练能力”，找出对应的“教学任务”
      Collection<TeachTask> iAllTasks = groupInTaskMap.get(student.getLanguageAbility());

      // 如果第 i 个学生没有找到对应的“教学任务”，则中止第 i 个学生的余下处理，并通知前台
      if (CollectionUtils.isEmpty(iAllTasks)) {
        ob.outputNotify(OutputWebObserver.error,
            new OutputMessage("", "没有找到第" + stdCount + "位学生所对应符合要求的教学任务"), allTaskSize);
        // invalidObjects.put(student.getId().toString(), StringUtils.EMPTY);
        continue;
      }

      // 找出第 i 个当前正处理学期的历史上课记录
      Set<TeachTask> tasksInStudent = takesInStudent(student, calendar);
      tasksInStudent.addAll(takesInStudentWithOther(student, calendar));

      // 重复课程过滤暂存器
      Set<Course> coursesInStudent = coursesInStudents.get(student);

      // “指定”保存器
      Collection<TeachTask> toBeSaved = new ArrayList<TeachTask>();
      // 对第 i 个学生开始逐一“指定”
      for (int k = 0; k < iAllTasks.size();) {
        // 对第 i 个学生“指定”第 k 条教学任务的处理
        TeachTask task = (TeachTask) iAllTasks.toArray()[k];
        // 是否“教学班”方式
        if (isTeachClassCase) {
          // 验证当前学生是否上当前教学任务的课
          if (!isInTask(task, student)) {
            System.out.println("当前第" + stdCount + "位学生不上课程序号为 " + task.getSeqNo() + " 教学任务的课程");
            k++;
            continue;
          }
        } else {
          // 验证学生与教务任务的年级是否一致
          if (StringUtils.isNotBlank(task.getTeachClass().getEnrollTurn())
              && task.getTeachClass().getEnrollTurn().indexOf(student.getEnrollYear()) == -1) {
            k++;
            continue;
          }
        }
        // FIXME zhouqi 20120920 以下顺序不要改
        // 验证是否重复“指定”课程（相同课程的不同教学任务）
        if (hasCourseInStudentTake(task, coursesInStudent, tasksInStudent)) {
          k++;
          continue;
        }
        // 验证是否教学班学生已满
        if (CollectionUtils.size(task.getTeachClass().getCourseTakes()) >= task.getTeachClass()
            .getPlanStdCount().intValue()) {
          // 如果“已满”，下一个学生就不再需要“指定”这条教学任务了，即立即排除
          iAllTasks.remove(task);
          continue;
        }
        // 验证是否上课冲突
        if (isConflictedTask(resources, locale, task, tasksInStudent)) {
          k++;
          continue;
        }

        // 保存有效匹对成功的分配结果
        CourseTake take = new CourseTake(task, student, USE_COURSE_TAKE_TYPE);
        takes.add(take);
        task.getTeachClass().addCourseTake(take); // 当前教学任务的“实际人数”++
        task.getTeachClass().setStdCount(new Integer(task.getTeachClass().getCourseTakes().size()));
        if (null == coursesInStudent) {
          coursesInStudent = new HashSet<Course>();
          coursesInStudents.put(student, coursesInStudent);
        }
        coursesInStudent.add(task.getCourse()); // 通过“过滤器”第 i 个学生已经“指定”了这门课
        tasksInStudent.add(task); // 已经“指定”上了，当前属于“历史”选课了，故归入“历史”中
        toBeSaved.add(task); // 通过要保存当前教学任务的处理结果

        k++;
      }

      // Collection<TeachTask> invalidTasks = CollectionUtils.subtract(iAllTasks, toBeSaved);
      // 过滤掉与被“指定”成功教学任务课程相同的其它教学任务
      filterDuplicateCourseInTask(CollectionUtils.subtract(iAllTasks, toBeSaved), toBeSaved);
      // if (CollectionUtils.isNotEmpty(invalidTasks)) {
      // String taskIdSeq = "";
      // for (TeachTask task : invalidTasks) {
      // if (StringUtils.isNotBlank(taskIdSeq)) {
      // taskIdSeq += ",";
      // }
      // taskIdSeq += task.getId();
      // }
      // invalidObjects.put(student.getId().toString(), taskIdSeq);
      // }

      // 保存“指定”，结果第 i 个学生的处理
      utilService.saveOrUpdate(toBeSaved);
      ob.outputNotify(toBeSaved.size() == 0 ? OutputWebObserver.warnning : OutputWebObserver.good,
          new OutputMessage("", "第" + stdCount + "位 " + student.getCode() + " "
              + student.getLanguageAbility().getName() + " 分配了" + toBeSaved.size() + "条任务！"), allTaskSize);

    }
  }

  /**
   * 验证当前学生是否上当前教学任务的课
   * 
   * @param task
   * @param student
   * @return
   */
  protected boolean isInTask(TeachTask task, Student student) {
    if (null == task || null == student || null == task.getId() || null == student.getId()
        || null == task.getTeachClass() || CollectionUtils.isEmpty(task.getTeachClass().getAdminClasses())) { return false; }
    for (Iterator it = task.getTeachClass().getAdminClasses().iterator(); it.hasNext();) {
      AdminClass adminClass = (AdminClass) it.next();
      if (CollectionUtils.isNotEmpty(adminClass.getStudents()) && adminClass.getStudents().contains(student)) { return true; }
    }
    return false;
  }

  /**
   * 对指定的教学任务（集合）按“语言熟练能力”分组
   * 
   * @param resources
   *          TODO
   * @param locale
   *          TODO
   * @param tasks
   * @return
   */
  protected Map<LanguageAbility, Collection<TeachTask>> groupInEnglishTask(MessageResources resources,
      Locale locale, Collection<TeachTask> tasks) {
    if (CollectionUtils.isEmpty(tasks)) { return null; }
    Map<LanguageAbility, Collection<TeachTask>> taskInEnglishMap = new HashMap<LanguageAbility, Collection<TeachTask>>();
    for (TeachTask task : tasks) {
      for (LanguageAbility languageAbility : task.getRequirement().getLanguageAbilities()) {
        Collection<TeachTask> tasksInEnglish = taskInEnglishMap.get(languageAbility);
        if (null == tasksInEnglish) {
          tasksInEnglish = new ArrayList<TeachTask>();
          taskInEnglishMap.put(languageAbility, tasksInEnglish);
        }
        tasksInEnglish.add(task);
      }
    }
    return taskInEnglishMap;
  }

  /**
   * 找出指定学生在指定学期中所上课的教学任务
   * 
   * @param student
   * @param calendar
   * @return
   */
  protected Set<TeachTask> takesInStudent(Student student, TeachCalendar calendar) {
    EntityQuery query = new EntityQuery(CourseTake.class, "take");
    query.add(new Condition("take.student = :student", student));
    query.add(new Condition("take.task.calendar = :calendar", calendar));
    query.setSelect("take.task");
    return new HashSet<TeachTask>(utilService.search(query));
  }

  protected Collection<TeachTask> takesInStudentWithOther(Student student, TeachCalendar calendar) {
    Collection<TeachTask> tasks = Collections.EMPTY_LIST;
    if (!student.getAdminClasses().isEmpty()) {
      EntityQuery query1 = new EntityQuery(TeachTask.class, "task");
      query1.add(new Condition(
          "exists (from task.teachClass.adminClasses adminClass where adminClass in (:classes))", student
              .getAdminClasses()));
      query1.add(new Condition("size(task.requirement.languageAbilities)=0"));
      // query1.add(new Condition("tTask.taskGroup is not null"));
      query1.add(new Condition("task.calendar = :calendar", calendar));
      tasks = utilService.search(query1);
    }
    return tasks;
    // EntityQuery query = new EntityQuery(CourseTake.class, "take");
    // query.join("take.task", "tTask");
    // query.add(new Condition(
    // "exists (from take.student.adminClasses adminClass where exists (from tTask.teachClass.adminClasses tAdminClass where adminClass = tAdminClass and exists (from tAdminClass.students tStudent where tStudent = :student)))",
    // student));
    // query.add(new Condition("tTask.taskGroup is not null"));
    // query.add(new Condition("tTask.calendar = :calendar", calendar));
    // query.setSelect("tTask");
    // return utilService.search(query);
  }

  /**
   * 验证是否“指定”重复（指相同学期中，已经选过同代码的课程）
   * 
   * @param task
   * @param coursesInStudent
   * @param tasksInStudent
   * @return
   */
  protected boolean hasCourseInStudentTake(TeachTask task, Set<Course> coursesInStudent,
      Collection<TeachTask> tasksInStudent) {
    if (null != coursesInStudent && coursesInStudent.contains(task.getCourse())) return true;
    if (CollectionUtils.isNotEmpty(tasksInStudent)) {
      for (TeachTask taskInTake : tasksInStudent) {
        if (ObjectUtils.equals(task.getCourse(), taskInTake.getCourse())) { return true; }
      }
    }
    return false;
  }

  /**
   * 验证上课是否冲突
   * 
   * @param resources
   * @param locale
   * @param target
   * @param tasksInStudent
   * @return
   */
  protected boolean isConflictedTask(MessageResources resources, Locale locale, TeachTask target,
      Collection<TeachTask> tasksInStudent) {
    for (TeachTask taskInTake : tasksInStudent) {
      for (Iterator iterator = taskInTake.getArrangeInfo().getActivities().iterator(); iterator.hasNext();) {
        CourseActivity actvitiy = (CourseActivity) iterator.next();
        TimeUnit time = actvitiy.getTime();
        for (Iterator targetIter = target.getArrangeInfo().getActivities().iterator(); targetIter.hasNext();) {
          TimeUnit targetTime = ((CourseActivity) targetIter.next()).getTime();
          if (time.getYear().equals(targetTime.getYear()) && time.getStartUnit() <= targetTime.getEndUnit()
              && targetTime.getStartUnit() <= time.getEndUnit()
              && time.getWeekId().equals(targetTime.getWeekId())
              && (time.getValidWeeksNum() & targetTime.getValidWeeksNum()) > 0) return true;
        }
      }
    }
    return false;
  }

  /**
   * 过滤掉与被“指定”成功教学任务课程相同的其它教学任务
   * 
   * @param sTasks
   * @param dTasks
   */
  protected void filterDuplicateCourseInTask(Collection<TeachTask> sTasks, Collection<TeachTask> dTasks) {
    if (CollectionUtils.isEmpty(sTasks) || CollectionUtils.isEmpty(dTasks)) { return; }
    for (int i = 0; i < sTasks.size();) {
      TeachTask sTask = (TeachTask) sTasks.toArray()[i];
      boolean isRemoved = false;
      for (TeachTask dTask : dTasks) {
        if (ObjectUtils.equals(sTask.getCourse(), dTask.getCourse())) {
          sTasks.remove(sTask);
          isRemoved = true;
          break;
        }
      }
      if (!isRemoved) {
        i++;
      }
    }
  }

  /**
   * (暂时不用)初始化完成后需要传递的参数(params)和跳转的方法(Action的method)
   * 
   * @param params
   * @param observer
   * @param calendar
   *          TODO
   * @param toMethod
   * @param msg
   */
  @Deprecated
  protected void builderParamsInPage(String params, CourseTakeInEnglishProcessObserver observer,
      TeachCalendar calendar, String toMethod, String msg) {
    observer
        .outputNotify("<form method=\"post\" action=\"courseTakeInEnglish.do?method=continueInit\" name=\"actionForm\" target=\"_self\" onsubmit=\"return false;\">");
    observer.outputNotify("\t<input type=\"hidden\" name=\"params\" value=\"" + params + "&calendarId="
        + calendar.getId() + "\"/>");
    observer.outputNotify("\t<input type=\"hidden\" name=\"toMethod\" value=\"" + toMethod + "\"/>");
    observer.outputNotify("\t<input type=\"hidden\" name=\"msg\" value=\"" + msg + "\"/>");
    observer
        .outputNotify("\t<input type=\"hidden\" name=\"calendarId\" value=\"" + calendar.getId() + "\"/>");
    observer.outputNotify("</form>");
    observer.outputNotify("<script>document.actionForm.submit();</script>");
  }

  /**
   * (暂且不用)在“上一步”中有超出的情况，则收集起来以在页面显示此情况
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  @Deprecated
  public ActionForward conflictReason(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String sessionKey = "outSideObjs_" + getUserId(request.getSession());
    Map<String, String> invalidObjects = (Map<String, String>) request.getSession().getAttribute(sessionKey);
    if (null != invalidObjects) {
      request.getSession().removeAttribute(sessionKey);
    }

    Collection<Map<String, Object>> outSideObjects = new ArrayList<Map<String, Object>>();
    if (MapUtils.isNotEmpty(invalidObjects)) {
      for (String studentId_ : invalidObjects.keySet()) {
        Student student = (Student) utilService.get(Student.class, new Long(studentId_));

        String taskIdSeq = invalidObjects.get(studentId_);
        if (StringUtils.isBlank(taskIdSeq)) {
          Map<String, Object> outSideMap = new HashMap<String, Object>();
          outSideMap.put("student", student);
          outSideObjects.add(outSideMap);
        } else {
          Collection<TeachTask> tasks = utilService.load(TeachTask.class, "id",
              SeqStringUtil.transformToLong(taskIdSeq));

          for (TeachTask task : tasks) {
            Map<String, Object> outSideMap = new HashMap<String, Object>();
            outSideMap.put("student", student);
            outSideMap.put("task", task);
            outSideObjects.add(outSideMap);
          }
        }
      }
    }
    addCollection(request, "outSideObjects", outSideObjects);
    return forward(request);
  }
}
