/**
 * 
 */
package com.shufe.web.action.std.exemption;

import java.util.Collection;

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
import com.ekingstar.eams.system.basecode.state.PoliticVisage;
import com.shufe.model.std.exemption.ExemptionResult;
import com.shufe.model.system.baseinfo.Speciality;
import com.shufe.service.course.grade.gp.GradePointService;
import com.shufe.service.std.exemption.ExemptionPropertyExtractor;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;

/**
 * 推免申请结果
 * 
 * @author zhouqi
 */
public class ExemptionManagementAction extends CalendarRestrictionSupportAction {

  protected GradePointService gradePointService;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setCalendarDataRealm(request, hasStdTypeCollege);

    addCollection(request, "politicVisages", baseCodeService.getCodes(PoliticVisage.class));
    addCollection(request, "specialitis", getSpecialities(request));
    return forward(request);
  }

  protected Collection<?> getSpecialities(HttpServletRequest request) {
    EntityQuery query = new EntityQuery(Speciality.class, "speciality");
    query.add(new Condition("speciality.department in (:departments)", getDeparts(request)));
    query.add(new Condition("speciality.state = true"));
    return utilService.search(query);
  }

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = buildQuery(request);
    query.setLimit(getPageLimit(request));
    addCollection(request, "results", utilService.search(query));
    return forward(request);
  }

  protected EntityQuery buildQuery(HttpServletRequest request) {
    EntityQuery query = new EntityQuery(ExemptionResult.class, "result");
    populateConditions(request, query);
    String adminclassName = get(request, "adminclassName");
    if (StringUtils.isNotBlank(adminclassName)) {
      query.add(new Condition(
          "exists (from result.student.adminClasses adminclass where adminclass.name like :adminclassName)",
          "%" + adminclassName + "%"));
    }
    query.addOrder(OrderUtils.parser(get(request, "orderBy")));
    return query;
  }

  protected Collection<?> getExportDatas(HttpServletRequest request) {
    return utilService.search(buildQuery(request));

  }

  protected PropertyExtractor getPropertyExtractor(HttpServletRequest request) {
    return new ExemptionPropertyExtractor(getLocale(request), getResources(request), gradePointService,
        utilService);
  }

  public void setGradePointService(GradePointService gradePointService) {
    this.gradePointService = gradePointService;
  }
}
