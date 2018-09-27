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
 * chaostone             2006-4-18            Created
 *  
 ********************************************************************************/
package com.shufe.service.course.arrange.exam;

import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Locale;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.util.MessageResources;

import com.ekingstar.commons.mvc.struts.misc.StrutsMessageResource;
import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;
import com.shufe.model.course.arrange.Activity;
import com.shufe.model.course.arrange.exam.ExamActivity;
import com.shufe.model.course.arrange.exam.ExamTake;
import com.shufe.model.course.election.ElectStdScope;
import com.shufe.model.course.textbook.Textbook;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.baseinfo.Classroom;
import com.shufe.model.system.baseinfo.Teacher;
import com.shufe.service.course.arrange.task.CourseActivityDigestor;

public class ExamTakePropertyExtractor extends DefaultPropertyExtractor {

  protected MessageResources resources;

  public ExamTakePropertyExtractor(Locale locale, MessageResources resources) {
    super();
    this.locale = locale;
    this.resources = resources;
    this.setBuddle(new StrutsMessageResource(resources));
  }

  public Object getPropertyValue(Object target, String property) throws Exception {
    ExamTake examTake = (ExamTake) target;
    // 授课教师
    if (property.equals("std.adminClasses.name")) {
      StringBuilder adminClassNames = new StringBuilder();
      for (Iterator iter = examTake.getStd().getAdminClasses().iterator(); iter.hasNext();) {
        AdminClass adminClass = (AdminClass) iter.next();
        adminClassNames.append(adminClass.getName());
        if (iter.hasNext()) {
          adminClassNames.append(",");
        }
      }
      return adminClassNames;
    } else {
      return super.getPropertyValue(target, property);
    }
  }

  public void setResources(MessageResources resources) {
    this.resources = resources;
  }
}
