/**
 * 
 */
package com.shufe.model.std.exemption;

import java.util.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.security.User;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 推免申请开关
 * 
 * @author zhouqi
 */
public class ApplySwitch extends LongIdObject {

  private static final long serialVersionUID = 4150952871516607638L;

  /** 教学日历 */
  private TeachCalendar calendar;

  private Date fromAt;

  private Date endAt;

  private User operator;

  private Date updateAt;

  public TeachCalendar getCalendar() {
    return calendar;
  }

  public void setCalendar(TeachCalendar calendar) {
    this.calendar = calendar;
  }

  public Date getFromAt() {
    return fromAt;
  }

  public void setFromAt(Date fromAt) {
    this.fromAt = fromAt;
  }

  public Date getEndAt() {
    return endAt;
  }

  public void setEndAt(Date endAt) {
    this.endAt = endAt;
  }

  public User getOperator() {
    return operator;
  }

  public void setOperator(User operator) {
    this.operator = operator;
  }

  public Date getUpdateAt() {
    return updateAt;
  }

  public void setUpdateAt(Date updateAt) {
    this.updateAt = updateAt;
  }
}
