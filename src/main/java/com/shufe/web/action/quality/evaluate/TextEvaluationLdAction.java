//$Id: TextEvaluationAction.java,v 1.15 2007/01/09 07:54:47 cwx Exp $
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
 * @author hj
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * chenweixiong              2005-10-21         Created
 *  
 ********************************************************************************/

package com.shufe.web.action.quality.evaluate;

import java.util.Collection;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.shufe.model.quality.evaluate.TextEvaluation;
import com.shufe.service.quality.evaluate.TextEvaluationService;
import com.shufe.util.DataRealmUtils;

/**
 * @author hj 2005-10-21 TextEvaluationAction.java has been created<br>
 *         chaostone 2007-6-19 modified
 */
public class TextEvaluationLdAction extends TextEvaluationSearchAction {

  protected TextEvaluationService textEvaluationService;

  public void setTextEvaluationService(TextEvaluationService textEvaluationService) {
    this.textEvaluationService = textEvaluationService;
  }

  /**
   * 查询文字评教
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   */
  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) {
    addCollection(request, "textEvaluations", utilService.search(buildQuery(request)));
    return forward(request);
  }

  private EntityQuery buildQuery(HttpServletRequest request) {
    EntityQuery entityQuery = new EntityQuery(TextEvaluation.class, "textEvaluation");
    // 看不懂求解释
    // DataRealmUtils.addDataRealms(entityQuery, new String[] { "textEvaluation.std.type.id",
    // "textEvaluation.task.arrangeInfo.teachDepart.id" }, getDataRealms(request));
    populateConditions(request, entityQuery);
    entityQuery.add(new Condition("textEvaluation.user != null"));
    String isAffirmValue = get(request, "isAffirm");
    String textEvaluationId = get(request, "textEvaluationId");
    if (StringUtils.equals("null", isAffirmValue)) {
      entityQuery.add(new Condition("textEvaluation.isAffirm is null"));
    } else if (StringUtils.isNotEmpty(isAffirmValue)) {
      entityQuery.add(new Condition("textEvaluation.isAffirm = (:isAffirmValue)", getBoolean(request,
          "isAffirm")));
    } else if (StringUtils.isNotEmpty(textEvaluationId)) {
      entityQuery.add(new Condition("textEvaluation.id in (" + textEvaluationId + ")"));
    }
    entityQuery.setLimit(getPageLimit(request));
    entityQuery.addOrder(OrderUtils.parser(request.getParameter("orderBy")));
    return entityQuery;
  }

  /**
   * 删除所选择的一堆对象
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    utilService.remove(utilService.load(TextEvaluation.class, "id",
        SeqStringUtil.transformToLong(get(request, "textEvaluationIds"))));
    return redirect(request, "search", "info.delete.success");
  }

  /**
   * 更新对象
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward updateAffirm(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Collection evaluations = utilService.load(TextEvaluation.class, "id",
        SeqStringUtil.transformToLong(get(request, "textEvaluationIds")));
    for (Iterator it = evaluations.iterator(); it.hasNext();) {
      TextEvaluation evaluation = (TextEvaluation) it.next();
      evaluation.setIsAffirm(getBoolean(request, "isAffirm"));
    }
    utilService.saveOrUpdate(evaluations);
    return redirect(request, "search", "info.action.success");
  }
}
