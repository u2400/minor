package com.ekingstar.eams.teach.abilityrate.service;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateApply;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateApplyConfig;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateSubject;
import com.shufe.model.std.Student;

public class AbilitySignupChecker {

  UtilService utilService;

  AbilityScoreProvider provider;

  // courseAbility.error.timeSuitable=英语升降级申请还未开放
  // courseAbility.error.grade=没有针对你的年级开放
  // courseAbility.error.nullability=您没有英语等级信息，无法申请
  // courseAbility.error.notopenability=目前不允许你的等级进行申请
  // courseAbility.error.matchLevel=没有找到您可以申请的等级
  // courseAbility.error.notenoughScore=您的英语科目成绩没有达到达标要求
  // courseAbility.error.twiceApply=不能进行两次申请

  public AbilitySignupChecker(UtilService utilService, AbilityScoreProvider provider) {
    super();
    this.utilService = utilService;
    this.provider = provider;
  }

  public AbilitySignupChecker() {
    super();
  }

  public String check(CourseAbilityRateApplyConfig config, Student std, boolean isUpgrade) {
    if (!config.isTimeSuitable()) { return "courseAbility.error.timeSuitable"; }
    if (!config.getGrade().equals(std.getGrade())) { return "courseAbility.error.grade"; }
    LanguageAbility ability = std.getLanguageAbility();
    if (null == ability) { return "courseAbility.error.nullability"; }
    if (!config.getAbilities().contains(ability)) { return "courseAbility.error.notopenability"; }
    boolean matchLevel = false;
    if (isUpgrade) {
      for (LanguageAbility a : config.getAbilities()) {
        if (a.getLevel() - ability.getLevel() == 1) {
          matchLevel = true;
          break;
        }
      }
      for (CourseAbilityRateSubject subject : config.getSubjects()) {
        Float score = provider.getScore(subject, std);
        if (null == score || score < subject.getMinScore()) { return "courseAbility.error.notenoughScore"; }
      }
    } else {
      for (LanguageAbility a : config.getAbilities()) {
        if (a.getLevel() - ability.getLevel() == -1) {
          matchLevel = true;
          break;
        }
      }
      for (CourseAbilityRateSubject subject : config.getSubjects()) {
        Float score = provider.getScore(subject, std);
        if (null == score || score >= 60f) { return "courseAbility.error.notenoughScore"; }
      }
    }
    if (!matchLevel) { return "courseAbility.error.matchLevel"; }
    EntityQuery query = new EntityQuery(CourseAbilityRateApply.class, "apply");
    query.add(new Condition("apply.config.calendar<>:calendar", config.getCalendar()));
    query.setSelect("apply.id");
    if (utilService.search(query).size() > 0) { return "courseAbility.error.twiceApply"; }
    return null;
  }

  public void setProvider(AbilityScoreProvider provider) {
    this.provider = provider;
  }

  public void setUtilService(UtilService utilService) {
    this.utilService = utilService;
  }

}
