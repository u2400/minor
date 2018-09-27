package com.shufe.web.action.std.info;

import java.sql.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.utils.web.RequestUtils;
import com.ekingstar.eams.system.baseinfo.model.StudentType;
import com.shufe.model.std.Student;
import com.shufe.model.std.alteration.StudentInfoAlterApply;
import com.shufe.model.std.alteration.StudentInfoAlterItem;
import com.shufe.model.std.alteration.StudentPropertyMeta;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.service.std.alteration.service.StudentInfoAlterApplyService;
import com.shufe.web.action.common.DispatchBasicAction;

public class StudentInfoAlterAuditAction extends DispatchBasicAction {

  private StudentInfoAlterApplyService studentInfoAlterApplyService;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "stdTypeList", baseInfoService.getBaseInfos(StudentType.class));
    addCollection(request, "departmentList", baseInfoService.getBaseInfos(Department.class));
    return forward(request);
  }

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = builderQuery(request);
    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(get(request, "orderBy")));
    addCollection(request, "applies", utilService.search(query));
    request.setAttribute("studentInfoAlterApplyService", studentInfoAlterApplyService);
    return forward(request);
  }

  protected EntityQuery builderQuery(HttpServletRequest request) {
    EntityQuery query = new EntityQuery(StudentInfoAlterApply.class, "apply");
    populateConditions(request, query);
    String adminClassName = RequestUtils.get(request, "adminClassName");
    if (StringUtils.isNotBlank(adminClassName)) {
      query.join("apply.student.adminClasses", "adminClass");
      query.add(new Condition("adminClass.name like :adminClassName", "%" + adminClassName + "%"));
    }

    return query;
  }

  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long applyId = getLong(request, "applyIds");
    StudentInfoAlterApply apply = (StudentInfoAlterApply) utilService.get(StudentInfoAlterApply.class,
        applyId);
    request.setAttribute("apply", apply);
    request.setAttribute("studentInfoAlterApplyService", studentInfoAlterApplyService);
    return forward(request);
  }

  public ActionForward auditPassed(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] applyIds = SeqStringUtil.transformToLong(request.getParameter("applyIds"));
    EntityQuery entityQuery = new EntityQuery(StudentInfoAlterApply.class, "apply");
    entityQuery.add(new Condition("apply.id  in (:id)", applyIds));
    List<StudentInfoAlterApply> applys = (List) utilService.search(entityQuery);
    if (applys != null && applys.size() > 0) {
      for (int i = 0; i < applys.size(); i++) {
        StudentInfoAlterApply info = applys.get(i);
        info.setAuditAt(new Date(System.currentTimeMillis()));
        info.setAuditor(this.getUser(request));
        info.setIp(RequestUtils.getIpAddr(request));
        info.setPassed(true);

        Student std = info.getStudent();
        for (StudentInfoAlterItem item : info.getItems()) {
          StudentPropertyMeta meta = item.getMeta();
          String propertyName = meta.getCode();
          Object obj = null;
          if (propertyName.startsWith("std")) {
            obj = std;
          } else if (propertyName.startsWith("basicInfo")) {
            obj = std.getBasicInfo();
          } else if (propertyName.startsWith("statusInfo")) {
            obj = std.getStudentStatusInfo();
          }
          propertyName = StringUtils.substringAfter(propertyName, ".");
          if (propertyName.endsWith(".id")) {
            PropertyUtils.setProperty(obj, StringUtils.substringBeforeLast(propertyName, ".id"),
                studentInfoAlterApplyService.get(meta, item.getNewValue()));
          } else {
            BeanUtils.copyProperty(obj, propertyName, item.getNewValue());
          }
          utilService.saveOrUpdate(obj);
        }
        utilService.saveOrUpdate(info);
      }
    }
    return redirect(request, "search", "info.action.success");
  }

  public ActionForward auditNoPassed(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] applyIds = SeqStringUtil.transformToLong(request.getParameter("applyIds"));
    EntityQuery entityQuery = new EntityQuery(StudentInfoAlterApply.class, "apply");
    entityQuery.add(new Condition("apply.id  in (:id)", applyIds));
    List<StudentInfoAlterApply> applys = (List) utilService.search(entityQuery);
    if (applys != null && applys.size() > 0) {
      for (int i = 0; i < applys.size(); i++) {
        StudentInfoAlterApply info = applys.get(i);
        info.setAuditAt(new Date(System.currentTimeMillis()));
        info.setAuditor(this.getUser(request));
        info.setIp(RequestUtils.getIpAddr(request));
        info.setPassed(false);
        utilService.saveOrUpdate(info);
      }
    }
    return redirect(request, "search", "info.action.success");
  }

  public void setStudentInfoAlterApplyService(StudentInfoAlterApplyService studentInfoAlterApplyService) {
    this.studentInfoAlterApplyService = studentInfoAlterApplyService;
  }

}
