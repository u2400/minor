package com.ekingstar.eams.teach.abilityrate.web.action;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.mvc.struts.misc.StrutsMessageResource;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.Order;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.transfer.exporter.PropertyExtractor;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.ekingstar.eams.system.time.TeachCalendar;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateApply;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateApplyConfig;
import com.ekingstar.eams.teach.abilityrate.service.ApplyPropertyExtractor;
import com.ekingstar.eams.teach.abilityrate.service.CourseAbilityRateService;
import com.shufe.model.Constants;
import com.shufe.model.std.Student;
import com.shufe.web.action.common.CalendarRestrictionExampleTemplateAction;

/**
 * 英语升降级申请管理
 * 
 * @author chaostone
 */
public class CourseAbilityApplyManageAction extends CalendarRestrictionExampleTemplateAction {

  CourseAbilityRateService courseAbilityRateService;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setCalendarDataRealm(request, hasStdTypeCollege);
    request.setAttribute("abilities", utilService.loadAll(LanguageAbility.class));
    TeachCalendar calendar = (TeachCalendar) request.getAttribute(Constants.CALENDAR);
    EntityQuery query = new EntityQuery(CourseAbilityRateApplyConfig.class, "config");
    query.add(new Condition("config.calendar=:calendar", calendar));
    @SuppressWarnings("unchecked")
    List<CourseAbilityRateApplyConfig> configs = (List<CourseAbilityRateApplyConfig>) utilService
        .search(query);
    if (configs.isEmpty()) {
      request.setAttribute("config", configs.get(0));
    }
    return forward(request);
  }

  @Override
  protected EntityQuery buildQuery(HttpServletRequest request) {
    EntityQuery query = new EntityQuery(CourseAbilityRateApply.class, "apply");
    populateConditions(request, query);
    Boolean isUpgrade = getBoolean(request, "isUpgrade");
    if (null == isUpgrade) isUpgrade = Boolean.TRUE;
    if (isUpgrade) {
      query.add(new Condition("apply.applyAbility.level>apply.originAbility.level"));
    } else {
      query.add(new Condition("apply.applyAbility.level<apply.originAbility.level"));
    }
    Integer scoreBegin = getInteger(request, "score_begin");
    Integer scoreEnd = getInteger(request, "score_end");
    Long subjectId = getLong(request, "subjectId");
    if (null != subjectId && (null != scoreBegin || null != scoreEnd)) {
      query.join("apply.grades", "g");
      query.add(new Condition("g.subject.id=:subjectId", subjectId));
      if (null != scoreBegin) query.add(new Condition("g.score>=", scoreBegin));
      if (null != scoreEnd) query.add(new Condition("g.score<=", scoreEnd));
    }
    String orderBy = get(request, Order.ORDER_STR);
    if (StringUtils.isNotBlank(orderBy)) query.addOrder(OrderUtils.parser(orderBy));
    return query;
  }

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = buildQuery(request);
    query.setLimit(getPageLimit(request));
    addCollection(request, "applies", utilService.search(query));
    return forward(request);
  }

  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    CourseAbilityRateApply apply = (CourseAbilityRateApply) getEntity(request, CourseAbilityRateApply.class,
        "apply");
    request.setAttribute("apply", apply);
    return forward(request);
  }

  public ActionForward approve(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Collection<CourseAbilityRateApply> applies = utilService.load(CourseAbilityRateApply.class, "id",
        SeqStringUtil.transformToLong(get(request, "applyIds")));
    for (CourseAbilityRateApply apply : applies) {
      apply.getStd().setLanguageAbility(apply.getApplyAbility());
      apply.setPassed(true);
      utilService.saveOrUpdate(apply.getStd());
      utilService.saveOrUpdate(apply);
    }
    return redirect(request, "search", "info.action.success");
  }

  public ActionForward withdraw(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Collection<CourseAbilityRateApply> applies = utilService.load(CourseAbilityRateApply.class, "id",
        SeqStringUtil.transformToLong(get(request, "applyIds")));
    for (CourseAbilityRateApply apply : applies) {
      apply.getStd().setLanguageAbility(apply.getOriginAbility());
      apply.setPassed(false);
      utilService.saveOrUpdate(apply.getStd());
      utilService.saveOrUpdate(apply);
    }
    return redirect(request, "search", "info.action.success");
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    CourseAbilityRateApply apply = (CourseAbilityRateApply) getEntity(request, CourseAbilityRateApply.class,
        "apply");
    request.setAttribute("apply", apply);
    request.setAttribute("statMap", courseAbilityRateService.stat(apply.getConfig()));
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    CourseAbilityRateApply apply = (CourseAbilityRateApply) populateEntity(request,
        CourseAbilityRateApply.class, "apply");
    utilService.saveOrUpdate(apply);
    return redirect(request, "search", "info.save.success");
  }

  protected PropertyExtractor getPropertyExtractor(HttpServletRequest request) {
    return new ApplyPropertyExtractor(getLocale(request), new StrutsMessageResource(getResources(request)));
  }

  public void setCourseAbilityRateService(CourseAbilityRateService courseAbilityRateService) {
    this.courseAbilityRateService = courseAbilityRateService;
  }

}
