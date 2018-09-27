package com.shufe.web.action.std.bursary;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.shufe.model.std.bursary.BursaryApply;

/**
 * 学校最终审核
 * 
 * @author chaostone
 */
public class SchoolAction extends ApplySearchAction {
  public ActionForward approve(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    BursaryApply apply = getApply(request);
    if (null == apply.getCollegeApproved()) return redirect(request, "search", "院系尚未审批");
    apply.setApproved(getBoolean(request, "apply.approved"));
    apply.setSchoolOpinion(request.getParameter("apply.schoolOpinion"));
    utilService.saveOrUpdate(apply);
    return redirect(request, "search", "info.save.success");
  }

  public ActionForward batchApproveForm(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    List<BursaryApply> applies = utilService.load(BursaryApply.class, "id",
        SeqStringUtil.transformToLong(request.getParameter("applyIds")));
    addSingleParameter(request, "applies", applies);
    return forward(request);
  }

  public ActionForward reject(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    BursaryApply apply = (BursaryApply) utilService.get(BursaryApply.class, getLong(request, "applyId"));
    apply.setApproved(null);
    apply.setCollegeApproved(null);
    utilService.saveOrUpdate(apply);
    return redirect(request, "search", "info.action.success");
  }

  public ActionForward batchApprove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Boolean approved = getBoolean(request, "approved");
    String schoolOpinion = request.getParameter("schoolOpinion");
    List<BursaryApply> applies = new ArrayList<BursaryApply>();
    for (String applyId : request.getParameterValues("apply.id")) {
      BursaryApply apply = (BursaryApply) utilService.get(BursaryApply.class, Long.valueOf(applyId));
      apply.setApproved(approved);
      apply.setSchoolOpinion(schoolOpinion);
    }
    utilService.saveOrUpdate(applies);
    return redirect(request, "search", "info.save.success");
  }

  protected void buildQuery(HttpServletRequest request, EntityQuery query) {
    query.add(new Condition("apply.collegeApproved = true"));
  }
}
