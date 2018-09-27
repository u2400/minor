//$Id: OutSideObject.java,v 1.1 2012-8-9 zhouqi Exp $
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
 * zhouqi				2012-8-9             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.model.course.english;

import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;

/**
 * @author zhouqi
 */
public class OutSideObject {

  private Student student;

  private TeachTask task;

  private Boolean isConflicted;

  private Boolean isOver;

  public OutSideObject(Student student, TeachTask task, Boolean isConflicted, Boolean isOver) {
    this.student = student;
    this.task = task;
    this.isConflicted = isConflicted;
    this.isOver = isOver;
  }

  public Student getStudent() {
    return student;
  }

  public void setStudent(Student student) {
    this.student = student;
  }

  public TeachTask getTask() {
    return task;
  }

  public void setTask(TeachTask task) {
    this.task = task;
  }

  public Boolean getIsConflicted() {
    return isConflicted;
  }

  public void setIsConflicted(Boolean isConflicted) {
    this.isConflicted = isConflicted;
  }

  public Boolean getIsOver() {
    return isOver;
  }

  public void setIsOver(Boolean isOver) {
    this.isOver = isOver;
  }
}
