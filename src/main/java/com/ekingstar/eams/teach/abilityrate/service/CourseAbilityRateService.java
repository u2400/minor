package com.ekingstar.eams.teach.abilityrate.service;

import java.util.Map;

import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateApplyConfig;

public interface CourseAbilityRateService {

  Map<String, Integer> stat(CourseAbilityRateApplyConfig config);
}
