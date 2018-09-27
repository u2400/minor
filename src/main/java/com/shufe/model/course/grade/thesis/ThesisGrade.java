package com.shufe.model.course.grade.thesis;

import com.ekingstar.commons.model.pojo.LongIdObject;

public class ThesisGrade extends LongIdObject {

  String stdCode;

  String stdName;

  String newScoreText;

  String oldScoreText;

  Float score;

  Long courseGradeId;

  Long stdId;

  String grade;

  Long majorId;

  Long courseId;

  Long courseTypeId;

  Long teachCalendarId;

  public Float getScore() {
    return score;
  }

  public void setScore(Float score) {
    this.score = score;
  }

  public String getNewScoreText() {
    return newScoreText;
  }

  public void setNewScoreText(String newScoreText) {
    this.newScoreText = newScoreText;
  }

  public String getOldScoreText() {
    return oldScoreText;
  }

  public void setOldScoreText(String oldScoreText) {
    this.oldScoreText = oldScoreText;
  }

  public String getStdCode() {
    return stdCode;
  }

  public void setStdCode(String stdCode) {
    this.stdCode = stdCode;
  }

  public String getStdName() {
    return stdName;
  }

  public void setStdName(String stdName) {
    this.stdName = stdName;
  }

  public Long getCourseGradeId() {
    return courseGradeId;
  }

  public void setCourseGradeId(Long courseGradeId) {
    this.courseGradeId = courseGradeId;
  }

  public Long getStdId() {
    return stdId;
  }

  public void setStdId(Long stdId) {
    this.stdId = stdId;
  }

  public String getGrade() {
    return grade;
  }

  public void setGrade(String grade) {
    this.grade = grade;
  }

  public Long getCourseId() {
    return courseId;
  }

  public void setCourseId(Long courseId) {
    this.courseId = courseId;
  }

  public Long getCourseTypeId() {
    return courseTypeId;
  }

  public void setCourseTypeId(Long courseTypeId) {
    this.courseTypeId = courseTypeId;
  }

  public Long getMajorId() {
    return majorId;
  }

  public void setMajorId(Long majorId) {
    this.majorId = majorId;
  }

  public Long getTeachCalendarId() {
    return teachCalendarId;
  }

  public void setTeachCalendarId(Long teachCalendarId) {
    this.teachCalendarId = teachCalendarId;
  }

}
