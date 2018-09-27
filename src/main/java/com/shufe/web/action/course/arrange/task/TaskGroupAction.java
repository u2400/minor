//$Id: TaskGroupAction.java,v 1.3 2006/11/14 07:31:31 duanth Exp $
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
 * chaostone            2005-11-12          Created
 * zq                   2007-09-18          修改或替换了本Action中的所有info()方法
 ********************************************************************************/

package com.shufe.web.action.course.arrange.task;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ekingstar.common.detail.Pagination;

import org.apache.commons.beanutils.BeanComparator;
import org.apache.commons.beanutils.BeanPredicate;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.collection.predicates.InStrPredicate;
import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.eams.std.info.Student;
import com.ekingstar.eams.system.basecode.industry.CourseType;
import com.ekingstar.eams.system.basecode.state.Gender;
import com.ekingstar.eams.system.baseinfo.model.StudentType;
import com.ekingstar.eams.system.time.WeekInfo;
import com.shufe.checker.course.task.TeachTaskRemoveCheckerApp;
import com.shufe.model.Constants;
import com.shufe.model.course.arrange.AvailableTime;
import com.shufe.model.course.arrange.TaskActivity;
import com.shufe.model.course.arrange.exam.ExamTake;
import com.shufe.model.course.arrange.task.AddTaskOptions;
import com.shufe.model.course.arrange.task.AdjustArrange;
import com.shufe.model.course.arrange.task.CourseActivity;
import com.shufe.model.course.arrange.task.CourseArrangeAlteration;
import com.shufe.model.course.arrange.task.CourseTake;
import com.shufe.model.course.arrange.task.RemoveTaskOptions;
import com.shufe.model.course.arrange.task.TaskGroup;
import com.shufe.model.course.arrange.task.TaskInDepartment;
import com.shufe.model.course.election.ElectRecord;
import com.shufe.model.course.election.ElectStdScope;
import com.shufe.model.course.election.WithdrawRecord;
import com.shufe.model.course.grade.CourseGrade;
import com.shufe.model.course.grade.GradeLog;
import com.shufe.model.course.grade.GradeState;
import com.shufe.model.course.task.GenderLimitGroup;
import com.shufe.model.course.task.TaskAlterRequest;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.course.textbook.BookRequirement;
import com.shufe.model.duty.DutyRecord;
import com.shufe.model.quality.accident.TeachAccident;
import com.shufe.model.quality.evaluate.EvaluateResult;
import com.shufe.model.quality.evaluate.EvaluateResultLd;
import com.shufe.model.quality.evaluate.EvaluateStatics;
import com.shufe.model.quality.evaluate.QuestionnaireStat;
import com.shufe.model.quality.evaluate.TextEvaluation;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.model.system.baseinfo.Speciality;
import com.shufe.model.system.baseinfo.SpecialityAspect;
import com.shufe.model.system.baseinfo.Teacher;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.model.workload.course.TeachWorkload;
import com.shufe.model.workload.course.TeachWorkloadAlteration;
import com.shufe.service.course.arrange.task.TaskGroupService;
import com.shufe.service.course.task.TeachTaskService;
import com.shufe.service.system.baseinfo.AdminClassService;
import com.shufe.service.system.baseinfo.ClassroomService;
import com.shufe.util.DataAuthorityUtil;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;
import com.shufe.web.helper.BaseInfoSearchHelper;

/**
 * 排课组的界面响应类
 * 
 * @author chaostone 2005-11-12
 */
public class TaskGroupAction extends CalendarRestrictionSupportAction {

  protected TaskGroupService groupService;

  protected ClassroomService roomService;

  protected TeachTaskService teachTaskService;

  protected BaseInfoSearchHelper baseInfoSearchHelper;

  protected AdminClassService adminClassService;

  /**
   * 课程组管理的主界面
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setCalendarDataRealm(request, hasStdType);
    // 按照教学任务找到课程组
    Long taskId = getLong(request, "taskId");
    if (null != taskId) {
      EntityQuery query = new EntityQuery(TaskGroup.class, "taskGroup");
      query.join("taskGroup.directTasks", "task");
      query.add(new Condition("task.id = :taskId", taskId));
      for (Iterator it = utilService.search(query).iterator(); it.hasNext();) {
        TaskGroup group = (TaskGroup) it.next();
        addSingleParameter(request, "taskGroupId", group.getId());
        break;
      }
    }
    return forward(request);
  }

  /**
   * 查找指定学期的课程组
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward groupList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String departDataRealm = getDepartmentIdSeq(request);
    if (StringUtils.isEmpty(departDataRealm)) { return forward(mapping, request,
        "error.depart.dataRealm.notExists", "error"); }
    TeachCalendar calendar = getTeachCalendar(request);
    if (null == calendar) { return forward(mapping, request, new String[] { "entity.calendar",
        "error.model.notExist" }, "error"); }

    // 如果刚刚保存了新建的课程组，则定位到该组页面
    Long taskGroupId = getLong(request, "taskGroup.id");
    TaskGroup group = null;
    if (null != taskGroupId) {
      group = (TaskGroup) utilService.load(TaskGroup.class, taskGroupId);
    }
    TaskGroup groupInQuery = null;
    String groupName = get(request, "groupName");
    if (StringUtils.isNotBlank(groupName)) {
      groupInQuery = new TaskGroup();
      groupInQuery.setName(groupName);
      groupInQuery.setIsSameTime(null);
      groupInQuery.setPriority(null);
      groupInQuery.setIsClassChange(null);
    }

    Pagination groupList = null;
    boolean isHas = false;
    if (null != group) {
      for (int i = getPageNo(request), n = getPageSize(request); i < n; i++) {
        groupList = groupService.getTaskGroups(groupInQuery, getStdTypeIdSeq(request), departDataRealm,
            calendar, i, n, null);
        Set groups = new HashSet(groupList.getItems());
        if (groups.contains(group)) {
          isHas = true;
          break;
        }
      }
    }
    if (!isHas || null == group) {
      groupList = groupService.getTaskGroups(groupInQuery, getStdTypeIdSeq(request), departDataRealm,
          calendar, getPageNo(request), getPageSize(request), null);
    }
    // FIXME 改为 不分页排序
    Collections.sort(groupList.getItems(), new BeanComparator("name"));
    addOldPage(request, "groupPageList", groupList);
    return forward(request);
  }

  /**
   * 有日历id则按照日历id查找数据库<br>
   * 若没有则根据日历参数的学生类别、学年度、学期参数直接查询.<br>
   * 
   * @param request
   * @return null 如果没有对应的日历.
   */
  protected TeachCalendar getTeachCalendar(HttpServletRequest request) {
    TeachCalendar calendar = null;
    String calendarId = request.getParameter(Constants.CALENDAR_KEY);
    if (StringUtils.isEmpty(calendarId)) {
      calendar = (TeachCalendar) populateEntity(request, TeachCalendar.class, Constants.CALENDAR);

      calendar = teachCalendarService.getTeachCalendar(calendar.getStudentType(), calendar.getYear(),
          calendar.getTerm());
    } else calendar = teachCalendarService.getTeachCalendar(Long.valueOf(calendarId));
    return calendar;
  }

  /**
   * 新建课程组
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward newGroup(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, Constants.TASKGROUP, new TaskGroup());
    return forward(request);
  }

  /**
   * 准备添加老师
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward addTeachersSetting(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    request.setAttribute("taskGroup", utilService.load(TaskGroup.class, getLong(request, "taskGroup.id")));
    addTeacherDepartList(request);
    return forward(request);
  }

  /**
   * 准备添加班级
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward addAdminClassesSetting(ActionMapping mapping, ActionForm form,
      HttpServletRequest request, HttpServletResponse response) throws Exception {
    request.setAttribute("taskGroup", utilService.load(TaskGroup.class, getLong(request, "taskGroup.id")));
    EntityQuery query = baseInfoSearchHelper.buildAdminClassQuery(request, Boolean.FALSE);
    query.setLimit(null);
    addCollection(request, "adminClasses", utilService.search(query));
    return forward(request);
  }

  /**
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward adminClassSearch(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TaskGroup group = (TaskGroup) utilService.load(TaskGroup.class, getLong(request, "taskGroup.id"));
    List adminClasses = new ArrayList(group.getAdminClasses());
    Long[] adminClassIds = new Long[adminClasses.size()];
    for (int i = 0; i < adminClassIds.length; i++) {
      AdminClass adminClass = (AdminClass) adminClasses.get(i);
      adminClassIds[i] = adminClass.getId();
    }
    EntityQuery query = baseInfoSearchHelper.buildAdminClassQuery(request, Boolean.FALSE);
    query.add(new Condition("adminClass.id not in (:ids)", adminClassIds));

    addCollection(request, "adminClasses", utilService.search(query));
    addCollection(request, "majors", baseInfoService.getBaseInfos(Speciality.class));
    addCollection(request, "aspects", baseInfoService.getBaseInfos(SpecialityAspect.class));
    addCollection(request, "stdTypes", baseInfoService.getBaseInfos(StudentType.class));
    return forward(request);
  }

  /**
   * 编辑一个课程组的信息
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    /*------------检查课程组是否为新的课程组---------------------*/
    String groupId = request.getParameter(Constants.TASKGROUP_KEY);
    TaskGroup group = null;
    if (StringUtils.isEmpty(groupId)) {
      group = new TaskGroup();
    } else {
      group = groupService.getTaskGroup(Long.valueOf(groupId));
    }
    ActionForward errForward = checkGroup(mapping, request, group);
    if (null != errForward) { return errForward; }
    /*-------------设置数据----------------------*/
    String departDataRealm = getDepartmentIdSeq(request);
    // 包含公有教室
    if (departDataRealm.indexOf(String.valueOf(Department.SCHOOLID)) != -1) {
      departDataRealm += "," + Department.SCHOOLID;
    }
    List taskList = group.getTaskList();
    List configTypeList = new ArrayList();
    for (Iterator iter = taskList.iterator(); iter.hasNext();) {
      TeachTask task = (TeachTask) iter.next();
      configTypeList.add(task.getRequirement().getRoomConfigType());
    }
    request.setAttribute("roomList", roomService.getClassrooms(configTypeList, departDataRealm));

    request.setAttribute(Constants.TASKGROUP, group);
    setTimeAndSuggest(request, group);
    request.setAttribute("taskCount", groupService.getTaskCountOfGroup(group));

    return forward(request);
  }

  /**
   * 从教学任务中，创建挂牌分组
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward buildGroupSetting(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] taskIds = SeqStringUtil.transformToLong(get(request, "taskIds"));
    EntityQuery query = new EntityQuery(TeachTask.class, "task");
    query.add(new Condition("task.id in (:taskIds)", taskIds));
    query.groupBy("task.course.code");
    query.setSelect("task.course.code");
    Collection tasks = utilService.search(query);
    if (tasks.size() > 1) {
      request.setAttribute("errorMessage", "FFFF");
      return forward(request, "buildGroupError");
    }
    tasks = teachTaskService.getTeachTasksByIds(taskIds);
    Set teachers = new HashSet();
    for (Iterator it = tasks.iterator(); it.hasNext();) {
      TeachTask task = (TeachTask) it.next();
      // if (task.getArrangeInfo().getTeachers().size() > 1) {
      // request.setAttribute("errorMessage", "0001");
      // return forward(request, "buildGroupError");
      // }
      teachers.addAll(task.getArrangeInfo().getTeachers());
    }
    // if (teachers.size() == 0) {
    // request.setAttribute("errorMessage", "0002");
    // return forward(request, "buildGroupError");
    // }
    addCollection(request, "tasks", tasks);
    addTeacherDepartList(request);
    addCollection(request, "teachers", teachers);
    return forward(request);
  }

  /**
   * 挂牌分组保存
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward saveGroup(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TaskGroup group = getGroup(request);
    List<TeachTask> tasks = new ArrayList<TeachTask>();
    boolean isNew = null == group.getId();
    if (isNew) {
      // 从教学任务直接获取已有的教学任务
      tasks = teachTaskService.getTeachTasksByIds(SeqStringUtil.transformToLong(get(request, "taskIds")));
    } else {
      tasks = group.getTaskList();
    }

    List<Teacher> teachers = utilService.load(Teacher.class, "id",
        SeqStringUtil.transformToLong(get(request, "teacherIds")));

    Collection<Teacher> oldTeachers = group.getTeachers();

    teachers = (List<Teacher>) CollectionUtils.subtract(teachers, oldTeachers);

    // 是否循环填充教师到组里的任务中
    boolean isLoop = false;
    TeachTask sourceTask = tasks.get(0);
    for (int i = 0; i < teachers.size();) {
      for (Iterator<TeachTask> iter = tasks.iterator(); iter.hasNext();) {
        TeachTask task = iter.next();
        if (CollectionUtils.isEmpty(task.getArrangeInfo().getTeachers())) {
          task.getArrangeInfo().getTeachers().add(teachers.get(i++));
        } else if (isNew) {
          teachers.remove(i);
        }
        if (i >= teachers.size()) {
          isLoop = iter.hasNext();
          if (isLoop) {
            i = 0;
          } else {
            break;
          }
        }
      }
      if (isLoop) {
        break;
      } else {
        if (i < teachers.size()) {
          TeachTask cloneTask = (TeachTask) sourceTask.clone();
          cloneTask.getArrangeInfo().getTeachers().clear();
          cloneTask.getArrangeInfo().getTeachers().add(teachers.get(i++));
          cloneTask.getRequirement().setIsGuaPai(Boolean.TRUE);
          tasks.add(cloneTask);
        }
      }
    }
    teachTaskService.saveOrUpdateTasks(tasks);

    group.getSuggest().setTime(new AvailableTime(AvailableTime.commonTeacherAvailTime));
    AddTaskOptions options = new AddTaskOptions();
    options.setAddSuggestRoom(false);
    options.setAddSuggestTime(false);
    options.setMergeTeacher(true);
    options.setShareAdminClass(true);
    // group.setCourse(taskSource.getCourse());
    group.setIsSameTime(Boolean.TRUE);
    utilService.saveOrUpdate(group);
    if (isNew) {
      groupService.addTasks(group, tasks, options);
    }
    return redirect(request, "index", "info.save.success",
        "&taskId=" + ((TeachTask) tasks.iterator().next()).getId());
  }

  /**
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward saveAdminClassGroup(ActionMapping mapping, ActionForm form,
      HttpServletRequest request, HttpServletResponse response) throws Exception {
    TaskGroup group = getGroup(request);
    Collection adminClasses = new ArrayList(group.getAdminClasses());
    Collection selectedAdminClasses = adminClassService.getAdminClassesById(get(request, "adminClassIds"));
    adminClasses = CollectionUtils.subtract(selectedAdminClasses, adminClasses);
    for (Iterator it = group.getTaskList().iterator(); it.hasNext();) {
      TeachTask task = (TeachTask) it.next();
      task.getTeachClass().getAdminClasses().addAll(adminClasses);
      task.getTeachClass().processTaskForClass();
    }

    group.getSuggest().setTime(new AvailableTime(AvailableTime.commonTeacherAvailTime));
    AddTaskOptions options = new AddTaskOptions();
    options.setAddSuggestRoom(false);
    options.setAddSuggestTime(false);
    options.setMergeTeacher(true);
    options.setShareAdminClass(true);
    group.setCourse(((TeachTask) group.getTaskList().get(0)).getCourse());
    group.setIsSameTime(Boolean.TRUE);
    utilService.saveOrUpdate(group);
    groupService.addTasks(group, group.getTaskList(), options);
    return redirect(request, "index", "info.save.success", "&taskGroup.id=" + group.getId());
  }

  /**
   * 查看排课课程组信息
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String groupId = request.getParameter(Constants.TASKGROUP_KEY);
    if (StringUtils.isEmpty(groupId)) { return forward(request, "prompt"); }
    TaskGroup group = getGroup(request);
    ActionForward errForward = checkGroup(mapping, request, group);
    if (null != errForward) { return errForward; }
    request.setAttribute(Constants.TASKGROUP, group);

    request
        .setAttribute("calendar", (((TeachTask) (group.getDirectTasks().iterator().next())).getCalendar()));
    setTimeAndSuggest(request, group);
    request.setAttribute("taskCount", groupService.getTaskCountOfGroup(group));
    request.setAttribute("arrangedCount", group.getArrangedTaskCount());
    request.setAttribute("MALE", Gender.MALE);
    request.setAttribute("FEMALE", Gender.FEMALE);
    return forward(request);
  }

  /**
   * 保存排课组的基本信息
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TaskGroup group = (TaskGroup) populateEntity(request, TaskGroup.class, Constants.TASKGROUP);
    ActionForward errForward = checkGroup(mapping, request, group);
    if (null != errForward) { return errForward; }

    String classroomIdSeq = request.getParameter(Constants.CLASSROOM_KEYSEQ);
    List selectedRooms = null;
    // 清空原来的所有可用教室
    group.getSuggest().setRooms(new HashSet());
    if (StringUtils.isNotEmpty(classroomIdSeq)) {
      selectedRooms = roomService.getClassrooms(Arrays.asList(SeqStringUtil.transformToLong(classroomIdSeq)));
      List authRooms = roomService.getClassrooms(getDepartmentIdSeq(request));
      group.getSuggest().getRooms().addAll(CollectionUtils.intersection(selectedRooms, authRooms));
    }
    if (!group.getSuggest().getTime().isValid()) { return forward(mapping, request,
        "arrangeCourse.availTime.not.corrected", "error"); }
    logHelper.info(request, "Uave taskGroup with id:" + group.getId());
    try {
      utilService.saveOrUpdate(group);
    } catch (Exception e) {
      logHelper.info(request, "Failure in updating taskGroup with id:" + group.getId(), e);
      return forward(mapping, request, "error.occurred", "error");
    }
    return redirect(request, "info", "info.save.success", "&taskGroup.id=" + group.getId());
  }

  /**
   * 添加教学任务的选项
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward addTaskOptions(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TaskGroup group = (TaskGroup) populate(request, TaskGroup.class);
    if (group.isPO()) {
      group = (TaskGroup) utilService.get(TaskGroup.class, group.getId());
    }
    addEntity(request, group);
    return forward(request);
  }

  /**
   * 准备时间信息
   * 
   * @param request
   * @param time
   */
  private void setTimeAndSuggest(HttpServletRequest request, TaskGroup group) {
    request
        .setAttribute("calendar", (((TeachTask) (group.getDirectTasks().iterator().next())).getCalendar()));
    request.setAttribute("weekList", WeekInfo.WEEKS);
    request.setAttribute("availTime", group.getSuggest().getTime());
  }

  /**
   * 为普通课程组添加教学任务
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward addTasks(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String taskIds = get(request, Constants.TEACHTASK_KEYSEQ);
    if (StringUtils.isEmpty(taskIds)) { return forward(mapping, request, new String[] { "entity.teachTask",
        "error.model.ids.needed" }, "error"); }

    List tasks = teachTaskService.getTeachTasksByIds(taskIds);
    String stdTypeDataRealm = getStdTypeIdSeq(request);
    String departDataRealm = getDepartmentIdSeq(request);
    DataAuthorityUtil.filter("TeachTaskForTeachDepart", tasks, stdTypeDataRealm, departDataRealm);
    if (tasks.isEmpty()) { return forward(mapping, request, "error.dataRealm.insufficient", "error"); }
    /*-------------查找对应的组---------------------*/
    TaskGroup group = getGroup(request);
    // 是否设置课程以及课程性质要看所有的课程以及用户意愿
    try {
      if (group.isVO()) {
        group.getSuggest().setTime(new AvailableTime(AvailableTime.commonTeacherAvailTime));
        utilService.saveOrUpdate(group);
        logHelper.info(request, "Create group with name: " + group.getName());
      }
      logHelper.info(request, "Add Tasks to group with name " + group.getName());

      AddTaskOptions options = null;
      Boolean quickAdd = getBoolean(request, "quickAdd");
      if (Boolean.TRUE.equals(quickAdd)) {
        options = new AddTaskOptions();
        options.setAddSuggestRoom(true);
        options.setAddSuggestRoom(true);
        if (Boolean.TRUE.equals(group.getIsSameTime())) {
          options.setShareAdminClass(true);
          options.setMergeTeacher(true);
        }
      } else {
        options = (AddTaskOptions) populate(request, AddTaskOptions.class, "options");
      }
      groupService.addTasks(group, tasks, options);
    } catch (Exception e) {
      e.printStackTrace();
      logHelper.info(request, "Failure in Save Or Add Tasks to group with name " + group.getName());
      return forward(mapping, request, "error.occurred", "error");
    }
    // 统计改组是否同一课程代码和同一课程性质.
    Course course = null;
    List courses = group.getCourses();
    if (courses.size() == 1 && (null == group.getCourse() || !group.getCourse().equals(courses.get(0)))) {
      course = (Course) group.getCourses().get(0);
    }
    CourseType courseType = null;
    List courseTypes = group.getCourseTypes();
    if (courseTypes.size() == 1
        && (null == group.getCourseType() || !group.getCourseType().getId()
            .equals(((CourseType) courseTypes.get(0)).getId()))) {
      courseType = (CourseType) courseTypes.get(0);
    }
    if (null != course) {
      group.setCourse(course);
    }
    if (null != courseType) {
      group.setCourseType(courseType);
    }
    utilService.saveOrUpdate(group);

    return redirect(request, "info", "info.save.success", "&taskGroup.id=" + group.getId());
  }

  /**
   * 设置课程组的课程或者课程类别
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward updateGroupCourse(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Boolean updateCourse = getBoolean(request, "updateCourse");
    Boolean updateCourseType = getBoolean(request, "updateCourseType");
    Long groupId = getLong(request, "taskGroup.id");
    TaskGroup group = groupService.getTaskGroup(groupId);
    if (null != updateCourse && updateCourse.equals(Boolean.TRUE)) {
      group.setCourse(new Course(getLong(request, "course.id")));
    }
    if (null != updateCourseType && updateCourseType.equals(Boolean.TRUE)) {
      group.setCourseType(new CourseType(getLong(request, "courseType.id")));
    }
    groupService.updateTaskGroup(group);
    return redirect(request, "info", "info.save.success", "&taskGroup.id=" + group.getId());
  }

  /**
   * 为普通课程组显示可以选择的课以添加的教学任务
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward lonelyTaskList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    /*-------------查找对应的组---------------------*/
    addSingleParameter(request, Constants.TASKGROUP, getGroup(request));
    addOldPage(request, Constants.TEACHTASK_LIST, getTeachTasks(request, true));
    return forward(request);
  }

  /**
   * 查找课程组内的课程
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward groupTaskList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Results.addPagination(Constants.TEACHTASK_LIST, getTeachTasks(request, false));
    addSingleParameter(request, Constants.TASKGROUP, getGroup(request, "task.taskGroup.id"));
    return forward(request);
  }

  /**
   * 删除排课组内的教学任务
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward deleteTask(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String taskIds = get(request, Constants.TEACHTASK_KEYSEQ);
    String groupId = get(request, Constants.TASKGROUP_KEY);
    if (StringUtils.isNotEmpty(taskIds)) {
      TaskGroup group = groupService.getTaskGroup(Long.valueOf(groupId));
      try {
        logHelper.info(request, "Remove task from task group with id:" + group.getId());
        deleteTaskOfGroup(request, group, teachTaskService.getTeachTasksByIds(taskIds));
      } catch (Exception e) {
        logHelper.info(request, "Failure in Remove task from task group with id:" + group.getId(), e);
        return forward(mapping, request, "error.occurred", "error");
      }
      /*--------------------没有对应的教学任务，排课组也不复存在----------*/
      if (group.getTaskList().isEmpty()) {
        try {
          logHelper.info(request, "Remove taskGroup with id:" + group.getId());
          groupService.removeTaskGroup(group);
        } catch (Exception e) {
          logHelper.info(request, "Failure in Remove taskGroup with id:" + group.getId(), e);
          return forward(mapping, request, "error.occurred", "error");
        }
        return null;
      }
    }
    return redirect(request, "info", "info.delete.success", "&taskGroup.id=" + groupId);
  }

  /**
   * 删除班级<br>
   * 如果选择删除没有班级的空任务，将导致删除任务与该组的联系<br>
   * 如果所有的任务全部被删除，将导致删除该组<br>
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward removeAdminClass(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] adminClassIds = SeqStringUtil.transformToLong(request.getParameter("adminClassIds"));
    List adminClasses = utilService.load(AdminClass.class, "id", adminClassIds);
    Long groupId = getLong(request, "taskGroup.id");
    TaskGroup group = groupService.getTaskGroup(groupId);
    Boolean removeEmptyTask = getBoolean(request, "removeEmptyTask");
    group.removeAdminClass(adminClasses, (null == removeEmptyTask) ? true : removeEmptyTask.booleanValue());
    List taskList = group.getTaskList();
    for (Iterator iter = taskList.iterator(); iter.hasNext();) {
      TeachTask task = (TeachTask) iter.next();
      task.getTeachClass().processTaskForClass();
      utilService.saveOrUpdate(task);
    }
    if (group.getTaskList().isEmpty()) {
      try {
        logHelper.info(request, "Remove taskGroup with id:" + group.getId());
        groupService.removeTaskGroup(group);
      } catch (Exception e) {
        logHelper.info(request, "Failure in Remove taskGroup with id:" + group.getId(), e);
        return forward(mapping, request, "error.occurred", "error");
      }
      return null;
    }
    return redirect(request, "info", "info.delete.success", "&taskGroup.id=" + groupId);
  }

  /**
   * 删除课程组（FIXME 2013-05-10 zhouqi 华政主修系统暂且不用）
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  @Deprecated
  public ActionForward deleteGroup_bak(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String groupId = request.getParameter(Constants.TASKGROUP_KEY);
    TaskGroup group = groupService.getTaskGroup(Long.valueOf(groupId));
    try {
      logHelper.info(request, "Remove task from task group with id:" + group.getId());
      deleteTaskOfGroup(request, group, group.getTaskList());
    } catch (Exception e) {
      logHelper.info(request, "Failure in Remove task from task group with id:" + group.getId(), e);
      return forwardError(mapping, request, "error.occurred");
    }
    try {
      /*--------------------没有对应的教学任务，排课组也不复存在----------*/
      if (group.getTaskList().isEmpty()) {
        logHelper.info(request, "Remove task group with id:" + group.getId());
        groupService.removeTaskGroup(group);
      }
    } catch (Exception e) {
      logHelper.info(request, "Failure in Remove task group with id:" + group.getId(), e);
      return forwardError(mapping, request, "error.occurred");
    }
    return null;
  }

  public ActionForward deleteGroup(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String groupId = request.getParameter(Constants.TASKGROUP_KEY);
    TaskGroup group = groupService.getTaskGroup(new Long(groupId));

    if (CollectionUtils.isNotEmpty(group.getDirectTasks())) {
      if (!isUsedInEntityWithTask(group.getDirectTasks())) { return redirect(request, "info",
          "error.taskGroup.teachTask.deleteFailure", "&taskGroup.id=" + groupId); }

      generateTasks(request, group.getDirectTasks());
    }

    utilService.remove(group.getDirectTasks());
    utilService.remove(group);

    return redirect(request, "success", "info.action.success", "&taskGroup.id=" + groupId);
  }

  /**
   * 教学任务是否被其它模块所引用
   * 
   * @param tasks
   * @return
   */
  protected boolean isUsedInEntityWithTask(Collection<TeachTask> tasks) {
    TeachTaskRemoveCheckerApp checker = new TeachTaskRemoveCheckerApp();
    checker.addChecker(TaskActivity.class);
    checker.addChecker(ExamTake.class);
    checker.addChecker(AdjustArrange.class);
    checker.addChecker(CourseActivity.class);
    checker.addChecker(CourseArrangeAlteration.class);
    checker.addChecker(CourseTake.class);
    checker.addChecker(TaskInDepartment.class, new StringBuilder(
        "exists (from taskindepartment.tasks task where task in (:tasks))"));
    checker.addChecker(ElectRecord.class);
    checker.addChecker(ElectStdScope.class);
    checker.addChecker(WithdrawRecord.class);
    checker.addChecker(CourseGrade.class);
    checker.addChecker(GradeLog.class);
    checker.addChecker(GenderLimitGroup.class);
    checker.addChecker(TaskAlterRequest.class);
    checker.addChecker(BookRequirement.class);
    checker.addChecker(DutyRecord.class, "teachTask");
    checker.addChecker(TeachAccident.class);
    checker.addChecker(EvaluateResult.class);
    checker.addChecker(EvaluateResultLd.class);
    checker.addChecker(EvaluateStatics.class);
    checker.addChecker(QuestionnaireStat.class);
    checker.addChecker(TextEvaluation.class);
    checker.addChecker(TeachWorkload.class, "teachTask");
    checker.addChecker(TeachWorkloadAlteration.class);
    checker.addTasks(tasks);
    checker.setUtilService(utilService);
    // boolean checkResult = checker.check();
    // System.out.println(StringUtils.repeat("*", 50) + " checker: " + checkResult);
    return checker.check();
  }

  /**
   * info页面操作成功跳转处
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward success(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {

    return forward(request);
  }

  /**
   * 生成新任务
   * 
   * @param request
   * @param tasks
   */
  protected void generateTasks(HttpServletRequest request, Collection<TeachTask> tasks) {
    if (CollectionUtils.isNotEmpty(tasks)) {
      Collection<TeachTask> newTasks = new ArrayList<TeachTask>();
      for (TeachTask task : tasks) {
        for (Iterator<AdminClass> it = task.getTeachClass().getAdminClasses().iterator(); it.hasNext();) {
          AdminClass adminclass = it.next();
          TeachTask newTask = (TeachTask) task.clone();
          newTask.getArrangeInfo().getTeachers().clear();
          newTask.getArrangeInfo().getActivities().clear();
          newTask.getTeachClass().getCourseTakes().clear();
          newTask.getTeachClass().getStds().clear();
          newTask.getTeachClass().setPlanStdCount(
              null != adminclass.getActualStdCount() ? adminclass.getActualStdCount() : adminclass
                  .getPlanStdCount());
          newTask.getRequirement().getTextbooks().clear();
          newTask.getTeachClass().getAdminClasses().clear();
          newTask.getTeachClass().getAdminClasses().add(adminclass);
          newTask.getTeachClass().setName(adminclass.getName());
          newTask.setTaskGroup(null);
          newTask.setGradeState(new GradeState(newTask));
          newTasks.add(newTask);
        }
      }
      teachTaskService.saveOrUpdateTasks(newTasks);
    }
  }

  protected TeachTask cloneTask(TeachTask task) {
    if (null != task) {
    }
    return null;
  }

  /**
   * 删除对应组中的用户权限范围内的任务，
   * 
   * @param group
   * @param tasks
   */
  private void deleteTaskOfGroup(HttpServletRequest request, TaskGroup group, Collection tasks) {
    /*---------------过滤掉不再权限范围内的教学任务---------------------*/
    InStrPredicate predicate = new InStrPredicate(getDepartmentIdSeq(request));
    RemoveTaskOptions options = (RemoveTaskOptions) populate(request, RemoveTaskOptions.class, "options");
    groupService.removeTaskFormGroup(group,
        CollectionUtils.select(tasks, new BeanPredicate("arrangeInfo.teachDepart.id", predicate)), options);
  }

  /**
   * 查询教学任务
   * 
   * @param request
   * @param isGP
   *          是否挂牌
   * @param excludeGroup
   *          设置要排除的排课组，即结果集没有该组的教学任务
   * @return
   */
  protected Pagination getTeachTasks(HttpServletRequest request, boolean lonely) {
    /*---------------获得查询条件-------------------*/
    TeachTask task = (TeachTask) populate(request, TeachTask.class, Constants.TEACHTASK);
    Teacher teacher = (Teacher) populate(request, Teacher.class, Constants.TEACHER);
    task.getArrangeInfo().getTeachers().add(teacher);
    Long stdTypeId = getLong(request, "calendar.studentType.id");
    // 查询
    Pagination taskList = null;
    if (lonely) {
      taskList = teachTaskService.getTeachTasksOfLonely(task,
          SeqStringUtil.transformToLong(getStdTypeIdSeqOf(stdTypeId, request)),
          SeqStringUtil.transformToLong(getDepartmentIdSeq(request)), getPageNo(request),
          getPageSize(request));
    } else {
      taskList = teachTaskService.getTeachTasksOfTeachDepart(task, getStdTypeIdSeq(request),
          getDepartmentIdSeq(request), getPageNo(request), getPageSize(request));
    }
    return taskList;
  }

  /**
   * 从request中获得一个组，或者对已存在的组进行合并
   * 
   * @param request
   * @param groupIdName
   * @return
   */
  private TaskGroup getGroup(HttpServletRequest request, String groupIdName) {
    TaskGroup group = null;
    Long groupId = getLong(request, groupIdName);
    if (null != groupId) {
      group = groupService.getTaskGroup(groupId);
    } else {
      group = (TaskGroup) populateEntity(request, TaskGroup.class, Constants.TASKGROUP);
    }
    return group;
  }

  /**
   * @param request
   * @return
   * @throws NumberFormatException
   */
  private TaskGroup getGroup(HttpServletRequest request) throws NumberFormatException {
    return getGroup(request, Constants.TASKGROUP_KEY);
  }

  /**
   * 检查课程组是否在用户权限范围内.<br>
   * 主要检查课程组内的课程是否在用户权限范围内，即：<br>
   * 课程组的权限划分取决于课程组内部的课程（教学任务）权限的划分.<br>
   * 只要有一个教学任务在用户权限范围内，则可以查看该组.<br>
   * 删除组内的任务则要考察要删除的任务是否在用户的权限范围内.<br>
   * 
   * @param request
   * @param group
   * @return null if in dataRealm of current user.
   */
  private ActionForward checkGroup(ActionMapping mapping, HttpServletRequest request, TaskGroup group) {

    String stdTypeDataRealm = getStdTypeIdSeq(request);
    String departDataRealm = getDepartmentIdSeq(request);
    if (!DataAuthorityUtil.isInDataRealm("TaskGroup", group, stdTypeDataRealm, departDataRealm)) { return forward(
        mapping, request, "error.dataRealm.insufficient", "error"); }
    return null;
  }

  /**
   * 将所有班级的实际人数之和均分到每个教学任务上
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward divPlanCount(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long groupId = getLong(request, Constants.TASKGROUP_KEY);
    if (null == groupId) { return forwardError(mapping, request, "error.model.id.needed"); }
    TaskGroup group = groupService.getTaskGroup(groupId);

    request.setAttribute("genderCounts", getGenderCounts(group));
    request.setAttribute("genderCountsForTasks", getGenderCountsForTasks(group));
    request.setAttribute(Constants.TASKGROUP, group);
    request.setAttribute("MALE", Gender.MALE);
    request.setAttribute("FEMALE", Gender.FEMALE);
    return forward(request);
  }

  /**
   * 获取组内的男女生的人数
   * 
   * @param group
   * @return
   */
  protected Map<String, Serializable> getGenderCounts(TaskGroup group) {
    Set<AdminClass> adminClasses = new HashSet<AdminClass>();
    for (Iterator it = group.getTaskList().iterator(); it.hasNext();) {
      TeachTask task = (TeachTask) it.next();
      adminClasses.addAll(task.getTeachClass().getAdminClasses());
    }

    EntityQuery query = new EntityQuery(Student.class, "student");
    query.add(new Condition(
        "exists (from student.adminClasses adminClass where adminClass in (:adminClasses))", adminClasses));
    query.add(new Condition("student.basicInfo.gender.id in (:genderIds)", new Long[] { Gender.MALE,
        Gender.FEMALE }));
    query.add(new Condition("student.active = true"));
    query.add(new Condition("student.inSchool = true"));
    query.groupBy("student.basicInfo.gender.id");
    query.setSelect("student.basicInfo.gender.id, count(*)");
    Collection<Object[]> results = utilService.search(query);
    Serializable maleCount = 0, femaleCount = 0;
    for (Object[] objects : results) {
      Long genderId = (Long) objects[0];
      if (genderId.longValue() == Gender.MALE.longValue()) {
        maleCount = (Serializable) objects[1];
      } else {
        femaleCount = (Serializable) objects[1];
      }
    }
    Map<String, Serializable> genderCounts = new HashMap<String, Serializable>();
    genderCounts.put("maleCount", maleCount);
    genderCounts.put("femaleCount", femaleCount);
    return genderCounts;
  }

  /**
   * 获取每个教学任务的组内男女生之人数
   * 
   * @param group
   * @return
   */
  protected Map<String, Map<String, Serializable>> getGenderCountsForTasks(TaskGroup group) {
    Map<String, Map<String, Serializable>> genderCountsForTasks = new HashMap<String, Map<String, Serializable>>();
    for (Iterator it = group.getTaskList().iterator(); it.hasNext();) {
      TeachTask task = (TeachTask) it.next();

      Map<String, Serializable> genderCounts = new HashMap<String, Serializable>();
      genderCountsForTasks.put(task.getId().toString(), genderCounts);

      EntityQuery query = new EntityQuery(CourseTake.class, "take");
      query.add(new Condition("take.task = :task", task));
      query.groupBy("take.student.basicInfo.gender.id");
      query.setSelect("take.student.basicInfo.gender.id, count(distinct take.student.id)");
      Collection<Object[]> results = utilService.search(query);

      Serializable maleCount = 0, femaleCount = 0;
      for (Object[] objects : results) {
        Long genderId = (Long) objects[0];
        if (genderId.longValue() == Gender.MALE.longValue()) {
          maleCount = (Serializable) objects[1];
        } else {
          femaleCount = (Serializable) objects[1];
        }
      }
      genderCounts.put("maleCount", maleCount);
      genderCounts.put("femaleCount", femaleCount);
    }

    return genderCountsForTasks;
  }

  /**
   * @param request
   */
  protected void addTeacherDepartList(HttpServletRequest request) {
    // 老师所在院系列表
    addCollection(request, "teacherDepartList", baseInfoService.getBaseInfos(Department.class));
  }

  protected void setPreCourses(String preCourseCodeSeq, TeachTask task) {
    task.getElectInfo().getPrerequisteCourses().clear();
    if (StringUtils.isNotEmpty(preCourseCodeSeq)) {
      task.getElectInfo().getPrerequisteCourses()
          .addAll(utilService.load(Course.class, "code", StringUtils.split(preCourseCodeSeq, ",")));
    }
  }

  /**
   * 保存计划人数
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward savePlanCount(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long groupId = getLong(request, Constants.TASKGROUP_KEY);
    if (null == groupId) { return forwardError(mapping, request, "error.model.id.needed"); }
    TaskGroup group = groupService.getTaskGroup(groupId);
    for (Iterator iter = group.getTaskList().iterator(); iter.hasNext();) {
      TeachTask task = (TeachTask) iter.next();
      Integer planStdCount = getInteger(request, "planStdCount" + task.getId());
      if (null != planStdCount) {
        task.getTeachClass().setPlanStdCount(planStdCount);
      }
      task.getTeachClass().processTaskForClass();
      utilService.saveOrUpdate(task);
    }
    return redirect(request, "info", "info.save.success", "&taskGroup.id=" + groupId);
  }

  /**
   * @param roomService
   *          The roomService to set.
   */
  public void setRoomService(ClassroomService roomService) {
    this.roomService = roomService;
  }

  /**
   * @param groupService
   *          The groupService to set.
   */
  public void setGroupService(TaskGroupService groupService) {
    this.groupService = groupService;
  }

  /**
   * @param teachTaskService
   *          The teachTaskService to set.
   */
  public void setTeachTaskService(TeachTaskService teachTaskService) {
    this.teachTaskService = teachTaskService;
  }

  public void setBaseInfoSearchHelper(BaseInfoSearchHelper baseInfoSearchHelper) {
    this.baseInfoSearchHelper = baseInfoSearchHelper;
  }

  public void setAdminClassService(AdminClassService adminClassService) {
    this.adminClassService = adminClassService;
  }
}
