package com.shufe.web.action.course.grade.moral;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.Order;
import com.shufe.model.Constants;
import com.shufe.model.course.grade.MoralGradeInputSwitch;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.web.action.common.CalendarRestrictionExampleTemplateAction;

/**
 * 筛选出符合德育成绩录入的学期
 * 
 * @author chaostone
 */
public abstract class MoralGradeCalendarSupportAction extends CalendarRestrictionExampleTemplateAction {

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setCalendarDataRealm(request, hasStdTypeCollege);
    setMoralCalendar(request);
    return forward(request);
  }

  @SuppressWarnings("unchecked")
  protected void setMoralCalendar(HttpServletRequest request) throws Exception {
    EntityQuery calendarQuery = new EntityQuery(TeachCalendar.class, "calendar");
    calendarQuery.addOrder(new Order("calendar.year"));
    calendarQuery.add(new Condition("calendar.term='2'"));
    List<TeachCalendar> calendars = (List<TeachCalendar>) utilService.search(calendarQuery);
    addCollection(request, "calendars", calendars);

    Long calendarId = getLong(request, "calendar.id");
    //不读取cookiey中的学年学期，因为德育成绩大都维护上个学年度的。
    TeachCalendar calendar = null;//(TeachCalendar) request.getAttribute(Constants.CALENDAR);
    if (null != calendarId) {
      for (TeachCalendar c : calendars) {
        if (c.getId().equals(calendarId)) {
          calendar = c;
          break;
        }
      }
    }
    if (null == calendar) {
      EntityQuery query = new EntityQuery(MoralGradeInputSwitch.class, "egis");
      query.add(new Condition("egis.opened=true"));
      query.addOrder(new Order("egis.endOn desc"));
      List<MoralGradeInputSwitch> swithes = (List<MoralGradeInputSwitch>) utilService.search(query);
      if (!swithes.isEmpty()) {
        calendar = swithes.get(0).getCalendar();
      }
    }
    request.setAttribute(Constants.CALENDAR, calendar);
  }

  protected void addSwitch(HttpServletRequest request) {
    this.addSingleParameter(request, "inputSwitch", getSwitch(request));
  }

  @SuppressWarnings("unchecked")
  protected MoralGradeInputSwitch getSwitch(HttpServletRequest request) {
    Long calendarId = getLong(request, "calendar.id");
    if (null == calendarId) calendarId = getLong(request, "calendarId");
    if (null == calendarId) calendarId = getLong(request, "moralGrade.calendar.id");

    List<MoralGradeInputSwitch> switches = (List<MoralGradeInputSwitch>) utilService
        .load(MoralGradeInputSwitch.class, "calendar.id", calendarId);
    MoralGradeInputSwitch is = null;
    if (switches.size() == 1) {
      is = switches.get(0);
    } else {
      is = new MoralGradeInputSwitch();
    }
    return is;
  }

}
