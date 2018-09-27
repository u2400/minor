//$Id: CourseTakeInEnglishComparator.java,v 1.1 2012-8-13 zhouqi Exp $
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
 * zhouqi				2012-8-13             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.service.course.arrange.english;

import java.util.Comparator;
import java.util.Map;

import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;

/**
 * @author zhouqi
 */
public class CourseTakeInEnglishComparator<T extends Map<String, Object>> implements Comparator<T> {

  public int compare(T objMap1, T objMap2) {
    Student student1 = (Student) objMap1.get("student");
    TeachTask task1 = (TeachTask) objMap1.get("task");
    Boolean isConflicted1 = (Boolean) objMap1.get("isConflicted");
    Boolean isOver1 = (Boolean) objMap1.get("isOver");

    Student student2 = (Student) objMap2.get("student");
    TeachTask task2 = (TeachTask) objMap2.get("task");
    Boolean isConflicted2 = (Boolean) objMap2.get("isConflicted");
    Boolean isOver2 = (Boolean) objMap2.get("isOver");

    if (student1.getCode().compareTo(student2.getCode()) < 0) {
      return -1;
    } else if (student1.getCode().compareTo(student2.getCode()) == 0) {
      if (task1.getCourse().getCode().compareTo(task2.getCourse().getCode()) < 0) {
        return -1;
      } else if (task1.getCourse().getCode().compareTo(task2.getCourse().getCode()) == 0) {
        if (isConflicted1.booleanValue() && !isConflicted2.booleanValue()) {
          return -1;
        } else if (!isConflicted1.booleanValue() && !isConflicted1.booleanValue()) {
          return isOver1.compareTo(isOver2);
        } else if (isConflicted1.booleanValue() && isConflicted1.booleanValue()) {
          return 0;
        } else {
          return 1;
        }
      } else {
        return 1;
      }
    } else {
      return 1;
    }
  }
}
