package com.shufe.service.course.achivement;

/**
 * 成绩结果
 * 
 * @author chaostone
 */
public class GradeResult {

  /** 得分 */
  public final Float score;

  /** 是否通过 */
  public final boolean passed;

  public final String content;

  public GradeResult(Float score, boolean passed, String content) {
    super();
    this.score = score;
    this.passed = passed;
    this.content = content;
  }

  public GradeResult(Float score, boolean passed) {
    this(score, passed, null);
  }

}
