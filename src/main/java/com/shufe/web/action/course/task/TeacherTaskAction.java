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
 * chaostone             2006-8-23            Created
 *  
 ********************************************************************************/
package com.shufe.web.action.course.task;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.web.dispatch.Action;
import com.ekingstar.eams.system.baseinfo.StudentType;
import com.ekingstar.eams.system.time.WeekInfo;
import com.shufe.dao.course.task.TeachTaskFilterCategory;
import com.shufe.model.Constants;
import com.shufe.model.course.arrange.CourseArrangeSwitch;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.course.task.TeachingSchedule;
import com.shufe.model.system.baseinfo.Teacher;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.course.arrange.task.CourseActivityDigestor;
import com.shufe.web.action.course.textbook.TeacherBookRequirementAction;

/**
 * 教师的教学任务
 * 
 * @author chaostone
 */
public class TeacherTaskAction extends TeacherBookRequirementAction {

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Teacher teacher = getTeacherFromSession(request.getSession());
    List stdTypeList = teachTaskService.getStdTypesForTeacher(teacher);
    if (stdTypeList.isEmpty()) { return forward(mapping, request, "error.teacher.noTask", "error"); }
    setCalendar(request, (StudentType) stdTypeList.iterator().next());

    request.setAttribute("stdTypeList", stdTypeList);
    request.setAttribute("weekList", WeekInfo.WEEKS);
    request.setAttribute("startWeek", new Integer(1));
    request.setAttribute("endWeek", ((TeachCalendar) request.getAttribute(Constants.CALENDAR)).getWeeks());
    List tasks = teachTaskService.getTeachTasksByCategory(teacher.getId(), TeachTaskFilterCategory.TEACHER,
        (TeachCalendar) request.getAttribute(Constants.CALENDAR));
    TeachCalendar calendar = (TeachCalendar) request.getAttribute(Constants.CALENDAR);
    List<CourseArrangeSwitch> courseArranges = utilService.load(CourseArrangeSwitch.class, "calendar.id",
        calendar.getId());
    addCollection(request, "taskList", tasks);
    // 控制排课结果的可见性
    Boolean isArrangeSwitch = Boolean.TRUE;
    Boolean isArrangeAddress = Boolean.TRUE;
    if (CollectionUtils.isNotEmpty(courseArranges)) {
      isArrangeSwitch &= courseArranges.get(0).getIsPublished();
      isArrangeAddress &= courseArranges.get(0).getIsArrangeAddress();
    }
    List activityList = new ArrayList();
    if (Boolean.TRUE.equals(isArrangeSwitch)) {
      CourseActivityDigestor.setDelimeter("<br>");
      for (Iterator iter = tasks.iterator(); iter.hasNext();) {
        TeachTask task = (TeachTask) iter.next();
        activityList.addAll(task.getArrangeInfo().getActivities());
      }

    }
    request.setAttribute("isArrangeSwitch", isArrangeSwitch);
    request.setAttribute("isArrangeAddress", isArrangeAddress);
    request.setAttribute(Constants.TEACHER, teacher);
    request.setAttribute("activityList", activityList);

    Map<String, TeachingSchedule> scheduleMap = new HashMap<String, TeachingSchedule>();
    EntityQuery query = new EntityQuery(TeachingSchedule.class, "schedule");
    if (CollectionUtils.isEmpty(tasks)) {
      query.add(new Condition("schedule.task is null"));
    } else {
      query.add(new Condition("schedule.task in (:tasks)", tasks));
    }
    Collection<TeachingSchedule> schedules = utilService.search(query);
    for (TeachingSchedule schedule : schedules) {
      scheduleMap.put(schedule.getTask().getId().toString(), schedule);
    }
    request.setAttribute("scheduleMap", scheduleMap);
    return forward(request);
  }

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    return forward(request, new Action(this, "index"));
  }

  /**
   * 学生名单
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
    Long taskId = getLong(request, "teachTask.id");
    if (null == taskId) return forwardError(mapping, request, "error.model.id.needed");
    TeachTask task = (TeachTask) utilService.get(TeachTask.class, taskId);
    request.setAttribute(Constants.TEACHTASK, task);
    ArrayList courseTakes = new ArrayList();
    courseTakes.addAll(task.getTeachClass().getCourseTakes());
    request.setAttribute("courseTakes", courseTakes);
    return forward(request);
  }

  /**
   * 学生考勤名单
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward printDutyStdList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    return forward(request, new Action("teachTask", "printStdListForDuty"));
  }

  /**
   * 教学任务书
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward taskInfo(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long taskId = getLong(request, "task.id");
    if (null == taskId) { return forwardError(mapping, request, "error.model.id.needed"); }
    request.setAttribute(Constants.TEACHTASK, utilService.get(TeachTask.class, taskId));
    return forward(request);
  }

  public ActionForward bookInfo(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long taskId = getLong(request, "task.id");
    if (null == taskId) { return forwardError(mapping, request, "error.model.id.needed"); }
    request.setAttribute(Constants.TEACHTASK, utilService.get(TeachTask.class, taskId));
    return forward(request);
  }
}
