//$Id: CourseInTaskAction.java,v 1.1 2010-9-25 下午05:28:54 zhouqi Exp $
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

import java.sql.Date;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.beanfuse.lang.SeqStringUtil;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.transfer.exporter.Context;
import com.ekingstar.commons.transfer.exporter.PropertyExtractor;
import com.ekingstar.eams.system.basecode.industry.CourseCategory;
import com.ekingstar.eams.system.basecode.industry.GradeType;
import com.ekingstar.eams.system.basecode.state.Gender;
import com.ekingstar.eams.system.baseinfo.SchoolDistrict;
import com.ekingstar.eams.system.security.model.EamsRole;
import com.ekingstar.eams.system.time.WeekInfo;
import com.shufe.model.Constants;
import com.shufe.model.course.grade.report.TeachClassGrade;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.course.task.TeachTaskParam;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.course.task.TeachTaskPropertyExtractor;

/**
 * @author zhouqi
 */
public class CourseInTaskAction extends TeachTaskHeadAction {

  /**
   * 进入教学任务管理模块
   */
  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setCalendarDataRealm(request, hasStdTypeCollege);
    TeachCalendar teachCalendar = (TeachCalendar) request.getAttribute(Constants.CALENDAR);
    EntityQuery query = new EntityQuery(TeachTaskParam.class, "teachTaskParam");
    String order = "Y";
    if (teachCalendar != null) {
      query.add(new Condition("teachTaskParam.calendar.id=" + teachCalendar.getId()));
    }
    List manualArrangeParamList = (List) utilService.search(query);
    Set users = getUser(request.getSession()).getRoles();
    for (Iterator iter = users.iterator(); iter.hasNext();) {
      EamsRole eamsRole = (EamsRole) iter.next();
      if (manualArrangeParamList.size() == 0 && eamsRole.getId().longValue() != 1L) {
        order = "N";
      } else {
        for (Iterator iter_ = manualArrangeParamList.iterator(); iter_.hasNext();) {
          TeachTaskParam param = (TeachTaskParam) iter_.next();
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
    // 获得开课院系和上课教师列表
    String stdTypeDataRealm = getStdTypeIdSeq(request);
    String departDataRealm = getDepartmentIdSeq(request);
    if (request.getAttribute(Constants.CALENDAR) != null) {
      List departList = teachTaskService.getDepartsOfTask(stdTypeDataRealm, departDataRealm,
          (TeachCalendar) request.getAttribute(Constants.CALENDAR));
      addCollection(
          request,
          "courseTypes",
          teachTaskService.getCourseTypesOfTask(stdTypeDataRealm, departDataRealm,
              (TeachCalendar) request.getAttribute(Constants.CALENDAR)));
      addCollection(
          request,
          "teachDepartList",
          teachTaskService.getTeachDepartsOfTask(stdTypeDataRealm, departDataRealm,
              (TeachCalendar) request.getAttribute(Constants.CALENDAR)));

      addCollection(request, Constants.DEPARTMENT_LIST, departList);
      addCollection(request, "weeks", WeekInfo.WEEKS);
    }

    initBaseCodes(request, "schoolDistricts", SchoolDistrict.class);
    /*----------------加载上课学生性别列表--------------------*/
    initBaseCodes(request, "genderList", Gender.class);
    initBaseCodes(request, "courseCategoryList", CourseCategory.class);
    return forward(request);
  }

  protected void searchQuerySetting(EntityQuery query, HttpServletRequest request) {
    String ss = "select distinct task.course, (select count(*) from CourseGrade grade where grade.calendar = task.calendar and grade.course = task.course), (select count(*) from CourseGrade grade where grade.calendar = task.calendar)";
    query.setSelect(ss);
  }

  protected void exportQuerySetting(EntityQuery query, HttpServletRequest request) {
    Boolean isExportedTaskList = getBoolean(request, "isExportedTaskList");

    try {
      // 为避免异常导出
      if (null == isExportedTaskList) { throw new Exception("Error: Invalid Exported!"); }

      // 如果isExportedTaskList为true，则导出当前查询任务，不需要对query任何的处理；
      // 若为false，则导出当前选择课程的教学任务，需要进行如下处理。
      if (Boolean.FALSE.equals(isExportedTaskList)) {
        String courseIdSeq = get(request, "courseIds");
        if (StringUtils.isBlank(courseIdSeq)) { throw new Exception("No pointed CourseId(s)!"); }
        Long[] courseIds = SeqStringUtil.transformToLong(courseIdSeq);
        query.add(new Condition("task.course.id in (:courseIds)", courseIds));
        query.getOrders().clear();
        // 优先排序课程
        StringBuilder orderBy = new StringBuilder();
        orderBy.append("task.course.name");
        String orderByForOther = get(request, "orderBy");
        if (StringUtils.isNotBlank(orderByForOther)) {
          orderBy.append(",").append(orderByForOther);
        }
        query.addOrder(OrderUtils.parser(orderBy.toString()));
      }
      query.setLimit(null);
    } catch (Exception e) {
      e.printStackTrace();
      throw new RuntimeException("Export Failure!");
    }
  }

  protected PropertyExtractor getPropertyExtractor(HttpServletRequest request) {
    if (null != getBoolean(request, "isExportedTaskList")) {
      return new TeachTaskPropertyExtractor(getLocale(request), getResources(request));
    } else {
      return super.getPropertyExtractor(request);
    }
  }

  protected void configExportContext(HttpServletRequest request, Context context) {
    Boolean isExportedStdScores = getBoolean(request, "isExportedStdScores");
    if (null != isExportedStdScores) {
      EntityQuery query = teachTaskSearchHelper.buildTaskQuery(request, Boolean.TRUE);
      if (Boolean.FALSE.equals(isExportedStdScores)) {
        String courseIdSeq = get(request, "courseIds");
        query
            .add(new Condition("task.course.id in (:courseIds)", SeqStringUtil.transformToLong(courseIdSeq)));
      }
      query.setLimit(null);
      query.getOrders().clear();
      Collection tasks = utilService.search(query);

      Integer stdPerClass = getInteger(request, "stdPerClass");
      if (null == stdPerClass) {
        stdPerClass = new Integer(80);
      }
      List reports = new ArrayList();
      GradeType GA = (GradeType) baseCodeService.getCode(GradeType.class, GradeType.GA);
      for (Iterator iter = tasks.iterator(); iter.hasNext();) {
        TeachTask task = (TeachTask) iter.next();
        List gradeTypes = gradeService.getGradeTypes(task.getGradeState());
        if (!gradeTypes.contains(GA)) {
          gradeTypes.add(GA);
        }
        reports.addAll(TeachClassGrade.buildTaskClassGrade(gradeTypes, task,
            gradeService.getCourseGrades(task), stdPerClass));
      }
      context.put("reports", reports);
      List indexes = new ArrayList();
      for (int i = 0; i < stdPerClass.intValue() / 2; i++) {
        indexes.add(new Integer(i));
      }
      context.put("indexes", indexes);
      context.put("USUAL", baseCodeService.getCode(GradeType.class, GradeType.USUAL));
      context.put("END", baseCodeService.getCode(GradeType.class, GradeType.END));
      // context.put("END", baseCodeService.getCode(GradeType.class, GradeType.DELAY));
      context.put("USUAL", baseCodeService.getCode(GradeType.class, GradeType.USUAL));
      context.put("resourses", getResources(request));
      context.put("locale", getLocale(request));
      context.put("systemConfig", getSystemConfig());
      context.put("haveClassAt", ":day:time :weeks周");
      context.put("haveClassPlace", " :room(:district :building)");
    } else {
      super.configExportContext(request, context);
    }
  }
}
