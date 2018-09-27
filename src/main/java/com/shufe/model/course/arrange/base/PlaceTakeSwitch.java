/**
 * 
 */
package com.shufe.model.course.arrange.base;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.eams.system.baseinfo.StudentType;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.Department;

/**
 * 毕业实习基地开关
 * 
 * @author zhouqi
 */
public class PlaceTakeSwitch extends LongIdObject {

  private static final long serialVersionUID = -7247645765019046218L;

  String name;

  /** （一个或多个）年级 */
  String grades;

  /** 开始日期 */
  Date beginOn;

  /** 截止日期 */
  Date endOn;

  /** 学生类别 */
  Set<StudentType> stdTypes;

  /** 院系 */
  Set<Department> departments;

  /** 是否使用 */
  Boolean open;

  /** 毕业实习基地配置 */
  Set<SwitchPlace> switchPlaces;

  public PlaceTakeSwitch() {
    super();
    stdTypes = new HashSet<StudentType>();
    departments = new HashSet<Department>();
  }

  public PlaceTakeSwitch(Long placeSwitchId) {
    this();
    this.id = placeSwitchId;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getGrades() {
    return grades;
  }

  public void setGrades(String grades) {
    this.grades = grades;
  }

  public Date getBeginOn() {
    return beginOn;
  }

  public void setBeginOn(Date beginOn) {
    this.beginOn = beginOn;
  }

  public Date getEndOn() {
    return endOn;
  }

  public void setEndOn(Date endOn) {
    this.endOn = endOn;
  }

  public Set<StudentType> getStdTypes() {
    return stdTypes;
  }

  public void setStdTypes(Set<StudentType> stdTypes) {
    this.stdTypes = stdTypes;
  }

  public Set<Department> getDepartments() {
    return departments;
  }

  public void setDepartments(Set<Department> departments) {
    this.departments = departments;
  }

  public Boolean getOpen() {
    return open;
  }

  public void setOpen(Boolean open) {
    this.open = open;
  }

  public Set<SwitchPlace> getSwitchPlaces() {
    return switchPlaces;
  }

  public void setSwitchPlaces(Set<SwitchPlace> switchPlaces) {
    this.switchPlaces = switchPlaces;
  }

  public void addSwitchPlace(SwitchPlace switchPlace) {
    if (null == switchPlaces) {
      switchPlaces = new HashSet<SwitchPlace>();
    }
    switchPlaces.add(switchPlace);
  }

  public boolean hasTake(Student student) {
    if (null == student || null == student.getId()) { return false; }

    for (SwitchPlace switchPlace : switchPlaces) {
      for (PlaceTake take : switchPlace.getTakes()) {
        if (student.getId().longValue() == take.getStudent().getId().longValue()) { return true; }
      }
    }
    return false;
  }
}
