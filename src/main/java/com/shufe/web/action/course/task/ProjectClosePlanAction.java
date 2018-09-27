//$Id: TeachTaskAction.java,v 1.52 2007/01/15 01:03:44 duanth Exp $
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
 * chaostone            2005-10-25          Created
 * zq                   2007-09-18          修改或替换了本Action中的所有info()方法 
 * zq                   2007-10-17          在edit()方法中，添加了“授课语言类型”
 *                                          和修改了更新了相关的初始化列表
 ********************************************************************************/

package com.shufe.web.action.course.task;

import java.sql.Date;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
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
import com.ekingstar.eams.system.basecode.industry.CourseCategory;
import com.ekingstar.eams.system.basecode.state.Gender;
import com.ekingstar.eams.system.baseinfo.SchoolDistrict;
import com.ekingstar.eams.system.security.model.EamsRole;
import com.ekingstar.eams.system.time.WeekInfo;
import com.shufe.model.Constants;
import com.shufe.model.course.arrange.CourseArrangeSwitch;
import com.shufe.model.course.task.ProjectClosePlan;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.course.task.TeachTaskParam;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.course.arrange.task.CourseActivityDigestor;
import com.shufe.service.course.task.ProjectClosePlanService;

/**
 * 不开课记录
 */
public class ProjectClosePlanAction extends ProjectClosePlanHeadAction {

  /**
   * 进入教学任务管理模块
   */
  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setCalendarDataRealm(request, hasStdTypeCollege);
    // 获得开课院系和上课教师列表
    String stdTypeDataRealm = getStdTypeIdSeq(request);
    String departDataRealm = getDepartmentIdSeq(request);
    if (request.getAttribute(Constants.CALENDAR) != null) {
      List departList = projectClosePlanService.getDepartsOfTask(stdTypeDataRealm, departDataRealm,
          (TeachCalendar) request.getAttribute(Constants.CALENDAR));
      addCollection(request, "courseTypes", projectClosePlanService.getCourseTypesOfTask(stdTypeDataRealm,
          departDataRealm, (TeachCalendar) request.getAttribute(Constants.CALENDAR)));
      addCollection(request, "teachDepartList", projectClosePlanService.getTeachDepartsOfTask(
          stdTypeDataRealm, departDataRealm, (TeachCalendar) request.getAttribute(Constants.CALENDAR)));

      addCollection(request, Constants.DEPARTMENT_LIST, departList);
      addCollection(request, "weeks", WeekInfo.WEEKS);
    }

    // initBaseCodes(request, "schoolDistricts", SchoolDistrict.class);
    // /*----------------加载上课学生性别列表--------------------*/
    // initBaseCodes(request, "genderList", Gender.class);
    // initBaseCodes(request, "courseCategoryList", CourseCategory.class);
    return forward(request);
  }

  public ActionForward arrangeInfoList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Collection tasks = teachTaskSearchHelper.searchTask(request);
    addCollection(request, "tasks", tasks);
    CourseActivityDigestor.setDelimeter("<br>");
    Map arrangeInfo = new HashMap();
    for (Iterator iter = tasks.iterator(); iter.hasNext();) {
      TeachTask task = (TeachTask) iter.next();
      arrangeInfo.put(task.getId().toString(),
          CourseActivityDigestor.digest(task, getResources(request), getLocale(request)));
    }
    addSingleParameter(request, "arrangeInfo", arrangeInfo);
    addSingleParameter(request, "userCategory", getUserCategoryId(request));
    List switches = utilService.load(CourseArrangeSwitch.class, "calendar.id",
        getLong(request, "calendar.id"));
    if (CollectionUtils.isNotEmpty(switches)) {
      addSingleParameter(request, "switch", switches.get(0));
    }
    return forward(request);
  }

  /**
   * 点击查询跳入的方法
   */
  protected ActionForward forward(HttpServletRequest request) {
    Map<String, ActionForward> forwardMap = new HashMap<String, ActionForward>();
    forwardMap.put("index", super.forward(request));
    forwardMap.put("search", super.forward(request));

    String method = get(request, "method");

    if (StringUtils.isBlank(method)) {
      method = "index";
    }
    ActionForward forward = forwardMap.get(method);
    if (null == forward) { return forward(request, "../teachTaskCollege/" + method); }
    return forward;
  }
}
