// Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/kpdus/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   StudentAbilityQueryAction.java

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

public class StudentAbilityQueryAction extends RestrictionSupportAction {

  public StudentAbilityQueryAction() {
  }

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
    if (isGraduated != null) if (isGraduated.booleanValue()) query.add(new Condition(
        "student.degreeInfo.graduateOn is not null"));
    else query
        .add(new Condition(
            "not exists (from student.degreeInfo) or not exists (from student.degreeInfo degreeInfo where degreeInfo.graduateOn is null)"));
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
    if (transfer == null) {
      return forward(request, "/pages/components/importData/error");
    } else {
      transfer.addListener(new ImporterForeignerListener(utilService)).addListener(
          new StudentAbilityImporterListener(utilService));
      transfer.transfer(tr);
      return forward(request, "/pages/components/importData/result");
    }
  }

  protected Collection getExportDatas(HttpServletRequest request) {
    return utilService.search(builderQuery(request));
  }
}
