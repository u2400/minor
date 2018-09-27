package com.shufe.model.course.grade;

import com.ekingstar.eams.system.basecode.industry.MarkStyle;
import com.ekingstar.security.User;
import com.shufe.model.std.Student;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 德育成绩
 * 
 * @author chaostone
 */
public class MoralGrade extends AbstractGrade {

  private static final long serialVersionUID = -1625912046204811539L;

  private String remark;

  private java.util.Date updatedAt;

  public void updateScore(Float score, User who) {

  }

  public MoralGrade() {
    super();
  }

  public MoralGrade(Student std, TeachCalendar calendar, MarkStyle markStyle) {
    this.std = std;
    this.calendar = calendar;
    this.markStyle = markStyle;
  }

  /**
   * 更新是否及格的状态
   * 
   * @see MarkStyle#isPass(Float)
   */
  public void updateScore(Float score) {
    this.score = score;
    setIsPass(markStyle.isPass(score));
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }

  public java.util.Date getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(java.util.Date updatedAt) {
    this.updatedAt = updatedAt;
  }

}
