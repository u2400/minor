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
 * 院系查看和审核
 * 
 * @author chaostone
 */
public class CollegeAction extends ApplySearchAction {
  public ActionForward approve(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    BursaryApply apply = getApply(request);
    if (apply.getApproved() != null) {
      return redirect(request, "search", "上级单位已经审批");
    } else {
      if (null == apply.getInstructorApproved()) return redirect(request, "search", "辅导员尚未审批");
      apply.setCollegeApproved(getBoolean(request, "apply.collegeApproved"));
      apply.setCollegeOpinion(request.getParameter("apply.collegeOpinion"));
      utilService.saveOrUpdate(apply);
    }
    return redirect(request, "search", "info.save.success");
  }

  public ActionForward reject(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    BursaryApply apply = (BursaryApply) utilService.get(BursaryApply.class, getLong(request, "applyId"));
    if (null == apply.getApproved()) {
      apply.setCollegeApproved(null);
      apply.setInstructorApproved(null);
      utilService.saveOrUpdate(apply);
      return redirect(request, "search", "info.action.success");
    } else {
      return redirect(request, "search", "info.action.failure");
    }
  }

  public ActionForward batchApproveForm(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    List<BursaryApply> applies = utilService.load(BursaryApply.class, "id",
        SeqStringUtil.transformToLong(request.getParameter("applyIds")));
    List<BursaryApply> filtedApplies = new ArrayList<BursaryApply>();
    for (BursaryApply apply : applies) {
      if (apply.getApproved() == null) filtedApplies.add(apply);
    }
    addSingleParameter(request, "applies", filtedApplies);
    return forward(request);
  }

  public ActionForward batchApprove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Boolean approved = getBoolean(request, "approved");
    String collegeOpinion = request.getParameter("collegeOpinion");
    List<BursaryApply> applies = new ArrayList<BursaryApply>();
    for (String applyId : request.getParameterValues("apply.id")) {
      BursaryApply apply = (BursaryApply) utilService.get(BursaryApply.class, Long.valueOf(applyId));
      if (apply.getApproved() == null) {
        apply.setCollegeApproved(approved);
        apply.setCollegeOpinion(collegeOpinion);
      }
    }
    utilService.saveOrUpdate(applies);
    return redirect(request, "search", "info.save.success");
  }

  protected void buildQuery(HttpServletRequest request, EntityQuery query) {
    query.add(new Condition("apply.instructorApproved = true"));
    query.add(new Condition("apply.std.department in (:departments)", this.getDeparts(request)));
  }
}
