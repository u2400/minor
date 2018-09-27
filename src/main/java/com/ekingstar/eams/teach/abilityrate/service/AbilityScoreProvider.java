package com.ekingstar.eams.teach.abilityrate.service;

import java.util.Collection;

import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.ekingstar.eams.std.info.Student;
import com.ekingstar.eams.system.basecode.industry.GradeType;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateSubject;
import com.shufe.model.course.grade.CourseGrade;
import com.shufe.model.course.grade.ExamGrade;
import com.shufe.model.course.grade.Grade;

public class AbilityScoreProvider {

  UtilService utilService;

  public AbilityScoreProvider() {
    super();
  }

  public AbilityScoreProvider(UtilService utilService) {
    super();
    this.utilService = utilService;
  }

  public Float getScore(CourseAbilityRateSubject subject, Student std) {
    String[] courseCodes = StringUtils.split(subject.getCourseCodes(), ",");
    if (courseCodes.length < 1) return null;
    EntityQuery query = new EntityQuery(CourseGrade.class, "cg");
    query.join("cg.examGrades", "eg");
    query.add(new Condition("cg.std=:std", std));
    query.add(new Condition("eg.gradeType.id=:endId", GradeType.END));
    query.add(new Condition("cg.course.code in(:codes)", courseCodes));
    query.add(new Condition("eg.status=:status", Grade.PUBLISHED));
    query.setSelect("eg");
    Collection<ExamGrade> endGrades = utilService.search(query);
    if (endGrades.isEmpty()) return null;
    Float maxScore = 0f;
    for (ExamGrade eg : endGrades) {
      if (null != eg.getScore() && eg.getScore() > maxScore) maxScore = eg.getScore();
    }
    return maxScore;
  }

  public void setUtilService(UtilService utilService) {
    this.utilService = utilService;
  }
}
