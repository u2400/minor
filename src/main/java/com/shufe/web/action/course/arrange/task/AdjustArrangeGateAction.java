//$Id: AdjustArrangeGatesAction.java,v 1.1 2012-11-13 zhouqi Exp $
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
 * zhouqi				2012-11-13             Created
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

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.security.User;
import com.shufe.model.course.arrange.task.AdjustArrange;
import com.shufe.model.system.baseinfo.Classroom;

/**
 * 调停课审批（管理员界面）
 * 
 * @author zhouqi
 */
public class AdjustArrangeGateAction extends AdjustArrangeBaseAction {

  public ActionForward beforeSettingPassed(ActionMapping mapping, ActionForm form,
      HttpServletRequest request, HttpServletResponse response) throws Exception {
    addSingleParameter(request, "adjust", utilService.get(AdjustArrange.class, getLong(request, "adjustId")));
    addCollection(request, "rooms", baseInfoService.getBaseInfos(Classroom.class));
    return forward(request, "beforeSettingPassed");
  }

  /**
   * 批量审批
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward settingPassed(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Collection<AdjustArrange> adjusts = utilService.load(AdjustArrange.class, "id",
        SeqStringUtil.transformToLong(get(request, "adjustIds")));

    Long roomId = getLong(request, "roomId");
    Classroom room = null;
    if (null != roomId) {
      room = (Classroom) utilService.get(Classroom.class, getLong(request, "roomId"));
    }

    Boolean isPassed = getBoolean(request, "isPassed");
    User auditBy = getUser(request);
    Date passedAt = new Date();
    for (AdjustArrange adjust : adjusts) {
      adjust.setIsPassed(isPassed);
      adjust.setAuditBy(auditBy);
      adjust.setPassedAt(passedAt);

      // FIXME 2013-09-27 zhouqi 暂且如此，因为当“通过”时，只循环一次，其它的无所谓；如果需要“批量”时，再作调整
      if (isPassed.booleanValue()) {
        adjust.setRoom(room);
      } else {
        adjust.setRoom(null);
      }
    }
    utilService.saveOrUpdate(adjusts);
    return redirect(request, "search", "info.action.success");
  }
}
