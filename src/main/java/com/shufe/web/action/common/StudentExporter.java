//$Id: StudentExporter.java,v 1.1 2010-5-31 上午11:51:53 zhouqi Exp $
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
 * zhouqi              2010-5-31             Created
 *  
 ********************************************************************************/

package com.shufe.web.action.common;

import org.apache.commons.lang.BooleanUtils;
import org.apache.struts.util.MessageResources;

import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;
import com.ekingstar.commons.transfer.exporter.PropertyExtractor;
import com.shufe.model.std.Student;

/**
 * @author zhouqi
 */
public class StudentExporter extends DefaultPropertyExtractor {

  protected MessageResources resources;

  public Object getPropertyValue(Object target, String property) throws Exception {
    Student student = (Student) target;
    // 授课教师
    if (property.equals("graduateAuditStatus")) {
      if (null == student.getGraduateAuditStatus()) {
        return "未审核";
      } else if (BooleanUtils.isTrue(student.getGraduateAuditStatus())) { return "审核通过"; }
      return "审核未通过";
    }
    return super.getPropertyValue(target, property);
  }

  public MessageResources getResources() {
    return resources;
  }

  public void setResources(MessageResources resources) {
    this.resources = resources;
  }
}
