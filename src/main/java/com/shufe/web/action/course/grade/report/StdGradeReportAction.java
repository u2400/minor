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
 * chaostone            2007-01-04          Created
 * zq                   2007-09-13          在stdList()中，添加了addStdTypeTreeDataRealm(...)方法F
 ********************************************************************************/

package com.shufe.web.action.course.grade.report;

import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.eams.system.basecode.industry.GradeType;
import com.ekingstar.eams.teach.program.service.GradeFilter;
import com.ekingstar.eams.teach.program.service.impl.SubstituteGradeFilter;
import com.ekingstar.eams.teach.program.service.impl.SubstituteGradeFilter_V1;
import com.shufe.model.course.grade.CourseGrade;
import com.shufe.model.course.grade.CourseGradeComparator;
import com.shufe.model.course.grade.Grade;
import com.shufe.model.course.grade.report.StdGrade;
import com.shufe.model.std.Student;
import com.shufe.web.helper.StdSearchHelper;

/**
 * 学生个人成绩总表界面响应类
 * 
 * @author chaostone
 */
public class StdGradeReportAction extends GradeReportForStudentAction {

  protected StdSearchHelper stdSearchHelper;

  /**
   * 学生个人成绩总表主界面
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
    setDataRealm(request, hasStdTypeCollege);
    return forward(request);
  }

  /**
   * 查询学生
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
    addCollection(request, "students", utilService.search(query));
    addCollection(request, "gradeTypes", baseCodeService.getCodes(GradeType.class));
    request.setAttribute("printAt", new Date());
    return forward(request);
  }

  /**
   * 确认要显示（或打印）成绩总表的学生
   * 
   * @param request
   * @return
   */
  protected List<Student> findStudents(HttpServletRequest request) {
    return utilService.load(Student.class, "id", SeqStringUtil.transformToLong(get(request, "stdIds")));
  }

  /**
   * 测试filter两个版本的差别
   * 
   * @param setting
   * @param cmp
   */
  protected void tmpFun(GradeReportSetting setting, CourseGradeComparator cmp) {
    List stds = utilService
        .searchHQLQuery("from Student where enrollYear='2005-9' and code='0305051001' order by code");
    CourseGrade example = new CourseGrade();
    example.setMajorType(setting.getMajorType());
    if (Boolean.TRUE.equals(setting.published)) {
      example.setStatus(new Integer(Grade.PUBLISHED));
    }
    int i = 0;
    for (Iterator iterator = stds.iterator(); iterator.hasNext();) {
      Student std = (Student) iterator.next();
      GradeFilter filter1 = new SubstituteGradeFilter_V1(substituteCourseService.getStdSubstituteCourses(std,
          setting.getMajorType()));
      GradeFilter filter2 = new SubstituteGradeFilter(substituteCourseService.getStdSubstituteCourses(std,
          setting.getMajorType()));
      example.setStd(std);
      List grades = gradeService.getCourseGrades(example);
      StdGrade stdGrade1 = new StdGrade(std, filter1.filter(grades), cmp, setting.getGradePrintType());
      StdGrade stdGrade2 = new StdGrade(std, filter2.filter(grades), cmp, setting.getGradePrintType());
      i++;
      if (0 != stdGrade1.getCredit().compareTo(stdGrade2.getCredit())
          || 0 != stdGrade1.getGPA().compareTo(stdGrade2.getGPA())) {
      }
      // Collection a = CollectionUtils.subtract(stdGrade1.getGrades(),
      // stdGrade2.getGrades());
      // Collection b = CollectionUtils.subtract(stdGrade2.getGrades(),
      // stdGrade1.getGrades());
    }
  }

  public void setStdSearchHelper(StdSearchHelper stdSearchHelper) {
    this.stdSearchHelper = stdSearchHelper;
  }
}
