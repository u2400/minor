//$Id: SpecialityAlerationPropertyExtractor.java,v 1.1 2012-7-16 zhouqi Exp $
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
 * zhouqi				2012-7-16             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.service.std.alteration;

import java.util.Locale;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.util.MessageResources;

import com.ekingstar.commons.mvc.struts.misc.StrutsMessageResource;
import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;
import com.ekingstar.eams.std.changeMajor.ChangeMajorApplication;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.AdminClass;

/**
 * 转专业导出
 * 
 * @author zhouqi
 */
public class SpecialityAlerationPropertyExtractor extends DefaultPropertyExtractor {

  protected MessageResources resources;

  private int rowIndex = 0;

  public SpecialityAlerationPropertyExtractor(Locale locale, MessageResources resources) {
    super();
    this.locale = locale;
    this.resources = resources;
    this.setBuddle(new StrutsMessageResource(resources));
    rowIndex = 1;
  }

  public Object getPropertyValue(Object target, String property) throws Exception {
    ChangeMajorApplication application = (ChangeMajorApplication) target;

    if (property.equals("seqNo")) {
      return rowIndex++ + "";
    } else if (property.equals("std.adminClasses?first.name")) {
      Student std = (Student) application.getStd();
      if (CollectionUtils.isNotEmpty(std.getAdminClasses())) {
        return ((AdminClass) std.getAdminClasses().iterator().next()).getName();
      } else {
        return StringUtils.EMPTY;
      }
    } else {
      return super.getPropertyValue(target, property);
    }
  }
}
