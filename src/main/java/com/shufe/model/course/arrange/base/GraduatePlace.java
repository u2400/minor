//$Id: GraduatePlace.java,v 1.1 2012-11-14 zhouqi Exp $
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
 * zhouqi				2012-11-14             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.model.course.arrange.base;

import java.util.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.eams.system.basecode.industry.CorporationKind;
import com.ekingstar.security.User;
import com.shufe.model.system.baseinfo.Department;

/**
 * 毕业实习基地
 * 
 * @author zhouqi
 */
public class GraduatePlace extends LongIdObject {

  private static final long serialVersionUID = 7789388708978780827L;

  /** 单位名称 */
  private String name;

  /** 单位所在地 */
  private String addressInfo;

  /** 单位类型 */
  private CorporationKind corporation;

  /** 是否校内 */
  private Boolean isInSchool;

  /** 签约日期 */
  private Date assignOn;

  /** 合作协议状态 */
  private Integer status;

  /** 联系人 */
  private String contactPerson;

  /** 联系方式——联系电话+email */
  private String contactInfo;

  /** 所属部门（分管院系） */
  private Department department;

  /** 接收实习生人数 */
  private Integer planStdCount;

  /** 是否有效（即确认状态） */
  private Boolean enabled;

  /** 操作人 */
  private User operatorBy;

  /** 创建时间 */
  private Date createdAt;

  /** 修改时间 */
  private Date updatedAt;

  /** 备注 */
  private String remark;

  public GraduatePlace() {
    createdAt = updatedAt = new Date();
    enabled = Boolean.FALSE;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getAddressInfo() {
    return addressInfo;
  }

  public void setAddressInfo(String addressInfo) {
    this.addressInfo = addressInfo;
  }

  public CorporationKind getCorporation() {
    return corporation;
  }

  public void setCorporation(CorporationKind corporation) {
    this.corporation = corporation;
  }

  public Boolean getIsInSchool() {
    return isInSchool;
  }

  public void setIsInSchool(Boolean isInSchool) {
    this.isInSchool = isInSchool;
  }

  public Date getAssignOn() {
    return assignOn;
  }

  public void setAssignOn(Date assignOn) {
    this.assignOn = assignOn;
  }

  public Integer getStatus() {
    return status;
  }

  public void setStatus(Integer status) {
    this.status = status;
  }

  public String getContactPerson() {
    return contactPerson;
  }

  public void setContactPerson(String contactPerson) {
    this.contactPerson = contactPerson;
  }

  public String getContactInfo() {
    return contactInfo;
  }

  public void setContactInfo(String contactInfo) {
    this.contactInfo = contactInfo;
  }

  public Department getDepartment() {
    return department;
  }

  public void setDepartment(Department department) {
    this.department = department;
  }

  public Integer getPlanStdCount() {
    return planStdCount;
  }

  public void setPlanStdCount(Integer planStdCount) {
    this.planStdCount = planStdCount;
  }

  public User getOperatorBy() {
    return operatorBy;
  }

  public void setOperatorBy(User operatorBy) {
    this.operatorBy = operatorBy;
  }

  public Boolean getEnabled() {
    return enabled;
  }

  public void setEnabled(Boolean enabled) {
    this.enabled = enabled;
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
