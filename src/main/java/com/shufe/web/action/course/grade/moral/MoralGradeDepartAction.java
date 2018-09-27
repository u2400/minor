package com.shufe.web.action.course.grade.moral;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.mvc.struts.misc.ImporterServletSupport;
import com.ekingstar.commons.transfer.Transfer;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.utils.transfer.ImporterForeignerListener;
import com.shufe.model.course.grade.MoralGrade;
import com.shufe.service.course.grade.moral.MoralGradeImporter;

public class MoralGradeDepartAction extends AbstractMoralGradeAction {
 
  public ActionForward importData(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TransferResult tr = new TransferResult();
    Transfer transfer = ImporterServletSupport.buildEntityImporter(request, MoralGrade.class, tr);
    if (null == transfer) { return forward(request, "/pages/components/importData/error"); }
    transfer.addListener(new ImporterForeignerListener(utilService)).addListener(
        new MoralGradeImporter(utilService, Boolean.TRUE));
    transfer.transfer(tr);
    if (tr.hasErrors()) {
      return forward(request, "/pages/components/importData/error");
    } else {
      return redirect(request, "search", "info.import.success");
    }
  }

}
