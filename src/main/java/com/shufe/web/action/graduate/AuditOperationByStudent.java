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
 * @author yang
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * yang                 2005-11-9           Created
 *  
 ********************************************************************************/
package com.shufe.web.action.graduate;

import java.util.Collection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.model.pojo.PojoNotExistException;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.eams.std.graduation.audit.model.OffsetCredit;
import com.shufe.model.std.Student;

/**
 * 学生用户毕业审核操作
 */
public class AuditOperationByStudent extends StudentAuditSupportAction {

  /**
   * 学生用户查看本人培养计划完成情况
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   */
  public ActionForward detail(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) {
    Student student = getStudentFromSession(request.getSession());
    if (student == null) { return this.forwardError(mapping, request, "error.dataRealm.insufficient"); }
    try {
      getStudentTeachPlanAuditDetail(student, null, null, request.getParameter("auditTerm"),
          new Boolean(true), Boolean.TRUE);
    } catch (PojoNotExistException e) {
      if (e.getMessage() != null && e.getMessage().equals(com.shufe.model.Constants.TEACHPLAN)) { return this
          .forwardError(mapping, request, "error.teachPlan.notExists"); }
    }
    EntityQuery query = new EntityQuery(OffsetCredit.class, "oc");
    query.add(new Condition("oc.std=:std", student));
    query.add(new Condition("oc.offsetCredit >0"));
    Collection offsetcredits = utilService.search(query);
    if (offsetcredits.size() > 0) request.setAttribute("offsetCredit", offsetcredits.iterator().next());
    return this.forward(request, "../auditResultDetailForStudent");
  }

  /**
   * FIXME 该方法应移入学位审核
   * 读取当前登录学生学位审核数据结果
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   */
  public ActionForward studentDegreeDetail(ActionMapping mapping, ActionForm form,
      HttpServletRequest request, HttpServletResponse response) {
    // String stdNo = this.getUserFromSession(request.getSession()).getName();
    // List resultList = utilService.loadByKey(StudentDetailWithAudit.class, "stdNo", stdNo);
    // if (!resultList.isEmpty()){
    // Results.addObject("auditResult", resultList.get(0));
    // }
    return this.forward(mapping, request, "detail");
  }
}
