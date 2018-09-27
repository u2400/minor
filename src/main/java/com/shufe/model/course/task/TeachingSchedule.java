/**
 * 
 */
package com.shufe.model.course.task;

import java.util.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.security.User;

/**
 * 教学进度
 * 
 * @author zhouqi
 */
public class TeachingSchedule extends LongIdObject {

  private static final long serialVersionUID = 162620622397818743L;

  private TeachTask task;

  private String name;

  private String path;

  private User uploadBy;

  private Date uploadAt;

  public TeachTask getTask() {
    return task;
  }

  public void setTask(TeachTask task) {
    this.task = task;
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
