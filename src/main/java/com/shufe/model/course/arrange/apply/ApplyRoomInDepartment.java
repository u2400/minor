//$Id: ApplyRoomInDepartment.java,v 1.1 2012-5-9 zhouqi Exp $
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
 * @author zhouqi
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * zhouqi				2012-5-9             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.model.course.arrange.apply;

import java.util.Collection;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.security.User;
import com.shufe.model.system.baseinfo.Classroom;
import com.shufe.model.system.baseinfo.Department;

/**
 * 分配院系可借用的教室
 * 
 * @author zhouqi
 */
public class ApplyRoomInDepartment extends LongIdObject {

  private static final long serialVersionUID = 2843755723578052733L;

  /** 分配部门 */
  private Department department;

  /** 可借教室 */
  private Set<Classroom> rooms;

  /** 创建人 */
  private User createdBy;

  /** 修改人 */
  private User updatedBy;

  /** 创建时间 */
  private Date createdOn;

  /** 修改时间 */
  private Date updatedOn;

  public ApplyRoomInDepartment() {
    rooms = new HashSet<Classroom>();
    createdOn = updatedOn = new Date();
  }

  public ApplyRoomInDepartment(Department department, User operator) {
    this();
    updateThisObject(operator);
  }

  public Department getDepartment() {
    return department;
  }

  public void setDepartment(Department department) {
    this.department = department;
  }

  /**
   * 添加可借用的教室
   * 
   * @param room
   * @return
   */
  public Set<Classroom> addClassroom(Classroom room) {
    if (null == rooms) {
      rooms = new HashSet<Classroom>();
      createdOn = updatedOn = new Date();
    }
    rooms.add(room);
    return rooms;
  }

  /**
   * 添加可借用的教室
   * 
   * @param room
   * @return
   */
  public Set<Classroom> addClassroom(Collection<Classroom> rooms) {
    if (null == this.rooms) {
      this.rooms = new HashSet<Classroom>();
      createdOn = updatedOn = new Date();
    }
    this.rooms.addAll(rooms);
    return this.rooms;
  }

  public void updateThisObject(User operator) {
    if (null == this.createdBy) {
      this.createdBy = operator;
    }
    this.updatedBy = operator;
    if (null != id) {
      this.updatedOn = new Date();
    }
  }

  public Set<Classroom> getRooms() {
    return rooms;
  }

  public void setRooms(Set<Classroom> rooms) {
    this.rooms = rooms;
  }

  public User getCreatedBy() {
    return createdBy;
  }

  public void setCreatedBy(User createdBy) {
    this.createdBy = createdBy;
  }

  public User getUpdatedBy() {
    return updatedBy;
  }

  public void setUpdatedBy(User updatedBy) {
    this.updatedBy = updatedBy;
  }

  public Date getCreatedOn() {
    return createdOn;
  }

  public void setCreatedOn(Date createdOn) {
    this.createdOn = createdOn;
  }

  public Date getUpdatedOn() {
    return updatedOn;
  }

  public void setUpdatedOn(Date updatedOn) {
    this.updatedOn = updatedOn;
  }
}
