package com.shufe.model.course.arrange.task;

import java.util.Date;
import java.util.Calendar;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 排课开关参数
 * 
 * @author Owner
 */
public class ManualArrangeParam extends LongIdObject {

  private static final long serialVersionUID = -4256266970671862342L;

  /** 教学日历 */
  private TeachCalendar calendar;

  /** 院系（null为全校） */
  private Department department;

  /** 开始日期 */
  private Date startDate;

  /** 结束日期 */
  private Date finishDate;

  /** 是否打开选课开关 */
  private Boolean isOpenElection;

  /** 注意事项 */
  private String notice;

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

  public boolean isValid(Date sysdate) {
    Calendar cal = Calendar.getInstance();
    cal.setTime(finishDate);
    cal.add(Calendar.DAY_OF_YEAR, +1);
    return isOpenElection.booleanValue()
        && (sysdate.equals(startDate) || sysdate.equals(cal.getTime()) || sysdate.after(startDate)
            && sysdate.before(cal.getTime()));
  }

  public boolean isInvalid(Date sysdate) {
    return !isValid(sysdate);
  }

  public String getNotice() {
    return notice;
  }

  public void setNotice(String notice) {
    this.notice = notice;
  }

  public static long getSerialVersionUID() {
    return serialVersionUID;
  }

  public Department getDepartment() {
    return department;
  }

  public void setDepartment(Department department) {
    this.department = department;
  }
}
