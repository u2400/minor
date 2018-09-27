package com.ekingstar.eams.teach.abilityrate.model;

import com.ekingstar.commons.model.pojo.LongIdObject;

/**
 * @author chaostone
 */
public class CourseAbilityGrade extends LongIdObject {

  private static final long serialVersionUID = -5928298039974018416L;

  /**
   * 申请
   */
  private CourseAbilityRateApply apply;

  /**
   * 科目
   */
  private CourseAbilityRateSubject subject;

  /**
   * 分数
   */
  private Float score;

  public CourseAbilityGrade() {
    super();
  }

  public CourseAbilityGrade(CourseAbilityRateApply apply, CourseAbilityRateSubject subject, Float score) {
    super();
    this.apply = apply;
    this.subject = subject;
    this.score = score;
  }

  public CourseAbilityRateApply getApply() {
    return apply;
  }

  public void setApply(CourseAbilityRateApply apply) {
    this.apply = apply;
  }

  public CourseAbilityRateSubject getSubject() {
    return subject;
  }

  public void setSubject(CourseAbilityRateSubject subject) {
    this.subject = subject;
  }

  public Float getScore() {
    return score;
  }

  public void setScore(Float score) {
    this.score = score;
  }

}
