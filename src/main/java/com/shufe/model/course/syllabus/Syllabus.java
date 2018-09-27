/**
 * 
 */
package com.shufe.model.course.syllabus;

import java.util.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;

import com.ekingstar.security.User;
import com.shufe.model.system.baseinfo.Course;

/**
 * 课程大纲
 * 
 * @author zhouqi
 */
public class Syllabus extends LongIdObject {

  private static final long serialVersionUID = 162620622397818743L;

  private Course course;

  private String name;

  private String path;

  private User uploadBy;

  private Date uploadAt;

  public Course getCourse() {
    return course;
  }

  public void setCourse(Course course) {
    this.course = course;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getPath() {
    return path;
  }

  public void setPath(String path) {
    this.path = path;
  }

  public User getUploadBy() {
    return uploadBy;
  }

  public void setUploadBy(User uploadBy) {
    this.uploadBy = uploadBy;
  }

  public Date getUploadAt() {
    return uploadAt;
  }

  public void setUploadAt(Date uploadAt) {
    this.uploadAt = uploadAt;
  }
}
