package com.shufe.service.course.achivement.impl;

import java.util.List;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.shufe.model.course.grade.MoralGrade;
import com.shufe.model.std.Student;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.BasicService;
import com.shufe.service.course.achivement.GradeResult;
import com.shufe.service.course.achivement.MoralGradeProvider;

public class MoralGradeProviderImpl extends BasicService implements MoralGradeProvider {

  @Override
  public GradeResult getGrade(Student std, List<TeachCalendar> calendars) {
    EntityQuery query = new EntityQuery(MoralGrade.class, "grade");
    query.add(new Condition("grade.std=:std", std));
    query.add(new Condition("grade.calendar in (:calendars)", calendars));
    @SuppressWarnings("unchecked")
    List<MoralGrade> moralGrades = (List<MoralGrade>) utilService.search(query);
    Float score = null;
    if (moralGrades.size() > 1) {
      Float total = 0f;
      for (MoralGrade mg : moralGrades) {
        total += mg.getScore();
      }
      score = total / moralGrades.size();
    } else if (moralGrades.size() == 1) {
      score = moralGrades.get(0).getScore();
    }
    if (null == score) return new GradeResult(null, false);
    else return new GradeResult(score, Float.compare(score, 60) >= 0);
  }

}
