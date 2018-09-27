package com.shufe.service.std.alteration.service;

import com.shufe.model.std.alteration.StudentPropertyMeta;

public interface StudentInfoAlterApplyService {

  String getString(StudentPropertyMeta meta, String value);

  Object get(StudentPropertyMeta meta, String value);

}
