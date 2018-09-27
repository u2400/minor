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
 * chaostone             2006-6-22            Created
 *  
 ********************************************************************************/
package com.shufe.model.course.textbook;

import java.util.Date;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 教材
 * 
 * @author chaostone
 */
public class TextbookOrderLine extends LongIdObject {
  private static final long serialVersionUID = 6059248193975178690L;
  private TeachCalendar calendar;
  private TeachTask task;
  private Student std;
  private Textbook textbook;
  private Date createdAt;

  public TeachCalendar getCalendar() {
    return calendar;
  }

  public void setCalendar(TeachCalendar calendar) {
    this.calendar = calendar;
  }

  public Student getStd() {
    return std;
  }

  public void setStd(Student std) {
    this.std = std;
  }

  public Textbook getTextbook() {
    return textbook;
  }

  public void setTextbook(Textbook textbook) {
    this.textbook = textbook;
  }

  public Date getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Date createdAt) {
    this.createdAt = createdAt;
  }

  public TeachTask getTask() {
    return task;
  }

  public void setTask(TeachTask task) {
    this.task = task;
  }

}
