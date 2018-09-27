package com.shufe.model.course.arrange.resource;

import java.util.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.model.system.calendar.TeachCalendar;

public class RoomOccupySwitch extends LongIdObject {

  private static final long serialVersionUID = 333L;

  /** 教学日历 */
  private TeachCalendar calendar;

  /** 院系（null为全校） */
  private Department department;

  /** 开始日期 */
  private Date startDate;

  /** 结束日期 */
  private Date finishDate;

  /** 是否开放 */
  private Boolean isOpen = Boolean.FALSE;

  /** 注意事项 */
  private String notice;

  // /**
  // * 检查该评教开关是否开放
  // *
  // * @param date
  // * @return
  // */
  // public boolean checkOpen(Date date) {
  // if (null == getStartAt() || null == getEndAt())
  // return false;
  // if (date.after(getEndAt()) || getStartAt().after(date))
  // return false;
  // else {
  // return this.isOpen.booleanValue();
  // }
  // }

  public TeachCalendar getCalendar() {
    return calendar;
  }

  public Department getDepartment() {
    return department;
  }

  public void setDepartment(Department department) {
    this.department = department;
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

  public String getNotice() {
    return notice;
  }

  public void setNotice(String notice) {
    this.notice = notice;
  }

  public void setCalendar(TeachCalendar calendar) {
    this.calendar = calendar;
  }

  public Boolean getIsOpen() {
    return isOpen;
  }

  public void setIsOpen(Boolean isOpen) {
    this.isOpen = isOpen;
  }

}
