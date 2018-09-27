package com.shufe.service.course.achivement.impl;

import com.ekingstar.eams.system.basecode.industry.GradeType;
import com.shufe.model.course.grade.CourseGrade;
import com.shufe.model.course.grade.ExamGrade;

public class GaScoreProvider {

  private static final GradeType Makeup = new GradeType(GradeType.MAKEUP);

  public static Float getScore(CourseGrade grade) {
    ExamGrade m = grade.getExamGrade(Makeup);
    if (null == m) return grade.getScore();
    else return grade.getGA();
  }

  public static boolean isPassed(Float score){
    return (null != score && Float.compare(score, 60.0f) >= 0);
  }
}
