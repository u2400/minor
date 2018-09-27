//$Id: TeachWorkloadServiceImpl.java,v 1.19 2007/01/10 06:17:24 cwx Exp $
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
 * @author hj
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * chenweixiong              2005-11-21         Created
 *  
 ********************************************************************************/

package com.shufe.service.workload.course.impl;

import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import com.ekingstar.eams.system.basecode.industry.CourseCategory;
import com.shufe.model.course.arrange.ArrangeInfo;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.baseinfo.Teacher;
import com.shufe.model.workload.course.TeachModulus;
import com.shufe.model.workload.course.TeachWorkload;

/**
 * @author hj
 */
public class CJEAMSTeachWorkloadServiceImpl extends TeachWorkloadServiceImpl {

  /**
   * 根据教师教学任务 教学种类s，教学系数s得到一个教学工作量 FIXME 写死的体教部
   */
  public TeachWorkload buildTeachWorkload(Teacher teacher, TeachTask teachTask, List teachCatgoryList,
      List teachModulList) {
    TeachWorkload teachWorkload = new TeachWorkload(teacher, teachTask);
    CourseCategory courseCategory = new CourseCategory(teachTask.getRequirement().getCourseCategory().getId());
    teachWorkload.setCourseCategory(courseCategory);
    teachWorkload.setTeachCategory(getCategory(teachTask.getTeachClass().getStdType(), teachTask
        .getCourseType().getId(), teachCatgoryList));
    StringBuffer classIds = new StringBuffer();
    StringBuffer classNames = new StringBuffer();
    Set classSet = null == teachTask.getTeachClass().getAdminClasses() ? new HashSet() : teachTask
        .getTeachClass().getAdminClasses();
    for (Iterator iter = classSet.iterator(); iter.hasNext();) {
      AdminClass element = (AdminClass) iter.next();
      classIds.append(element.getId());
      classNames.append(element.getName());
      if (iter.hasNext()) {
        classIds.append(",");
        classNames.append(",");
      }
    }
    teachWorkload.setClassIds(classIds.toString());
    teachWorkload.setClassNames(classNames.toString());
    Integer studentNumber = teachTask.getTeachClass().getStdCount();
    teachWorkload.setStudentNumber(studentNumber);
    TeachModulus teachModulus = getModulu(teachTask.getTeachClass().getStdType(), courseCategory.getId(),
        studentNumber, teachModulList);
    teachWorkload.setTeachModulus(teachModulus);
    ArrangeInfo arrangeInfo = teachTask.getArrangeInfoOfTeacher(teacher);
    Float weeks = new Float(arrangeInfo.getWeeks().floatValue());
    teachWorkload.setWeeks(weeks);
    // 自动计算
    Float totleCourse = new Float(arrangeInfo.getWeeks().floatValue()
        * arrangeInfo.getWeekUnits().floatValue());
    teachWorkload.setTotleCourses(totleCourse);
    if (null != teachModulus) {
      Float totleWorkload = new Float(teachModulus.getModulusValue().floatValue() * totleCourse.floatValue());
      teachWorkload.setTotleWorkload(totleWorkload);
    }
    Float numOfWeek = arrangeInfo.getWeekUnits();
    if (null == numOfWeek && null != weeks && weeks.intValue() != 0) {
      numOfWeek = new Float(totleCourse.intValue() / weeks.intValue());
    }
    teachWorkload.setClassNumberOfWeek(null == numOfWeek ? new Float(0) : numOfWeek);
    return teachWorkload;
  }

}
