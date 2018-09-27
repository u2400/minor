package com.shufe.web.action.course.grade.moral;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.Order;
import com.shufe.model.course.grade.MoralGradeInputSwitch;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 德育成绩录入开关
 * 
 * @author chaostone
 */
@SuppressWarnings({ "rawtypes", "unchecked" })
public class MoralGradeInputSwitchAction extends MoralGradeCalendarSupportAction {

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(MoralGradeInputSwitch.class, "moralGradeInputSwitch");
    populateConditions(request, query);
    List<MoralGradeInputSwitch> switches = (List) utilService.search(query);
    addCollection(request, "moralGradeInputSwitches", switches);
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long moralSwitchId = getLong(request, "moralGradeInputSwitch.id");
    MoralGradeInputSwitch moralSwitch = null;
    if (null == moralSwitchId) {
      moralSwitch = new MoralGradeInputSwitch();
    } else {
      moralSwitch = (MoralGradeInputSwitch) this.utilService.get(MoralGradeInputSwitch.class, moralSwitchId);
    }
    Map params = getParams(request, "moralGradeInputSwitch");
    populate(params, moralSwitch);
    moralSwitch.setUpdatedAt(getNowDate());
    utilService.saveOrUpdate(moralSwitch);
    return redirect(request, "search", "info.save.success");
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    MoralGradeInputSwitch moralSwitch = (MoralGradeInputSwitch) getEntity(request,
        MoralGradeInputSwitch.class, "moralGradeInputSwitch");

    Long calendarId = getLong(request, "moralGradeInputSwitch.calendar.id");
    if (null != calendarId && moralSwitch.isVO()) {
      moralSwitch.setCalendar((TeachCalendar) utilService.get(TeachCalendar.class, calendarId));
    }

    EntityQuery calendarQuery = new EntityQuery(TeachCalendar.class, "calendar");
    calendarQuery.addOrder(new Order("calendar.year"));
    calendarQuery.add(new Condition("calendar.term='2'"));

    addCollection(request, "calendars", utilService.search(calendarQuery));
    request.setAttribute("moralGradeInputSwitch", moralSwitch);
    return forward(request);
  }
}
