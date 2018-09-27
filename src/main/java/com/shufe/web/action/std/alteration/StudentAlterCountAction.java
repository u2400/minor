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
 * yang                 2005-11-09          Created
 * zq					2007-09-27			修改了保存方法－增加了修改前和修改后的
 * 											记录
 ********************************************************************************/

package com.shufe.web.action.std.alteration;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.model.Entity;
import com.ekingstar.commons.model.predicate.ValidEntityPredicate;
import com.ekingstar.commons.mvc.struts.misc.ImporterServletSupport;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.Order;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.query.limit.Page;
import com.ekingstar.commons.transfer.Transfer;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.utils.query.QueryRequestSupport;
import com.ekingstar.commons.utils.transfer.ImporterForeignerListener;
import com.ekingstar.commons.utils.web.RequestUtils;
import com.ekingstar.commons.web.dispatch.Action;
import com.ekingstar.eams.system.basecode.industry.AlterMode;
import com.ekingstar.eams.system.basecode.industry.AlterReason;
import com.ekingstar.eams.system.basecode.industry.StudentState;
import com.ekingstar.eams.system.baseinfo.StudentType;
import com.ekingstar.security.model.User;
import com.shufe.model.Constants;
import com.shufe.model.course.arrange.task.CourseTake;
import com.shufe.model.course.grade.CourseGrade;
import com.shufe.model.course.grade.other.OtherGrade;
import com.shufe.model.std.Student;
import com.shufe.model.std.alteration.StdStatus;
import com.shufe.model.std.alteration.StudentAlteration;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.course.arrange.task.CourseTakeService;
import com.shufe.service.course.grade.other.OtherGradeImportListener;
import com.shufe.service.std.StudentService;
import com.shufe.service.system.calendar.TeachCalendarService;
import com.shufe.util.DataRealmUtils;
import com.shufe.web.helper.StudentAlterationImportListerner;

/**
 * 学籍变动管理界面
 * 
 * @author chaostone
 */
public class StudentAlterCountAction extends StudentAlterationSearchAction {

  protected StudentService studentService;

  protected TeachCalendarService teachCalendarService;

  protected CourseTakeService courseTakeService;

  protected void indexSetting(HttpServletRequest request) throws Exception {
    EntityQuery query = new EntityQuery(TeachCalendar.class, "calendar");
    query.setSelect("calendar.year");
    query.add(new Condition("calendar.scheme.id=:schemeId", 1L));
    query.groupBy("calendar.year");
    query.addOrder(new Order("calendar.year desc"));
    query.setLimit(getPageLimit(request));
    addCollection(request, "calendars", utilService.search(query));
    addCollection(request, "modes", baseCodeService.getCodes(AlterMode.class));
    initBaseCodes("studentStateList", StudentState.class);
  }

  protected EntityQuery buildQuery(HttpServletRequest request) {
    EntityQuery query = new EntityQuery(StudentAlteration.class, getEntityName());
    populateConditions(request, query);
    query.getConditions().addAll(
        QueryRequestSupport.extractConditions(request, Student.class, "std", "std.type.id"));
    Long stdTypeId = getLong(request, "std.type.id");
    DataRealmUtils.addDataRealms(query, new String[] { "alteration.std.type.id",
        "alteration.std.department.id" }, getDataRealmsWith(stdTypeId, request));
    Long alterYearId = RequestUtils.getLong(request, "alterYearId");
    TeachCalendar calendar = null;
    String year = get(request, "alterYearId");
    String term = get(request, "alterTerm");
    if (StringUtils.isNotEmpty(year)) {
      EntityQuery query1 = new EntityQuery(TeachCalendar.class, "c");
      query1.add(new Condition("c.year=:year", year));
      query1.add(new Condition("c.term=:term", term));
      List<TeachCalendar> tc = (List) utilService.search(query1);
      if (tc.size() > 0) {
        calendar = tc.get(0);
      }
    }
    if (calendar != null) {
      query.add(new Condition("alteration.alterBeginOn >= (:fromDate)", calendar.getStart()));
      query.add(new Condition("alteration.alterBeginOn <= (:toDate)", calendar.getFinish()));
    }
    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(request.getParameter("orderBy")));
    return query;
  }

  protected void editSetting(HttpServletRequest request, Entity entity) throws Exception {
    if (entity.isVO()) {
      String stdNo = get(request, "stdNo");
      Student std = studentService.getStudent(stdNo);
      if (null != std) {
        StudentAlteration alteration = (StudentAlteration) entity;
        StdStatus afterStatus = new StdStatus();
        alteration.setStd(std);
        afterStatus.setEnrollYear(std.getEnrollYear());
        afterStatus.setStdType(std.getStdType());
        afterStatus.setDepartment(std.getDepartment());
        afterStatus.setSpeciality(std.getFirstMajor());
        afterStatus.setAspect(std.getFirstAspect());
        afterStatus.setGraduateOn(std.getGraduateOn());
        afterStatus.setState(std.getState());
        afterStatus.setAdminClass(std.getFirstMajorClass());
        alteration.setAfterStatus(afterStatus);
        request.setAttribute("alteration", alteration);
      }
    }
    addCollection(request, "modes", baseCodeService.getCodes(AlterMode.class));
    addCollection(request, "reasons", baseCodeService.getCodes(AlterReason.class));
    addCollection(request, "statuses", baseCodeService.getCodes(StudentState.class));
    setDataRealm(request, hasStdTypeCollege);
  }

  public ActionForward searchStuNo(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    return forward(request);
  }

  /**
   * 学生学籍变得的其它处理：成绩、选课信息
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward processOthers(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    StudentAlteration alteration = (StudentAlteration) utilService.load(StudentAlteration.class,
        getLong(request, "alterationId"));

    TeachCalendar calendar = teachCalendarService.getTeachCalendar(alteration.getAlterBeginOn());
    if (null == calendar) { return forward(mapping, request, "error.calendar.onTime.notExists", "error"); }
    // 获得学生的成绩，内容是发生变动学期和下学期
    EntityQuery query1 = new EntityQuery(CourseGrade.class, "grade");
    Set calendars = new HashSet();
    calendars.add(calendar);
    if (null != calendar.getNext()) {
      calendars.add(calendar.getNext());
    }
    query1.add(new Condition("grade.calendar in (:calendars)", calendars));
    query1.add(new Condition("grade.std = :student", alteration.getStd()));
    query1.addOrder(OrderUtils.parser("grade.calendar.year,grade.calendar.term"));
    addCollection(request, "courseGrades", utilService.search(query1));
    query1.groupBy("grade.calendar.id");
    String selectHQL = "grade.calendar.id,count(*)";
    query1.getOrders().clear();
    query1.setSelect(selectHQL);
    Collection gradeCalendars = utilService.search(query1);
    Map calendarGradeMap = new HashMap();
    for (Iterator it = gradeCalendars.iterator(); it.hasNext();) {
      Object[] obj = (Object[]) it.next();
      calendarGradeMap.put(obj[0].toString(), obj[1]);
    }
    addSingleParameter(request, "calendarGradeMap", calendarGradeMap);

    // 获得学生的选课记录，内容同上
    EntityQuery query2 = new EntityQuery(CourseTake.class, "take");
    query2.add(new Condition("take.task.calendar in (:calendars)", calendars));
    query2.add(new Condition("take.student = :student", alteration.getStd()));
    query2.addOrder(OrderUtils.parser("take.task.calendar.year,take.task.calendar.term"));
    addCollection(request, "courseTakes", utilService.search(query2));
    query2.groupBy("take.task.calendar.id");
    query2.getOrders().clear();
    selectHQL = "take.task.calendar.id,count(*)";
    query2.setSelect(selectHQL);
    Collection takeCalendars = utilService.search(query2);
    Map calendarTakeMap = new HashMap();
    for (Iterator it = takeCalendars.iterator(); it.hasNext();) {
      Object[] obj = (Object[]) it.next();
      calendarTakeMap.put(obj[0].toString(), obj[1]);
    }
    addSingleParameter(request, "calendarTakeMap", calendarTakeMap);

    addSingleParameter(request, "alteration", alteration);
    addCollection(request, "calendars", calendars);
    return forward(request);
  }

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    try {
      EntityQuery query = buildQuery(request);
      query.setLimit(null);
      query.getOrders().clear();
      List groupBy = new ArrayList();
      groupBy.add("alteration.mode.id");
      query.setGroups(groupBy);
      query.setSelect("alteration.mode.id, count(*)");

      List statResult = (List) utilService.search(query);
      List results = new ArrayList();
      for (Iterator it = statResult.iterator(); it.hasNext();) {
        Object[] obj = (Object[]) it.next();
        obj[0] = utilService.load(AlterMode.class, new Long(String.valueOf(obj[0])));
        results.add(obj);
      }

      addCollection(request, "results", results);
      return forward(request);
    } catch (Exception e) {
      addCollection(request, entityName + "s", Page.EMPTY_PAGE);
      return forward(request);
    }
  }

  public ActionForward removeRelation(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String courseGradeSeq = get(request, "courseGradeIds");
    String courseTakeSeq = get(request, "courseTakeIds");
    Collection courseGrades = null;
    if (StringUtils.isNotEmpty(courseGradeSeq)) {
      Long[] courseGradeIds = SeqStringUtil.transformToLong(courseGradeSeq);
      courseGrades = utilService.load(CourseGrade.class, "id", courseGradeIds);
    }
    Collection courseTakes = null;
    if (StringUtils.isNotEmpty(courseTakeSeq)) {
      Long[] courseTakeIds = SeqStringUtil.transformToLong(courseTakeSeq);
      courseTakes = utilService.load(CourseTake.class, "id", courseTakeIds);
    }
    Student student = (Student) utilService.load(Student.class, getLong(request, "stdId"));

    if (null != courseGrades) {
      utilService.remove(courseGrades);
    }
    // 发送退消息
    if (null != courseTakes) {
      User sender = (User) utilService.load(User.class, "name", student.getCode()).iterator().next();
      courseTakeService.sendWithdrawMessage((List) courseTakes, sender);
      courseTakeService.withdraw((List) courseTakes, sender);
    }

    return redirect(request, "search", "info.action.success");
  }

  protected ActionForward saveAndForwad(HttpServletRequest request, Entity entity) throws Exception {
    StudentAlteration alteration = (StudentAlteration) entity;
    StdStatus stdStatus = (StdStatus) populateEntity(request, StdStatus.class, "alteration.afterStatus");
    alteration.setAfterStatus(stdStatus);
    if (null != alteration.getStd().getStudentStatusInfo()) {
      request.setAttribute("std_outof_shool", new Boolean(!alteration.getStd().isInSchool()));
    }
    if (!ValidEntityPredicate.INSTANCE.evaluate(alteration.getStd())) { return forward(request, new Action(
        "", "search"), "error.std.notExists"); }
    Student std = (Student) utilService.load(Student.class, alteration.getStd().getId());
    alteration.setStd(std);
    if (alteration.getId() == null || alteration.getBeforeStatus() == null) {
      alteration.beforeStatusSetting();
    }
    alteration.setAlterBy(getUser(request.getSession()));

    List toBeSaved = new ArrayList();
    // 新增或修改并设置为应用时，修改
    Boolean isApply = getBoolean(request, "isApply");
    if (isApply != null && Boolean.TRUE.equals(isApply)) {
      // 学生状态改变
      alteration.apply();
      AdminClass adminClassBefore = std.getFirstMajorClass();
      if (null != adminClassBefore) {
        adminClassBefore.getStudents().remove(std);
      }
      // 改变班级
      if (null != stdStatus.getAdminClass()) {
        AdminClass adminClassAfter = (AdminClass) utilService.load(AdminClass.class, stdStatus
            .getAdminClass().getId());
        adminClassAfter.getStudents().add(std);
        std.getAdminClasses().add(adminClassAfter);
      } else {
        std.getAdminClasses().add(null);
      }
    }

    // 获取并填写“流水号”
    if (null == alteration.getId()) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
      EntityQuery query = new EntityQuery(StudentAlteration.class, "alteration");
      query.add(new Condition("to_char(alteration.alterBeginOn, 'yyyy') = :alterBeginOn", sdf
          .format(alteration.getAlterBeginOn())));
      query.add(new Condition("alteration.mode = :mode", alteration.getMode()));
      query.setSelect("max(alteration.seqNo)");
      Collection results = utilService.search(query);
      String seqNo = sdf.format(alteration.getAlterBeginOn());
      if (null == results.iterator().next()) {
        seqNo += "0001";
      } else {
        String previousSeqNo = results.iterator().next().toString();
        seqNo = StringUtils.left(previousSeqNo, 4) + alteration.getMode().getCode()
            + StringUtils.leftPad((Integer.parseInt(StringUtils.right(previousSeqNo, 4)) + 1) + "", 4, "0");
      }
      alteration.setSeqNo(seqNo);
    }

    toBeSaved.add(alteration);
    utilService.saveOrUpdate(toBeSaved);

    return redirect(request, "search", "info.action.success");
  }

  /**
   * 打印报表
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward report(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(StudentAlteration.class, "alteration");
    query.add(new Condition("alteration.id in (:alterationIds)", SeqStringUtil.transformToLong(get(request,
        "alterationIds"))));
    query.addOrder(OrderUtils.parser(get(request, "orderBy")));
    addCollection(request, "alterations", utilService.search(query));
    addSingleParameter(request, "thisObj", this);
    return forward(request);
  }

  /**
   * 根据学生类别和时间段，计算有几个学期（给页面调用）
   * 
   * @param stdType
   * @param fromDate
   * @param toDate
   * @return
   */
  public int getSemesterCount(StudentType stdType, Date fromDate, Date toDate) {
    int count = 0;
    if (null != stdType && null != fromDate && null != toDate) {
      EntityQuery query = new EntityQuery(TeachCalendar.class, "calendar");
      query.add(new Condition("calendar.studentType = :stdType", stdType));
      query.add(new Condition(":fromDate <= calendar.finish", fromDate));
      query.add(new Condition(":toDate >= calendar.start", toDate));
      count = CollectionUtils.size(utilService.search(query));
    }
    return count;
  }

  public ActionForward importData(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TransferResult tr = new TransferResult();
    Transfer transfer = ImporterServletSupport.buildEntityImporter(request, StudentAlteration.class, tr);
    if (null == transfer) { return forward(request, "/pages/components/importData/error"); }
    transfer.addListener(new ImporterForeignerListener(utilService)).addListener(
        new StudentAlterationImportListerner(utilService));
    transfer.transfer(tr);
    if (tr.hasErrors()) {
      return forward(request, "/pages/components/importData/error");
    } else {
      return redirect(request, "search", "info.import.success");
    }
  }

  public void setTeachCalendarService(TeachCalendarService teachCalendarService) {
    this.teachCalendarService = teachCalendarService;
  }

  public void setStudentService(StudentService studentService) {
    this.studentService = studentService;
  }

  public void setCourseTakeService(CourseTakeService courseTakeService) {
    this.courseTakeService = courseTakeService;
  }
}
