//$Id: TeachTaskValidator.java,v 1.1 2006/08/02 00:53:11 duanth Exp $
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
 * chaostone             2005-11-11         Created
 *  
 ********************************************************************************/

package com.shufe.service.course.task;

import org.apache.commons.collections.Predicate;

public class TeachTaskValidator implements Predicate {

  public boolean evaluate(Object arg0) {
    //
    // TODO check for calendar weeks and task.weeks
    return false;
  }

}
