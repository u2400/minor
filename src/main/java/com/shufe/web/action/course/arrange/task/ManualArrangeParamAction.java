package com.shufe.web.action.course.arrange.task;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.shufe.model.course.arrange.task.ManualArrangeParam;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.service.course.arrange.task.ManualArrangeParamService;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;

public class ManualArrangeParamAction extends CalendarRestrictionSupportAction {

  protected ManualArrangeParamService manualArrangeParamService;

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long calendarId = getLong(request, "manualArrangeParam.calendar.id");
    if (null == calendarId) {
      calendarId = getLong(request, "calendarId");
    }
    addCollection(request, "manualArrangeParamList",
        manualArrangeParamService.getManualArrangeParam(calendarId));
    return forward(request);
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(Department.class, "department");
    query.add(new Condition("department in (:departments)", getDeparts(request)));

    Long paramsId = getLong(request, "paramsId");
    if (null == paramsId) {
      query
          .add(new Condition(
              "not exists (from ManualArrangeParam param where param.department = department and param.calendar.id = :calendarId)",
              getLong(request, "calenarId")));
    } else {
      query
          .add(new Condition(
              "not exists (from ManualArrangeParam param where param.department = department and param.calendar.id = :calendarId and param.id != :paramsId)",
              getLong(request, "calenarId"), paramsId));
      request.setAttribute("manualArrangeParam", utilService.load(ManualArrangeParam.class, paramsId));
    }

    addCollection(request, "departments", utilService.search(query));
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ManualArrangeParam param = (ManualArrangeParam) populateEntity(request, ManualArrangeParam.class,
        "manualArrangeParam");
    EntityQuery query = new EntityQuery(ManualArrangeParam.class, "manualArrangeParam");
    query.add(new Condition("manualArrangeParam.calendar = :calendar", param.getCalendar()));
    if (null == param.getDepartment()) {
      query.add(new Condition("manualArrangeParam.department is null"));
    } else {
      query.add(new Condition("manualArrangeParam.department = :deparment", param.getDepartment()));
    }
    if (null != param.getId()) {
      query.add(new Condition("manualArrangeParam != :param", param));
    }
    if (CollectionUtils.isNotEmpty(utilService.search(query))) { return redirect(request, "search",
        "info.save.failure.overlapAcross"); }

    manualArrangeParamService.saveManualArrangeParam(param);
    return redirect(request, "search", "info.save.success");
  }

  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] paramsIds = SeqStringUtil.transformToLong(get(request, "paramsIds"));
    if (ArrayUtils.isEmpty(paramsIds)) { return redirect(request, "search", "error.electParams.id.needed"); }
    utilService.remove(utilService.load(ManualArrangeParam.class, "id", paramsIds));
    return redirect(request, "search", "info.delete.success");
  }

  public void setManualArrangeParamService(ManualArrangeParamService manualArrangeParamService) {
    this.manualArrangeParamService = manualArrangeParamService;
  }

}
