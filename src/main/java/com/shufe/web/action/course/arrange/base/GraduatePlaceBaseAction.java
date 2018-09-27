//$Id: GraduatePlaceBaseAction.java,v 1.1 2012-11-14 zhouqi Exp $
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.eams.system.basecode.industry.CorporationKind;
import com.shufe.model.course.arrange.base.GraduatePlace;
import com.shufe.web.action.common.RestrictionSupportAction;

/**
 * @author zhouqi
 */
public class GraduatePlaceBaseAction extends RestrictionSupportAction {

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "corporations", baseCodeService.getCodes(CorporationKind.class));
    return super.index(mapping, form, request, response);
  }

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(GraduatePlace.class, "place");
    populateConditions(request, query);
    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(get(request, "orderBy")));
    addCollection(request, "places", utilService.search(query));
    return forward(request);
  }

  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "place", utilService.get(GraduatePlace.class, getLong(request, "placeId")));
    return forward(request);
  }
}
