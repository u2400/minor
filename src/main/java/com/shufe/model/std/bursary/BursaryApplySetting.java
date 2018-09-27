package com.shufe.model.std.bursary;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 助学金申请设定
 * 
 * @author chaostone
 */
public class BursaryApplySetting extends LongIdObject {

  private static final long serialVersionUID = 1L;

  private String name;

  private TeachCalendar fromSemester;

  private TeachCalendar toSemester;

  private Set<BursaryAward> awards = new HashSet<BursaryAward>();

  private Date beginAt;

  private Date endAt;

  public TeachCalendar getFromSemester() {
    return fromSemester;
  }

  public void setFromSemester(TeachCalendar fromSemester) {
    this.fromSemester = fromSemester;
  }

  public TeachCalendar getToSemester() {
    return toSemester;
  }

  public void setToSemester(TeachCalendar toSemester) {
    this.toSemester = toSemester;
  }

  public Set<BursaryAward> getAwards() {
    return awards;
  }

  public void setAwards(Set<BursaryAward> awards) {
    this.awards = awards;
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

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }
}
