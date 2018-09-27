//$Id: GraduatePlaceManageAction.java,v 1.1 2012-11-14 zhouqi Exp $
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
 * zhouqi				2012-11-14             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.web.action.course.arrange.base;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.BooleanUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.security.User;
import com.shufe.model.course.arrange.base.GraduatePlace;

/**
 * 毕业实习基地管理
 * 
 * @author zhouqi
 */
public class GraduatePlaceManageAction extends GraduatePlaceAction {

  public ActionForward settingEnabled(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Collection<GraduatePlace> places = utilService.load(GraduatePlace.class, "id",
        SeqStringUtil.transformToLong(get(request, "placeIds")));

    Boolean enabled = getBoolean(request, "enabled");
    Date nowAt = new Date();
    User user = getUser(request);
    for (GraduatePlace place : places) {
      place.setEnabled(enabled);
      place.setOperatorBy(user);
      place.setUpdatedAt(nowAt);
    }
    StringBuilder content = new StringBuilder();
    content.append(places.size());
    content.append(" number of GraduatePlace-Object(s) been ");
    if (BooleanUtils.isTrue(enabled)) {
      content.append("confirmed");
    } else {
      content.append("unconfirmed");
    }
    content.append(" by ");
    content.append(user.getName());
    content.append(" user at '");
    content.append(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(nowAt));
    content.append("'!");

    Collection<Object> toBeSaved = new ArrayList<Object>();
    toBeSaved.addAll(places);
    toBeSaved.add(logHelper.buildInfo(request, content.toString()));
    utilService.saveOrUpdate(toBeSaved);
    return redirect(request, "search", "info.action.success");
  }
}
