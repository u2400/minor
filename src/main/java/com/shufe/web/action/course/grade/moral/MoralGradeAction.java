package com.shufe.web.action.course.grade.moral;

import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.mvc.struts.misc.ImporterServletSupport;
import com.ekingstar.commons.transfer.Transfer;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.utils.transfer.ImporterForeignerListener;
import com.shufe.model.course.grade.Grade;
import com.shufe.model.course.grade.MoralGrade;
import com.shufe.service.course.grade.moral.MoralGradeImporter;

/**
 * 德育成绩管理
 * 
 * @author chaostone
 */
public class MoralGradeAction extends AbstractMoralGradeAction {

  /**
   * 更新成绩状态
   */
  public ActionForward updateStatus(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Integer status = getInteger(request, "status");
    if (null != status) {
      if (status.intValue() == Grade.CONFIRMED || status.intValue() == Grade.PUBLISHED) {
        Long[] gradeIds = SeqStringUtil.transformToLong(request.getParameter("moralGradeIds"));
        List grades = utilService.load(MoralGrade.class, "id", gradeIds);
        for (Iterator iterator = grades.iterator(); iterator.hasNext();) {
          MoralGrade grade = (MoralGrade) iterator.next();
          grade.setStatus(status);
        }
        utilService.saveOrUpdate(grades);
      }
    }
    return redirect(request, "search", "info.action.success");
  }

  public ActionForward importData(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TransferResult tr = new TransferResult();
    Transfer transfer = ImporterServletSupport.buildEntityImporter(request, MoralGrade.class, tr);
    if (null == transfer) { return forward(request, "/pages/components/importData/error"); }
    transfer.addListener(new ImporterForeignerListener(utilService)).addListener(
        new MoralGradeImporter(utilService, Boolean.FALSE));
    transfer.transfer(tr);
    if (tr.hasErrors()) {
      return forward(request, "/pages/components/importData/error");
    } else {
      return redirect(request, "search", "info.import.success");
    }
  }

}
