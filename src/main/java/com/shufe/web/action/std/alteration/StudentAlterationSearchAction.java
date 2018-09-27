//$Id: StudentAlterationSearchAction.java,v 1.1 2012-7-5 zhouqi Exp $
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
 * zhouqi				2012-7-5             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.web.action.std.alteration;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.query.limit.Page;
import com.ekingstar.commons.utils.query.QueryRequestSupport;
import com.ekingstar.commons.utils.web.RequestUtils;
import com.ekingstar.eams.system.basecode.industry.AlterMode;
import com.ekingstar.eams.system.basecode.industry.StudentState;
import com.shufe.model.std.Student;
import com.shufe.model.std.alteration.StudentAlteration;
import com.shufe.util.DataRealmUtils;
import com.shufe.web.action.common.RestrictionExampleTemplateAction;

/**
 * @author zhouqi
 */
public class StudentAlterationSearchAction extends RestrictionExampleTemplateAction {

  protected void indexSetting(HttpServletRequest request) throws Exception {
    addCollection(request, "modes", baseCodeService.getCodes(AlterMode.class));
    initBaseCodes("studentStateList", StudentState.class);
  }

  /**
   * 查找标准
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    try {
      EntityQuery query = buildQuery(request);
      addCollection(request, entityName + "s", utilService.search(query));
      return forward(request);
    } catch (Exception e) {
      addCollection(request, entityName + "s", Page.EMPTY_PAGE);
      return forward(request);
    }
  }

  protected EntityQuery buildQuery(HttpServletRequest request) {
    EntityQuery query = new EntityQuery(StudentAlteration.class, getEntityName());
    populateConditions(request, query);
    query.getConditions().addAll(
        QueryRequestSupport.extractConditions(request, Student.class, "std", "std.type.id"));
    Long stdTypeId = getLong(request, "std.type.id");
    DataRealmUtils.addDataRealms(query, new String[] { "alteration.std.type.id",
        "alteration.std.department.id" }, getDataRealmsWith(stdTypeId, request));
    // 加入变动日期查询条件
    Date alterFormDate = RequestUtils.getDate(request, "alterFromDate");
    Date alterToDate = RequestUtils.getDate(request, "alterToDate");
    if (null != alterFormDate) {
      query.add(new Condition("alteration.alterBeginOn >= (:fromDate)", alterFormDate));
    }
    if (null != alterToDate) {
      query.add(new Condition("alteration.alterBeginOn <= (:toDate)", alterToDate));
    }

    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(request.getParameter("orderBy")));
    return query;
  }

  /**
   * 按变动日期进行统计
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward stat(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    try {
      EntityQuery query = buildQuery(request);
      query.setLimit(null);
      query.getOrders().clear();
      List groupBy = new ArrayList();
      groupBy.add("alteration.mode.id");
      query.setGroups(groupBy);
      query.setSelect("alteration.mode.id, count(*)");

      List statResult = (List) utilService.search(query);
      List results = new ArrayList();
      for (Iterator it = statResult.iterator(); it.hasNext();) {
        Object[] obj = (Object[]) it.next();
        obj[0] = utilService.load(AlterMode.class, new Long(String.valueOf(obj[0])));
        results.add(obj);
      }

      addCollection(request, "results", results);
      return forward(request, "statResult");
    } catch (Exception e) {
      addCollection(request, entityName + "s", Page.EMPTY_PAGE);
      return forward(request);
    }
  }
}
