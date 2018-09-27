package com.shufe.model.course.task;

import java.sql.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.system.calendar.TeachCalendar;

public class TeachTaskParam extends LongIdObject {

  private static final long serialVersionUID = -4156265970801861342L;

  public TeachCalendar getCalendar() {
    return calendar;
  }

  public void setCalendar(TeachCalendar calendar) {
    this.calendar = calendar;
  }

  public Date getStartDate() {
    return startDate;
  }

  public void setStartDate(Date startDate) {
    this.startDate = startDate;
  }

  public Date getFinishDate() {
    return finishDate;
  }

  public void setFinishDate(Date finishDate) {
    this.finishDate = finishDate;
  }

  public Boolean getIsOpenElection() {
    return isOpenElection;
  }

  public void setIsOpenElection(Boolean isOpenElection) {
    this.isOpenElection = isOpenElection;
  }

  public static long getSerialVersionUID() {
    return serialVersionUID;
  }

  /** 教学日历 */
  private TeachCalendar calendar;

  /** 开始日期 */
  private Date startDate;

  /** 结束日期 */
  private Date finishDate;

  /** 是否打开选课开关 */
  private Boolean isOpenElection;
  /** 注意事项 */
  private String notice;

  public String getNotice() {
    return notice;
  }

  public void setNotice(String notice) {
    this.notice = notice;
  }
}
