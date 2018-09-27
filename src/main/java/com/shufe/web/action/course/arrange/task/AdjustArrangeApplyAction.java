//$Id: AdjustArrangeApplyAction.java,v 1.1 2012-11-12 zhouqi Exp $
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

import java.util.Collection;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.security.User;
import com.shufe.model.course.arrange.task.AdjustArrange;
import com.shufe.model.system.baseinfo.Teacher;

/**
 * 调停课申请（教师界面）
 * 
 * @author zhouqi
 */
public class AdjustArrangeApplyAction extends AdjustArrangeBaseAction {

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setCalendarDataRealm(request, hasStdTypeCollege);
    addSingleParameter(request, "teacher", getTeacherFromSession(request.getSession()));
    return super.index(mapping, form, request, response);
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long adjustId = getLong(request, "adjustId");
    if (null != adjustId) {
      addSingleParameter(request, "adjust", utilService.get(AdjustArrange.class, adjustId));
    }
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    AdjustArrange adjust = (AdjustArrange) populateEntity(request, AdjustArrange.class, "adjust");
    if (null != adjust.getId()) {
      adjust.setUpdatedAt(new Date());
    }
    utilService.saveOrUpdate(adjust);
    return redirect(request, "search", "info.action.success");
  }
}
