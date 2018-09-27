/*
 * KINGSTAR MEDIA SOLUTIONS Co.,LTD. Copyright c 2005-2006. All rights reserved. This source code is
 * the property of KINGSTAR MEDIA SOLUTIONS LTD. It is intended only for the use of KINGSTAR MEDIA
 * application development. Reengineering, reproduction arose from modification of the original
 * source, or other redistribution of this source is not permitted without written permission of the
 * KINGSTAR MEDIA SOLUTIONS LTD.
 */
/***************************************************************************************************
 * @author yang MODIFICATION DESCRIPTION
 * Name         Date            Description
 * ============ ============    ============
 * yang         2005-11-09      Created
 * zq           2007-09-27      增加了两个StdStatus属性，为变更前和变更后；
 * zq           2007-09-28      在apply()方法中，添加了修改“所在年级”语句；
 **************************************************************************************************/

package com.shufe.model.std.alteration;

import java.util.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.eams.system.basecode.industry.AlterMode;
import com.ekingstar.eams.system.basecode.industry.AlterReason;
import com.ekingstar.security.User;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.AdminClass;

/**
 * 学籍变动
 * 
 * @author chaostone
 */
public class StudentAlteration extends LongIdObject {

  private static final long serialVersionUID = 3286874472425126383L;

  /** 流水号 */
  private String seqNo;

  /** 变动类型 */
  private AlterMode mode;

  /** 变动原因 */
  private AlterReason reason;

  /** 变动 开始日期 */
  private Date alterBeginOn;

  /** 变动日期结束日期 */
  private Date alterEndOn;

  /** 变动对应的学生 */
  private Student std;

  /** 执行该变动操作的用户 */
  private User alterBy;

  /** 操作备注（以逗号,分隔的国际化文件的key,记录该变动操作的备注,如培养计划操作和帐号禁用激活） */
  private String remark;

  /** 变动前信息 */
  private StdStatus beforeStatus;

  /** 变动后信息 */
  private StdStatus afterStatus;

  public void apply() {
    if (null != getAfterStatus().getEnrollYear()) {
      std.setEnrollYear(getAfterStatus().getEnrollYear());
    }
    if (null != getAfterStatus().getStdType()) {
      std.setType(getAfterStatus().getStdType());
    }
    if (null != getAfterStatus().getDepartment()) {
      std.setDepartment(getAfterStatus().getDepartment());
    }
    if (null != getAfterStatus().getSpeciality()) {
      std.setFirstMajor(getAfterStatus().getSpeciality());
    }
    if (null != getAfterStatus().getAspect()) {
      std.setFirstAspect(getAfterStatus().getAspect());
    }
    if (null != getAfterStatus().getState()) {
      std.setState(getAfterStatus().getState());
    }
    if (null != getAfterStatus().getGraduateOn()) {
      std.setGraduateOn(getAfterStatus().getGraduateOn());
    }
    if (null != getAfterStatus().getIsActive()) {
      std.setActive(getAfterStatus().getIsActive().booleanValue());
    }
    if (null != getAfterStatus().getIsInSchool()) {
      std.setInSchool(getAfterStatus().getIsInSchool().booleanValue());
    }
    if (null != getAfterStatus().getAdminClass()) {
      AdminClass adminClass = std.getFirstMajorClass();
      if (null != adminClass) {
        adminClass.getStudents().remove(std);
      }
      getAfterStatus().getAdminClass().getStudents().add(std);
      std.getAdminClasses().clear();
      std.getAdminClasses().add(getAfterStatus().getAdminClass());
    }
  }

  /**
   * 当第一次变动的时候记录
   */
  public void beforeStatusSetting() {
    if (null == this.beforeStatus) {
      this.beforeStatus = new StdStatus();
      beforeStatus.setEnrollYear(std.getEnrollYear());
      beforeStatus.setStdType(std.getType());
      beforeStatus.setDepartment(std.getDepartment());
      beforeStatus.setSpeciality(std.getFirstMajor());
      beforeStatus.setAspect(std.getFirstAspect());
      beforeStatus.setState(std.getState());
      beforeStatus.setGraduateOn(std.getGraduateOn());
      beforeStatus.setAdminClass(std.getFirstMajorClass());
      beforeStatus.setIsActive(new Boolean(std.isActive()));
      beforeStatus.setIsInSchool(new Boolean(std.isInSchool()));
    }
  }

  public AlterMode getMode() {
    return mode;
  }

  public void setMode(AlterMode mode) {
    this.mode = mode;
  }

  public AlterReason getReason() {
    return reason;
  }

  public void setReason(AlterReason reason) {
    this.reason = reason;
  }

  public Date getAlterBeginOn() {
    return alterBeginOn;
  }

  public void setAlterBeginOn(Date alterBeginOn) {
    this.alterBeginOn = alterBeginOn;
  }

  public Date getAlterEndOn() {
    return alterEndOn;
  }

  public void setAlterEndOn(Date alterEndOn) {
    this.alterEndOn = alterEndOn;
  }

  public Student getStd() {
    return std;
  }

  public void setStd(Student std) {
    this.std = std;
  }

  public User getAlterBy() {
    return alterBy;
  }

  public void setAlterBy(User alterBy) {
    this.alterBy = alterBy;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }

  public StdStatus getAfterStatus() {
    return afterStatus;
  }

  public void setAfterStatus(StdStatus afterStatus) {
    this.afterStatus = afterStatus;
  }

  public StdStatus getBeforeStatus() {
    return beforeStatus;
  }

  public void setBeforeStatus(StdStatus beforeStatus) {
    this.beforeStatus = beforeStatus;
  }

  public String getSeqNo() {
    return seqNo;
  }

  public void setSeqNo(String seqNo) {
    this.seqNo = seqNo;
  }

}
