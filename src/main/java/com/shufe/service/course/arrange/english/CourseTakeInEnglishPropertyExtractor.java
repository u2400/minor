//$Id: CourseTakeInEnglishPropertyExtractor.java,v 1.1 2012-8-13 zhouqi Exp $
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

import java.util.Locale;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.util.MessageResources;

import com.ekingstar.commons.mvc.struts.misc.StrutsMessageResource;
import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.AdminClass;

/**
 * @author zhouqi
 */
public class CourseTakeInEnglishPropertyExtractor extends DefaultPropertyExtractor {

  protected MessageResources resources;

  public CourseTakeInEnglishPropertyExtractor(Locale locale, MessageResources resources) {
    super();
    this.locale = locale;
    this.resources = resources;
    this.setBuddle(new StrutsMessageResource(resources));
  }

  public Object getPropertyValue(Object target, String property) throws Exception {
    Object[] objs = (Object[]) target;

    if (StringUtils.equals(property, "student.code")) {
      Student student = (Student) objs[0];
      return student.getCode();
    } else if (StringUtils.equals(property, "student.name")) {
      Student student = (Student) objs[0];
      return student.getName();
    } else if (StringUtils.equals(property, "student.adminClass.name")) {
      Student student = (Student) objs[0];
      if (CollectionUtils.isEmpty(student.getAdminClasses())) {
        return StringUtils.EMPTY;
      } else {
        return ((AdminClass) student.getAdminClasses().iterator().next()).getName();
      }
    } else if (StringUtils.equals(property, "task.seqNo")) {
      TeachTask task = (TeachTask) objs[1];
      return null == task ? "没有找到可匹配的教学任务！" : task.getSeqNo();
    } else if (StringUtils.equals(property, "task.course.code")) {
      TeachTask task = (TeachTask) objs[1];
      return null == task ? "没有找到可匹配的教学任务！" : task.getCourse().getCode();
    } else if (StringUtils.equals(property, "task.course.name")) {
      TeachTask task = (TeachTask) objs[1];
      return null == task ? "没有找到可匹配的教学任务！" : task.getCourse().getName();
    } else if (StringUtils.equals(property, "student_task_languageAbility")) {
      Student student = (Student) objs[0];
      TeachTask task = (TeachTask) objs[1];
      if (null == task) {
        return student.getLanguageAbility().getName() + "/？";
      } else {
        StringBuilder abilityValue = new StringBuilder();
        abilityValue.append(student.getLanguageAbility().getName());
        abilityValue.append("/");

        for (int i = 0; i < task.getRequirement().getLanguageAbilities().size(); i++) {
          LanguageAbility ability = (LanguageAbility) task.getRequirement().getLanguageAbilities().toArray()[i];
          abilityValue.append(ability.getName());
          if (i + 1 < task.getRequirement().getLanguageAbilities().size()) {
            abilityValue.append(",");
          }
        }
        return abilityValue.toString();
      }
    } else if (StringUtils.equals(property, "stdCount_maxStdCount")) {
      TeachTask task = (TeachTask) objs[1];
      if (null == task) {
        return "没有找到可匹配的教学任务！";
      } else {
        Integer maxStdCount = task.getElectInfo().getMaxStdCount();
        return CollectionUtils.size(task.getTeachClass().getCourseTakes()) + "/"
            + (null == maxStdCount ? 0 : maxStdCount);
      }
    } else if (StringUtils.equals(property, "arrangeInfo")) {
      TeachTask task = (TeachTask) objs[1];
      if (null == task) {
        return "没有找到可匹配的教学任务！";
      } else {
        return task.getArrangeInfo()
            .digest(task.getCalendar(), resources, locale, ":day :units :weeks :room");
      }
    } else {
      return super.getPropertyValue(target, property);
    }
  }

  public void setResources(MessageResources resources) {
    this.resources = resources;
  }
}
