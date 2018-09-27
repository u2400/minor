//$Id: CourseTakeInEnglishProcessObserver.java,v 1.1 2012-8-8 zhouqi Exp $
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
 * zhouqi				2012-8-8             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.web.action.course.arrange.english;

import org.apache.commons.lang.StringUtils;

import com.shufe.web.OutputMessage;
import com.shufe.web.OutputProcessObserver;

/**
 * @author zhouqi
 */
public class CourseTakeInEnglishProcessObserver extends OutputProcessObserver {

  public void outputNotify(int level, OutputMessage msgObj, int increaceStep) {
    try {
      String msg = message(msgObj);
      if (StringUtils.isBlank(msg)) {
        writer.println("<script>increaceProcess(" + increaceStep + ");</script>");
      } else {
        writer.println("<script>addProcessMsg(" + level + ",\"" + msg + "\"," + increaceStep + ");</script>");
      }
      writer.flush();
    } catch (Exception e) {
      throw new RuntimeException("IO Exeption:" + e.getMessage());
    }
  }

  public void outputNotify(String msg) {
    try {
      if (StringUtils.isNotBlank(msg)) {
        writer.println(msg);
      }
      writer.flush();
    } catch (Exception e) {
      throw new RuntimeException("IO Exeption:" + e.getMessage());
    }
  }

  public void outputCaption(String caption) {
    outputNotify("<script>document.getElementById(\"caption\").innerHTML = \"<div style='background-color: #ECD83C;border: 0px solid #000;color: #000000;font-family: Arial, Helvetica, sans-serif;font-weight: normal;text-align: center;vertical-align: bottom;'>"
        + caption + "</div>\";</script>");
  }
}
