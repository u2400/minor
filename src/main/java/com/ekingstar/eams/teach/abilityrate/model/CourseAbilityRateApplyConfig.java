package com.ekingstar.eams.teach.abilityrate.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 英语升降级配置
 * 
 * @author chaostone
 */
public class CourseAbilityRateApplyConfig extends LongIdObject {

  private static final long serialVersionUID = -9216838542889654966L;

  private TeachCalendar calendar;

  /**
   * 允许申请的年级
   */
  private String grade;

  /**
   * 申请开始时间
   */
  private Date beginAt;

  /**
   * 申请结束时间
   */
  private Date endAt;

  /**
   * 升级提示
   */
  private String upgradeNotice;

  /**
   * 降级提示
   */
  private String degradeNotice;

  /**
   * 允许参与申请的级别集合
   */
  private Set<LanguageAbility> abilities = new HashSet<LanguageAbility>();

  /**
   * 所涉及的科目
   */
  private List<CourseAbilityRateSubject> subjects = new ArrayList<CourseAbilityRateSubject>();

  /**
   * 涉及到的面试信息
   */
  private List<InterviewInfo> interviewInfos = new ArrayList<InterviewInfo>();

  public TeachCalendar getCalendar() {
    return calendar;
  }

  public void setCalendar(TeachCalendar calendar) {
    this.calendar = calendar;
  }

  public Date getBeginAt() {
    return beginAt;
  }

  public void setBeginAt(Date beginAt) {
    this.beginAt = beginAt;
  }

  public Date getEndAt() {
    return endAt;
  }

  public void setEndAt(Date endAt) {
    this.endAt = endAt;
  }

  public String getUpgradeNotice() {
    return upgradeNotice;
  }

  public void setUpgradeNotice(String upgradeNotice) {
    this.upgradeNotice = upgradeNotice;
  }

  public String getDegradeNotice() {
    return degradeNotice;
  }

  public void setDegradeNotice(String degradeNotice) {
    this.degradeNotice = degradeNotice;
  }

  public Set<LanguageAbility> getAbilities() {
    return abilities;
  }

  public void setAbilities(Set<LanguageAbility> abilities) {
    this.abilities = abilities;
  }

  public List<InterviewInfo> getInterviewInfos() {
    return interviewInfos;
  }

  public void setInterviewInfos(List<InterviewInfo> interviewInfos) {
    this.interviewInfos = interviewInfos;
  }

  public List<CourseAbilityRateSubject> getSubjects() {
    return subjects;
  }

  public void setSubjects(List<CourseAbilityRateSubject> subjects) {
    this.subjects = subjects;
  }

  public String getGrade() {
    return grade;
  }

  public void setGrade(String grade) {
    this.grade = grade;
  }

  public static long getSerialversionuid() {
    return serialVersionUID;
  }

  public boolean isTimeSuitable() {
    long now = System.currentTimeMillis();
    return (now <= endAt.getTime()) && (now >= beginAt.getTime());
  }
}
