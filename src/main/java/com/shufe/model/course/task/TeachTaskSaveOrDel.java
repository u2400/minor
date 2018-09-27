package com.shufe.model.course.task;

import com.ekingstar.commons.model.pojo.LongIdObject;

public class TeachTaskSaveOrDel extends LongIdObject {
  private String courseseqNo;
  private String coursecode;
  private String term;
  private String courseName;
  private String courseType;
  private String credit;
  private String teachClass;
  private String studentType;

  public String getMaxCount() {
    return maxCount;
  }

  public void setMaxCount(String maxCount) {
    this.maxCount = maxCount;
  }

  public String getHSKDegree() {
    return HSKDegree;
  }

  public void setHSKDegree(String hSKDegree) {
    HSKDegree = hSKDegree;
  }

  public String getPrerequisteCourses() {
    return prerequisteCourses;
  }

  public void setPrerequisteCourses(String prerequisteCourses) {
    this.prerequisteCourses = prerequisteCourses;
  }

  public String getMinCount() {
    return minCount;
  }

  public void setMinCount(String minCount) {
    this.minCount = minCount;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }

  public String getSeqno() {
    return seqno;
  }

  public void setSeqno(String seqno) {
    this.seqno = seqno;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getSuggestTime() {
    return suggestTime;
  }

  public void setSuggestTime(String suggestTime) {
    this.suggestTime = suggestTime;
  }

  public String getSuggestClass() {
    return suggestClass;
  }

  public void setSuggestClass(String suggestClass) {
    this.suggestClass = suggestClass;
  }

  public String getOtherSuggest() {
    return otherSuggest;
  }

  public void setOtherSuggest(String otherSuggest) {
    this.otherSuggest = otherSuggest;
  }

  private String enrollTurn;
  private String teachClassDepart;
  private String teachClassSpeciality;
  private String teachClassAspect;
  private String adminClassName;
  private String planStdCount;
  private String stdCount;
  private String gender;
  private String roomConfigType;
  private String isGuaPai;
  private String teachLangType;
  private String textbooks;
  private String referenceBooks;
  private String cases;
  private String teachDepartName;
  private String arrangeInfoTeachers;
  private String courseUnits;
  private String extInfoPeriod;
  private String weekUnits;
  private String weeks;
  private String teachWeek;
  private String weekStart;
  private String isArrangeComplete;
  private String schoolDistrict;
  private String isElectable;
  private String isCancelable;
  private String maxCount;
  private String HSKDegree;
  private String prerequisteCourses;
  private String minCount;
  private String remark;
  private String seqno;
  private String name;
  private String suggestTime;
  private String suggestClass;
  private String otherSuggest;

  public String getCourseseqNo() {
    return courseseqNo;
  }

  public String getCoursecode() {
    return coursecode;
  }

  public void setCoursecode(String coursecode) {
    this.coursecode = coursecode;
  }

  public void setCourseseqNo(String courseseqNo) {
    this.courseseqNo = courseseqNo;
  }

  public String getTerm() {
    return term;
  }

  public void setTerm(String term) {
    this.term = term;
  }

  public String getCourseName() {
    return courseName;
  }

  public void setCourseName(String courseName) {
    this.courseName = courseName;
  }

  public String getCourseType() {
    return courseType;
  }

  public void setCourseType(String courseType) {
    this.courseType = courseType;
  }

  public String getCredit() {
    return credit;
  }

  public void setCredit(String credit) {
    this.credit = credit;
  }

  public String getTeachClass() {
    return teachClass;
  }

  public void setTeachClass(String teachClass) {
    this.teachClass = teachClass;
  }

  public String getStudentType() {
    return studentType;
  }

  public void setStudentType(String studentType) {
    this.studentType = studentType;
  }

  public String getEnrollTurn() {
    return enrollTurn;
  }

  public void setEnrollTurn(String enrollTurn) {
    this.enrollTurn = enrollTurn;
  }

  public String getTeachClassDepart() {
    return teachClassDepart;
  }

  public void setTeachClassDepart(String teachClassDepart) {
    this.teachClassDepart = teachClassDepart;
  }

  public String getTeachClassSpeciality() {
    return teachClassSpeciality;
  }

  public void setTeachClassSpeciality(String teachClassSpeciality) {
    this.teachClassSpeciality = teachClassSpeciality;
  }

  public String getTeachClassAspect() {
    return teachClassAspect;
  }

  public void setTeachClassAspect(String teachClassAspect) {
    this.teachClassAspect = teachClassAspect;
  }

  public String getAdminClassName() {
    return adminClassName;
  }

  public void setAdminClassName(String adminClassName) {
    this.adminClassName = adminClassName;
  }

  public String getPlanStdCount() {
    return planStdCount;
  }

  public void setPlanStdCount(String planStdCount) {
    this.planStdCount = planStdCount;
  }

  public String getStdCount() {
    return stdCount;
  }

  public void setStdCount(String stdCount) {
    this.stdCount = stdCount;
  }

  public String getGender() {
    return gender;
  }

  public void setGender(String gender) {
    this.gender = gender;
  }

  public String getRoomConfigType() {
    return roomConfigType;
  }

  public void setRoomConfigType(String roomConfigType) {
    this.roomConfigType = roomConfigType;
  }

  public String getIsGuaPai() {
    return isGuaPai;
  }

  public void setIsGuaPai(String isGuaPai) {
    this.isGuaPai = isGuaPai;
  }

  public String getTeachLangType() {
    return teachLangType;
  }

  public void setTeachLangType(String teachLangType) {
    this.teachLangType = teachLangType;
  }

  public String getTextbooks() {
    return textbooks;
  }

  public void setTextbooks(String textbooks) {
    this.textbooks = textbooks;
  }

  public String getReferenceBooks() {
    return referenceBooks;
  }

  public void setReferenceBooks(String referenceBooks) {
    this.referenceBooks = referenceBooks;
  }

  public String getCases() {
    return cases;
  }

  public void setCases(String cases) {
    this.cases = cases;
  }

  public String getTeachDepartName() {
    return teachDepartName;
  }

  public void setTeachDepartName(String teachDepartName) {
    this.teachDepartName = teachDepartName;
  }

  public String getArrangeInfoTeachers() {
    return arrangeInfoTeachers;
  }

  public void setArrangeInfoTeachers(String arrangeInfoTeachers) {
    this.arrangeInfoTeachers = arrangeInfoTeachers;
  }

  public String getCourseUnits() {
    return courseUnits;
  }

  public void setCourseUnits(String courseUnits) {
    this.courseUnits = courseUnits;
  }

  public String getExtInfoPeriod() {
    return extInfoPeriod;
  }

  public void setExtInfoPeriod(String extInfoPeriod) {
    this.extInfoPeriod = extInfoPeriod;
  }

  public String getWeekUnits() {
    return weekUnits;
  }

  public void setWeekUnits(String weekUnits) {
    this.weekUnits = weekUnits;
  }

  public String getWeeks() {
    return weeks;
  }

  public void setWeeks(String weeks) {
    this.weeks = weeks;
  }

  public String getTeachWeek() {
    return teachWeek;
  }

  public void setTeachWeek(String teachWeek) {
    this.teachWeek = teachWeek;
  }

  public String getWeekStart() {
    return weekStart;
  }

  public void setWeekStart(String weekStart) {
    this.weekStart = weekStart;
  }

  public String getIsArrangeComplete() {
    return isArrangeComplete;
  }

  public void setIsArrangeComplete(String isArrangeComplete) {
    this.isArrangeComplete = isArrangeComplete;
  }

  public String getSchoolDistrict() {
    return schoolDistrict;
  }

  public void setSchoolDistrict(String schoolDistrict) {
    this.schoolDistrict = schoolDistrict;
  }

  public String getIsElectable() {
    return isElectable;
  }

  public void setIsElectable(String isElectable) {
    this.isElectable = isElectable;
  }

  public String getIsCancelable() {
    return isCancelable;
  }

  public void setIsCancelable(String isCancelable) {
    this.isCancelable = isCancelable;
  }

}
