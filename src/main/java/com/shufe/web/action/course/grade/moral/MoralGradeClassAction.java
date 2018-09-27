package com.shufe.web.action.course.grade.moral;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.shufe.model.course.grade.MoralGradeInputSwitch;

public class MoralGradeClassAction extends MoralGradeInstructorAction {

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setCalendarDataRealm(request, hasStdTypeCollege);
    setMoralCalendar(request);
    return forward(request);
  }

  public ActionForward classList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "adminClasses", baseInfoSearchHelper.searchAdminClass(request));
    Long calendarId = getLong(request, "calendar.id");
    List<MoralGradeInputSwitch> switches = (List<MoralGradeInputSwitch>) utilService.load(
        MoralGradeInputSwitch.class, "calendar.id", calendarId);
    if (switches.size() == 1) {
      this.addSingleParameter(request, "inputSwitch", switches.get(0));
    }
    return forward(request);
  }
}
