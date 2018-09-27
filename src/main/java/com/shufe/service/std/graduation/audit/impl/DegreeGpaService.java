package com.shufe.service.std.graduation.audit.impl;

import com.ekingstar.eams.system.basecode.industry.MajorType;
import com.shufe.model.std.Student;

public interface DegreeGpaService {

  Float statGpa(Student student, MajorType majorType);
}
