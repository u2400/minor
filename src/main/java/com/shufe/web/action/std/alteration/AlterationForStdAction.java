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
 * @author yang
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * yang                 2005-11-9           Created
 *  
 ********************************************************************************/
package com.shufe.web.action.std.alteration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.shufe.model.std.alteration.StudentAlteration;
import com.shufe.web.action.common.DispatchBasicAction;

/**
 * 学生用户学籍变动Action
 */
public class AlterationForStdAction extends DispatchBasicAction {

  /**
   * 学生学籍变动主界面
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   */
  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) {
    addCollection(request, "alterations", utilService.load(StudentAlteration.class, "std.id",
        getStudentFromSession(request.getSession()).getId()));
    return forward(request);
  }
}
