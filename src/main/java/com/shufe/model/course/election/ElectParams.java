//$Id: ElectParams.java,v 1.2 2006/10/12 12:20:00 duanth Exp $
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
 * @author chaostone
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * hc                   2005-9-26           Created
 * chaostone            2005-10-16          modified,rename,
 *  
 ********************************************************************************/

package com.shufe.model.course.election;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.Speciality;
import com.shufe.model.system.baseinfo.SpecialityAspect;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 选课参数实体类
 * 
 * @author chaostone 2005-10-16
 */
public class ElectParams extends LongIdObject implements Serializable {

  private static final long serialVersionUID = -4156165970801860342L;

  /** 选课轮次 */
  private Integer turn;

  /** 教学日历 */
  private TeachCalendar calendar;

  /** 参数内允许选课的学生类别 */
  private Set stdTypes = new HashSet();

  /** 参数内允许选课的学生所在院系 */
  private Set departs = new HashSet();

  /** 参数允许的专业 */
  private Set majors = new HashSet();

  /** 参数允许的专业方向 */
  private Set majorFields = new HashSet();

  /** 参数内允许选课的所在年级 */
  private Set enrollTurns = new HashSet();

  /** 参数内允许非当轮可退课的学生学籍状态 */
  private Set studentStates = new HashSet();

  /** 参数内允许的特殊学生 */
  private Set stds = new HashSet();

  /** 指定非当前轮次可退课的课程类别 */
  private Set notCurrentCourseTypes = new HashSet();

  /** 开始时间 */
  private Date electStartAt;

  /** 结束时间 */
  private Date electEndAt;

  /** 总体开始时间 */
  private Date startAt;

  /** 总体结束时间 */
  private Date endAt;

  /** 是否打开选课开关 */
  private Boolean isOpenElection;

  /** 是否允许重修 */
  private Boolean isRestudyAllowed;

  /** 是否允许超过人数上限 */
  private Boolean isOverMaxAllowed;

  /** 是否允许退课时低于人数下限 */
  private Boolean isUnderMinAllowed;

  /** 是否允许自由退课 */
  private Boolean isCancelAnyTime;

  /** 是否检查评教 */
  private Boolean isCheckEvaluation;

  /** 是否考虑奖励学分 */
  private Boolean isAwardCreditConsider;

  /** 是否限制校区 */
  private Boolean isSchoolDistrictRestrict;

  /** 重修选课时是否限制范围 */
  private Boolean isCheckScopeForReSturdy;

  /** 是否计划内课程 */
  private Boolean isInPlanOfCourse;

  /** 教学班开课对象限制 */
  private Boolean isLimitedInTeachClass;

  /** 浮动学分 */
  private Float floatCredit;

  /** 注意事项 */
  private ParamContent notice;

  /**
   * 是否总体时间合适
   * 
   * @return
   */
  public boolean isTimeSuitable() {
    long now = System.currentTimeMillis();
    return (now <= endAt.getTime()) && (now >= startAt.getTime());
  }

  /**
   * 是否选课时间合适
   * 
   * @return
   */
  public boolean isElectionTimeSuitable() {
    if (getIsOpenElection().equals(Boolean.FALSE)) { return false; }
    long now = System.currentTimeMillis();
    return (now <= electEndAt.getTime()) && (now >= electStartAt.getTime());
  }

  public ElectParams() {
    turn = new Integer(0);
    calendar = new TeachCalendar();
    startAt = new Date(System.currentTimeMillis());
    isOpenElection = Boolean.TRUE;
    isRestudyAllowed = Boolean.FALSE;
    isOverMaxAllowed = Boolean.FALSE;
    isCancelAnyTime = Boolean.FALSE;
    floatCredit = new Float(0);
    isCheckEvaluation = Boolean.TRUE;
    isUnderMinAllowed = Boolean.FALSE;
    isAwardCreditConsider = Boolean.TRUE;
    isInPlanOfCourse = Boolean.TRUE;
  }

  private ElectParams(boolean empty) {
  }

  public static ElectParams getEmptyParams() {
    return new ElectParams(true);
  }

  public Integer getTurn() {
    return turn;
  }

  public void setTurn(Integer turn) {
    this.turn = turn;
  }

  public Date getElectStartAt() {
    return electStartAt;
  }

  public void setElectStartAt(Date electStartAt) {
    this.electStartAt = electStartAt;
  }

  public Date getElectEndAt() {
    return electEndAt;
  }

  public void setElectEndAt(Date electEndAt) {
    this.electEndAt = electEndAt;
  }

  public Date getStartAt() {
    return startAt;
  }

  public void setStartAt(Date startAt) {
    this.startAt = startAt;
  }

  public Date getEndAt() {
    return endAt;
  }

  public void setEndAt(Date endAt) {
    this.endAt = endAt;
  }

  public Boolean getIsOpenElection() {
    return isOpenElection;
  }

  public void setIsOpenElection(Boolean isElectionOpen) {
    this.isOpenElection = isElectionOpen;
  }

  public Boolean getIsOverMaxAllowed() {
    return isOverMaxAllowed;
  }

  public void setIsOverMaxAllowed(Boolean isOverMaxAllowed) {
    this.isOverMaxAllowed = isOverMaxAllowed;
  }

  public Boolean getIsRestudyAllowed() {
    return isRestudyAllowed;
  }

  public void setIsRestudyAllowed(Boolean isRestudyAllowed) {
    this.isRestudyAllowed = isRestudyAllowed;
  }

  public ParamContent getNotice() {
    return notice;
  }

  public void setNotice(ParamContent notice) {
    this.notice = notice;
  }

  public Boolean getIsCancelAnyTime() {
    return isCancelAnyTime;
  }

  public TeachCalendar getCalendar() {
    return calendar;
  }

  public void setCalendar(TeachCalendar calendar) {
    this.calendar = calendar;
  }

  public void setIsCancelAnyTime(Boolean isCancelAnyTime) {
    this.isCancelAnyTime = isCancelAnyTime;
  }

  public Float getFloatCredit() {
    return floatCredit;
  }

  public void setFloatCredit(Float floatCredit) {
    this.floatCredit = floatCredit;
  }

  public Boolean getIsCheckEvaluation() {
    return isCheckEvaluation;
  }

  public void setIsCheckEvaluation(Boolean isCheckEvaluation) {
    this.isCheckEvaluation = isCheckEvaluation;
  }

  public Boolean getIsUnderMinAllowed() {
    return isUnderMinAllowed;
  }

  public void setIsUnderMinAllowed(Boolean isUnderMinAllowed) {
    this.isUnderMinAllowed = isUnderMinAllowed;
  }

  public Boolean getIsAwardCreditConsider() {
    return isAwardCreditConsider;
  }

  public void setIsAwardCreditConsider(Boolean isAwardCreditConsider) {
    this.isAwardCreditConsider = isAwardCreditConsider;
  }

  public Set getDeparts() {
    return departs;
  }

  public void setDeparts(Set departs) {
    this.departs = departs;
  }

  public Set getEnrollTurns() {
    return enrollTurns;
  }

  public void setEnrollTurns(Set enrollTurns) {
    this.enrollTurns = enrollTurns;
  }

  public Set getStdTypes() {
    return stdTypes;
  }

  public void setStdTypes(Set stdTypes) {
    this.stdTypes = stdTypes;
  }

  public boolean isTimeCollision(ElectParams other) {
    if ((!getStartAt().before(other.getEndAt())) || (!other.getStartAt().before(getEndAt()))) return false;
    return true;
  }

  public Boolean getIsSchoolDistrictRestrict() {
    return isSchoolDistrictRestrict;
  }

  public void setIsSchoolDistrictRestrict(Boolean isSchoolDistrictRestrict) {
    this.isSchoolDistrictRestrict = isSchoolDistrictRestrict;
  }

  public Boolean getIsCheckScopeForReSturdy() {
    return isCheckScopeForReSturdy;
  }

  public void setIsCheckScopeForReSturdy(Boolean isCheckScopeForReSturdy) {
    this.isCheckScopeForReSturdy = isCheckScopeForReSturdy;
  }

  public Set getMajors() {
    return majors;
  }

  public void setMajors(Set majors) {
    this.majors = majors;
  }

  public Set getMajorFields() {
    return majorFields;
  }

  public void setMajorFields(Set majorFields) {
    this.majorFields = majorFields;
  }

  // q。
  public Set getStudentStates() {
    return studentStates;
  }

  public void setStudentStates(Set studentStates) {
    this.studentStates = studentStates;
  }

  public Set getStds() {
    return stds;
  }

  public void setStds(Set stds) {
    this.stds = stds;
  }

  public Boolean getIsInPlanOfCourse() {
    return isInPlanOfCourse;
  }

  public void setIsInPlanOfCourse(Boolean isInPlanOfCourse) {
    this.isInPlanOfCourse = isInPlanOfCourse;
  }

  public Set getNotCurrentCourseTypes() {
    return notCurrentCourseTypes;
  }

  public void setNotCurrentCourseTypes(Set notCurrentCourseTypes) {
    this.notCurrentCourseTypes = notCurrentCourseTypes;
  }

  public static final Speciality null_Speciality = new Speciality(new Long(-1));

  public static final SpecialityAspect null_SpecialityAspect = new SpecialityAspect(new Long(-1));

  public boolean isStudentSuitable(Student std) {
    Speciality major = std.getFirstMajor();
    if (null == major) major = null_Speciality;
    SpecialityAspect aspect = std.getFirstAspect();
    if (null == aspect) aspect = null_SpecialityAspect;
    return (getMajors().isEmpty() || getMajors().contains(major))
        && (getMajorFields().isEmpty() || getMajorFields().contains(aspect))
        && (getEnrollTurns().isEmpty() || getEnrollTurns().contains(std.getEnrollYear()))
        && (getStds().isEmpty() || getStds().contains(std));
  }

  public Boolean getIsLimitedInTeachClass() {
    return isLimitedInTeachClass;
  }

  public void setIsLimitedInTeachClass(Boolean isLimitedInTeachClass) {
    this.isLimitedInTeachClass = isLimitedInTeachClass;
  }
}
