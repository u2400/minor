package com.shufe.model.std.alteration;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.security.User;
import com.shufe.model.std.Student;

/**
 * 学生主要信息（经过管理员审核才可以修改的）
 * 
 * @author cqq
 */

public class StudentInfoAlterApply extends LongIdObject implements Serializable {

  private static final long serialVersionUID = -507997924590348564L;

  private List<StudentInfoAlterItem> items = new ArrayList<StudentInfoAlterItem>();

  /** 审核状态(是否审核过) */
  private Boolean passed;

  /** 申请时间 */
  private Date applyAt;

  /** 审核时间 */
  private Date auditAt;

  /** 对应的学生 */
  private Student student;

  /** 审核人 */
  private User auditor;

  /** 提交申请的ip地址 */
  private String ip;

  public List<StudentInfoAlterItem> getItems() {
    return items;
  }

  public void setItems(List<StudentInfoAlterItem> items) {
    this.items = items;
  }

  public Boolean getPassed() {
    return passed;
  }

  public void setPassed(Boolean passed) {
    this.passed = passed;
  }

  public Date getApplyAt() {
    return applyAt;
  }

  public void setApplyAt(Date applyAt) {
    this.applyAt = applyAt;
  }

  public Date getAuditAt() {
    return auditAt;
  }

  public void setAuditAt(Date auditAt) {
    this.auditAt = auditAt;
  }

  public Student getStudent() {
    return student;
  }

  public void setStudent(Student student) {
    this.student = student;
  }

  public User getAuditor() {
    return auditor;
  }

  public void setAuditor(User auditor) {
    this.auditor = auditor;
  }

  public String getIp() {
    return ip;
  }

  public void setIp(String ip) {
    this.ip = ip;
  }

}
