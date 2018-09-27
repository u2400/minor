package com.shufe.web.action.std.bursary;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.shufe.model.std.bursary.BursaryApply;

/**
 * 辅导员管理和审核
 * 
 * @author chaostone
 */
public class InstructorAction extends ApplySearchAction {

  public ActionForward approve(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    BursaryApply apply = getApply(request);
    if (apply.getApproved() != null || apply.getCollegeApproved() != null) {
      return redirect(request, "search", "上级单位已经审批");
    } else {
      if (!apply.getSubmited()) return redirect(request, "search", "申请尚未提交");
      apply.setInstructorApproved(getBoolean(request, "apply.instructorApproved"));
      apply.setInstructorOpinion(request.getParameter("apply.instructorOpinion"));
      utilService.saveOrUpdate(apply);
    }
    return redirect(request, "search", "info.save.success");
  }

  public ActionForward reject(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    BursaryApply apply = (BursaryApply) utilService.get(BursaryApply.class, getLong(request, "applyId"));
    if (apply.getCollegeApproved() == null) {
      apply.setInstructorApproved(null);
      apply.setSubmited(false);
      utilService.saveOrUpdate(apply);
      return redirect(request, "search", "info.action.success");
    } else {
      return redirect(request, "search", "info.action.failure");
    }
  }

  protected void buildQuery(HttpServletRequest request, EntityQuery query) {
    query.add(new Condition("apply.submited = true"));
    query.join("apply.std.adminClasses", "adminclass");
    query.add(new Condition("adminclass.instructor.code = :me", getLoginName(request)));
  }
}
