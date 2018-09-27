package com.ekingstar.eams.teach.abilityrate.model;

import java.util.HashSet;
import java.util.Set;

import org.beanfuse.model.pojo.LongIdTimeObject;

import com.ekingstar.commons.model.Entity;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.shufe.model.std.Student;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 英语升降级申请信息
 * 
 * @author chaostone
 */
public class CourseAbilityRateApply extends LongIdTimeObject implements Entity {

  private static final long serialVersionUID = 7870436149617580644L;

  /**
   * 升降级配置
   */
  private CourseAbilityRateApplyConfig config;

  /**
   * 学生
   */
  private Student std;

  /**
   * 申请时的等级
   */
  private LanguageAbility originAbility;

  /**
   * 申请等级
   */
  private LanguageAbility applyAbility;

  /**
   * 教学日历
   */
  private TeachCalendar calendar;

  /**
   * 移动电话
   */
  private String mobilephone;

  /**
   * 联系地址
   */
  private String address;

  /**
   * 是否通过
   */
  private boolean passed;

  /**
   * 面试信息
   */
  private InterviewInfo interview;

  /**
   * 英语成绩
   */
  private Set<CourseAbilityGrade> grades = new HashSet<CourseAbilityGrade>();

  public CourseAbilityRateApplyConfig getConfig() {
    return config;
  }

  public void setConfig(CourseAbilityRateApplyConfig config) {
    this.config = config;
  }

  public Student getStd() {
    return std;
  }

  public void setStd(Student std) {
    this.std = std;
  }

  public LanguageAbility getOriginAbility() {
    return originAbility;
  }

  public void setOriginAbility(LanguageAbility originAbility) {
    this.originAbility = originAbility;
  }

  public LanguageAbility getApplyAbility() {
    return applyAbility;
  }

  public void setApplyAbility(LanguageAbility applyAbility) {
    this.applyAbility = applyAbility;
  }

  public TeachCalendar getCalendar() {
    return calendar;
  }

  public void setCalendar(TeachCalendar calendar) {
    this.calendar = calendar;
  }

  public String getMobilephone() {
    return mobilephone;
  }

  public void setMobilephone(String mobilephone) {
    this.mobilephone = mobilephone;
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public boolean isPassed() {
    return passed;
  }

  public void setPassed(boolean passed) {
    this.passed = passed;
  }

  public InterviewInfo getInterview() {
    return interview;
  }

  public void setInterview(InterviewInfo interview) {
    this.interview = interview;
  }

  public Set<CourseAbilityGrade> getGrades() {
    return grades;
  }

  public void setGrades(Set<CourseAbilityGrade> grades) {
    this.grades = grades;
  }

}
