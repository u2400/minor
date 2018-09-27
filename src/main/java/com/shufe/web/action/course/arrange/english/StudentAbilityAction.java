//$Id: OtherGradeSearchAction.java,v 1.1 2007-2-24 下午06:34:58 chaostone Exp $
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
 * Name             Date            Description 
 * ============     ============    ============
 * chaostone        2007-02-24      Created
 * zq               2007-09-13      在buildQuery中，增加了addStdTypeTreeDataRealm(...)方法
 ********************************************************************************/

package com.shufe.web.action.course.arrange.english;

import java.util.Collection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.mvc.struts.misc.ImporterServletSupport;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.transfer.Transfer;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.utils.transfer.ImporterForeignerListener;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.ekingstar.eams.system.baseinfo.model.StudentType;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.service.course.arrange.english.StudentAbilityImporterListener;
import com.shufe.web.action.common.RestrictionSupportAction;

/**
 * 学生语种等级管理
 * 
 * @author chaostone
 */
public class StudentAbilityAction extends RestrictionSupportAction {

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "stdTypeList", baseInfoService.getBaseInfos(StudentType.class));
    addCollection(request, "departmentList", baseInfoService.getBaseInfos(Department.class));
    addCollection(request, "languageAbilities", baseCodeService.getCodes(LanguageAbility.class));
    return forward(request);
  }

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = builderQuery(request);
    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(get(request, "orderBy")));
    addCollection(request, "students", utilService.search(query));
    return forward(request);
  }

  protected EntityQuery builderQuery(HttpServletRequest request) {
    EntityQuery query = new EntityQuery(Student.class, "student");
    populateConditions(request, query);
    query.add(new Condition("student.inSchool = true"));
    query.add(new Condition("student.active = true"));
    Boolean isGraduated = getBoolean(request, "isGraduated");
    if (null != isGraduated) {
      if (isGraduated.booleanValue()) {
        query.add(new Condition("student.degreeInfo.graduateOn is not null"));
      } else {
        query
            .add(new Condition(
                "not exists (from student.degreeInfo) or not exists (from student.degreeInfo degreeInfo where degreeInfo.graduateOn is null)"));
      }
    }
    return query;
  }

  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "student", utilService.get(Student.class, getLong(request, "studentId")));
    return forward(request);
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "student", utilService.get(Student.class, getLong(request, "studentId")));
    addCollection(request, "languageAbilities", baseCodeService.getCodes(LanguageAbility.class));
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    utilService.saveOrUpdate(populateEntity(request, Student.class, "student"));
    return redirect(request, "search", "info.action.success");
  }

  public ActionForward importData(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TransferResult tr = new TransferResult();
    Transfer transfer = ImporterServletSupport.buildEntityImporter(request, Student.class, tr);
    if (null == transfer) { return forward(request, "/pages/components/importData/error"); }
    transfer.addListener(new ImporterForeignerListener(utilService)).addListener(
        new StudentAbilityImporterListener(utilService));
    transfer.transfer(tr);
    return forward(request, "/pages/components/importData/result");
  }

  @Override
  protected Collection getExportDatas(HttpServletRequest request) {
    return utilService.search(builderQuery(request));
  }
}
