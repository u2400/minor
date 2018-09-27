package com.shufe.model.course.grade;

import java.sql.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 德育成绩录入开关
 * 
 * @author chaostone
 */
public class MoralGradeInputSwitch extends LongIdObject {
  private static final long serialVersionUID = 8673786667643266988L;

  /** 教学日历 */
  private TeachCalendar calendar;

  /** 开始时间 */
  private Date beginOn;

  /** 关闭时间 */
  private Date endOn;

  /** 成绩录入开关 */
  private boolean opened = true;

  private java.util.Date updatedAt;

  public boolean checkOpen(java.util.Date date) {
    if (null == getBeginOn() || null == getEndOn()) return false;
    if (date.after(getEndOn()) || getBeginOn().after(date)) return false;
    else {
      return opened;
    }
  }

  public boolean checkOpen( ) {
    return checkOpen(new java.util.Date());
  }

  public TeachCalendar getCalendar() {
    return calendar;
  }

  public void setCalendar(TeachCalendar calendar) {
    this.calendar = calendar;
  }

  public Date getBeginOn() {
    return beginOn;
  }

  public void setBeginOn(Date beginOn) {
    this.beginOn = beginOn;
  }

  public Date getEndOn() {
    return endOn;
  }

  public void setEndOn(Date endOn) {
    this.endOn = endOn;
  }

  public boolean isOpened() {
    return opened;
  }

  public void setOpened(boolean opened) {
    this.opened = opened;
  }

  public java.util.Date getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(java.util.Date updatedAt) {
    this.updatedAt = updatedAt;
  }

}
