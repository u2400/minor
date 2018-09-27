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
 * chaostone            2006-12-25          Created
 * zq                   2007-10-09          增加了settingStdsCount()和saveStdsCount()
 *                                          方法
 ********************************************************************************/

package com.shufe.web.action.course.arrange.task;

import java.sql.Date;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
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

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.model.EntityUtils;
import com.ekingstar.commons.mvc.struts.misc.ForwardSupport;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.Order;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.web.dispatch.Action;
import com.ekingstar.eams.system.basecode.industry.ClassroomType;
import com.ekingstar.eams.system.basecode.industry.CourseCategory;
import com.ekingstar.eams.system.basecode.industry.MajorType;
import com.ekingstar.eams.system.basecode.state.Gender;
import com.ekingstar.eams.system.baseinfo.SchoolDistrict;
import com.ekingstar.eams.system.baseinfo.model.Building;
import com.ekingstar.eams.system.security.model.EamsRole;
import com.ekingstar.eams.system.time.WeekInfo;
import com.ekingstar.security.User;
import com.ekingstar.security.service.UserService;
import com.shufe.model.Constants;
import com.shufe.model.course.arrange.Activity;
import com.shufe.model.course.arrange.task.CourseActivity;
import com.shufe.model.course.arrange.task.CourseArrangeAlteration;
import com.shufe.model.course.arrange.task.CourseTake;
import com.shufe.model.course.election.ElectRecord;
import com.shufe.model.course.task.CourseTakeForTaskParam;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.baseinfo.Classroom;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.course.arrange.task.CourseTakeService;
import com.shufe.service.course.election.ElectCourseService;
import com.shufe.service.course.task.TeachTaskService;
import com.shufe.web.OutputProcessObserver;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;
import com.shufe.web.action.system.message.SystemMessageAction;
import com.shufe.web.helper.StdSearchHelper;
import com.shufe.web.helper.TeachTaskSearchHelper;

/**
 * 上课名单的统计\筛选\指定
 * 
 * @author chaostone
 */
public class CourseTakeForTaskAction extends CalendarRestrictionSupportAction {

  protected TeachTaskService teachTaskService;

  protected CourseTakeService courseTakeService;

  protected TeachTaskSearchHelper teachTaskSearchHelper;

  protected StdSearchHelper stdSearchHelper;

  protected UserService userService;

  /**
   * 筛选学生主界面
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
    setCalendarDataRealm(request, hasStdTypeCollege);
    addCollection(request, "courseCategories", baseCodeService.getCodes(CourseCategory.class));
    TeachCalendar teachCalendar = (TeachCalendar) request.getAttribute(Constants.CALENDAR);
    EntityQuery query = new EntityQuery(CourseTakeForTaskParam.class, "courseTakeForTaskParam");
    String order = "Y";
    if (teachCalendar != null) {
      query.add(new Condition("courseTakeForTaskParam.calendar.id=" + teachCalendar.getId()));
    }
    List manualArrangeParamList = (List) utilService.search(query);
    Set users = getUser(request.getSession()).getRoles();
    for (Iterator iter = users.iterator(); iter.hasNext();) {
      EamsRole eamsRole = (EamsRole) iter.next();
      if (manualArrangeParamList.size() == 0 && eamsRole.getId().longValue() != 1L) {
        order = "N";
      } else {
        for (Iterator iter_ = manualArrangeParamList.iterator(); iter_.hasNext();) {
          CourseTakeForTaskParam param = (CourseTakeForTaskParam) iter_.next();
          Date dateNow = new Date(System.currentTimeMillis());
          Date dateStart = param.getStartDate();
          Date dateFinsh = param.getFinishDate();
          Calendar cal = Calendar.getInstance();
          cal.setTime(dateFinsh);
          cal.add(Calendar.DAY_OF_YEAR, +1);
          if ((dateNow.before(dateStart) || dateNow.after(cal.getTime()) || param.getIsOpenElection().equals(
              Boolean.valueOf(false)))
              && eamsRole.getId().longValue() != 1L) {
            order = "N";
          }
        }
      }
    }
    addSingleParameter(request, "order", order);
    addCollection(request, "teachDepartList", teachTaskService.getTeachDepartsOfTask(
        getStdTypeIdSeq(request), getDepartmentIdSeq(request),
        (TeachCalendar) request.getAttribute(Constants.CALENDAR)));
    List departList = teachTaskService.getDepartsOfTask(getStdTypeIdSeq(request),
        getDepartmentIdSeq(request), (TeachCalendar) request.getAttribute(Constants.CALENDAR));
    addCollection(request, "courseTypes", teachTaskService.getCourseTypesOfTask(getStdTypeIdSeq(request),
        getDepartmentIdSeq(request), (TeachCalendar) request.getAttribute(Constants.CALENDAR)));
    initBaseInfos(request, "schoolDistricts", SchoolDistrict.class);
    request.setAttribute(Constants.DEPARTMENT_LIST, departList);
    request.setAttribute("weeks", WeekInfo.WEEKS);
    /*----------------加载上课学生性别列表--------------------*/
    initBaseCodes(request, "genderList", Gender.class);
    return forward(request);
  }

  /**
   * 查询教学任务
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward taskList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Collection tasks = utilService.search(builderQuery(request));
    addCollection(request, "tasks", tasks);
    String order = request.getParameter("order");
    Map alterationCountMap = new HashMap();
    if (CollectionUtils.isNotEmpty(tasks)) {
      EntityQuery query = new EntityQuery(CourseArrangeAlteration.class, "alteration");
      query.add(new Condition("alteration.happenPlace = 1"));
      query.add(new Condition("alteration.task in (:tasks)", tasks));

      query.groupBy("alteration.task.id");
      query.setSelect("alteration.task.id || '', count(*)");
      for (Iterator it = utilService.search(query).iterator(); it.hasNext();) {
        Object[] obj = (Object[]) it.next();
        alterationCountMap.put(obj[0], null == obj[1] ? new Integer(0) : obj[1]);
      }
    }
    request.setAttribute("alterationCountMap", alterationCountMap);
    addSingleParameter(request, "order", order);
    return forward(request);
  }

  protected EntityQuery builderQuery(HttpServletRequest request) {
    EntityQuery query = teachTaskSearchHelper.buildTaskQuery(request, Boolean.TRUE);

    String capacityValueBValue = get(request, "capacityValueB");
    Integer capacityValueB = getInteger(request, "capacityValueB");
    String capacityValueEValue = get(request, "capacityValueE");
    Integer capacityValueE = getInteger(request, "capacityValueE");
    // 如果是非法数字，则如下，否则正常查询
    if (null == capacityValueB && StringUtils.isNotBlank(capacityValueBValue) || null == capacityValueE
        && StringUtils.isNotBlank(capacityValueEValue)) {
      StringBuilder hql = new StringBuilder();
      hql.append("exists (");
      hql.append("    from task.arrangeInfo.activities activity");
      hql.append("   where activity.room.capacityOfCourse is null");
      hql.append(")");
      query.add(new Condition(hql.toString()));
    } else if (null != capacityValueB && StringUtils.isNotBlank(capacityValueBValue)
        || null != capacityValueE && StringUtils.isNotBlank(capacityValueEValue)) {
      Condition content = new Condition();

      StringBuilder hql = new StringBuilder();
      hql.append("exists (");
      hql.append("    from task.arrangeInfo.activities activity");
      hql.append("   where 1 = 1");
      if (null != capacityValueB) {
        hql.append("     and activity.room.capacityOfCourse - task.teachClass.stdCount >= :capacityOfCourseB");
        content.addValue(capacityValueB);
      }
      if (null != capacityValueE) {
        hql.append("     and activity.room.capacityOfCourse - task.teachClass.stdCount <= :capacityOfCourseE");
        content.addValue(capacityValueE);
      }
      hql.append(")");

      content.setContent(hql.toString());
      query.add(content);
    }

    return query;
  }

  @Deprecated
  public ActionForward taskList1(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Collection tasks = teachTaskSearchHelper.searchTask(request);
    addCollection(request, "tasks", tasks);

    Map alterationCountMap = new HashMap();
    if (CollectionUtils.isNotEmpty(tasks)) {
      EntityQuery query = new EntityQuery(CourseArrangeAlteration.class, "alteration");
      query.add(new Condition("alteration.happenPlace = 1"));
      query.add(new Condition("alteration.task in (:tasks)", tasks));

      query.groupBy("alteration.task.id");
      query.setSelect("alteration.task.id || '', count(*)");
      for (Iterator it = utilService.search(query).iterator(); it.hasNext();) {
        Object[] obj = (Object[]) it.next();
        alterationCountMap.put(obj[0], null == obj[1] ? new Integer(0) : obj[1]);
      }
    }
    request.setAttribute("alterationCountMap", alterationCountMap);
    return forward(request);
  }

  /**
   * 统计每个教学任务中，班级人数分布情况
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward adminClassStdCount(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] taskIds = SeqStringUtil.transformToLong(get(request, "taskIds"));
    EntityQuery query = new EntityQuery(TeachTask.class, "task");
    query.add(new Condition("task.id in (:taskId)", taskIds));
    query.join("task.teachClass.adminClasses", "adminClass");
    query.add(new Condition("adminClass.id = stdAdminClass.id"));
    query.add(new Condition("adminClass.speciality.majorType.id = (:majorTypeId)", MajorType.FIRST));
    StringBuffer groupBy = new StringBuffer().append("task.id,").append("stdAdminClass.id");
    query.groupBy(groupBy.toString());
    List orders = new ArrayList();
    query.join("task.teachClass.courseTakes", "courseTake");
    query.join("courseTake.student.adminClasses", "stdAdminClass");
    orders.add(new Order("task.id"));
    orders.add(new Order("stdAdminClass.id"));
    orders.add(new Order("count(*)"));
    query.addOrder(orders);
    query.setSelect(groupBy.toString() + ",count(*)");
    List queryList = (List) utilService.search(query);

    Map adminClassStdMap = new HashMap();
    for (Iterator it = queryList.iterator(); it.hasNext();) {
      Object[] obj = (Object[]) it.next();
      TeachTask task = teachTaskService.getTeachTask(new Long(obj[0].toString()));
      AdminClass adminClass = (AdminClass) utilService.load(AdminClass.class, new Long(obj[1].toString()));
      if (adminClassStdMap.containsKey(task.getId().toString())) {
        List stdCounts = (List) adminClassStdMap.get(task.getId().toString());
        stdCounts.add(new Object[] { adminClass, obj[2] });
      } else {
        List stdCounts = new ArrayList();
        stdCounts.add(new Object[] { adminClass, obj[2] });
        adminClassStdMap.put(task.getId().toString(), stdCounts);
      }
    }
    request.setAttribute("tasks", teachTaskService.getTeachTasksByIds(taskIds));
    request.setAttribute("adminClassStdMap", adminClassStdMap);
    return forward(request);
  }

  /**
   * 过滤筛选
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward filter(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String taskIdSeq = request.getParameter("taskIds");
    String selectValue = get(request, "selectId");

    teachTaskService.statStdCount(taskIdSeq);
    Long[] taskIds = SeqStringUtil.transformToLong(taskIdSeq);
    List tasks = teachTaskService.getTeachTasksByIds(taskIds);
    if (selectValue.equals("default")) {
      courseTakeService.filter(tasks, null);
    } else {
      courseTakeService.filter(tasks, Integer.valueOf(selectValue));
    }
    return redirect(request, "taskList&order=Y", "info.action.success");
  }

  public ActionForward listWithTeachTask(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "tasks", teachTaskSearchHelper.searchTask(request));
    return forward(request);
  }

  /**
   * 发送指定轮次的筛选消息<br>
   * 1)按照任务发送<br>
   * 2)按照学期向所有筛选过的任务中的筛选掉的学生
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward sendFilterMessage(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(ElectRecord.class, "electRecord");
    query.add(new Condition("electRecord.turn=:turn", getInteger(request, "turn")));

    Long[] taskIds = SeqStringUtil.transformToLong(request.getParameter("taskIds"));
    if (null == taskIds) {
      Long calendarId = getLong(request, "calendar.id");
      query.add(new Condition("electRecord.task.calendar.id=:calendarId", calendarId));
    } else {
      query.add(new Condition("electRecord.task.id in (:taskIds)", taskIds));
    }
    query.add(new Condition("electRecord.isPitchOn=false"));
    query.add(new Condition("not exists(from WithdrawRecord wr where wr.task=electRecord.task "
        + "and wr.student=electRecord.student and wr.time>electRecord.electTime)"));
    List electRecords = (List) utilService.search(query);
    // 整理成task->students
    Map taskStudentMap = new HashMap();
    for (Iterator iter = electRecords.iterator(); iter.hasNext();) {
      ElectRecord er = (ElectRecord) iter.next();
      Set students = (Set) taskStudentMap.get(er.getTask());
      if (null == students) {
        students = new HashSet();
        taskStudentMap.put(er.getTask(), students);
      }
      students.add(er.getStudent());
    }
    courseTakeService.sendFilterMessage(taskStudentMap, userService.get("admin"));
    return redirect(request, "index", "info.send.success");
  }

  private List getTaskSearched(HttpServletRequest request, Boolean updateSelected) {
    List tasks = null;
    if (updateSelected.equals(Boolean.TRUE)) {
      Long[] taskIds = SeqStringUtil.transformToLong(request.getParameter("taskIds"));
      if (taskIds != null) tasks = teachTaskService.getTeachTasksByIds(taskIds);
    } else {
      EntityQuery query = teachTaskSearchHelper.buildTaskQuery(request, Boolean.TRUE);
      System.out.println(query.toQueryString());
      query.setLimit(null);
      tasks = (List) utilService.search(query);
    }
    return tasks;
  }

  /**
   * 指定学生
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward assignStds(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Boolean updateSelected = getBoolean(request, "updateSelected");
    List tasks = getTaskSearched(request, updateSelected);
    if (null == tasks) { return forwardError(mapping, request, "error.model.id.needed"); }

    response.setContentType("text/html; charset=utf-8");
    ActionForward processDisplay = mapping.findForward("processDisplay");
    String path = request.getSession().getServletContext().getRealPath("") + processDisplay.getPath();

    OutputProcessObserver observer = new OutputProcessObserver(response.getWriter(), getResources(request),
        getLocale(request), path);

    info(getUser(request.getSession()).getName() + " assign course take for taskId["
        + EntityUtils.extractIds(tasks) + "]");
    courseTakeService.assignStds(tasks, getBoolean(request, "deleteExisted"), observer);
    response.getWriter().flush();
    response.getWriter().close();
    return null;
  }

  public ActionForward autoChangeRoomEdit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "tasks",
        utilService.load(TeachTask.class, "id", SeqStringUtil.transformToLong(get(request, "taskIds"))));
    addCollection(request, "roomTypes", baseCodeService.getCodes(ClassroomType.class));
    addCollection(request, "buildings", baseCodeService.getCodes(Building.class));
    return forward(request, "autoChangeRoomForm");
  }

  /**
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward autoChangeRoom(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String UN_ARRANGE = "未安排", NO_ROOM = "无教室可更换";

    Collection<TeachTask> tasks = utilService.load(TeachTask.class, "id",
        SeqStringUtil.transformToLong(get(request, "taskIds")));

    Building building = null;
    Long buildingId = getLong(request, "buildingId");
    if (null != buildingId) {
      building = (Building) utilService.get(Building.class, buildingId);
    }

    ClassroomType roomType = null;
    Long roomTypeId = getLong(request, "roomTypeId");
    if (null != roomTypeId) {
      roomType = (ClassroomType) utilService.get(ClassroomType.class, roomTypeId);
    }

    Integer minStdCount = getInteger(request, "minStdCount");
    Integer maxStdCount = getInteger(request, "maxStdCount");
    if (null == minStdCount && null != maxStdCount) {
      minStdCount = 0;
    }

    Map<String, String> resultMap = new HashMap<String, String>();

    int successCount = 0;

    for (TeachTask task : tasks) {
      if (CollectionUtils.isEmpty(task.getArrangeInfo().getActivities())) {
        resultMap.put(task.getId().toString(), UN_ARRANGE);
      } else {
        String sMsg = "";
        Collection<Activity> activities = new ArrayList<Activity>();
        boolean isNoRoom = false;
        for (Iterator iter = task.getArrangeInfo().getActivities().iterator(); iter.hasNext();) {
          CourseActivity activity = (CourseActivity) iter.next();
          Collection<Classroom> rooms = buildFreeRoomsQuery(activity, building, roomType, minStdCount,
              maxStdCount);
          if (CollectionUtils.isEmpty(rooms)) {
            sMsg = NO_ROOM;
            isNoRoom = true;
            break;
          }
          if (StringUtils.isNotBlank(sMsg)) {
            sMsg += "，";
          }
          sMsg += "将“" + activity.getRoom().getName() + "(" + activity.getRoom().getCode() + ")";
          activity.setRoom(rooms.iterator().next());
          sMsg += "”更换为“" + activity.getRoom().getName() + "(" + activity.getRoom().getCode() + ")”";
          activities.add(activity);
        }
        resultMap.put(task.getId().toString(), sMsg);
        if (isNoRoom) {
          continue;
        }
        successCount++;
        utilService.saveOrUpdate(activities);
      }

    }

    addSingleParameter(request, "resultMap", resultMap);
    addCollection(request, "tasks", tasks);

    String actionStatus = "";
    if (successCount >= tasks.size()) {
      actionStatus = "info.action.success";
    } else if (successCount > 0 && successCount < tasks.size()) {
      actionStatus = "info.action.conflict";
    } else {
      actionStatus = "info.action.failure";
    }

    saveErrors(request.getSession(), ForwardSupport.buildMessages(new String[] { actionStatus }));
    return forward(request, "autoChangeRoomResult");
  }

  private Collection<Classroom> buildFreeRoomsQuery(CourseActivity activity, Building building,
      ClassroomType roomType, Integer minStdCount, Integer maxStdCount) {
    EntityQuery query = new EntityQuery(Classroom.class, "room");
    query.add(new Condition("room.state = true"));
    query.add(new Condition("room != :room", activity.getRoom()));

    if (null == roomType && null == building) {
      if (null != activity.getRoom().getConfigType() && null != activity.getRoom().getConfigType().getId()) {
        query.add(new Condition("room.configType = :roomType", activity.getRoom().getConfigType()));
      }
    } else {
      if (null != building) {
        query.add(new Condition("room.building = :building", building));
      }
      if (null != roomType) {
        query.add(new Condition("room.configType = :roomType", roomType));
      }
    }

    String hql = "not exists (from com.shufe.model.course.arrange.Activity activity where activity.room = room and activity.time.year = "
        + activity.getTime().getYear()
        + " and activity.time.startUnit <= "
        + activity.getTime().getEndUnit()
        + " and "
        + activity.getTime().getStartUnit()
        + " <= activity.time.endUnit and activity.time.weekId = "
        + activity.getTime().getWeekId()
        + " and BITAND (activity.time.validWeeksNum, " + activity.getTime().getValidWeeksNum() + ") > 0)";
    query.add(new Condition(hql));

    query.add(new Condition("room.capacity >= :stdCount", activity.getTask().getTeachClass().getCourseTakes()
        .size()));
    if (null != maxStdCount) {
      query.add(new Condition("room.capacity between :minStdCount and :maxStdCount", null == minStdCount ? 0
          : minStdCount, maxStdCount));
    }
    query.addOrder(OrderUtils.parser("room.capacity"));
    return utilService.search(query);
  }

  /**
   * 列举教学班学生名单
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward teachClassStdList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long taskId = getLong(request, "taskId");
    if (null == taskId) return forwardError(mapping, request, "error.model.id.needed");
    request.setAttribute(Constants.TEACHTASK, utilService.get(TeachTask.class, taskId));
    return forward(request);
  }

  /**
   * 列举单个任务的学生退课名单
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward withdrawList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long taskId = getLong(request, "taskId");
    if (null == taskId) return forwardError(mapping, request, "error.model.id.needed");
    request.setAttribute(Constants.TEACHTASK, utilService.get(TeachTask.class, taskId));
    return forward(request);
  }

  /**
   * 查询单个任务的学生选课纪录
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward electRecordList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long taskId = getLong(request, "taskId");
    if (null == taskId) return forwardError(mapping, request, "error.model.id.needed");
    TeachTask task = (TeachTask) utilService.get(TeachTask.class, taskId);
    request.setAttribute(Constants.TEACHTASK, task);
    EntityQuery entityQuery = new EntityQuery(ElectRecord.class, "electRecord");
    entityQuery.add(new Condition("electRecord.task.id=" + taskId));
    Boolean isPitchOn = getBoolean(request, "isPitchOn");
    if (null != isPitchOn) {
      entityQuery.add(new Condition("electRecord.isPitchOn=:isPitchOn", isPitchOn));
    }
    // 选上的,最近的排在前面
    entityQuery.addOrder(OrderUtils.parser("electRecord.isPitchOn desc,electRecord.electTime desc"));
    addCollection(request, "electRecords", utilService.search(entityQuery));
    return forward(request);
  }

  /**
   * 将学生添加到教学班名单中
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward add(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String stdNos = get(request, "stdNos");
    Long taskId = getLong(request, "taskId");
    TeachTask task = (TeachTask) utilService.get(TeachTask.class, taskId);
    List stds = utilService.load(Student.class, "code", StringUtils.split(stdNos, ","));

    Boolean checkConstraint = getBoolean(request, "checkConstraint");
    if (null == checkConstraint) {
      checkConstraint = Boolean.TRUE;
    }
    Map failMsgs = new HashMap();
    List failedStds = new ArrayList();
    for (Iterator iter = stds.iterator(); iter.hasNext();) {
      Student std = (Student) iter.next();
      String msg = courseTakeService.add(task, std, checkConstraint.booleanValue());
      if (!msg.equals(ElectCourseService.selectSuccess)) {
        failMsgs.put(std.getCode(), msg);
        failedStds.add(std);
      }
    }
    if (failedStds.isEmpty()) {
      return redirect(request, "teachClassStdList", "info.save.success", "&taskId=" + task.getId());
    } else {
      addSingleParameter(request, "task", task);
      addCollection(request, "failedStds", failedStds);
      request.setAttribute("failMsgs", failMsgs);
      return forward(request, "addFailure");
    }
  }

  /**
   * 将学生从教学班名单中退课
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward withdraw(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] courseTakeIds = SeqStringUtil.transformToLong(get(request, "courseTakeIds"));
    List courseTakes = utilService.load(CourseTake.class, "id", courseTakeIds);

    User sender = getUser(request.getSession());
    courseTakeService.sendWithdrawMessage(courseTakes, sender);

    Boolean log = getBoolean(request, "log");
    courseTakeService.withdraw(courseTakes, Boolean.TRUE.equals(log) ? sender : null);
    return redirect(request, "teachClassStdList", "info.action.success",
        "&taskId=" + request.getParameter("taskId"));
  }

  /**
   * 查找学生
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward stdList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = stdSearchHelper.buildStdQuery(request);
    addCollection(request, "stdList", utilService.search(query));
    initBaseCodes(request, "genders", Gender.class);
    return forward(request);
  }

  /**
   * 统计教学班人数(主要用于选课后实际人数计算不准时)
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward statStdCount(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long calendarId = getLong(request, "calendar.id");
    TeachCalendar calendar = (TeachCalendar) utilService.get(TeachCalendar.class, calendarId);
    teachTaskService.statStdCount(calendar);
    return redirect(request, "index", "info.stat.success");
  }

  /**
   * 向上课学生发送消息
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward sendMessage(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String courseTakeIdSeq = request.getParameter("courseTakeIds");
    List courseTakes = utilService.load(CourseTake.class, "id",
        SeqStringUtil.transformToLong(courseTakeIdSeq));
    StringBuffer sb = new StringBuffer();
    for (Iterator iter = courseTakes.iterator(); iter.hasNext();) {
      CourseTake take = (CourseTake) iter.next();
      sb.append(take.getStudent().getCode()).append(",");
    }
    return forward(request,
        new Action(SystemMessageAction.class, "quickSend", "&receiptorIds=" + sb.toString()));
  }

  /**
   * 批量修改学生人数
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward batchUpdateStdCountSetting(ActionMapping mapping, ActionForm form,
      HttpServletRequest request, HttpServletResponse response) throws Exception {
    Long[] ids = SeqStringUtil.transformToLong(request.getParameter("taskIds"));
    if (ids == null || ids.length == 0) { return forward(request, new Action("", "taskList&order=Y"),
        "info.action.failure"); }
    addCollection(request, "tasks", utilService.load(TeachTask.class, "id", ids));
    return forward(request);
  }

  /**
   * 保存指设置的人数
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward batchUpdateStdCount(ActionMapping mapping, ActionForm form,
      HttpServletRequest request, HttpServletResponse response) throws Exception {
    Long[] ids = SeqStringUtil.transformToLong(request.getParameter("taskIds"));
    Integer stdCount = getInteger(request, "stdCount");
    Integer planStdCount = getInteger(request, "planStdCount");
    Integer maxStdCount = getInteger(request, "maxStdCount");
    if (ids == null || ids.length == 0) { return forward(request, new Action("", "taskList&order=Y"),
        "info.action.failure"); }

    List tasks = utilService.load(TeachTask.class, "id", ids);
    for (Iterator it = tasks.iterator(); it.hasNext();) {
      TeachTask task = (TeachTask) it.next();
      if (null != stdCount) task.getTeachClass().setStdCount(stdCount);
      if (null != planStdCount) task.getTeachClass().setPlanStdCount(planStdCount);
      if (null != maxStdCount) task.getElectInfo().setMaxStdCount(maxStdCount);
    }
    utilService.saveOrUpdate(tasks);
    return redirect(request, new Action("", "taskList&order=Y"), "info.action.success");
  }

  public void setTeachTaskService(TeachTaskService teachTaskService) {
    this.teachTaskService = teachTaskService;
  }

  public void setCourseTakeService(CourseTakeService courseTakeService) {
    this.courseTakeService = courseTakeService;
  }

  public void setTeachTaskSearchHelper(TeachTaskSearchHelper teachTaskSearchHelper) {
    this.teachTaskSearchHelper = teachTaskSearchHelper;
  }

  public void setStdSearchHelper(StdSearchHelper stdSearchHelper) {
    this.stdSearchHelper = stdSearchHelper;
  }

  public void setUserService(UserService userService) {
    this.userService = userService;
  }
}
