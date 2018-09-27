package com.ekingstar.eams.teach.program.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.map.MultiValueMap;

import com.ekingstar.eams.teach.program.SubstituteCourse;
import com.ekingstar.eams.teach.program.service.GradeFilter;
import com.shufe.model.course.grade.CourseGrade;
import com.shufe.model.system.baseinfo.Course;

public class SubstituteGradeFilter implements GradeFilter {

  private List substituteCourses = null;

  public SubstituteGradeFilter() {
  }

  public SubstituteGradeFilter(List substituteCourses) {
    this.substituteCourses = substituteCourses;
  }

  private Map getBestMap(List grades) {
    Map objMap = new HashMap();
    CourseGrade old = null;
    for (Iterator iter = grades.iterator(); iter.hasNext();) {
      CourseGrade grade = (CourseGrade) iter.next();
      old = (CourseGrade) objMap.get(grade.getCourse().getId());
      if (null == old) {
        objMap.put(grade.getCourse().getId(), grade);
      } else {
        if (old.getGP().compareTo(grade.getGP()) <= 0) {
          if (old.getGP().compareTo(grade.getGP()) == 0) {
            Float oldScore = null == old.getScore() ? 0 : old.getScore();
            Float newScore = null == grade.getScore() ? 0 : grade.getScore();
            if (oldScore < newScore) {
              objMap.put(grade.getCourse().getId(), grade);
            }
          } else {
            objMap.put(grade.getCourse().getId(), grade);
          }
        }
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
        SubstituteGroupGrade ocg1 = make(subCourse.getOrigins(), newMap);
        SubstituteGroupGrade ocg2 = make(subCourse.getSubstitutes(), newMap);
        if (ocg1.fullGrade || ocg2.fullGrade) {
          substituteMap.put(subCourse.getSubstitutes(), ocg2);
          substituteMap.put(subCourse.getSubstitutes(), ocg1);
        }
      }
      // 开始替代
      for (Iterator iterator = substituteMap.keySet().iterator(); iterator.hasNext();) {
        Set courses = (Set) iterator.next();
        // 把可选成绩中最小的作为删除对象
        List overlaped = (List) substituteMap.get(courses);
        Collections.sort(overlaped);
        SubstituteGroupGrade scg = (SubstituteGroupGrade) overlaped.get(0);
        for (Iterator iterator2 = scg.getCourses().iterator(); iterator2.hasNext();) {
          Course course = (Course) iterator2.next();
          newMap.remove(course.getId());
        }
      }
    }
    return new ArrayList(newMap.values());
  }

  private SubstituteGroupGrade make(Set origins, Map newMap) {
    float score = 0;
    float gpa = 0;
    float credit = 0;
    float ga = 0;
    boolean fullGrade = true;
    for (Iterator it1 = origins.iterator(); it1.hasNext();) {
      Course course = (Course) it1.next();
      CourseGrade grade = (CourseGrade) newMap.get(course.getId());
      if (null != grade) {
        if (grade.getScore() != null) {
          score += grade.getScore().floatValue();
        }
        gpa += grade.getCredit().floatValue() * grade.getGP().floatValue();
        credit += grade.getCredit().floatValue();
        if (null != grade.getScore()) {
          ga += grade.getCredit().floatValue() * grade.getScore().floatValue();
        }
      } else {
        fullGrade = false;
      }
    }
    SubstituteGroupGrade ocg = null;
    if (0 == credit) {
      fullGrade = false;
      ocg = new SubstituteGroupGrade(score, credit, gpa, ga, Collections.EMPTY_SET);
    } else {
      ocg = new SubstituteGroupGrade(score, credit, gpa, ga, origins);
    }
    ocg.setFullGrade(fullGrade);
    return ocg;
  }

  public List getSubstituteCourses() {
    return substituteCourses;
  }

  public void setSubstituteCourses(List substituteCourses) {
    this.substituteCourses = substituteCourses;
  }

}
