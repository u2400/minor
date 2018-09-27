/**
 * 
 */
package com.shufe.model.course.arrange.base;

import java.util.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.std.Student;

/**
 * 毕业实习基地选课名单
 * 
 * @author zhouqi
 */
public class PlaceTake extends LongIdObject {

  private static final long serialVersionUID = 4109687137098887961L;

  SwitchPlace switchPlace;

  Student student;

  Date createdAt;

  public PlaceTake() {
    super();
  }

  public PlaceTake(SwitchPlace switchPlace, Student student) {
    this();
    this.switchPlace = switchPlace;
    this.student = student;
    this.createdAt = new Date();
  }

  public SwitchPlace getSwitchPlace() {
    return switchPlace;
  }

  public void setSwitchPlace(SwitchPlace switchPlace) {
    this.switchPlace = switchPlace;
  }

  public Student getStudent() {
    return student;
  }

  public void setStudent(Student student) {
    this.student = student;
  }

  public Date getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Date createdAt) {
    this.createdAt = createdAt;
  }
}
