/**
 * 
 */
package com.shufe.model.std.exemption;

import java.util.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.eams.system.basecode.industry.ExemptionApplyType;
import com.shufe.model.std.Student;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 推免申请结果
 * 
 * @author zhouqi
 */
public class ExemptionResult extends LongIdObject {

  private static final long serialVersionUID = 3014260451893343306L;

  /** 申请学校名称 */
  private String schoolName;

  /** 申请学生 */
  private Student student;

  /** 申请类型 */
  private ExemptionApplyType applyType;

  /** 申请专业 */
  private String majorName;

  /** 教学日历 */
  private TeachCalendar calendar;

  /** 愿否专业（方向）调剂 */
  private Boolean isAllowMajor;

  /** 本人只愿意接受学术型推免资格 */
  private Boolean isAllowAcademic;

  /** 本人接受调剂为专业学位推免资格 */
  private Boolean isAllowDegree;

  private Date createAt;

  private Date updateAt;

  public String getSchoolName() {
    return schoolName;
  }

  public void setSchoolName(String schoolName) {
    this.schoolName = schoolName;
  }

  public Student getStudent() {
    return student;
  }

  public void setStudent(Student student) {
    this.student = student;
  }

  public ExemptionApplyType getApplyType() {
    return applyType;
  }

  public void setApplyType(ExemptionApplyType applyType) {
    this.applyType = applyType;
  }

  public String getMajorName() {
    return majorName;
  }

  public void setMajorName(String majorName) {
    this.majorName = majorName;
  }

  public TeachCalendar getCalendar() {
    return calendar;
  }

  public void setCalendar(TeachCalendar calendar) {
    this.calendar = calendar;
  }

  public Boolean getIsAllowMajor() {
    return isAllowMajor;
  }

  public void setIsAllowMajor(Boolean isAllowMajor) {
    this.isAllowMajor = isAllowMajor;
  }

  public Boolean getIsAllowAcademic() {
    return isAllowAcademic;
  }

  public void setIsAllowAcademic(Boolean isAllowAcademic) {
    this.isAllowAcademic = isAllowAcademic;
  }

  public Boolean getIsAllowDegree() {
    return isAllowDegree;
  }

  public void setIsAllowDegree(Boolean isAllowDegree) {
    this.isAllowDegree = isAllowDegree;
  }

  public Date getCreateAt() {
    return createAt;
  }

  public void setCreateAt(Date createAt) {
    this.createAt = createAt;
  }

  public Date getUpdateAt() {
    return updateAt;
  }

  public void setUpdateAt(Date updateAt) {
    this.updateAt = updateAt;
  }
}
