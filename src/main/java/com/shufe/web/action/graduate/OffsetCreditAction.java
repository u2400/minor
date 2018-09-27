package com.shufe.web.action.graduate;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ekingstar.common.detail.Pagination;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.Order;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.utils.query.QueryRequestSupport;
import com.ekingstar.commons.utils.web.RequestUtils;
import com.ekingstar.commons.web.dispatch.Action;
import com.ekingstar.eams.std.graduation.audit.model.AuditResult;
import com.ekingstar.eams.std.graduation.audit.model.AuditStandard;
import com.ekingstar.eams.std.graduation.audit.model.OffsetCredit;
import com.ekingstar.eams.system.basecode.industry.MajorType;
import com.ekingstar.eams.system.basecode.industry.StudentState;
import com.ekingstar.security.Resource;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.baseinfo.Speciality;
import com.shufe.service.graduate.AuditStandardService;
import com.shufe.service.std.StudentService;
import com.shufe.util.DataRealmUtils;
import com.shufe.web.OutputProcessObserver;
import com.shufe.web.helper.RestrictionHelper;
import com.shufe.web.helper.StdSearchHelper;

public class OffsetCreditAction extends StudentAuditSupportAction {

  protected RestrictionHelper dataRealmHelper;

  protected AuditStandardService auditStandardService;

  protected StdSearchHelper stdSearchHelper;

  /**
   * @param auditStandardService
   *          要设置的 auditStandardService.
   */
  public void setAuditStandardService(AuditStandardService auditStandardService) {
    this.auditStandardService = auditStandardService;
  }

  public void setDataRealmHelper(RestrictionHelper dataRealmHelper) {
    this.dataRealmHelper = dataRealmHelper;
  }

  /**
   * 待审核学生列表
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return studentAuditManager.ftl
   */
  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    initSearchBar(form, request);
    initBaseCodes("studentStateList", StudentState.class);
    return forward(request);
  }

  public ActionForward studentList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) {
    initSearchBar(form, request);
    initBaseCodes("studentStateList", StudentState.class);
    return this.forward(mapping, request, "studentList");
  }

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String departmentIds = getDepartmentIdSeq(request);
    String studentTypeIds = getStdTypeIdSeq(request);
    // searchBar(form, request, studentTypeIds, departmentIds);
    setOtherSearch(request, studentTypeIds, departmentIds);

    EntityQuery query = stdSearchHelper.buildStdQuery(request);
    if (StringUtils.equals("null", get(request, "studentGraduateAuditStatus"))) {
      query.add(new Condition("std.graduateAuditStatus is null"));
    }

    Collection students = utilService.search(query);
    addCollection(request, "studentList", students);

    return forward(request);
  }

  public EntityQuery buildOffsetCreditQuery(HttpServletRequest request) {
    return buildOffsetCreditQuery(request, null);
  }

  /**
   * 查询学生的界面参数一般规定为:std<br>
   * 其他查询班级项,采用adminClass开头<br>
   * majorTypeId表示是否为双专业<br>
   * std_state一专业学籍有效性和二专业是否就读的条件
   * 
   * @param request
   * @param extraStdTypeAttr
   * @return
   */
  public EntityQuery buildOffsetCreditQuery(HttpServletRequest request, String extraStdTypeAttr) {
    EntityQuery query = new EntityQuery(OffsetCredit.class, "offsetCredit");
    QueryRequestSupport.populateConditions(request, query, "offsetCredit.std.type.id");
    Long majorTypeId = RequestUtils.getLong(request, "majorTypeId");
    // 默认是第一专业
    if (null == majorTypeId) majorTypeId = MajorType.FIRST;
    Long stdTypeId = RequestUtils.getLong(request, "offsetCredit.std.type.id");
    if (null == stdTypeId && StringUtils.isNotEmpty(extraStdTypeAttr)) {
      stdTypeId = RequestUtils.getLong(request, extraStdTypeAttr);
    }
    // 学生类别大类查询
    String resourceName = getResourceName(request);
    Resource resource = (Resource) authorityService.getResource(resourceName);
    if (null != resource && !resource.getPatterns().isEmpty()) {
      String departName = "offsetCredit.std.department.id";
      if (MajorType.SECOND.equals(majorTypeId)) {
        departName = "offsetCredit.std.secondMajor.department.id";
      }
      DataRealmUtils.addDataRealms(query, new String[] { "offsetCredit.std.type.id", departName },
          dataRealmHelper.getDataRealmsWith(stdTypeId, request));
    } else {
      dataRealmHelper.addStdTypeTreeDataRealm(query, stdTypeId, "offsetCredit.std.type.id", request);
    }

    Long departId = RequestUtils.getLong(request, "department.id");
    Long specialityId = RequestUtils.getLong(request, "speciality.id");
    Long aspectId = RequestUtils.getLong(request, "specialityAspect.id");
    Boolean stdActive = RequestUtils.getBoolean(request, "stdActive");
    Boolean graduateAuditStatus = RequestUtils.getBoolean(request, "std.graduateAuditStatus");
    if (MajorType.FIRST.equals(majorTypeId)) {
      if (null != aspectId) {
        query.add(new Condition("offsetCredit.std.firstAspect.id=" + aspectId));
      }
      if (null != specialityId) {
        query.add(new Condition("offsetCredit.std.firstMajor.id=" + specialityId));
        query.add(new Condition("offsetCredit.std.department.id=" + departId));
      } else {
        if (null != departId) query.add(new Condition("offsetCredit.std.department.id=" + departId));
      }
      // 查询一专业就读的学生
      if (null != stdActive) {
        query.add(new Condition("offsetCredit.std.active = (:stdActive)", stdActive));
      }
      // 查询一专业毕业审核情况
      if (null != graduateAuditStatus) {
        query.add(new Condition("offsetCredit.std.graduateAuditStatus=:graduateAuditStatus",
            graduateAuditStatus));
      }
    } else {
      query
          .add(new Condition("offsetCredit.std.secondMajor.majorType.id = (:majorTypeId)", MajorType.SECOND));
      if (null != aspectId) {
        query.add(new Condition("offsetCredit.std.secondAspect is not null"));
        query.add(new Condition("offsetCredit.std.secondAspect.id=" + aspectId));
      } else {
        if (null != specialityId) {
          query.add(new Condition("offsetCredit.std.secondMajor.id=" + specialityId));
          query.add(new Condition("offsetCredit.std.department.id=" + departId));
        } else {
          if (null != departId) query.add(new Condition("offsetCredit.std.secondMajor.department.id="
              + departId));
        }
      }
      // 查询双专业就读的学生
      if (Boolean.TRUE.equals(stdActive)) {
        query.add(new Condition("offsetCredit.std.isSecondMajorStudy = true"));
      } else if (Boolean.FALSE.equals(stdActive)) {
        query.add(new Condition(
            "offsetCredit.std.isSecondMajorStudy is null or std.isSecondMajorStudy = false"));
      }
      // 查询二专业毕业审核情况
      if (null != graduateAuditStatus) {
        query.add(new Condition("offsetCredit.std.secondGraduateAuditStatus=:secondGraduateAuditStatus",
            graduateAuditStatus));
      }
    }

    query.setLimit(getPageLimit(request));
    // 排序方式以年级降序
    List orders = OrderUtils.parser(request.getParameter("orderBy"));
    if (orders.isEmpty()) {
      orders = new ArrayList();
      orders.add(new Order("offsetCredit.std.enrollYear desc"));
    }
    query.addOrder(orders);
    String adminClassName = RequestUtils.get(request, "adminClassName");
    if (StringUtils.isNotBlank(adminClassName)) {
      query.join("offsetCredit.std.adminClasses", "adminClass");
      query.add(new Condition("adminClass.name like :adminClassName", "%" + adminClassName + "%"));
    }
    query.join("offsetCredit.std.auditResults", "auditResult");
    return query;
  }

  /**
   * @param form
   * @param request
   * @param studentTypeIds
   * @param departmentIds
   */
  protected void searchBar(ActionForm form, HttpServletRequest request, String studentTypeIds,
      String departmentIds) {
    DynaActionForm dynaForm = (DynaActionForm) form;

    String studenGraduateAuditStatus = request.getParameter("studentGraduateAuditStatus");
    int pageNo = ((Integer) (request.getAttribute("pageNo") == null ? dynaForm.get("pageNo") : request
        .getAttribute("pageNo"))).intValue();
    int pageSize = ((Integer) (request.getAttribute("pageSize") == null ? dynaForm.get("pageSize") : request
        .getAttribute("pageSize"))).intValue();
    Pagination stds = studentService.searchStudent(populateStudent(request), pageNo, pageSize,
        studentTypeIds, departmentIds, studenGraduateAuditStatus);
    addOldPage(request, "studentList", stds);
    Results.addObject("studenGraduateAuditStatus", studenGraduateAuditStatus);
  }

  /**
   * populate页面提供的学生数据
   * 
   * @param request
   * @return
   */
  protected Student populateStudent(HttpServletRequest request) {
    Student student = (Student) populateEntity(request, Student.class, "std");
    String adminClasssIdString = get(request, "adminClasssId1");
    String adminClassName = get(request, "adminClassName");
    AdminClass adminClass = null;
    if (StringUtils.isNotEmpty(adminClasssIdString)) {
      adminClass = new AdminClass(Long.valueOf(adminClasssIdString));
    }
    if (StringUtils.isNotEmpty(adminClassName)) {
      if (null == adminClass) {
        adminClass = new AdminClass();
      }
      adminClass.setName(adminClassName);
    }
    Set adminClassSet = new HashSet();
    adminClassSet.add(adminClass);
    student.setAdminClasses(adminClassSet);
    return student;
  }

  /**
   * @param studentTypeIds
   * @param departmentIds
   */
  protected void setOtherSearch(HttpServletRequest request, String studentTypeIds, String departmentIds) {
    Speciality speciality = new Speciality();
    speciality.setMajorType(new MajorType(MajorType.SECOND));
    Results.addObject("secondSpecialityList",
        specialityService.getSpecialities(speciality, studentTypeIds, departmentIds));
    AuditStandard auditStandard = (AuditStandard) populate(request, AuditStandard.class, "auditStandard");
    Results.addObject("auditStandardList",
        auditStandardService.searchAuditStandard(auditStandard, studentTypeIds));
  }

  protected OutputProcessObserver getOutputProcessObserver(ActionMapping mapping, HttpServletRequest request,
      HttpServletResponse response, Class observerClass) throws Exception {
    return getOutputProcessObserver(mapping, request, response, "processDisplay", observerClass);
  }

  protected OutputProcessObserver getOutputProcessObserver(ActionMapping mapping, HttpServletRequest request,
      HttpServletResponse response, String forwardName, Class observerClass) throws Exception {
    String ext = ".ftl";
    String srcPackage = "com.shufe.web.action.";
    char separator = '/';
    String pageDir = separator + "pages" + separator;
    String actionPostfix = "Action";
    Map action_pages = new HashMap();
    action_pages.put("search", "list");
    action_pages.put("query", "list");
    action_pages.put("edit", "form");
    action_pages.put("home", "index");
    action_pages.put("execute", "index");
    action_pages.put("add", "new");

    StringBuffer buf = new StringBuffer();
    buf.append(pageDir);
    buf.append(StringUtils.substring(clazz.getPackage().getName(), srcPackage.length()).replace('.',
        separator));
    String simpleName = clazz.getName().substring(clazz.getName().lastIndexOf('.') + 1);
    if (simpleName.indexOf(actionPostfix) != -1) {
      buf.append(separator).append(
          StringUtils.uncapitalize(simpleName.substring(0, simpleName.length() - actionPostfix.length())));
    } else {
      buf.append(separator).append(StringUtils.uncapitalize(simpleName.substring(0, simpleName.length())));
    }
    buf.append(separator);
    if (StringUtils.isEmpty(forwardName)) {
      String method = request.getParameter("method");
      if (StringUtils.isEmpty(method)) throw new RuntimeException("need method parameter in dispatch action!");
      if (null == action_pages.get(method)) buf.append(method);
      else buf.append(action_pages.get(method));
    } else {
      buf.append(forwardName);
    }
    buf.append(ext);
    if (Results != null) {
      request.setAttribute(DETAIL_RESULT, Results.getDetail());
    }
    if (log.isDebugEnabled()) {
      log.debug(buf.toString());
    }
    response.setContentType("text/html; charset=utf-8");
    // response.setHeader("title","name");
    ActionForward processDisplay = new ActionForward(buf.toString());
    String path = request.getSession().getServletContext().getRealPath("") + processDisplay.getPath();
    OutputProcessObserver observer = (OutputProcessObserver) observerClass.newInstance();
    observer.setResourses(getResources(request));
    observer.setLocale(getLocale(request));
    observer.setWriter(response.getWriter());
    observer.setPath(path);
    observer.outputTemplate();
    return observer;
  }

  protected EntityQuery buildQuery(HttpServletRequest request) {
    EntityQuery query = new EntityQuery(Student.class, "std");
    populateConditions(request, query, "std.type.id");
    DataRealmUtils.addDataRealms(query, new String[] { "std.type.id", "std.department.id" },
        restrictionHelper.getDataRealmsWith(getLong(request, "std.type.id"), request));
    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(request.getParameter("orderBy")));
    return query;
  }

  // 冲抵学分修改
  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] stdIds = SeqStringUtil.transformToLong(request.getParameter("stdIds"));
    //
    if (stdIds != null && stdIds.length != 0) {
      EntityQuery entityQuery = new EntityQuery(OffsetCredit.class, "offsetCredit");
      entityQuery.add(new Condition("offsetCredit.std.id  = :id", stdIds[0]));
      List<OffsetCredit> offsetCredits = (List) utilService.search(entityQuery);
      if (null != offsetCredits && !offsetCredits.isEmpty()) {
        request.setAttribute("offsetCredit", offsetCredits.get(0));
      }
      Student std = (Student) utilService.get(Student.class, stdIds[0]);
      request.setAttribute("student", std);
    }
    request.setAttribute("queryStr", this.get(request, "queryStr"));
    return forward(request);
  }

  // 冲抵学分保存
  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long stdId = Long.parseLong(get(request, "offsetCredit.std.id"));
    Student std = (Student) utilService.get(Student.class, stdId);
    OffsetCredit offsetCredit = (OffsetCredit) populateEntity(request, OffsetCredit.class, "offsetCredit");
    offsetCredit.setStd(std);
    utilService.saveOrUpdate(offsetCredit);
    return redirect(request, new Action("", "search"), "info.action.success");
  }

  /**
   * @return Returns the studentService.
   */
  public StudentService getStudentService() {
    return studentService;
  }

  public void setStdSearchHelper(StdSearchHelper stdSearchHelper) {
    this.stdSearchHelper = stdSearchHelper;
  }
}
