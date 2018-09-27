package com.ekingstar.eams.teach.abilityrate.service;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateApply;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateApplyConfig;

public class CourseAbilityRateServiceImpl implements CourseAbilityRateService {

  private UtilService utilService;

  @SuppressWarnings("unchecked")
  @Override
  public Map<String, Integer> stat(CourseAbilityRateApplyConfig config) {
    EntityQuery query = new EntityQuery(CourseAbilityRateApply.class, "apply");
    query.add(new Condition("apply.config=:config", config));
    query.add(new Condition("apply.interview is not null"));
    query.groupBy("apply.interview.id");
    query.setSelect("apply.interview.id,count(*)");
    Collection<Object[]> datas = utilService.search(query);
    Map<String, Integer> rs = new HashMap<String, Integer>();
    for (Object[] data : datas) {
      rs.put(data[0].toString(), Integer.valueOf(((Number) data[1]).intValue()));
    }
    return rs;
  }

  public void setUtilService(UtilService utilService) {
    this.utilService = utilService;
  }

}
