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

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.bean.comparators.PropertyComparator;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.transfer.exporter.PropertyExtractor;
import com.ekingstar.eams.system.basecode.industry.CourseType;
import com.ekingstar.eams.system.baseinfo.StudentType;
import com.ekingstar.eams.system.security.model.EamsRole;
import com.ekingstar.eams.system.time.WeekInfo;
import com.ekingstar.security.User;
import com.ekingstar.security.model.UserCategory;
import com.shufe.model.Constants;
import com.shufe.model.course.arrange.CourseArrangeSwitch;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.course.task.TeachTaskPropertyExtractor;
import com.shufe.service.course.task.TeachTaskService;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;
import com.shufe.web.helper.TeachTaskSearchHelper;

public class TeachTaskHeadAction extends CalendarRestrictionSupportAction {

  protected TeachTaskService teachTaskService;

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

    TeachCalendar calendar = (TeachCalendar) request.getAttribute(Constants.CALENDAR);
    EntityQuery query = new EntityQuery(TeachTask.class, "task");
    query.setSelect("distinct task.arrangeInfo.teachDepart");
    query.add(new Condition("task.calendar=:calendar", calendar));

    addCollection(request, "teachDepartList", utilService.search(query));
    addCollection(request, Constants.DEPARTMENT_LIST, departmentService.getColleges());
    addCollection(request, "weeks", WeekInfo.WEEKS);
    initBaseCodes(request, "courseTypes", CourseType.class);

    putUserCategory(request);

    addSingleParameter(request, "switch", loadCourseArrangeSwitch(calendar));
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
   * 确定用户身份
   * 
   * @param request
   */
  protected void putUserCategory(HttpServletRequest request) {
    User user = getUser(request.getSession());
    addSingleParameter(request, "user", user);
    Boolean isAdmin = Boolean.FALSE;
    Set categories = user.getCategories();
    if (null != categories) {
      Iterator it = categories.iterator();
      while (it.hasNext()) {
        UserCategory temp = (UserCategory) it.next();
        if (temp.getId().equals(EamsRole.MANAGER_USER)) {
          isAdmin = Boolean.TRUE;
          break;
        }
      }
    }
    request.setAttribute("isAdmin", isAdmin);
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
    // 暂不要删除，因页面中有ignoreAuthority参数
    // Boolean ignoreAuthority = getBoolean(request, "ignoreAuthority");
    // Collection tasks = null;
    // if (null != ignoreAuthority && ignoreAuthority.equals(Boolean.TRUE)) {
    // tasks = teachTaskSearchHelper.searchTask(request);
    // } else {
    // tasks = teachTaskSearchHelper.searchTask(request);
    // }
    EntityQuery query = teachTaskSearchHelper.buildTaskQuery(request, Boolean.TRUE);
    searchQuerySetting(query, request);
    addCollection(request, "tasks", utilService.search(query));
    return forward(request);
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

  /**
   * @param teachTaskService
   *          The teachTaskService to set.
   */
  public void setTeachTaskService(TeachTaskService teachTaskService) {
    this.teachTaskService = teachTaskService;
  }

  public void setTeachTaskSearchHelper(TeachTaskSearchHelper teachTaskSearchHelper) {
    this.teachTaskSearchHelper = teachTaskSearchHelper;
  }

}
