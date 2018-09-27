package com.shufe.web.action.course.grade.moral;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.transfer.exporter.PropertyExtractor;
import com.ekingstar.commons.utils.query.QueryRequestSupport;
import com.shufe.model.course.grade.MoralGrade;
import com.shufe.service.course.grade.moral.MoralGradePropertyExtractor;
import com.shufe.util.DataRealmUtils;

/**
 * 德育成绩管理抽象类
 * @author chaostone
 *
 */
public class AbstractMoralGradeAction extends MoralGradeCalendarSupportAction {

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = buildQuery(request);
    addCollection(request, "moralGrades", utilService.search(query));
    addSwitch(request);
    return forward(request);
  }

  @Override
  protected EntityQuery buildQuery(HttpServletRequest request) {
    EntityQuery query = new EntityQuery(MoralGrade.class, "moralGrade");
    QueryRequestSupport.populateConditions(request, query, "moralGrade.std.type.id");
    DataRealmUtils.addDataRealms(query, new String[] { "moralGrade.std.type.id",
        "moralGrade.std.department.id" },
        getDataRealmsWith(getLong(request, "moralGrade.std.type.id"), request));
    Long departId = getLong(request, "department.id");
    Long specialityId = getLong(request, "speciality.id");
    Long aspectId = getLong(request, "specialityAspect.id");
    if (null != aspectId) query.add(new Condition("moralGrade.std.firstAspect.id=:aspectId", aspectId));
    if (null != specialityId) {
      query.add(new Condition("moralGrade.std.firstMajor.id=:specialityId", specialityId));
    } else {
      if (null != departId) query.add(new Condition("moralGrade.std.department.id=:departId", departId));
    }
    String adminClassName = get(request, "adminClassName");
    if (StringUtils.isNotBlank(adminClassName)) {
      query.join("moralGrade.std.adminClasses", "adminClass");
      query.add(new Condition("adminClass.name like :adminClassName", "%" + adminClassName + "%"));
    }
    Float score1 = getFloat(request, "score1");
    if (null != score1) {
      query.add(new Condition("moralGrade.score>=:score1", score1));
    }
    Float score2 = getFloat(request, "score2");
    if (null != score2) {
      query.add(new Condition("moralGrade.score<=:score2", score2));
    }
    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(request.getParameter("orderBy")));
    return query;
  }

  protected PropertyExtractor getPropertyExtractor(HttpServletRequest request) {
    return new MoralGradePropertyExtractor(getLocale(request), getResources(request));
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    MoralGrade moralGrade = (MoralGrade) getEntity(request, MoralGrade.class, "moralGrade");
    request.setAttribute("moralGrade", moralGrade);
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    MoralGrade moralGrade = (MoralGrade) populateEntity(request, MoralGrade.class, "moralGrade");
    moralGrade.setUpdatedAt(getNowDate());
    utilService.saveOrUpdate(moralGrade);
    return redirect(request, "search", "info.save.success");
  }

}
