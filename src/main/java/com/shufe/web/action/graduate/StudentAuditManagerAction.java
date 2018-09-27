//$Id: StudentAuditManager.java,v 1.20 2007/01/18 10:00:32 yd Exp $
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
 * @author pippo
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * pippo                2005-11-15          Created
 * zq                   2007-10-16          把secondSpecialityStudentList()方法
 *                                          的Results.addObject()改成addOldPage()。
 ********************************************************************************/

package com.shufe.web.action.graduate;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ekingstar.common.detail.Pagination;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.mvc.struts.misc.StrutsMessageResource;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.transfer.Transfer;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.transfer.exporter.PropertyExtractor;
import com.ekingstar.commons.transfer.importer.DefaultEntityImporter;
import com.ekingstar.commons.transfer.importer.EntityImporter;
import com.ekingstar.commons.transfer.importer.reader.CSVReader;
import com.ekingstar.commons.transfer.importer.reader.ExcelItemReader;
import com.ekingstar.commons.utils.transfer.ImporterForeignerListener;
import com.ekingstar.commons.utils.web.RequestUtils;
import com.ekingstar.commons.web.dispatch.Action;
import com.ekingstar.eams.std.graduation.audit.model.AuditResult;
import com.ekingstar.eams.std.graduation.audit.model.AuditStandard;
import com.ekingstar.eams.std.graduation.audit.model.OffsetCredit;
import com.ekingstar.eams.system.basecode.industry.MajorType;
import com.ekingstar.eams.system.basecode.industry.StudentState;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.baseinfo.Speciality;
import com.shufe.service.graduate.AuditStandardService;
import com.shufe.service.std.StudentService;
import com.shufe.service.std.graduation.audit.OffsetCreditImportListener;
import com.shufe.util.DataRealmUtils;
import com.shufe.web.OutputProcessObserver;
import com.shufe.web.action.common.StudentExporter;
import com.shufe.web.helper.StdSearchHelper;

/**
 * 毕业审核<br>
 * 1. 批量自动审核：<br>
 * 位置： StudentAuditOperation<br>
 * 2. 批量手动审核：<br>
 * 位置： StudentAuditOperation<br>
 * 3. 批量手动审核：<br>
 * 位置： StudentAuditOperation<br>
 * 4. 批量审核给定条件内的学生：<br>
 * 位置： this<br>
 * 
 * @author dell
 */
public class StudentAuditManagerAction extends StudentAuditSupportAction {

  protected AuditStandardService auditStandardService;

  protected StdSearchHelper stdSearchHelper;

  /**
   * @param auditStandardService
   *          要设置的 auditStandardService.
   */
  public void setAuditStandardService(AuditStandardService auditStandardService) {
    this.auditStandardService = auditStandardService;
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
    // 毕业状态：1、未毕业，2、肄业，3、结业，4、毕业
    Integer graduateStatus = getInteger(request, "graduateStatus");
    Long majorTypeId = RequestUtils.getLong(request, "majorTypeId");
    // 默认是第一专业
    if (null == majorTypeId) {
      majorTypeId = MajorType.FIRST;
    }
    if (null != graduateStatus) {
      switch (graduateStatus.intValue()) {
      case 1: {
        // 1、未毕业：没有毕业审核状态
        if (MajorType.FIRST.longValue() == majorTypeId.longValue()) {
          query.add(new Condition("std.graduateAuditStatus is null"));
        } else {
          query.add(new Condition("std.secondGraduateAuditStatus is null"));
        }
        break;
      }
      case 2: {
        // 2、肄业：有毕业审核状态，但未通过
        if (MajorType.FIRST.longValue() == majorTypeId.longValue()) {
          query.add(new Condition("std.graduateAuditStatus = false"));
        } else {
          query.add(new Condition("std.secondGraduateAuditStatus = false"));
        }
        break;
      }
      case 3: {
        // 3、结业：毕业审核状态为“通过”，但没有毕业证书编号
        if (MajorType.FIRST.longValue() == majorTypeId.longValue()) {
          query.add(new Condition("std.graduateAuditStatus = true"));
        } else {
          query.add(new Condition("std.secondGraduateAuditStatus = true"));
        }
        query.add(new Condition("std.degreeInfo.certificateNo is null"));
        break;
      }
      case 4: {
        // 4、毕业：毕业审核状态为“通过”，且有毕业证书编号
        if (MajorType.FIRST.longValue() == majorTypeId.longValue()) {
          query.add(new Condition("std.graduateAuditStatus = true"));
        } else {
          query.add(new Condition("std.secondGraduateAuditStatus = true"));
        }
        query.add(new Condition("std.degreeInfo.certificateNo is not null"));
        break;
      }
      }
    }

    addCollection(request, "studentList", utilService.search(query));
    return forward(request);
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

  /**
   * 4.批量审核给定条件内的学生
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   */
  public ActionForward batchAuditWithCondition(ActionMapping mapping, ActionForm form,
      HttpServletRequest request, HttpServletResponse response) throws Exception {
    String auditTerm = request.getParameter("auditTerm");
    StudentAuditProcessObserver observer = (StudentAuditProcessObserver) getOutputProcessObserver(mapping,
        request, response, StudentAuditProcessObserver.class);
    String departmentIds = getDepartmentIdSeq(request);
    String studentTypeIds = getStdTypeIdSeq(request);
    Long auditStandardId = getLong(request, "auditStandardId");

    String studenGraduateAuditStatus = request.getParameter("studentGraduateAuditStatus");
    Student student = populateStudent(request);
    /* long startTime = System.currentTimeMillis(); */
    Pagination stdPagination = studentService.searchStudent(student, 1, StudentAuditProcessObserver.pageSize,
        studentTypeIds, departmentIds, studenGraduateAuditStatus);
    MajorType majorType = new MajorType(MajorType.FIRST);
    if (StringUtils.isEmpty(auditTerm)) {
      observer.notifyStart("毕业审核", stdPagination.getItemCount());
      graduateAuditService.batchGraduateAudit(stdPagination.getItems(), majorType, auditStandardId, null,
          observer);
      int maxPageNo = stdPagination.getMaxPageNumber();
      for (int i = 2; i <= maxPageNo; i++) {
        stdPagination = studentService.searchStudent(student, i, StudentAuditProcessObserver.pageSize,
            studentTypeIds, departmentIds, studenGraduateAuditStatus);
        graduateAuditService.batchGraduateAudit(stdPagination.getItems(), majorType, auditStandardId, null,
            observer);
      }
    } else {
      observer.notifyStart("按学期审核培养计划" + graduateAuditService.getAuditTermList(auditTerm),
          stdPagination.getItemCount());
      graduateAuditService.batchGraduateAudit(stdPagination.getItems(), majorType, auditStandardId,
          auditTerm, observer);
      int maxPageNo = stdPagination.getMaxPageNumber();
      for (int i = 2; i <= maxPageNo; i++) {
        stdPagination = studentService.searchStudent(student, i, StudentAuditProcessObserver.pageSize,
            studentTypeIds, departmentIds, studenGraduateAuditStatus);
        graduateAuditService.batchGraduateAudit(stdPagination.getItems(), majorType, auditStandardId,
            auditTerm, observer);
      }
    }
    response.getWriter().flush();
    response.getWriter().close();
    return null;
  }

  /**
   * 2. 批量手动审核<br>
   * 3. 撤销通过选中学生
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward batchAudit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] stdId = SeqStringUtil.transformToLong(request.getParameter("stdIds"));
    studentService.batchUpdateGraduateAuditStatus(stdId, Boolean.valueOf(request.getParameter("status")));
    return redirect(request, new Action("exchangeStudentAuditManager", "search"), "info.action.success");
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

  protected Collection getExportDatas(HttpServletRequest request) {
    Long[] stdIds = SeqStringUtil.transformToLong(get(request, "stdIds"));
    if (null == stdIds || stdIds.length == 0) {
      EntityQuery stdQuery = buildQuery(request);
      stdQuery.setSelect("id");
      stdQuery.setLimit(null);
      Collection students = utilService.search(stdQuery);
      stdIds = (Long[]) students.toArray(new Long[0]);
    }
    EntityQuery query = new EntityQuery(AuditResult.class, "auditResult");
    query.add(new Condition("auditResult.std.id in (:stdIds)", stdIds));
    Collection list = utilService.search(query);
    return list;
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

  /**
   * 批量审核确认/取消确认
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward batchAuditAffirm(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] stdId = SeqStringUtil.transformToLong(request.getParameter("stdIds"));
    // 更新审核确认状态
    studentService.batchUpdateGraduateAuditStatus(stdId, Boolean.valueOf(request.getParameter("status")));
    return redirect(request, new Action("", "search"), "info.action.success");
  }

  /** 国外交流生的审核 */
  public ActionForward batchAutoAudit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] stdId = SeqStringUtil.transformToLong(get(request, "stdIds"));

    Long auditStandardId = getLong(request, "auditStandardId");
    /* 审核通过 */
    MajorType majorType = new MajorType(MajorType.FIRST);
    List parseStudent = null;
    try {
      parseStudent = graduateAuditService.batchAuditStudent(stdId, majorType, auditStandardId);
    } catch (Exception e) {
      e.printStackTrace();
      return this.forwardError(mapping, request, e.getMessage());
    }
    if (!CollectionUtils.isEmpty(parseStudent)) {
      studentService.batchUpdateGraduateAuditStatus(parseStudent, new Boolean(true));
    }

    /* 审核未通过 */
    List unParseStudent = new ArrayList();
    for (int i = 0; i < stdId.length; i++) {
      if (!parseStudent.contains(stdId[i])) unParseStudent.add(stdId[i]);
    }
    if (!CollectionUtils.isEmpty(unParseStudent)) {
      studentService.batchUpdateGraduateAuditStatus(unParseStudent, new Boolean(false));
    }
    return redirect(request, new Action("exchangeStudentAuditManager", "search"), "info.audit.complete");
  }

  /** 可冲抵学分维护 */
  public ActionForward actAsCredit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] stdId = SeqStringUtil.transformToLong(get(request, "stdIds"));
    Student std = (Student) utilService.get(Student.class, Long.valueOf(stdId[0]));
    EntityQuery entityQuery = new EntityQuery(OffsetCredit.class, "offsetCredit");
    entityQuery.add(new Condition("offsetCredit.std = :std", std));

    List<OffsetCredit> offsetCredits = (List) utilService.search(entityQuery);
    if (null != offsetCredits && !offsetCredits.isEmpty()) {
      request.setAttribute("offsetCredit", offsetCredits.get(0));
    }
    request.setAttribute("student", std);
    request.setAttribute("queryStr", this.get(request, "queryStr"));
    return forward(request);
  }

  /** 冲抵学分导入 */
  public ActionForward importData(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TransferResult tr = new TransferResult();
    Transfer transfer = buildEntityImporter(request, Student.class, tr);
    if (null == transfer) { return forward(request, "/pages/components/importData/error"); }
    transfer.addListener(new ImporterForeignerListener(utilService)).addListener(
        new OffsetCreditImportListener(utilService.getUtilDao()));
    transfer.transfer(tr);
    return forward(request, "/pages/components/importData/result");
  }

  public static EntityImporter buildEntityImporter(HttpServletRequest request, Class clazz, TransferResult tr) {
    try {
      ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());

      upload.setHeaderEncoding("utf-8");
      List items = upload.parseRequest(request);
      for (Iterator iter = items.iterator(); iter.hasNext();) {
        FileItem element = (FileItem) iter.next();
        if (!element.isFormField()) {
          String fileName = element.getName();
          if (!StringUtils.isEmpty(fileName)) {
            InputStream is = element.getInputStream();
            if (fileName.endsWith(".xls")) {
              HSSFWorkbook wb = new HSSFWorkbook(is);
              if ((wb.getNumberOfSheets() < 1) || (wb.getSheetAt(0).getLastRowNum() == 0)) { return null; }
              EntityImporter importer = new DefaultEntityImporter(clazz);

              importer.setReader(new ExcelItemReader(wb, 1));
              request.setAttribute("importer", importer);
              request.setAttribute("importResult", tr);
              return importer;
            }
            LineNumberReader reader = new LineNumberReader(new InputStreamReader(is));

            if (null == reader.readLine()) return null;
            reader.reset();
            EntityImporter importer = new DefaultEntityImporter(clazz);

            importer.setReader(new CSVReader(reader));
            return importer;
          }
        }
      }
      return null;
    } catch (Exception e) {
      tr.addFailure("error.parameters.illegal", e.getMessage());
    }
    return null;
  }

  // 冲抵学分的删除
  public ActionForward deleteItem(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] offsetCreditIds = SeqStringUtil.transformToLong(request.getParameter("chongDiCreditIds"));
    OffsetCredit credit = (OffsetCredit) utilService
        .get(OffsetCredit.class, Long.valueOf(offsetCreditIds[0]));
    String stdIds = String.valueOf(credit.getStd().getId());
    utilService.remove(OffsetCredit.class, "id", offsetCreditIds);
    request.setAttribute("stdIds", stdIds);
    return redirect(request, new Action("studentAuditManager", "search"), "info.action.success");
  }

  // 冲抵学分的保存
  public ActionForward saveCredit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long stdId = Long.parseLong(get(request, "offsetCredit.std.id"));
    Student std = (Student) utilService.get(Student.class, stdId);
    OffsetCredit offsetCredit = (OffsetCredit) populateEntity(request, OffsetCredit.class, "offsetCredit");
    offsetCredit.setStd(std);
    utilService.saveOrUpdate(offsetCredit);
    return redirect(request, new Action("studentAuditManager", "search"), "info.action.success");
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

  // protected PropertyExtractor getPropertyExtractor(HttpServletRequest request) {
  // StudentExporter exporter = new StudentExporter();
  // exporter.setLocale(getLocale(request));
  // exporter.setResources(getResources(request));
  // exporter.setBuddle(new StrutsMessageResource(exporter.getResources()));
  // return exporter;
  // }
}
