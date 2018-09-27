/**
 * 
 */
package com.shufe.web.action.std.exemption;

import java.util.Collection;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.eams.system.basecode.industry.ExemptionApplyType;
import com.shufe.model.std.Student;
import com.shufe.model.std.exemption.ApplySwitch;
import com.shufe.model.std.exemption.ExemptionResult;
import com.shufe.service.course.grade.gp.GradePointService;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;

/**
 * 推免申请（学生界面）
 * 
 * @author zhouqi
 */
public class ExemptionApplyAction extends CalendarRestrictionSupportAction {

  protected GradePointService gradePointService;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "applySwitches", utilService.loadAll(ApplySwitch.class));

    addCollection(request, "applyTypes", baseCodeService.getCodes(ExemptionApplyType.class));

    Student student = getStudentFromSession(request.getSession());
    EntityQuery query = new EntityQuery(ExemptionResult.class, "result");
    query.add(new Condition("result.student = :student", student));
    query.setLimit(getPageLimit(request));
    addCollection(request, "results", utilService.search(query));

    addSingleParameter(request, "currCalendar",
        teachCalendarService.getCurTeachCalendar(student.getStdType()));

    addSingleParameter(request, "openApplySwitch", getApplySwitchInOpen(null));
    return forward(request);
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long resultId = getLong(request, "resultId");

    ExemptionResult result = null;

    if (null != resultId) {
      result = (ExemptionResult) utilService.get(ExemptionResult.class, resultId);
      addSingleParameter(request, "eResult", result);
    }
    ApplySwitch applySwitch = getApplySwitchInOpen(result);
    if (null == applySwitch) { return redirect(request, "index", "exemption.noOpenedElective"); }
    Student student = getStudentFromSession(request.getSession());
    if (null == result && isExistResult(applySwitch, student)) { return redirect(request, "index",
        "error.data.exists"); }

    addSingleParameter(request, "student", student);
    addCollection(request, "applyTypes", baseCodeService.getCodes(ExemptionApplyType.class));
    addSingleParameter(request, "calendar", applySwitch.getCalendar());
    return forward(request);
  }

  @SuppressWarnings("unchecked")
  protected ApplySwitch getApplySwitchInOpen(ExemptionResult result) {
    EntityQuery query = new EntityQuery(ApplySwitch.class, "applySwitch");
    if (null != result && null != result.getId()) {
      query.add(new Condition("applySwitch.calendar = :calendar", result.getCalendar()));
    }
    query.add(new Condition("sysdate between applySwitch.fromAt and applySwitch.endAt"));
    Collection<ApplySwitch> applySwitches = utilService.search(query);
    if (CollectionUtils.isEmpty(applySwitches)) {
      return null;
    } else {
      return applySwitches.iterator().next();
    }
  }

  protected boolean isExistResult(ApplySwitch applySwitch, Student student) {
    EntityQuery query = new EntityQuery(ExemptionResult.class, "result");
    query.add(new Condition("result.calendar = :calendar", applySwitch.getCalendar()));
    query.add(new Condition("result.student = :student", student));
    return CollectionUtils.isNotEmpty(utilService.search(query));
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ExemptionResult result = (ExemptionResult) populateEntity(request, ExemptionResult.class, "eResult");
    if (null == getApplySwitchInOpen(result)) { return redirect(request, "index",
        "exemption.noOpenedElective"); }

    Date nowAt = new Date();
    if (null == result.getId()) {
      result.setCreateAt(nowAt);
    }
    result.setUpdateAt(nowAt);
    utilService.saveOrUpdate(result);
    return redirect(request, "index", "info.action.success");
  }

  public ActionForward report(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "applyResult",
        utilService.get(ExemptionResult.class, getLong(request, "resultId")));
    addCollection(request, "applyTypes", baseCodeService.getCodes(ExemptionApplyType.class));
    return forward(request);
  }

  public void setGradePointService(GradePointService gradePointService) {
    this.gradePointService = gradePointService;
  }
}
