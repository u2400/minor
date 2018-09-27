package com.ekingstar.eams.teach.abilityrate.model;

import com.ekingstar.commons.model.pojo.LongIdObject;

/**
 * 英语等级科目
 * 
 * @author chaostone
 */
public class CourseAbilityRateSubject extends LongIdObject {
  private static final long serialVersionUID = -5918563277433338441L;

  /**
   * 配置
   */
  private CourseAbilityRateApplyConfig config;

  /**
   * 科目名称
   */
  private String name;

  /**
   * 最低分数
   */
  private Float minScore;
  /**
   * 课程代码串
   */
  private String courseCodes;

  public CourseAbilityRateApplyConfig getConfig() {
    return config;
  }

  public void setConfig(CourseAbilityRateApplyConfig config) {
    this.config = config;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getCourseCodes() {
    return courseCodes;
  }

  public void setCourseCodes(String courseCodes) {
    this.courseCodes = courseCodes;
  }

  public Float getMinScore() {
    return minScore;
  }

  public void setMinScore(Float minScore) {
    this.minScore = minScore;
  }

}
