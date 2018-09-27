//$Id: OtherExamSignUpPropertyExtractor.java,v 1.1 2012-7-12 zhouqi Exp $
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
 * zhouqi				2012-7-12             Created
 *  
 ********************************************************************************/

package com.shufe.service.course.grade.other;

import java.util.Locale;

import org.apache.struts.util.MessageResources;

import com.ekingstar.commons.mvc.struts.misc.StrutsMessageResource;
import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;

/**
 * 校外考试导出
 * 
 * @author zhouqi
 */
public class OtherExamSignUpPropertyExtractor extends DefaultPropertyExtractor {

  protected MessageResources resources;

  public OtherExamSignUpPropertyExtractor(Locale locale, MessageResources resources) {
    super();
    this.locale = locale;
    this.resources = resources;
    this.setBuddle(new StrutsMessageResource(resources));
  }

  public Object getPropertyValue(Object target, String property) throws Exception {
    if (property.equals("workPlace")) {
      return "华东政法大学";
    } else if (property.equals("job")) {
      return "学生";
    } else {
      return super.getPropertyValue(target, property);
    }
  }
}
