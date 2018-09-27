//$Id: ElectCourseAction.java,v 1.31 2007/01/16 03:41:58 duanth Exp $
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
 * @author chaostone
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * chaostone             2005-12-12         Created
 *  
 ********************************************************************************/

package com.shufe.web.action.course.election;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.utils.web.RequestUtils;
import com.ekingstar.eams.system.basecode.industry.CourseTakeType;
import com.ekingstar.eams.system.basecode.industry.CourseType;
import com.ekingstar.eams.system.basecode.industry.StudentState;
import com.ekingstar.eams.system.basecode.industry.TeachLangType;
import com.ekingstar.eams.system.baseinfo.model.SchoolDistrict;
import com.ekingstar.eams.system.time.TimeUnit;
import com.ekingstar.eams.system.time.TimeUnitUtil;
import com.ekingstar.eams.system.time.WeekInfo;
import com.ekingstar.eams.teach.program.SubstituteCourse;
import com.ekingstar.eams.teach.program.service.SubstituteCourseService;
import com.shufe.dao.system.calendar.TermCalculator;
import com.shufe.model.Constants;
import com.shufe.model.course.arrange.CourseArrangeSwitch;
import com.shufe.model.course.arrange.resource.TimeTable;
import com.shufe.model.course.arrange.task.CourseTable;
import com.shufe.model.course.arrange.task.CourseTableSetting;
import com.shufe.model.course.election.ElectParams;
import com.shufe.model.course.election.ElectState;
import com.shufe.model.course.election.StdCreditConstraint;
import com.shufe.model.course.plan.CourseGroup;
import com.shufe.model.course.plan.PlanCourse;
import com.shufe.model.course.plan.TeachPlan;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.std.alteration.StudentAlteration;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.baseinfo.Teacher;
import com.shufe.model.system.calendar.OnCampusTime;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.course.arrange.resource.TeachResourceService;
import com.shufe.service.course.election.CreditConstraintService;
import com.shufe.service.course.election.ElectCourseService;
import com.shufe.service.course.election.ElectParamsService;
import com.shufe.service.course.grade.GradeService;
import com.shufe.service.course.plan.TeachPlanService;
import com.shufe.service.course.task.TeachTaskService;
import com.shufe.service.graduate.GraduateAuditService;
import com.shufe.service.graduate.result.CourseGroupAuditResult;
import com.shufe.service.graduate.result.TeachPlanAuditResult;
import com.shufe.service.system.calendar.TeachCalendarService;
import com.shufe.util.RequestUtil;
import com.shufe.web.action.common.DispatchBasicAction;
import com.shufe.web.action.course.arrange.task.TableTaskGroup;

import net.ekingstar.common.detail.Pagination;
import net.ekingstar.common.detail.Result;

/**
 * 学生选课界面响应类
 * 
 * @author chaostone 2005-12-14
 */
public class ElectCourseAction extends DispatchBasicAction {

  protected ElectCourseService electService;

  protected ElectParamsService paramsService;

  protected TeachCalendarService teachCalendarService;

  protected TeachCalendarService calendarService;

  protected TeachTaskService teachTaskService;

  protected TeachResourceService teachResourceService;

  protected TeachPlanService teachPlanService;

  protected CreditConstraintService creditConstraintService;

  protected TeachPlanService planService;

  protected GradeService gradeService;

  protected SubstituteCourseService substituteCourseService;

  protected GraduateAuditService graduateAuditService;

  public void setGraduateAuditService(GraduateAuditService graduateAuditService) {
    this.graduateAuditService = graduateAuditService;
  }

  public void setTeachPlanService(TeachPlanService teachPlanService) {
    this.teachPlanService = teachPlanService;
  }

  public void setTeachResourceService(TeachResourceService teachResourceService) {
    this.teachResourceService = teachResourceService;
  }

  /**
   * 选课入口
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward prompt(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ElectState state = (ElectState) request.getSession().getAttribute("electState");
    // 没有选课状态或者选课状态中的数据不是当前用户的
    if (null == state || !state.std.getStdNo().equals(getLoginName(request))) {
      Student std = getStudentFromSession(request.getSession());
      // 查找选课参数
      ElectParams params = paramsService.getAvailElectParams(std);
      if (null == params) { return forward(request, "notReady"); }
      request.setAttribute("electParams", params);
      // 更新评教信息
      if (params.getIsCheckEvaluation().equals(Boolean.TRUE)) {
        request.setAttribute("isEvaluated", Boolean.valueOf(electService.isPassEvaluation(std.getId())));
      }
    } else {
      if (state.params.getIsCheckEvaluation().equals(Boolean.TRUE)
          && (null == state.isEvaluated || state.isEvaluated.equals(Boolean.FALSE))) {
        state.isEvaluated = Boolean.valueOf(electService.isPassEvaluation(state.std.getId()));
      }
    }

    request.setAttribute("now", new java.util.Date(System.currentTimeMillis()));
    request.setAttribute("currStd", getStudentFromSession(request.getSession()));
    return forward(request, "prompt");
  }

  /**
   * 构建一个班级课程表
   * 
   * @param setting
   * @param resource
   * @return
   */
  private CourseTable buildClassCourseTable(CourseTableSetting setting, Long classId, ElectState state) {
    AdminClass adminClass = new AdminClass(classId);
    CourseTable table = new CourseTable(adminClass, setting.getKind());
    // 查询教学任务
    EntityQuery query = new EntityQuery(TeachTask.class, "task");
    query.add(new Condition("task.calendar = :calendar", state.params.getCalendar()));
    query.join("task.teachClass.adminClasses", "adminClass");
    query.add(new Condition("adminClass = :adminClass", adminClass));
    query.setCacheable(true);
    List<TeachTask> taskList = (List) utilService.search(query);
    for (TeachTask task : taskList) {
      table.addActivities(task.getArrangeInfo().getActivities());
    }
    Map taskGroupMap = new HashMap();
    try {
      for (Map.Entry<CourseType, Float> entry : state.typeCredits.entrySet()) {
        String typeId = entry.getKey().getId().toString();
        TableTaskGroup taskGroup = (TableTaskGroup) taskGroupMap.get(typeId);
        if ((entry.getValue().floatValue() > 0)) {
          if (null == taskGroup) {
            taskGroup = new TableTaskGroup(entry.getKey());
            taskGroupMap.put(typeId, taskGroup);
          }
          taskGroup.setCredit(entry.getValue());
        }
      }
    } catch (Exception e) {
      log.debug("maybe some studentType with no plan,or on campusTime");
    }
    // 不显示重复课程代码的课程
    Set courses = new HashSet();
    for (Iterator iter = taskList.iterator(); iter.hasNext();) {
      TeachTask task = (TeachTask) iter.next();
      if (!courses.contains(task.getCourse())) {
        courses.add(task.getCourse());
      } else {
        continue;
      }

      String typeId = task.getCourseType().getId().toString();
      Long planCourseTypeId = state.planCourse2Types.get(task.getCourse());
      if (null != planCourseTypeId) {
        typeId = String.valueOf(planCourseTypeId);
      }

      TableTaskGroup group = (TableTaskGroup) taskGroupMap.get(typeId);
      if (null == group) {
        group = new TableTaskGroup(task.getCourseType());
        taskGroupMap.put(typeId, group);
      }
      group.addTask(task);
    }
    taskList = new ArrayList();
    float credits = 0;
    for (Iterator iter = taskGroupMap.values().iterator(); iter.hasNext();) {
      TableTaskGroup taskGroup = (TableTaskGroup) iter.next();
      taskList.addAll(taskGroup.getTasks());
      credits += taskGroup.getCredit().floatValue();
    }
    table.setCredits(new Float(credits));
    List dd = new ArrayList(taskGroupMap.values());
    Collections.sort(dd);
    table.setTasksGroups(dd);
    if (null == table.getTasks()) {
      table.setTasks(taskList);
    }
    return table;
  }

  /**
   * 选课主页面
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  @SuppressWarnings({ "unchecked", "rawtypes" })
  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ElectState state = (ElectState) request.getSession().getAttribute("electState");
    StdCreditConstraint constraint = null;
    Student std = getStudentFromSession(request.getSession());
    // 如果还没有选课状态,或者不是当前用户的选课状态
    if (null == state || !state.std.getStdNo().equals(getLoginName(request))) {
      // 查找选课参数
      Long paramsId = getLong(request, "electParams.id");
      if (null == paramsId) { return forwardError(mapping, request, ElectCourseService.noParamsNotExists); }
      ElectParams params = paramsService.getElectParams(paramsId);
      if (null == params) { return forwardError(mapping, request, ElectCourseService.noParamsNotExists); }

      // 检查日期
      if (!params.isTimeSuitable()) {
        request.setAttribute("now", new Date());
        request.setAttribute("electResultInfo", ElectCourseService.noTimeSuitable);
        return forward(request, "electResult");
      }
      // hibernet对象初始化，在使用之前
      utilService.initialize(params.getCalendar());
      utilService.initialize(params.getNotCurrentCourseTypes());
      // 查找学分上限
      constraint = (StdCreditConstraint) creditConstraintService.getStdCreditConstraint(std.getId(),
          params.getCalendar());
      if (null == constraint) { return forwardError(mapping, request,
          ElectCourseService.notExistsCreditConstraint); }

      // 准备学生选课状态数据
      state = new ElectState(constraint, params);
      // 插入学籍状态为05转专业、26插班生、22复员、12延长学制
      Collection<StudentState> stdStates = utilService.load(StudentState.class, "id", new Long[] {
          Long.parseLong("24"), Long.parseLong("123"), Long.parseLong("222"), Long.parseLong("302") });
      state.getStudentStates2().addAll(stdStates);
      state.arrangeSwitch = loadCourseArrangeSwitch(params.getCalendar());
      utilService.initialize(params.getCalendar().getTimeSetting().getCourseUnits());

      // 计算第一专业的选课学分(第二专业不选课)
      try {
        TeachPlan plan = planService.getTeachPlan(std, Boolean.TRUE, null);
        if (plan != null) {
          OnCampusTime time = calendarService.getOnCampusTime(std.getType(), std.getEnrollYear());
          TermCalculator calc = new TermCalculator(calendarService, state.params.getCalendar());
          int term = calc.getTermBetween(time.getEnrollCalendar(), params.getCalendar(), Boolean.TRUE);
          for (Iterator iter = plan.getCourseGroups().iterator(); iter.hasNext();) {
            CourseGroup group = (CourseGroup) iter.next();
            CourseType groupCourseType = group.getCourseType();
            utilService.initialize(groupCourseType);
            String[] credits = StringUtils.split(group.getCreditPerTerms(), ",");
            state.typeCredits.put(groupCourseType, Float.valueOf(credits[term - 1]));
            if (group.getPlanCourses().isEmpty()) {
              state.emptyTypes.add(group.getCourseType().getId());
            } else {
              for (Iterator it = group.getPlanCourses().iterator(); it.hasNext();) {
                PlanCourse planCourse = (PlanCourse) it.next();
                state.planCourse2Types.put(planCourse.getCourse().getId(), groupCourseType.getId());
              }
            }
          }
        }
      } catch (Exception e) {
        log.debug("maybe somebody with no plan,or on campusTime");
      }
      // 加载已经上过的课程(ID)和是否通过
      gradeService.getGradeCourseMap(state);
      // 添加替代课程
      addSubstitueCourse(state, std);
      // 添加必修课
      electService.addCompulsoryCourse(state, constraint.getStd(),
          Collections.singletonList(params.getCalendar()));

      // 检查是否有转专业异动
      EntityQuery query = new EntityQuery(StudentAlteration.class, "stdAlteration");
      query.add(new Condition("stdAlteration.std.id = :stdId", state.getStd().getId()));
      query.add(new Condition("stdAlteration.mode.id = :alterModeId", new Long(24)));
      query.setSelect("count(stdAlteration.id)");
      Number changeMajorCnt = (Number) (utilService.search(query).iterator().next());
      state.majorChanged = changeMajorCnt.intValue() > 0;
      buildPlanAuditDetails(std, state);
      // 设置选课状态数据
      request.getSession().setAttribute("electState", state);
    } else {
      if (!state.getParams().isTimeSuitable()) {
        request.setAttribute("electResultInfo", ElectCourseService.noTimeSuitable);
        return forward(request, "electResult");
      }
    }

    // 检查评教状态
    if (state.params.getIsCheckEvaluation().equals(Boolean.TRUE)
        && (null == state.isEvaluated || state.isEvaluated.equals(Boolean.FALSE))) {
      state.isEvaluated = Boolean.valueOf(electService.isPassEvaluation(state.std.getId()));
    }

    // 20091217 add,2011-1102 modify by duantihua
    // 考虑当前学期的选课记录
    TeachCalendar curCalendar = teachCalendarService.getCurTeachCalendar(state.std.getStdTypeId());
    List withoutGradeCalendars = new ArrayList();
    withoutGradeCalendars.add(state.params.getCalendar());
    if (!withoutGradeCalendars.contains(curCalendar)) {
      withoutGradeCalendars.add(curCalendar);
    }
    List taskList = teachTaskService.getTeachTasksOfStd(state.std.getId(), withoutGradeCalendars);
    List curTaskList = new ArrayList();
    // 现在计算已选学分和已选的课程id
    float electedStat = 0;
    // 筛选指定课程类别的信息
    float creditGX = 0f;
    float creditXX = 0f;
    float creditTS = 0f;
    for (Iterator iter = taskList.iterator(); iter.hasNext();) {
      TeachTask task = (TeachTask) iter.next();
      if (state.params.getCalendar().equals(task.getCalendar())) {
        electedStat += task.getCourse().getCredits().floatValue();
        curTaskList.add(task);
      }
      if (task.getCourseType().getName().contains("公选")) {
        creditGX += task.getCourse().getCredits();
      } else if (task.getCourseType().getName().contains("通识")) {
        creditTS += task.getCourse().getCredits();
      } else if (task.getCourseType().getName().contains("限选")
          || task.getCourseType().getName().contains("限制性选")) {
        creditXX += task.getCourse().getCredits();
      }
      state.electedCourseIds.add(task.getCourse().getId());
    }
    state.electedMap.put("通识", creditTS);
    state.electedMap.put("公选", creditGX);
    state.electedMap.put("限选", creditXX);

    // 如果已选学分和实际不一样,则更新
    if (electedStat != state.electedCredit) {
      if (null == constraint) {
        constraint = (StdCreditConstraint) creditConstraintService.getStdCreditConstraint(state.std.getId(),
            state.params.getCalendar());
        if (null == constraint) { return forwardError(mapping, request,
            ElectCourseService.notExistsCreditConstraint); }
      }
      constraint.setElectedCredit(new Float(electedStat));
      utilService.saveOrUpdate(constraint);
      state.electedCredit = electedStat;
    }

    // 查询替代课程
    List planCoursesList = substituteCourseService.getStdSubstituteCourses(std);
    Map<String, String> subsMap = new HashMap<String, String>();
    for (Iterator iterator = planCoursesList.iterator(); iterator.hasNext();) {
      SubstituteCourse subsCourse = (SubstituteCourse) iterator.next();
      for (Iterator<Course> it2 = subsCourse.getOrigins().iterator(); it2.hasNext();) {
        Course course = it2.next();
        String subsCode = "";
        for (Iterator<Course> it3 = subsCourse.getSubstitutes().iterator(); it3.hasNext();) {
          Course subsC = it3.next();
          subsCode += subsC.getCode() + ",";
        }
        String subsCodes = subsCode.length() > 0 ? subsCode.substring(0, subsCode.length() - 1) : "";
        subsMap.put(course.getId().toString(), subsCodes);
      }
    }

    // 构建课表
    state.table = new TimeTable(curTaskList);
    request.setAttribute("state", state);
    request.setAttribute("subsMap", subsMap);
    request.setAttribute("taskList", curTaskList);
    request.setAttribute("nowAt", new Date());
    request.setAttribute("weekList", WeekInfo.WEEKS);
    return forward(request);
  }

  protected CourseArrangeSwitch loadCourseArrangeSwitch(TeachCalendar calendar) {
    EntityQuery query = new EntityQuery(CourseArrangeSwitch.class, "arrangeSwitch");
    query.add(new Condition("arrangeSwitch.calendar = :calendar", calendar));
    Collection<CourseArrangeSwitch> results = utilService.search(query);
    if (CollectionUtils.isEmpty(results)) {
      return null;
    } else {
      return results.iterator().next();
    }
  }

  /**
   * 选课-学生班级课表
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward taskListOfClass(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ElectState state = (ElectState) request.getSession().getAttribute("electState");
    if (null == state) { return prompt(mapping, form, request, response); }
    CourseTableSetting setting = new CourseTableSetting(state.params.getCalendar());
    setting.setTimes(getTimesFormPage(request, state.params.getCalendar()));
    setting.setWeekInfos(WeekInfo.WEEKS);
    setting.setDisplayCalendarTime(true);
    RequestUtil.populate(request, setting, "setting");
    Set classIds = state.getStd().getAdminClassIds();
    Long classId = (Long) classIds.iterator().next();
    request.setAttribute("courseTable", buildClassCourseTable(setting, classId, state));
    request.setAttribute("setting", setting);
    request.setAttribute("state", state);
    return forward(request);
  }

  protected TimeUnit[] getTimesFormPage(HttpServletRequest request, TeachCalendar calendar) {
    Integer startWeek = getInteger(request, "startWeek");
    Integer endWeek = getInteger(request, "endWeek");
    if (null == startWeek) startWeek = new Integer(1);
    if (null == endWeek) endWeek = calendar.getWeeks();
    if (startWeek.intValue() < 1) startWeek = new Integer(1);
    if (endWeek.intValue() > calendar.getWeeks().intValue()) endWeek = calendar.getWeeks();
    request.setAttribute("startWeek", startWeek);
    request.setAttribute("endWeek", endWeek);
    return TimeUnitUtil.buildTimeUnits(calendar.getStartYear(), calendar.getWeekStart().intValue(),
        startWeek.intValue(), endWeek.intValue(), TimeUnit.CONTINUELY);
  }

  /**
   * 查询任务列表
   */
  public ActionForward taskList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ElectState state = (ElectState) request.getSession().getAttribute("electState");
    if (null == state) { return prompt(mapping, form, request, response); }

    TimeUnit time = (TimeUnit) populate(request, TimeUnit.class, "timeUnit");
    TeachTask task = (TeachTask) populate(request, TeachTask.class, Constants.TEACHTASK);
    task.getRequirement().setCourseCategory(null);
    String teacherName = request.getParameter("teacher.name");
    if (StringUtils.isNotEmpty(teacherName)) {
      Teacher teacher = new Teacher();
      teacher.setName(teacherName);
      task.getArrangeInfo().getTeachers().add(teacher);
    }
    Pagination taskPage = null;
    if (Boolean.TRUE.equals(state.getParams().getIsSchoolDistrictRestrict())) {
      task.getArrangeInfo().setSchoolDistrict(new SchoolDistrict(state.getStd().getSchoolDistrictId()));
    } else {
      task.getArrangeInfo().setSchoolDistrict(null);
    }
    // 得到页面上的选择
    Integer compare = RequestUtils.getInteger(request, "task.electInfo.electCountCompare");
    Integer op = null;
    if (null != compare) {
      if (compare.intValue() == 0) {
        op = 0;
      } else if (compare.intValue() < 0) {
        op = -1;
      } else {
        op = 1;
      }
    }
    boolean reChoosePassedCourse = getSystemConfig().getBooleanParam("election.reChoosePassedCourse");
    Boolean isRestudy = getBoolean(request, "isRestudy");
    if (null != isRestudy && Boolean.TRUE.equals(isRestudy)) {
      Set<Long> unPassedCourseIds = null;
      if (reChoosePassedCourse) {
        unPassedCourseIds = state.hisCourses.keySet();
      } else {
        unPassedCourseIds = state.getUnPassedCourseIds();
      }
      if (unPassedCourseIds.isEmpty()) {
        taskPage = new Pagination(getPageNo(request), getPageSize(request),
            new Result(0, Collections.EMPTY_LIST));
      } else {
        // 重修是否限制范围,依照选课参数
        taskPage = electService.getElectableTasks(task, state, unPassedCourseIds, time,
            state.getParams().getIsCheckScopeForReSturdy().booleanValue(), getPageNo(request),
            getPageSize(request), op);
      }
    } else {
      // 如果是允许重修并且不限制范围，所有人都不限制范围了
      // boolean scopeRestrict = !(state.getParams().getIsRestudyAllowed() &&
      // !state.getParams()
      // .getIsCheckScopeForReSturdy());
      // 非重修限制选课范围
      // FIXME 3 false !state.majorChanged
      boolean isScopeConstraint = state.getParams().getIsLimitedInTeachClass();
      // 转专业并且第3轮不检查
      if (state.majorChanged && state.getParams().getTurn().equals(3)) {
        isScopeConstraint = false;
      }
      taskPage = electService.getElectableTasks(task, state, null, time, isScopeConstraint,
          getPageNo(request), getPageSize(request), op);
    }
    addOldPage(request, "taskList", taskPage);
    addSingleParameter(request, "state", state);
    addSingleParameter(request, "BILINGUAL", TeachLangType.BILINGUAL);
    return forward(request);
  }

  /**
   * 收集计划完成情况中的公选、通识、限选已修和应修学分
   */
  private void buildPlanAuditDetails(Student std, ElectState state) {
    List resultList = graduateAuditService.getStudentTeachPlanAuditDetail(std, null, null, new ArrayList(),
        Boolean.TRUE, Boolean.TRUE);
    Map<String, Float> completedMap = new HashMap<String, Float>();
    Map<String, Float> requiredMap = new HashMap<String, Float>();
    float GX_yx = 0f, GX_xx = 0f;
    float TS_yx = 0f, TS_xx = 0f;
    float XX_yx = 0f, XX_xx = 0f;
    for (Iterator it = resultList.iterator(); it.hasNext();) {
      TeachPlanAuditResult result = (TeachPlanAuditResult) it.next();
      Iterator groupIt = result.getOrderCourseGroupAuditResults().iterator();
      while (groupIt.hasNext()) {
        CourseGroupAuditResult gr = (CourseGroupAuditResult) groupIt.next();
        if (gr.getCreditAuditInfo() != null) {
          float completed = 0, required = 0;
          if (null != gr.getCreditAuditInfo().getCompleted())
            completed = gr.getCreditAuditInfo().getCompleted();
          if (null != gr.getCreditAuditInfo().getRequired()) required = gr.getCreditAuditInfo().getRequired();
          if (gr.getCourseType().getName().contains("公选")) {
            GX_yx += completed;
            GX_xx += required;
          } else if (gr.getCourseType().getName().contains("通识")) {
            TS_yx += completed;
            TS_xx += required;
          } else if (gr.getCourseType().getName().contains("限选")
              || gr.getCourseType().getName().contains("限制性选")) {
            XX_yx += completed;
            XX_xx += required;
          }
        }
      }
      completedMap.put("通识", TS_yx);
      completedMap.put("公选", GX_yx);
      completedMap.put("限选", XX_yx);

      requiredMap.put("通识", TS_xx);
      requiredMap.put("公选", GX_xx);
      requiredMap.put("限选", XX_xx);
      state.completedMap = completedMap;
      state.requiredMap = requiredMap;
    }
  }

  private void addSubstitueCourse(ElectState state, Student std) {
    List planCoursesList = substituteCourseService.getStdSubstituteCourses(std);
    for (Iterator iterator = planCoursesList.iterator(); iterator.hasNext();) {
      SubstituteCourse subCourse = (SubstituteCourse) iterator.next();
      boolean hasOriginGrade = false;
      for (Iterator it2 = subCourse.getOrigins().iterator(); it2.hasNext();) {
        Course course = (Course) it2.next();
        if (state.hisCourses.containsKey(course.getId())) {
          hasOriginGrade = true;
          break;
        }
      }
      for (Iterator it2 = subCourse.getSubstitutes().iterator(); it2.hasNext();) {
        Course course = (Course) it2.next();
        state.substituteIds.add(course.getId());
        if (hasOriginGrade && null == state.hisCourses.get(course.getId())) {
          state.hisCourses.put(course.getId(), Boolean.FALSE);
        }
      }
    }
  }

  /**
   * 选课
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward elect(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ElectState state = (ElectState) request.getSession().getAttribute("electState");
    if (null == state) { return prompt(mapping, form, request, response); }
    if (!state.getParams().isElectionTimeSuitable()) {
      request.setAttribute("electResultInfo", ElectCourseService.noTimeSuitable);
      return forward(request, "electResult");
    }
    if (getLoginName(request).equals(state.getStd().getStdNo())) {
      String taskId = request.getParameter(Constants.TEACHTASK_KEY);
      if (StringUtils
          .isEmpty(taskId)) { return forward(mapping, request, "error.teachTask.id.needed", "error"); }
      TeachTask task = teachTaskService.getTeachTask(Long.valueOf(taskId));
      CourseTakeType takeType = null;
      Long courseTakeTypeId = getLong(request, "courseTakeType.id");
      if (null != courseTakeTypeId) {
        takeType = new CourseTakeType(courseTakeTypeId);
      } else {
        takeType = new CourseTakeType(CourseTakeType.ELECTIVE);
      }

      request.setAttribute("electResultInfo", electService.elect(task, state, takeType));
    } else {
      request.setAttribute("electResultInfo", "error.elect.wrongStdCode");
    }
    return forward(request, "electResult");
  }

  /**
   * 退课
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward cancel(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ElectState state = (ElectState) request.getSession().getAttribute("electState");
    if (null == state) { return prompt(mapping, form, request, response); }
    if (!state.getParams().isElectionTimeSuitable()) {
      request.setAttribute("electResultInfo", ElectCourseService.noTimeSuitable);
      return forward(request, "electResult");
    }
    if (getLoginName(request).equals(state.getStd().getStdNo())) {
      String taskId = request.getParameter(Constants.TEACHTASK_KEY);
      if (StringUtils
          .isEmpty(taskId)) { return forward(mapping, request, "error.teachTask.id.needed", "error"); }

      TeachTask task = teachTaskService.getTeachTask(Long.valueOf(taskId));
      String info = electService.cancel(task, state);
      request.setAttribute("electResultInfo", info);
    } else {
      request.setAttribute("electResultInfo", "error.elect.wrongStdCode");
    }
    return forward(request, "electResult");
  }

  public void setElectService(ElectCourseService electService) {
    this.electService = electService;
  }

  public void setParamsService(ElectParamsService paramsService) {
    this.paramsService = paramsService;
  }

  public void setCalendarService(TeachCalendarService calendarService) {
    this.calendarService = calendarService;
  }

  public void setTeachTaskService(TeachTaskService teachTaskService) {
    this.teachTaskService = teachTaskService;
  }

  public void setCreditConstraintService(CreditConstraintService creditConstraintService) {
    this.creditConstraintService = creditConstraintService;
  }

  public void setPlanService(TeachPlanService planService) {
    this.planService = planService;
  }

  public void setGradeService(GradeService gradeService) {
    this.gradeService = gradeService;
  }

  public void setTeachCalendarService(TeachCalendarService teachCalendarService) {
    this.teachCalendarService = teachCalendarService;
  }

  public void setSubstituteCourseService(SubstituteCourseService substituteCourseService) {
    this.substituteCourseService = substituteCourseService;
  }

}
