//$Id: GraduatePlaceAction.java,v 1.1 2012-11-14 zhouqi Exp $
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

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.eams.system.basecode.industry.CorporationKind;
import com.shufe.model.course.arrange.base.GraduatePlace;

/**
 * 毕业实习基地维护
 * 
 * @author zhouqi
 */
public class GraduatePlaceAction extends GraduatePlaceBaseAction {

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long placeId = getLong(request, "placeId");
    if (null != placeId) {
      addSingleParameter(request, "place", utilService.get(GraduatePlace.class, placeId));
    }
    addCollection(request, "corporations", baseCodeService.getCodes(CorporationKind.class));
    addCollection(request, "departmentList", getDeparts(request));
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    GraduatePlace place = (GraduatePlace) populateEntity(request, GraduatePlace.class, "place");
    StringBuilder content = new StringBuilder();
    content.append("A GraduatePlace-Object been ");
    if (null == place.getId()) {
      content.append("created");
    } else {
      content.append("updated");
      place.setUpdatedAt(new Date());
    }
    content.append(" by ");
    place.setOperatorBy(getUser(request));
    content.append(place.getOperatorBy().getName());
    content.append(" user at '");
    content.append(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(place.getUpdatedAt()));
    content.append("'!");

    Collection<Object> toBeSaved = new ArrayList<Object>();
    toBeSaved.add(place);
    toBeSaved.add(logHelper.buildInfo(request, content.toString()));
    utilService.saveOrUpdate(toBeSaved);
    return redirect(request, "search", "info.action.success");
  }

  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Collection<GraduatePlace> places = utilService.load(GraduatePlace.class, "id",
        SeqStringUtil.transformToLong(get(request, "placeIds")));
    StringBuilder content = new StringBuilder();
    content.append(places.size());
    content.append(" number of GraduatePlace-Object(s) been removed by ");
    content.append(getUser(request).getName());
    content.append(" user at '");
    content.append(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
    content.append("'!");
    logHelper.info(request, content.toString());

    try {
      utilService.remove(places);
    } catch (Exception e) {
      return redirect(request, "search", "error.remove.beenUsed");
    }
    return redirect(request, "search", "info.action.success");
  }
}
