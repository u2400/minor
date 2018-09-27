//$Id: StdDetailAction.java,v 1.1 2007-5-22 下午02:29:53 chaostone Exp $
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
 * @author chaostone
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name           Date          Description 
 * ============         ============        ============
 *chaostone      2007-5-22         Created
 *  
 ********************************************************************************/

package com.shufe.web.action.std.info;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.Order;
import com.ekingstar.commons.utils.web.RequestUtils;
import com.ekingstar.eams.system.basecode.state.Gender;
import com.ekingstar.eams.system.basecode.state.Nation;
import com.ekingstar.eams.system.basecode.state.PoliticVisage;
import com.shufe.model.std.BasicInfo;
import com.shufe.model.std.Student;
import com.shufe.model.std.alteration.StudentInfoAlterApply;
import com.shufe.model.std.alteration.StudentInfoAlterItem;
import com.shufe.model.std.alteration.StudentPropertyMeta;
import com.shufe.service.std.alteration.service.StudentInfoAlterApplyService;
import com.shufe.web.action.common.DispatchBasicAction;

/**
 * 学生维护和查询个人信息
 * 
 * @author chaostone
 */
public class StdDetailAction extends DispatchBasicAction {

  private StudentInfoAlterApplyService studentInfoAlterApplyService;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    request.setAttribute("std", this.getStudentFromSession(request.getSession()));
    return forward(request);
  }

  /**
   * 查看信息
   */
  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Student std = getStudentFromSession(request.getSession());
    String kind = request.getParameter("kind");
    request.setAttribute("std", std);
    if (StringUtils.isEmpty(kind)) {
      kind = "stdInfo";
    }
    if (kind.equals("basicInfo")) {
      EntityQuery query = new EntityQuery(StudentInfoAlterApply.class, "apply");
      query.add(new Condition("apply.student=:std", std));
      query.addOrder(new Order("apply.applyAt desc"));
      addCollection(request, "applies", utilService.search(query));
      request.setAttribute("studentInfoAlterApplyService", studentInfoAlterApplyService);
    }
    return forward(request, kind);
  }

  public ActionForward editApply(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Student std = getStudentFromSession(request.getSession());
    addCollection(request, "genders", baseCodeService.getCodes(Gender.class));
    addCollection(request, "politicVisages", baseCodeService.getCodes(PoliticVisage.class));
    addCollection(request, "nations", baseCodeService.getCodes(Nation.class));

    request.setAttribute("std", std);
    return forward(request);
  }

  public ActionForward cancelApply(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long id = getLong(request, "applyId");
    Student std = getStudentFromSession(request.getSession());
    StudentInfoAlterApply apply = (StudentInfoAlterApply) utilService.get(StudentInfoAlterApply.class, id);
    if (std.equals(apply.getStudent()) && null == apply.getPassed()) {
      utilService.remove(apply);
      return redirect(request, "info", "info.delete.success", "&kind=basicInfo");
    } else {
      return redirect(request, "info", "info.delete.failure", "&kind=basicInfo");
    }
  }

  public ActionForward saveApply(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Student std = getStudentFromSession(request.getSession());
    StudentInfoAlterApply apply = new StudentInfoAlterApply();
    apply.setStudent(std);
    apply.setApplyAt(new Date(System.currentTimeMillis()));
    apply.setIp(RequestUtils.getIpAddr(request));
    String[] auditItems = new String[] { "std.name", "basicInfo.gender.id", "basicInfo.birthday",
        "basicInfo.idCard", "basicInfo.nation.id", "basicInfo.politicVisage.id",
        "statusInfo.originalAddress" };
    for (String name : auditItems) {
      String value = request.getParameter(name);
      if (StringUtils.isNotBlank(value)) {
        Object obj = null;
        if (name.startsWith("std")) {
          obj = std;
        } else if (name.startsWith("basicInfo")) {
          obj = std.getBasicInfo();
        } else if (name.startsWith("statusInfo")) {
          obj = std.getStudentStatusInfo();
        }
        Object objValue = null;
        try {
          objValue = PropertyUtils.getProperty(obj, StringUtils.substringAfter(name, "."));
        } catch (Exception e) {
        }
        String objStrValue = null;
        if (objValue == null) objStrValue = "";
        else objStrValue = objValue.toString();

        if (!objStrValue.equals(value)) {
          StudentInfoAlterItem item = new StudentInfoAlterItem();
          List<StudentPropertyMeta> metas = (List<StudentPropertyMeta>) utilService
              .load(StudentPropertyMeta.class, "code", name);
          item.setMeta(metas.get(0));
          item.setApply(apply);
          apply.getItems().add(item);
          item.setNewValue(value);
          item.setOldValue(objStrValue);
        }
      }
    }

    Map params = getParams(request, "basicInfo",
        "basicInfo.gender.id,basicInfo.birthday,basicInfo.idCard,basicInfo.nation.id,basicInfo.politicVisage.id");
    BasicInfo basicInfo = (BasicInfo) utilService.get(BasicInfo.class, getLong(request, "basicInfo.id"));
    populate(params, basicInfo);
    utilService.saveOrUpdate(basicInfo);
    if (!apply.getItems().isEmpty()) utilService.saveOrUpdate(apply);
    return redirect(request, "info", "info.save.success", "&kind=basicInfo");
  }

  public void setStudentInfoAlterApplyService(StudentInfoAlterApplyService studentInfoAlterApplyService) {
    this.studentInfoAlterApplyService = studentInfoAlterApplyService;
  }

}
