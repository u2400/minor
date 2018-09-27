//$Id: TeachTaskHeadAction.java,v 1.1 2010-9-25 下午05:14:41 zhouqi Exp $
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
 * zhouqi              2010-9-25             Created
 *  
 ********************************************************************************/

package com.shufe.web.action.course.task;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.bean.comparators.PropertyComparator;
import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.transfer.exporter.PropertyExtractor;
import com.ekingstar.eams.system.basecode.industry.CourseType;
import com.ekingstar.eams.system.baseinfo.StudentType;
import com.ekingstar.eams.system.security.model.EamsRole;
import com.ekingstar.eams.system.time.WeekInfo;
import com.ekingstar.security.User;
import com.shufe.model.Constants;
import com.shufe.model.course.task.ProjectClosePlan;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.course.arrange.task.CourseActivityDigestor;
import com.shufe.service.course.task.ProjectClosePlanService;
import com.shufe.service.course.task.TeachTaskPropertyExtractor;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;
import com.shufe.web.helper.TeachTaskSearchHelper;

public class ProjectClosePlanHeadAction extends CalendarRestrictionSupportAction {

  protected ProjectClosePlanService projectClosePlanService;

  protected TeachTaskSearchHelper teachTaskSearchHelper;

  /**
   * 进入教学任务管理模块
   */
  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    List stdTypes = baseInfoService.getBaseInfos(StudentType.class);
    User user = getUser(request.getSession());
    Long stdTypeId = getLong(request, "calendar.studentType.id");

    // 超找最适合用户的学生类别
    StudentType stdType = (StudentType) stdTypes.get(0);
    if (null == stdTypeId) {
      if (user != null && user.isCategory(EamsRole.STD_USER)) {
        Student std = getStudentFromSession(request.getSession());
        if (null != std) {
          stdType = std.getType();
        }
      }
    } else {
      stdType = (StudentType) utilService.get(StudentType.class, stdTypeId);
    }
    addCollection(request, "stdTypeList", stdTypes);
    setCalendar(request, stdType);
    // 设置日历中使用的学生类别
    StudentType studentType = (StudentType) request.getAttribute("studentType");
    List calendarStdTypes = teachCalendarService.getCalendarStdTypes(studentType.getId());
    List rs = (List) CollectionUtils.intersection(calendarStdTypes, stdTypes);
    Collections.sort(rs, new PropertyComparator("code"));
    addCollection(request, CALENDAR_STDTYPES_KEY, rs);

    TeachCalendar calenadar = (TeachCalendar) request.getAttribute(Constants.CALENDAR);
    EntityQuery query = new EntityQuery(TeachTask.class, "task");
    query.setSelect("distinct task.arrangeInfo.teachDepart");
    query.add(new Condition("task.calendar=:calendar", calenadar));

    addCollection(request, "teachDepartList", utilService.search(query));
    addCollection(request, Constants.DEPARTMENT_LIST, departmentService.getColleges());
    addCollection(request, "weeks", WeekInfo.WEEKS);
    initBaseCodes(request, "courseTypes", CourseType.class);
    return forward(request);
  }

  /**
   * 查找教学任务
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {

    EntityQuery query = teachTaskSearchHelper.buildProjectCloseQuery(request, Boolean.TRUE);
    searchQuerySetting(query, request);
    Collection lists = utilService.search(query);
    addCollection(request, "tasks", lists);
    return forward(request);

  }

  /**
   * 打印一个教学任务的学生名单
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward stuList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String teachTaskIds = get(request, "teachTaskIds");
    if (StringUtils.isEmpty(teachTaskIds)) { return forwardError(mapping, request, "error.model.id.needed"); }
    List tasks = utilService.load(ProjectClosePlan.class, "id", SeqStringUtil.transformToLong(teachTaskIds));
    Map courseTakes = new HashMap();
    for (Iterator iter = tasks.iterator(); iter.hasNext();) {
      ProjectClosePlan projectClosePlan = (ProjectClosePlan) iter.next();
      ArrayList myCourseTakeCloses = new ArrayList();
      myCourseTakeCloses.addAll(projectClosePlan.getCourseTakeCloses());
      courseTakes.put(projectClosePlan.getId().toString(), myCourseTakeCloses);
    }
    addCollection(request, "tasks", tasks);
    addSingleParameter(request, "courseTakes", courseTakes);

    // printStdListPrepare(teachTaskIds, request);
    return forward(request, "stuList");
  }

  /**
   * 获取学生名单
   * 
   * @param taskIds
   * @param request
   * @throws Exception
   */
  public void printStdListPrepare(String taskIds, HttpServletRequest request) throws Exception {
    List tasks = utilService.load(ProjectClosePlan.class, "id", SeqStringUtil.transformToLong(taskIds));
    Map courseTakes = new HashMap();
    for (Iterator iter = tasks.iterator(); iter.hasNext();) {
      ProjectClosePlan projectClosePlan = (ProjectClosePlan) iter.next();
      ArrayList myCourseTakeCloses = new ArrayList();
      myCourseTakeCloses.addAll(projectClosePlan.getCourseTakeCloses());
      courseTakes.put(projectClosePlan.getId().toString(), myCourseTakeCloses);
    }
    addCollection(request, "tasks", tasks);
    addSingleParameter(request, "courseTakes", courseTakes);
  }

  protected void searchQuerySetting(EntityQuery query, HttpServletRequest request) {
    ;
  }

  protected Collection getExportDatas(HttpServletRequest request) {
    EntityQuery query = teachTaskSearchHelper.buildTaskQuery(request, Boolean.TRUE);
    exportQuerySetting(query, request);
    return utilService.search(query);
  }

  protected void exportQuerySetting(EntityQuery query, HttpServletRequest request) {
    ;
  }

  protected PropertyExtractor getPropertyExtractor(HttpServletRequest request) {
    return new TeachTaskPropertyExtractor(getLocale(request), getResources(request));
  }

  public void setProjectClosePlanService(ProjectClosePlanService projectClosePlanService) {
    this.projectClosePlanService = projectClosePlanService;
  }

  public void setTeachTaskSearchHelper(TeachTaskSearchHelper teachTaskSearchHelper) {
    this.teachTaskSearchHelper = teachTaskSearchHelper;
  }

  /**
   * @param projectClosePlanService
   *          The projectClosePlanService to set.
   */

}
