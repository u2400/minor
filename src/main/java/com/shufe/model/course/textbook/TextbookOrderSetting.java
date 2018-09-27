package com.shufe.model.course.textbook;

import java.util.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 教材订购设置
 * 
 * @author chaostone
 */
public class TextbookOrderSetting extends LongIdObject {
  private static final long serialVersionUID = 6059248193975178609L;
  
  private TeachCalendar calendar;

  private Date beginAt;

  private Date endAt;

  private Boolean opened;

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

  public Boolean getOpened() {
    return opened;
  }

  public void setOpened(Boolean opened) {
    this.opened = opened;
  }

}
