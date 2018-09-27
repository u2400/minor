//$Id: SignUpStudentPropertyExtractor.java,v 1.1 2012-7-18 zhouqi Exp $
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
 * zhouqi				2012-7-18             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.service.std.speciality2nd;

import java.util.Locale;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.util.MessageResources;

import com.ekingstar.commons.mvc.struts.misc.StrutsMessageResource;
import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;
import com.shufe.model.std.speciality2nd.SignUpStudent;
import com.shufe.model.std.speciality2nd.SignUpStudentRecord;

/**
 * @author zhouqi
 */
public class SignUpStudentPropertyExtractor extends DefaultPropertyExtractor {

  protected MessageResources resources;

  private int rowIndex = 0;

  public SignUpStudentPropertyExtractor(Locale locale, MessageResources resources) {
    super();
    this.locale = locale;
    this.resources = resources;
    this.setBuddle(new StrutsMessageResource(resources));
    rowIndex = 1;
  }

  public Object getPropertyValue(Object target, String property) throws Exception {
    SignUpStudent signUpStd = (SignUpStudent) target;

    if (property.equals("seqNo")) {
      return rowIndex++ + "";
    } else if (property.equals("thisSchool")) {
      return "华东政法大学";
    } else if (property.equals("std.basicInfo.phone_mobile")) {
      StringBuilder phone_mobile = new StringBuilder();
      String phone = signUpStd.getStd().getBasicInfo().getPhone();
      if (StringUtils.isNotBlank(phone)) {
        phone_mobile.append(phone);
      }
      String mobile = signUpStd.getStd().getBasicInfo().getMobile();
      if (StringUtils.isNotBlank(mobile)) {
        if (phone_mobile.length() != 0) {
          phone_mobile.append(",");
        }
        phone_mobile.append(mobile);
      }
      return phone_mobile.toString();
    } else if (property.equals("record[1].school.name")) {
      SignUpStudentRecord record = signUpStd.getRecord(1);
      if (null == record) {
        return StringUtils.EMPTY;
      } else {
        return StringUtils.split(record.getSpecialitySetting().getSpeciality().getName(), " ")[0];
      }
    } else {
      return super.getPropertyValue(target, property);
    }
  }
}
