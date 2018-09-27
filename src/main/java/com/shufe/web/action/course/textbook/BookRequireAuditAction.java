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
 * Name                 Date                Description 
 * ============         ============        ============
 * chaostone             2006-11-5            Created
 *  
 ********************************************************************************/

package com.shufe.web.action.course.textbook;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.mvc.struts.misc.ImporterServletSupport;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.transfer.Transfer;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.utils.query.QueryRequestSupport;
import com.ekingstar.eams.system.basecode.industry.TextbookAwardLevel;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.course.textbook.BookRequirement;
import com.shufe.model.course.textbook.Textbook;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.service.course.textbook.BookRequirementService;
import com.shufe.service.course.textbook.impl.CourseTextbookImportListener;

/**
 * 教材需求审核
 * 
 * @author chaostone
 */
public class BookRequireAuditAction extends RequirementSearchAction {

  private BookRequirementService bookRequirementService;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setCalendarDataRealm(request, hasStdTypeCollege);
    addCollection(request, "teachDeparts", getColleges(request));
    addCollection(request, "awardLevels", baseCodeService.getCodes(TextbookAwardLevel.class));
    return forward(request);
  }

  /**
   * 查找教材需求登记
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery entityQuery = buildRequireQuery(request);
    addCollection(request, "requires", utilService.search(entityQuery));
    return forward(request);
  }

  public ActionForward courseTextbookIndex(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    return forward(request);
  }

  public ActionForward courseTextbookList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery entityQuery = new EntityQuery(Course.class, "course");
    QueryRequestSupport.populateConditions(request, entityQuery);
    entityQuery.setLimit(getPageLimit(request));
    entityQuery.add(new Condition("size(course.textbooks)>0"));
    String textbookName = get(request, "textbook.name");
    if (StringUtils.isNotBlank(textbookName)) {
      entityQuery.add(new Condition("exists( from course.textbooks t where t.name like :textbookName)",
          "%" + textbookName + "%"));
    }
    this.addCollection(request, "courses", utilService.search(entityQuery));
    return forward(request);
  }

  public ActionForward initByCourse(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(TeachTask.class, "task");
    Long calendarId = getLong(request, "require.task.calendar.id");
    query.add(new Condition("task.calendar.id=:calendarId", calendarId));
    query.add(new Condition(" not exists (from BookRequirement as require where require.task=task)"));
    query.add(new Condition(" size(task.course.textbooks)>0"));
    List rs = new ArrayList();
    for (TeachTask task : (List<TeachTask>) utilService.search(query)) {
      for (Textbook textbook : ((com.shufe.model.system.baseinfo.Course) task.getCourse()).getTextbooks()) {
        BookRequirement requirement = new BookRequirement();
        requirement.setTask(task);
        requirement.setTextbook(textbook);
        requirement.setCountForStd(task.getTeachClass().getStdCount());
        requirement.setChecked(false);
        requirement.setCountForTeacher(0);
        rs.add(requirement);
      }
    }
    utilService.saveOrUpdate(rs);
    return redirect(request, "search", "info.action.success", "&calendar.studentType.id="
        + get(request, "calendar.studentType.id") + "&require.task.calendar.id=" + calendarId);
  }

  public ActionForward importData(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TransferResult tr = new TransferResult();
    Transfer transfer = ImporterServletSupport.buildEntityImporter(request, Textbook.class, tr);
    if (null == transfer) { return forward(request, "/pages/components/importData/error"); }
    transfer.addListener(new CourseTextbookImportListener(utilService));
    transfer.transfer(tr);
    if (tr.hasErrors()) {
      return forward(request, "/pages/components/importData/error");
    } else {
      return redirect(request, "courseTextbookList", "info.import.success");
    }
  }

  public ActionForward setPass(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String ids = request.getParameter("requireIds");
    Boolean pass = getBoolean(request, "pass");
    if (null != pass) {
      Long[] passids = SeqStringUtil.transformToLong(ids);
      for (int x = 0; x < passids.length; x++) {
        BookRequirement requirement = bookRequirementService.getBookRequirement(passids[x]);
        requirement.setChecked(pass);
        utilService.saveOrUpdate(requirement);
      }
    }
    return redirect(request, "search", "info.update.success");
  }

  public void setBookRequirementService(BookRequirementService bookRequirementService) {
    this.bookRequirementService = bookRequirementService;
  }

}
