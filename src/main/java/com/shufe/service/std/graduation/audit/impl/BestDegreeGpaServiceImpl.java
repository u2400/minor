package com.shufe.service.std.graduation.audit.impl;

import java.util.Iterator;
import java.util.List;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.utils.persistence.impl.BaseServiceImpl;
import com.ekingstar.eams.system.basecode.industry.MajorType;
import com.ekingstar.eams.teach.program.service.GradeFilter;
import com.ekingstar.eams.teach.program.service.SubstituteCourseService;
import com.ekingstar.eams.teach.program.service.impl.SubstituteGradeFilter;
import com.shufe.model.course.grade.CourseGrade;
import com.shufe.model.course.grade.Grade;
import com.shufe.model.std.Student;

public class BestDegreeGpaServiceImpl extends BaseServiceImpl implements DegreeGpaService {

  protected SubstituteCourseService substituteCourseService;

  @Override
  public Float statGpa(Student student, MajorType majorType) {
    EntityQuery entityQuery = new EntityQuery(CourseGrade.class, "grade");
    entityQuery.add(new Condition("grade.std=:std", student));
    if (null != majorType) {
      entityQuery.add(new Condition("grade.majorType=:majorType", majorType));
    }
    entityQuery.add(new Condition("grade.status=" + Grade.PUBLISHED));
    List rs = (List) utilDao.search(entityQuery);

    GradeFilter filter = new SubstituteGradeFilter(substituteCourseService.getStdSubstituteCourses(student,
        majorType));
    rs = filter.filter(rs);
    double credits = 0;
    double gp = 0;
    for (Iterator iter = rs.iterator(); iter.hasNext();) {
      CourseGrade courseGrade = (CourseGrade) iter.next();
      credits += courseGrade.getCredit().doubleValue();
      gp += courseGrade.getCredit().doubleValue() * courseGrade.getGP().doubleValue();
    }
    if (credits == 0) return new Float(0);
    else {
      return new Float(gp / credits);
    }
  }

  public void setSubstituteCourseService(SubstituteCourseService substituteCourseService) {
    this.substituteCourseService = substituteCourseService;
  }
}
