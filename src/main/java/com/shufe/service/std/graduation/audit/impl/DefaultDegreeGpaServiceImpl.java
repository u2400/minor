package com.shufe.service.std.graduation.audit.impl;

import com.ekingstar.eams.system.basecode.industry.MajorType;
import com.shufe.model.std.Student;
import com.shufe.service.course.grade.gp.GradePointService;

public class DefaultDegreeGpaServiceImpl implements DegreeGpaService {

  private GradePointService gradePointService;

  @Override
  public Float statGpa(Student std, MajorType majorType) {
    return gradePointService.statStdGPA(std, null, majorType, Boolean.TRUE);
  }

  public final void setGradePointService(GradePointService gradePointService) {
    this.gradePointService = gradePointService;
  }

}
