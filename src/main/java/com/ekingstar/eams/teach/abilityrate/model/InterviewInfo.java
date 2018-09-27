package com.ekingstar.eams.teach.abilityrate.model;

import java.util.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.system.baseinfo.Classroom;

/**
 * 面试信息
 * 
 * @author chaostone
 */
public class InterviewInfo extends LongIdObject {
  private static final long serialVersionUID = -6699651200233645857L;

  /**
   * 配置
   */
  private CourseAbilityRateApplyConfig config;

  /**
   * 房间
   */
  private Classroom room;

  /**
   * 最大面试人数
   */
  private int maxviewer;

  /**
   * 面试起始时间
   */
  private Date beginAt;

  /**
   * 面试结束时间
   */
  private Date endAt;

  public CourseAbilityRateApplyConfig getConfig() {
    return config;
  }

  public void setConfig(CourseAbilityRateApplyConfig config) {
    this.config = config;
  }

  public Classroom getRoom() {
    return room;
  }

  public void setRoom(Classroom room) {
    this.room = room;
  }

  public int getMaxviewer() {
    return maxviewer;
  }

  public void setMaxviewer(int maxviewer) {
    this.maxviewer = maxviewer;
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

}
