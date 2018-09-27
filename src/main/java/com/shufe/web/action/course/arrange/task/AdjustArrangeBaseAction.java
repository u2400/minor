//$Id: AdjustArrangeBaseAction.java,v 1.1 2012-11-13 zhouqi Exp $
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.eams.system.baseinfo.model.StudentType;
import com.shufe.model.course.arrange.task.AdjustArrange;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;

/**
 * @author zhouqi
 */
public class AdjustArrangeBaseAction extends CalendarRestrictionSupportAction {

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "adjusts", utilService.search(builderQuery(request)));
    return forward(request);
  }

  protected EntityQuery builderQuery(HttpServletRequest request) {
    EntityQuery query = new EntityQuery(AdjustArrange.class, "adjust");
    populateConditions(request, query);
    if (null == getLong(request, "adjust.teacher.id")) {
      String isPassedValue = get(request, "adjust.isPassed");
      if (StringUtils.equals(isPassedValue, "final")) {
        query.add(new Condition("adjust.isFinalOk is not null"));
      } else if (StringUtils.isNotBlank(isPassedValue)) {
        query.add(new Condition("adjust.isFinalOk is null"));
      }
      // 权限
      Collection<Department> departments = getDeparts(request);
      if (CollectionUtils.isEmpty(departments)) {
        query.add(new Condition("adjust.task.arrangeInfo.teachDepart is null"));
      } else {
        query.add(new Condition("adjust.task.arrangeInfo.teachDepart in (:departments)", departments));
      }
      Collection<StudentType> stdTypes = getStdTypes(request);
      if (CollectionUtils.isEmpty(departments)) {
        query.add(new Condition("adjust.task.teachClass.stdType is null"));
      } else {
        query.add(new Condition("adjust.task.teachClass.stdType in (:stdTypes)", stdTypes));
      }
    }

    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(get(request, "orderBy")));
    return query;
  }

  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "adjust", utilService.get(AdjustArrange.class, getLong(request, "adjustId")));
    return forward(request);
  }

  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    utilService.remove(utilService.load(AdjustArrange.class, "id",
        SeqStringUtil.transformToLong(get(request, "adjustIds"))));
    return redirect(request, "search", "info.action.success");
  }

  protected Collection getExportDatas(HttpServletRequest request) {
    EntityQuery query = builderQuery(request);
    query.setLimit(null);
    return utilService.search(query);
  }
}
