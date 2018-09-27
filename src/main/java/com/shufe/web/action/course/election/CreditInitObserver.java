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
 * chaostone             2006-1-7            Created
 *  
 ********************************************************************************/
package com.shufe.web.action.course.election;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;

import org.apache.struts.util.MessageResources;

import com.shufe.service.course.election.CreditConstraintInitMessage;
import com.shufe.web.OutputWebObserver;

/**
 * 选课初始化过程观察者
 * 
 * @author chaostone
 */
public class CreditInitObserver extends OutputWebObserver {

  public CreditInitObserver() {
    super();
  }

  public CreditInitObserver(PrintWriter writer, MessageResources resourses, Locale locale) {
    super(writer, resourses, locale);
  }

  public void notifyStart() throws IOException {
    writer.println("<html><body>");
    writer.println(messageOf("info.creditInit.start"));
    writer.flush();
  }

  public void notifyFinish() throws IOException {
    writer.println(messageOf("info.creditInit.finish"));
    writer.println("</body></html>");
    writer.flush();
  }

  public String message(Object msgObj) {
    CreditConstraintInitMessage message = (CreditConstraintInitMessage) msgObj;
    return messageOf(message.getKey()) + message.getMessage(resourses, locale) + "<br>";
  }

}
