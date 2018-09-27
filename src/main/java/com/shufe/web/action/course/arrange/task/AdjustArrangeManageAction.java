//$Id: AdjustArrangeManageAction.java,v 1.1 2012-11-12 zhouqi Exp $
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
 * zhouqi				2012-11-12             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.web.action.course.arrange.task;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.shufe.model.course.arrange.task.AdjustArrange;
import com.shufe.model.system.baseinfo.Classroom;

/**
 * 调停课管理（管理员界面）
 * 
 * @author zhouqi
 */
public class AdjustArrangeManageAction extends AdjustArrangeBaseAction {

  public ActionForward auditEdit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "adjust", utilService.get(AdjustArrange.class, getLong(request, "adjustId")));
    addCollection(request, "rooms", baseInfoService.getBaseInfos(Classroom.class));
    return forward(request, "auditForm");
  }

  public ActionForward finalAudit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    AdjustArrange adjust = (AdjustArrange) populateEntity(request, AdjustArrange.class, "adjust");
    adjust.setFinalBy(getUser(request));
    adjust.setFinalAt(new Date());
    utilService.saveOrUpdate(adjust);
    return redirect(request, "search", "info.action.success");
  }
}
