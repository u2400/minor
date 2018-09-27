//$Id: GradeReportForStdAction.java,v 1.1 2012-10-23 zhouqi Exp $
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
 * zhouqi				2012-10-23             Created
 *  
 ********************************************************************************/

package com.shufe.web.action.course.grade.report;

import java.util.ArrayList;
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

import com.ekingstar.commons.bean.comparators.MultiPropertyComparator;
import com.ekingstar.commons.bean.comparators.PropertyComparator;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.Order;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.eams.std.graduation.audit.model.AuditResult;
import com.ekingstar.eams.system.basecode.industry.CourseType;
import com.ekingstar.eams.system.basecode.industry.GradeType;
import com.ekingstar.eams.teach.program.service.GradeFilter;
import com.ekingstar.eams.teach.program.service.SubstituteCourseService;
import com.ekingstar.eams.teach.program.service.impl.SubstituteGradeFilter;
import com.shufe.model.course.grade.CourseGrade;
import com.shufe.model.course.grade.CourseGradeComparator;
import com.shufe.model.course.grade.Grade;
import com.shufe.model.course.grade.gp.StdGP;
import com.shufe.model.course.grade.other.OtherGrade;
import com.shufe.model.course.grade.report.StdGrade;
import com.shufe.model.std.Student;
import com.shufe.service.course.grade.gp.GradePointService;
import com.shufe.service.course.grade.other.OtherGradeService;
import com.shufe.service.graduate.GraduateAuditService;
import com.shufe.web.action.common.RestrictionSupportAction;

/**
 * 学生打印成绩单
 * 
 * @author zhouqi
 */
public class GradeReportForStudentAction extends RestrictionSupportAction {

  protected SubstituteCourseService substituteCourseService;

  protected OtherGradeService otherGradeService;

  protected GradePointService gradePointService;

  protected GraduateAuditService graduateAuditService;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "gradeTypes", baseCodeService.getCodes(GradeType.class));
    return forward(request);
  }

  /**
   * 生成成绩总表
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  @SuppressWarnings("unchecked")
  public ActionForward report(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    // 找到参数和成绩比较器
    GradeReportSetting setting = new GradeReportSetting();
    populate(request, setting, "reportSetting");
    if (StringUtils.isEmpty(setting.getOrder().getProperty())) {
      setting.getOrder().setProperty("calendar.yearTerm");
      setting.getOrder().setDirection(Order.ASC);
    }
    // 默认80
    if (setting.getPageSize().intValue() <= 0) {
      setting.setPageSize(new Integer(80));
    }
    setting.setPrintGP(true);
    setting.setPrintOtherGrade(true);

    CourseGradeComparator cmp = new CourseGradeComparator(setting.getOrder().getProperty(),
        Order.ASC == setting.getOrder().getDirection(), baseCodeService.getCodes(GradeType.class));

    // 找到学生
    List<Student> students = findStudents(request);

    // 得到学生毕业审核数据
    EntityQuery query = new EntityQuery(AuditResult.class, "auditResult");
    query.add(new Condition("auditResult.std in (:students)", students));
    Map<String, AuditResult> auditResultMap = new HashMap<String, AuditResult>();
    for (Iterator<?> it = utilService.search(query).iterator(); it.hasNext();) {
      AuditResult auditResult = (AuditResult) it.next();
      auditResultMap.put(auditResult.getStd().getId().toString(), auditResult);
    }

    // 成绩样板
    CourseGrade example = new CourseGrade();
    example.setMajorType(setting.getMajorType());
    if (Boolean.TRUE.equals(setting.published)) {
      example.setStatus(new Integer(Grade.PUBLISHED));
    }
    // 制作报表
    List<StdGrade> stdGradeReports = new ArrayList<StdGrade>();
    Map<String, List<OtherGrade>> otherExamReportMap = new HashMap<String, List<OtherGrade>>();
    Map<String, OtherGrade> otherReportMap = new HashMap<String, OtherGrade>();
    Map<String, StdGP> stdGPMap = new HashMap<String, StdGP>();
    // 学生论文集合
    Map<String, Object> thesisSubjectMap = new HashMap<String, Object>();
    for (Student std : students) {
      example.setStd(std);
      List<CourseGrade> grades = gradeService.getCourseGrades(example);
      if (setting.getGradePrintType().equals(GradeReportSetting.BEST_GRADE)) {
        GradeFilter filter = new SubstituteGradeFilter(substituteCourseService.getStdSubstituteCourses(std,
            setting.getMajorType()));
        grades = filter.filter(grades);
      }
      StdGrade stdGrade = new StdGrade(std, grades, cmp, setting.getGradePrintType());
      graduateAuditService.filterSameCourse(stdGrade.getGrades());
      stdGradeReports.add(stdGrade);
      request.setAttribute("bz", Boolean.TRUE.equals(setting.getBz()) ? "Y" : "N");
      // 学生论文
      List<Object> thesisSubjectList = utilService
          .searchHQLQuery("select thesis.name from Thesis thesis where thesis.student.id=" + std.getId());
      Object thesisSubject = null;
      if (thesisSubjectList.size() != 0) {
        thesisSubject = thesisSubjectList.get(0);
      }
      thesisSubjectMap.put(std.getCode(), thesisSubject);

      // 校外考试
      if (Boolean.TRUE.equals(setting.getPrintOtherGrade())) {
        otherExamReportMap.put(std.getId().toString(), otherGradeService.getOtherGrades(std, Boolean.TRUE));
      }
      List<OtherGrade> otherGradeList = utilService.load(OtherGrade.class, "std.id", std.getId());
      if (CollectionUtils.isNotEmpty(otherGradeList)) {
        otherReportMap.put(std.getId().toString(), otherGradeList.get(0));
      }

      // 学期绩点;
      if (Boolean.TRUE.equals(setting.getPrintTermGP())) {
        stdGPMap.put(std.getId().toString(), gradePointService.statStdGPA(std, stdGrade.getGrades()));
      }
    }
    request.setAttribute("setting", setting);

    // 对多个报表进行排序
    List<Order> orders = OrderUtils.parser(get(request, "orderBy"));
    if (CollectionUtils.isEmpty(orders)) {
      Collections.sort(stdGradeReports, new MultiPropertyComparator(
          "std.firstMajor.name, std.firstMajorClass.name, std.code"));
    } else {
      Order order = orders.get(0);
      Collections.sort(stdGradeReports,
          new PropertyComparator(order.getProperty(), Order.ASC == order.getDirection()));
    }
    addCollection(request, "stdGradeReports", stdGradeReports);
    request.setAttribute("otherExamReportMap", otherExamReportMap);
    request.setAttribute("otherReportMap", otherReportMap);
    request.setAttribute("thesisSubjectMap", thesisSubjectMap);
    request.setAttribute("stdGPMap", stdGPMap);
    request.setAttribute("auditResultMap", auditResultMap);
    // tmpFun(setting, cmp);
    return forward(request);
  }

  @SuppressWarnings("unchecked")
  protected void filterSameCourseInGrades(StdGrade stdGrade) {
    if (null == stdGrade || CollectionUtils.isEmpty(stdGrade.getGrades())) { return; }
    List<CourseGrade> grades = stdGrade.getGrades();

    // 必修 > 专业限选 > 公选（根据“课程”的“课程类别”）
    Map<String, CourseGrade> priorityCourseMap = new HashMap<String, CourseGrade>();

    for (CourseGrade courseGrade : grades) {
      String courseName = courseGrade.getCourse().getName();
      if (priorityCourseMap.containsKey(courseName)) {
        CourseType preCourseType = priorityCourseMap.get(courseName).getCourseType();
        // 是否可升为必修
        boolean isOk1 = null != preCourseType && !preCourseType.getIsCompulsory();
        // 是否可升为限修
        boolean isOk2 = !isOk1
            && (null == preCourseType || CourseType.PUBLIC_COURSID.longValue() == preCourseType.getId()
                .longValue());
        // 如果之前暂存的是“公共等候课”，或者之前暂存提“限选课”
        if (isOk1 || isOk2) {
          priorityCourseMap.put(courseName, courseGrade);
        }
      } else {
        priorityCourseMap.put(courseName, courseGrade);
      }
    }

    for (int j = 0; j < grades.size();) {
      CourseGrade grade = grades.get(j);
      CourseGrade preGrade = priorityCourseMap.get(grade.getCourse().getName());
      // 是否必修
      boolean isOk1 = preGrade.getCourseType().getIsCompulsory()
          && grade.getCourseType().getIsCompulsory() == preGrade.getCourseType().getIsCompulsory();
      // 是否限修
      boolean isOk2 = !isOk1 && !preGrade.getCourseType().getIsCompulsory()
          && grade.getCourseType().getIsCompulsory() == preGrade.getCourseType().getIsCompulsory()
          && CourseType.PUBLIC_COURSID.longValue() != preGrade.getCourseType().getId().longValue()
          && CourseType.PUBLIC_COURSID.longValue() != grade.getCourseType().getId().longValue();
      // 是否公共
      boolean isOk3 = !isOk2
          && CourseType.PUBLIC_COURSID.longValue() == preGrade.getCourseType().getId().longValue()
          && preGrade.getCourseType().getId().longValue() == grade.getCourseType().getId().longValue();
      if (isOk1 || isOk2 || isOk3) {
        j++;
      } else {
        grades.remove(j);
      }
    }
  }

  /**
   * 确认要显示（或打印）成绩总表的学生
   * 
   * @param request
   * @return
   */
  protected List<Student> findStudents(HttpServletRequest request) {
    List<Student> students = new ArrayList<Student>();
    students.add(getStudentFromSession(request.getSession()));
    return students;
  }

  public void setOtherGradeService(OtherGradeService otherGradeService) {
    this.otherGradeService = otherGradeService;
  }

  public void setSubstituteCourseService(SubstituteCourseService substituteCourseService) {
    this.substituteCourseService = substituteCourseService;
  }

  public void setGradePointService(GradePointService gradePointService) {
    this.gradePointService = gradePointService;
  }

  public void setGraduateAuditService(GraduateAuditService graduateAuditService) {
    this.graduateAuditService = graduateAuditService;
  }
}
