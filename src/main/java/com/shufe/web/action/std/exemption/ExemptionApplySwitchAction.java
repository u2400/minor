/**
 * 
 */
package com.shufe.web.action.std.exemption;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.mvc.struts.misc.ForwardSupport;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.shufe.model.std.exemption.ApplySwitch;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;

/**
 * 推免申请开关
 * 
 * @author zhouqi
 */
public class ExemptionApplySwitchAction extends CalendarRestrictionSupportAction {

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(ApplySwitch.class, "applySwitch");
    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(get(request, "orderBy")));
    addCollection(request, "applySwitches", utilService.search(query));
    return forward(request);
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long applySwitchId = getLong(request, "applySwitchId");
    if (null != applySwitchId) {
      addSingleParameter(request, "applySwitch", utilService.get(ApplySwitch.class, applySwitchId));
    }
    addCollection(request, "stdTypeList", getStdTypes(request));
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ApplySwitch applySwitch = (ApplySwitch) populateEntity(request, ApplySwitch.class, "applySwitch");

    applySwitch.setCalendar(teachCalendarService.getTeachCalendar(getLong(request, "studentTypeId"),
        get(request, "year"), get(request, "term")));

    EntityQuery query = new EntityQuery(ApplySwitch.class, "applySwitch");
    if (null != applySwitch.getId()) {
      query.add(new Condition("applySwitch != :applySwitch", applySwitch));
    }
    query.add(new Condition("applySwitch.calendar = :calendar", applySwitch.getCalendar()));
    query.add(new Condition("applySwitch.fromAt <= :endAt", applySwitch.getEndAt()));
    query.add(new Condition("applySwitch.endAt >= :fromAt", applySwitch.getFromAt()));
    if (CollectionUtils.isNotEmpty(utilService.search(query))) {
      saveErrors(request.getSession(),
          ForwardSupport.buildMessages(new String[] { "info.save.failure.overlapAcross" }));
      addCollection(request, "stdTypeList", getStdTypes(request));
      addSingleParameter(request, "applySwitch", applySwitch);
      return forward(request, "form");
    }

    applySwitch.setOperator(getUser(request));
    applySwitch.setUpdateAt(new Date());
    utilService.saveOrUpdate(applySwitch);
    return redirect(request, "index", "info.action.success");
  }

  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    utilService.remove(utilService.load(ApplySwitch.class, "id",
        SeqStringUtil.transformToLong(get(request, "applySwitchIds"))));
    return redirect(request, "index", "info.action.success");
  }
}
