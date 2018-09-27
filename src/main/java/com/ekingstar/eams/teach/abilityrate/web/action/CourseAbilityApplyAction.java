package com.ekingstar.eams.teach.abilityrate.web.action;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityGrade;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateApply;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateApplyConfig;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateSubject;
import com.ekingstar.eams.teach.abilityrate.model.InterviewInfo;
import com.ekingstar.eams.teach.abilityrate.service.AbilityScoreProvider;
import com.ekingstar.eams.teach.abilityrate.service.AbilitySignupChecker;
import com.ekingstar.eams.teach.abilityrate.service.CourseAbilityRateService;
import com.shufe.model.std.Student;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;

public class CourseAbilityApplyAction extends CalendarRestrictionSupportAction {

  AbilityScoreProvider provider;
  AbilitySignupChecker checker;
  CourseAbilityRateService courseAbilityRateService;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    // 已经申请的信息
    EntityQuery applyQuery = new EntityQuery(CourseAbilityRateApply.class, "apply");
    applyQuery.add(new Condition("apply.std=:std", getStudentFromSession(request.getSession())));
    request.setAttribute("applies", utilService.search(applyQuery));

    EntityQuery query = new EntityQuery(CourseAbilityRateApplyConfig.class, "config");
    query.add(new Condition("config.endAt>=:now", new Date()));
    request.setAttribute("configs", utilService.search(query));
    return forward(request);
  }

  @SuppressWarnings("unchecked")
  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long configId = getLong(request, "config.id");
    CourseAbilityRateApplyConfig config = (CourseAbilityRateApplyConfig) utilService.get(
        CourseAbilityRateApplyConfig.class, configId);
    if (!config.isTimeSuitable()) return redirect(request, "index", "courseAbility.error.timeSuitable");
    // 已经申请的信息
    EntityQuery applyQuery = new EntityQuery(CourseAbilityRateApply.class, "apply");
    applyQuery.add(new Condition("apply.std=:std", getStudentFromSession(request.getSession())));
    applyQuery.add(new Condition("apply.config=:config", config));
    Collection<CourseAbilityRateApply> applies = utilService.search(applyQuery);
    List<CourseAbilityRateApply> removed = new ArrayList<CourseAbilityRateApply>();
    for (CourseAbilityRateApply a : applies) {
      if (!a.isPassed()) removed.add(a);
    }

    if (removed.isEmpty()) {
      return redirect(request, "index", "info.remove.failure");
    } else {
      utilService.remove(removed);
      return redirect(request, "index", "info.remove.success");
    }

  }

  public ActionForward signupForm(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long configId = getLong(request, "config.id");
    CourseAbilityRateApplyConfig config = (CourseAbilityRateApplyConfig) utilService.get(
        CourseAbilityRateApplyConfig.class, configId);
    Student std = getStudentFromSession(request.getSession());
    boolean isUpgrade = getBoolean(request, "isUpgrade");
    String msg = checker.check(config, std, isUpgrade);
    if (StringUtils.isEmpty(msg)) {
      EntityQuery applyQuery = new EntityQuery(CourseAbilityRateApply.class, "apply");
      applyQuery.add(new Condition("apply.std=:std", getStudentFromSession(request.getSession())));
      applyQuery.add(new Condition("apply.config=:config", config));
      Collection<CourseAbilityRateApply> applies = utilService.search(applyQuery);
      CourseAbilityRateApply apply = null;
      if (applies.isEmpty()) {
        apply = buildApply(std, config, isUpgrade);
      } else {
        apply = applies.iterator().next();
      }
      request.setAttribute("apply", apply);
      request.setAttribute("config", config);
      request.setAttribute("statMap", courseAbilityRateService.stat(config));
      return forward(request);
    } else {
      return redirect(request, "index", msg);
    }
  }

  private CourseAbilityRateApply buildApply(Student std, CourseAbilityRateApplyConfig config,
      boolean isUpgrade) {
    CourseAbilityRateApply apply = new CourseAbilityRateApply();
    apply.setConfig(config);
    apply.setCalendar(config.getCalendar());
    apply.setStd(std);
    apply.setCreatedAt(new Date());
    apply.setUpdatedAt(new Date());
    apply.setOriginAbility(std.getLanguageAbility());

    LanguageAbility applyAbility = null;
    for (LanguageAbility one : config.getAbilities()) {
      if (isUpgrade) {
        if (one.getLevel() - std.getLanguageAbility().getLevel() == 1) {
          applyAbility = one;
          break;
        }
      } else {
        if (one.getLevel() - std.getLanguageAbility().getLevel() == -1) {
          applyAbility = one;
          break;
        }
      }
    }
    apply.setApplyAbility(applyAbility);
    return apply;
  }

  public ActionForward signup(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long configId = getLong(request, "apply.config.id");
    CourseAbilityRateApplyConfig config = (CourseAbilityRateApplyConfig) utilService.get(
        CourseAbilityRateApplyConfig.class, configId);

    EntityQuery applyQuery = new EntityQuery(CourseAbilityRateApply.class, "apply");
    applyQuery.add(new Condition("apply.std=:std", getStudentFromSession(request.getSession())));
    applyQuery.add(new Condition("apply.config=:config", config));
    Collection<CourseAbilityRateApply> applies = utilService.search(applyQuery);
    CourseAbilityRateApply apply = null;
    Boolean isUpgrade = getBoolean(request, "isUpgrade");
    Student std = getStudentFromSession(request.getSession());
    if (applies.isEmpty()) {
      apply = buildApply(std, config, isUpgrade);
    } else {
      apply = applies.iterator().next();
    }
    apply.setUpdatedAt(new Date());
    Long interviewId = getLong(request, "apply.interview.id");
    InterviewInfo interview = null;
    if (null != interviewId) interview = (InterviewInfo) utilService.get(InterviewInfo.class, interviewId);

    boolean interviewChanged = (null == apply.getInterview() || null == interview || !apply.getInterview()
        .getId().equals(interview.getId()));

    apply.setInterview(interview);
    apply.setMobilephone(get(request, "apply.mobilephone"));
    apply.setAddress(get(request, "apply.address"));

    apply.getGrades().clear();
    for (CourseAbilityRateSubject subject : config.getSubjects()) {
      Float score = provider.getScore(subject, std);
      CourseAbilityGrade grade = new CourseAbilityGrade(apply, subject, score);
      apply.getGrades().add(grade);
    }

    boolean success = true;
    if (isUpgrade && null != interview) {
      if (interviewChanged) {
        int exists = utilService.count(CourseAbilityRateApply.class, "interview", apply.getInterview());
        if (interview.getMaxviewer() <= exists) success = false;
      }
    }
    if (success) utilService.saveOrUpdate(apply);
    return redirect(request, "index", success ? "info.save.success" : "info.save.failure");
  }

  public void setProvider(AbilityScoreProvider provider) {
    this.provider = provider;
  }

  public void setChecker(AbilitySignupChecker checker) {
    this.checker = checker;
  }

  public void setCourseAbilityRateService(CourseAbilityRateService courseAbilityRateService) {
    this.courseAbilityRateService = courseAbilityRateService;
  }

}
