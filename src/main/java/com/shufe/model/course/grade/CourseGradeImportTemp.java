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
 * chaostone             2006-12-26            Created
 *  
 ********************************************************************************/
package com.shufe.model.course.grade;

import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import com.ekingstar.eams.course.grade.converter.ConverterFactory;
import com.ekingstar.eams.course.grade.course.GradeTask;
import com.ekingstar.eams.course.grade.course.calculator.CalculatorFactory;
import com.ekingstar.eams.system.basecode.industry.CourseTakeType;
import com.ekingstar.eams.system.basecode.industry.CourseType;
import com.ekingstar.eams.system.basecode.industry.GradeType;
import com.ekingstar.eams.system.basecode.industry.MajorType;
import com.ekingstar.eams.system.basecode.industry.MarkStyle;
import com.ekingstar.security.User;
import com.shufe.model.course.arrange.task.CourseTake;
import com.shufe.model.course.grade.alter.CourseGradeAlterInfo;
import com.shufe.model.course.grade.gp.GradePointRule;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 课程成绩导入临时表
 */
public class CourseGradeImportTemp {

  private static final long serialVersionUID = 1L;

  /**
   * 课程序号,向后兼容
   */
  private String taskSeqNo;

  /**
   * 教学任务
   */
  private TeachTask task;

  /**
   * 课程
   */
  private Course course;

  /**
   * 学分
   */
  private Float credit;

  /**
   * grade point绩点
   */
  private Float GP;

  /**
   * grade average 总评成绩
   */
  private Float GA;

  /**
   * 期末成绩
   */
  private Float GF;

  /**
   * 平时成绩
   */
  private Float GT;

  /**
   * 课程类别
   */
  private CourseType courseType;

  /**
   * 上课信息
   */
  private CourseTakeType courseTakeType;

  /**
   * 学生
   */
  protected Student std;

  /**
   * 教学日历
   */
  protected TeachCalendar calendar;

  /**
   * 得分
   */
  protected Float score;

  /**
   * 是否合格
   */
  protected Boolean isPass;

  /**
   * 成绩记录方式
   */
  protected MarkStyle markStyle;

  private MajorType majorType;

  public Float getGF() {
    return GF;
  }

  public void setGF(Float gF) {
    GF = gF;
  }

  public Float getGT() {
    return GT;
  }

  public void setGT(Float gT) {
    GT = gT;
  }

  public String getTaskSeqNo() {
    return taskSeqNo;
  }

  public void setTaskSeqNo(String taskSeqNo) {
    this.taskSeqNo = taskSeqNo;
  }

  public TeachTask getTask() {
    return task;
  }

  public void setTask(TeachTask task) {
    this.task = task;
  }

  public Course getCourse() {
    return course;
  }

  public void setCourse(Course course) {
    this.course = course;
  }

  public Float getCredit() {
    return credit;
  }

  public void setCredit(Float credit) {
    this.credit = credit;
  }

  public Float getGP() {
    return GP;
  }

  public void setGP(Float gP) {
    GP = gP;
  }

  public Float getGA() {
    return GA;
  }

  public void setGA(Float gA) {
    GA = gA;
  }

  public CourseType getCourseType() {
    return courseType;
  }

  public void setCourseType(CourseType courseType) {
    this.courseType = courseType;
  }

  public CourseTakeType getCourseTakeType() {
    return courseTakeType;
  }

  public void setCourseTakeType(CourseTakeType courseTakeType) {
    this.courseTakeType = courseTakeType;
  }

  public Student getStd() {
    return std;
  }

  public void setStd(Student std) {
    this.std = std;
  }

  public TeachCalendar getCalendar() {
    return calendar;
  }

  public void setCalendar(TeachCalendar calendar) {
    this.calendar = calendar;
  }

  public Float getScore() {
    return score;
  }

  public void setScore(Float score) {
    this.score = score;
  }

  public Boolean getIsPass() {
    return isPass;
  }

  public void setIsPass(Boolean isPass) {
    this.isPass = isPass;
  }

  public MarkStyle getMarkStyle() {
    return markStyle;
  }

  public void setMarkStyle(MarkStyle markStyle) {
    this.markStyle = markStyle;
  }

  public MajorType getMajorType() {
    return majorType;
  }

  public void setMajorType(MajorType majorType) {
    this.majorType = majorType;
  }

  public static long getSerialversionuid() {
    return serialVersionUID;
  }

}
