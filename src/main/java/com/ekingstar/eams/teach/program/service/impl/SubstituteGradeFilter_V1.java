package com.ekingstar.eams.teach.program.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.map.MultiValueMap;

import com.ekingstar.commons.bean.comparators.PropertyComparator;
import com.ekingstar.eams.teach.program.SubstituteCourse;
import com.ekingstar.eams.teach.program.service.GradeFilter;
import com.shufe.model.course.grade.CourseGrade;
import com.shufe.model.system.baseinfo.Course;

public class SubstituteGradeFilter_V1 implements GradeFilter {

  private List substituteCourses = null;

  public SubstituteGradeFilter_V1() {
  }

  public SubstituteGradeFilter_V1(List substituteCourses) {
    this.substituteCourses = substituteCourses;
  }

  private Map getBestMap(List grades) {
    Map objMap = new HashMap();
    CourseGrade old = null;
    for (Iterator iter = grades.iterator(); iter.hasNext();) {
      CourseGrade grade = (CourseGrade) iter.next();
      old = (CourseGrade) objMap.get(grade.getCourse().getId());
      if (!(old != null && old.getGP().compareTo(grade.getGP()) > 0)) {
        objMap.put(grade.getCourse().getId(), grade);
      }
    }
    return objMap;
  }

  /**
   * @param grades
   *          <SubstitueCourse>
   * @return
   */
  public List filter(List grades) {
    Map newMap = getBestMap(grades);
    if (substituteCourses != null) {
      SubstituteCourse subCourse = null;
      // 记录替代课程成功的课程substitueCourses->OriginCourseGrade
      Map substituteMap = new MultiValueMap();
      for (Iterator iter = substituteCourses.iterator(); iter.hasNext();) {
        subCourse = (SubstituteCourse) iter.next();
        float score1 = 0;
        float gpa1 = 0;
        float credit1 = 0;
        for (Iterator it1 = subCourse.getOrigins().iterator(); it1.hasNext();) {
          Course course = (Course) it1.next();
          CourseGrade grade = (CourseGrade) newMap.get(course.getId());
          if (null != grade) {
            score1 += grade.getScore().floatValue();
            gpa1 += grade.getCredit().floatValue() * grade.getGP().floatValue();
            credit1 += grade.getCredit().floatValue();
          }
        }
        float score2 = 0;
        float gpa2 = 0;
        float credit2 = 0;
        for (Iterator it1 = subCourse.getSubstitutes().iterator(); it1.hasNext();) {
          Course course = (Course) it1.next();
          CourseGrade grade = (CourseGrade) newMap.get(course.getId());
          if (null != grade) {
            score2 += grade.getScore().floatValue();
            gpa2 += grade.getCredit().floatValue() * grade.getGP().floatValue();
            credit2 += grade.getCredit().floatValue();
          } else {
            gpa2 = credit2 = 0;
            break;
          }
        }
        if (credit1 > 0 && credit2 > 0 && gpa1 / credit1 < gpa2 / credit2 && score1 < score2) {
          substituteMap.put(subCourse.getSubstitutes(), new SubstituteGroupGrade(score1, credit1, gpa1, 0,
              subCourse.getOrigins()));
        }
      }
      // 开始替代
      for (Iterator iterator = substituteMap.keySet().iterator(); iterator.hasNext();) {
        Set courses = (Set) iterator.next();
        // 把可选成绩中gpa最小的作为替代对象
        List overlaped = (List) substituteMap.get(courses);
        if (1 < overlaped.size()) {
          Collections.sort(overlaped, new PropertyComparator("gpa asc"));
        }
        SubstituteGroupGrade scg = (SubstituteGroupGrade) overlaped.get(0);
        for (Iterator iterator2 = scg.getCourses().iterator(); iterator2.hasNext();) {
          Course course = (Course) iterator2.next();
          newMap.remove(course.getId());
        }
      }
    }
    return new ArrayList(newMap.values());
  }

  public List getSubstituteCourses() {
    return substituteCourses;
  }

  public void setSubstituteCourses(List substituteCourses) {
    this.substituteCourses = substituteCourses;
  }

}
