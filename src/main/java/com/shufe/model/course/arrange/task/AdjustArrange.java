//$Id: AdjustArrange.java,v 1.1 2012-11-12 zhouqi Exp $
/*
 *
 * KINGSTAR MEDIA SOLUTIONS Co.,LTD. Copyright c 2005-2006. All rights reserved.
 * 
 * This source code is the property of KINGSTAR MEDIA SOLUTIONS LTD. It is intended 
 * only for the use of KINGSTAR MEDIA application development. Reengineering, reproduction
 * arose from modification of the original source, or other redistribution of this source 
 * is not permitted without written permission of the KINGSTAR MEDIA SOLUTIONS LTD.
 * 
 */
/********************************************************************************
 * @author zhouqi
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * zhouqi				2012-11-12             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.model.course.arrange.task;

import java.util.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.security.User;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.system.baseinfo.Classroom;
import com.shufe.model.system.baseinfo.Teacher;

/**
 * 调停课
 * 
 * @author zhouqi
 */
public class AdjustArrange extends LongIdObject {

  private static final long serialVersionUID = -817270341863462228L;

  /** 调停任务 */
  private TeachTask task;

  /** 教师 */
  private Teacher teacher;

  /** 原上课信息（时间和教室） */
  private String beenInfo;

  /** 调停状态 */
  private Integer status;

  /** 申请时间信息（上课时间） */
  private String applyInfo;

  /** 是否通过（null：未审核，true：通过，false：不通过） */
  private Boolean isPassed;

  /** 审批人 */
  private User auditBy;

  /** 审批时间 */
  private Date passedAt;

  /** 是否终审通过 */
  private Boolean isFinalOk;

  /** 分配教室 */
  private Classroom room;

  /** 终审理由 */
  private String finalReason;

  /** 终审人 */
  private User finalBy;

  /** 终审时间 */
  private Date finalAt;

  /** 记录生成时间 */
  private Date createdAt;

  /** 记录修改时间 */
  private Date updatedAt;

  /** 备注 */
  private String remark;

  public AdjustArrange() {
    createdAt = updatedAt = new Date();
  }

  public TeachTask getTask() {
    return task;
  }

  public void setTask(TeachTask task) {
    this.task = task;
  }

  public Teacher getTeacher() {
    return teacher;
  }

  public void setTeacher(Teacher teacher) {
    this.teacher = teacher;
  }

  public String getBeenInfo() {
    return beenInfo;
  }

  public void setBeenInfo(String beenInfo) {
    this.beenInfo = beenInfo;
  }

  public Integer getStatus() {
    return status;
  }

  public void setStatus(Integer status) {
    this.status = status;
  }

  public String getApplyInfo() {
    return applyInfo;
  }

  public void setApplyInfo(String applyInfo) {
    this.applyInfo = applyInfo;
  }

  public Boolean getIsPassed() {
    return isPassed;
  }

  public void setIsPassed(Boolean isPassed) {
    this.isPassed = isPassed;
  }

  public User getAuditBy() {
    return auditBy;
  }

  public void setAuditBy(User auditBy) {
    this.auditBy = auditBy;
  }

  public Date getPassedAt() {
    return passedAt;
  }

  public void setPassedAt(Date passedAt) {
    this.passedAt = passedAt;
  }

  public Boolean getIsFinalOk() {
    return isFinalOk;
  }

  public void setIsFinalOk(Boolean isFinalOk) {
    this.isFinalOk = isFinalOk;
  }

  public Classroom getRoom() {
    return room;
  }

  public void setRoom(Classroom room) {
    this.room = room;
  }

  public String getFinalReason() {
    return finalReason;
  }

  public void setFinalReason(String finalReason) {
    this.finalReason = finalReason;
  }

  public User getFinalBy() {
    return finalBy;
  }

  public void setFinalBy(User finalBy) {
    this.finalBy = finalBy;
  }

  public Date getFinalAt() {
    return finalAt;
  }

  public void setFinalAt(Date finalAt) {
    this.finalAt = finalAt;
  }

  public Date getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Date createdAt) {
    this.createdAt = createdAt;
  }

  public Date getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(Date updatedAt) {
    this.updatedAt = updatedAt;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }
}
