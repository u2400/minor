package com.shufe.model.course.task;

import java.util.HashSet;
import java.util.Set;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.eams.system.basecode.industry.CourseType;
import com.ekingstar.eams.system.basecode.state.Gender;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.calendar.TeachCalendar;

public class ProjectClosePlan extends LongIdObject {

  private static final long serialVersionUID = -4125626970801812342L;

  /**
   * 课程序号
   */
  private String seqNo;

  /**
   * 课程
   */
  private Course course = new Course();

  /**
   * 课程类别
   */
  private CourseType courseType = new CourseType();

  // /**
  // * 教学班
  // */
  // private TeachClass teachClass = new TeachClass();
  //

  /**
   * 教学班名称
   */
  private String name;

  /**
   * 性别
   */
  private Gender gender;

  /**
   * 教学班的计划教学人数.自动生成教学任务时，若有行政班级，则对应行政班的班级人数总和.
   */
  private Integer planStdCount;

  /**
   * 教学日历
   */
  private TeachCalendar calendar = new TeachCalendar();

  // /**
  // * 安排情况
  // */
  // private ArrangeInfo arrangeInfo = new ArrangeInfo();

  /**
   * 周数
   */
  private Integer weeks;

  /**
   * 周课时
   */
  private Float weekUnits;

  /**
   * 总课时
   */
  private Integer overallUnits;

  private String arrangeInfo;

  /**
   * 是否排完
   */
  private Boolean isArrangeComplete;

  /**
   * 该教学班中的所有实际上课学生的修读信息（包括行政班里的部分学生和选修该课的其他学生）
   * 
   * @see com.shufe.model.course.arrange.task.CourseTake
   */
  private Set courseTakeCloses = new HashSet();

  public Set getCourseTakeCloses() {
    return courseTakeCloses;
  }

  public void setCourseTakeCloses(Set courseTakeCloses) {
    this.courseTakeCloses = courseTakeCloses;
  }

  /**
   * 教学任务中的教师
   */
  private String teacher;

  public String getSeqNo() {
    return seqNo;
  }

  public void setSeqNo(String seqNo) {
    this.seqNo = seqNo;
  }

  public Course getCourse() {
    return course;
  }

  public void setCourse(Course course) {
    this.course = course;
  }

  public CourseType getCourseType() {
    return courseType;
  }

  public void setCourseType(CourseType courseType) {
    this.courseType = courseType;
  }

  public TeachCalendar getCalendar() {
    return calendar;
  }

  public void setCalendar(TeachCalendar calendar) {
    this.calendar = calendar;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Gender getGender() {
    return gender;
  }

  public void setGender(Gender gender) {
    this.gender = gender;
  }

  public Integer getPlanStdCount() {
    return planStdCount;
  }

  public void setPlanStdCount(Integer planStdCount) {
    this.planStdCount = planStdCount;
  }

  public Integer getWeeks() {
    return weeks;
  }

  public void setWeeks(Integer weeks) {
    this.weeks = weeks;
  }

  public Float getWeekUnits() {
    return weekUnits;
  }

  public void setWeekUnits(Float weekUnits) {
    this.weekUnits = weekUnits;
  }

  public Integer getOverallUnits() {
    return overallUnits;
  }

  public void setOverallUnits(Integer overallUnits) {
    this.overallUnits = overallUnits;
  }

  public Boolean getIsArrangeComplete() {
    return isArrangeComplete;
  }

  public void setIsArrangeComplete(Boolean isArrangeComplete) {
    this.isArrangeComplete = isArrangeComplete;
  }

  public String getTeacher() {
    return teacher;
  }

  public void setTeacher(String teacher) {
    this.teacher = teacher;
  }

  public static long getSerialVersionUID() {
    return serialVersionUID;
  }

  public String getArrangeInfo() {
    return arrangeInfo;
  }

  public void setArrangeInfo(String arrangeInfo) {
    this.arrangeInfo = arrangeInfo;
  }
}
