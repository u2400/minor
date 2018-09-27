package com.ekingstar.eams.teach.abilityrate.web.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.ekingstar.eams.system.time.TeachCalendar;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateApplyConfig;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateSubject;
import com.ekingstar.eams.teach.abilityrate.model.InterviewInfo;
import com.ekingstar.eams.teach.abilityrate.service.CourseAbilityRateService;
import com.shufe.model.Constants;
import com.shufe.model.system.baseinfo.Classroom;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;

public class CourseAbilityApplyConfigAction extends CalendarRestrictionSupportAction {

  CourseAbilityRateService courseAbilityRateService;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setCalendarDataRealm(request, hasStdTypeCollege);
    TeachCalendar calendar = (TeachCalendar) request.getAttribute(Constants.CALENDAR);
    EntityQuery query = new EntityQuery(CourseAbilityRateApplyConfig.class, "config");
    query.add(new Condition("config.calendar=:calendar", calendar));
    @SuppressWarnings("unchecked")
    List<CourseAbilityRateApplyConfig> configs = (List<CourseAbilityRateApplyConfig>) utilService
        .search(query);
    request.setAttribute("configs", configs);
    Map<String, Map<String, Integer>> statMaps = new HashMap<String, Map<String, Integer>>();
    for (CourseAbilityRateApplyConfig config : configs) {
      statMaps.put(config.getId().toString(), courseAbilityRateService.stat(config));
    }
    request.setAttribute("statMaps", statMaps);
    return forward(request);
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    CourseAbilityRateApplyConfig config = (CourseAbilityRateApplyConfig) getEntity(request,
        CourseAbilityRateApplyConfig.class, "config");
    request.setAttribute("config", config);
    List abilities = utilService.loadAll(LanguageAbility.class);
    abilities.removeAll(config.getAbilities());
    request.setAttribute("abilities", abilities);
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    CourseAbilityRateApplyConfig config = (CourseAbilityRateApplyConfig) populateEntity(request,
        CourseAbilityRateApplyConfig.class, "config");
    config.getAbilities().clear();
    config.getAbilities().addAll(
        utilService.load(LanguageAbility.class, "id",
            SeqStringUtil.transformToLong(get(request, "abilityIds"))));
    utilService.saveOrUpdate(config);
    return redirect(request, "index", "info.save.success");
  }

  public ActionForward editInterview(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    InterviewInfo interview = (InterviewInfo) getEntity(request, InterviewInfo.class, "interview");
    request.setAttribute("interview", interview);
    EntityQuery query = new EntityQuery(Classroom.class, "room");
    query.add(new Condition("room.state=true and room.capacityOfCourse>0"));
    request.setAttribute("rooms", utilService.search(query));
    return forward(request);
  }

  public ActionForward saveInterview(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    InterviewInfo interview = (InterviewInfo) populateEntity(request, InterviewInfo.class, "interview");
    utilService.saveOrUpdate(interview);
    return redirect(request, "index", "info.save.success");
  }

  public ActionForward removeInterview(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    InterviewInfo interview = (InterviewInfo) getEntity(request, InterviewInfo.class, "interview");
    utilService.remove(interview);
    return redirect(request, "index", "info.save.success");
  }

  public ActionForward editSubject(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    CourseAbilityRateSubject subject = (CourseAbilityRateSubject) getEntity(request,
        CourseAbilityRateSubject.class, "subject");
    request.setAttribute("subject", subject);
    return forward(request);
  }

  public ActionForward saveSubject(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    CourseAbilityRateSubject subject = (CourseAbilityRateSubject) populateEntity(request,
        CourseAbilityRateSubject.class, "subject");
    utilService.saveOrUpdate(subject);
    return redirect(request, "index", "info.save.success");
  }

  public ActionForward removeSubject(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    CourseAbilityRateSubject subject = (CourseAbilityRateSubject) getEntity(request,
        CourseAbilityRateSubject.class, "subject");
    utilService.remove(subject);
    return redirect(request, "index", "info.save.success");
  }

  public void setCourseAbilityRateService(CourseAbilityRateService courseAbilityRateService) {
    this.courseAbilityRateService = courseAbilityRateService;
  }

}
