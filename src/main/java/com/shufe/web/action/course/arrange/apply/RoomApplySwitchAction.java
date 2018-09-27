package com.shufe.web.action.course.arrange.apply;

import java.text.SimpleDateFormat;
import java.util.List;

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
import com.shufe.model.course.arrange.resource.RoomOccupySwitch;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.service.course.arrange.apply.RoomApplySwitchService;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;

public class RoomApplySwitchAction extends CalendarRestrictionSupportAction {

  protected RoomApplySwitchService roomApplySwitchService;

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long calendarId = getLong(request, "roomOccupySwitch.calendar.id");
    if (null == calendarId) {
      calendarId = getLong(request, "calendarId");
    }
    addCollection(request, "manualArrangeParamList", roomApplySwitchService.getRoomApplySwitch(calendarId));
    return forward(request);
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(Department.class, "department");
    // query.add(new Condition("department in (:departments)", getDeparts(request)));

    Long paramsId = getLong(request, "paramsId");
    if (null == paramsId) {
      query
          .add(new Condition(
              "not exists (select param.department  from RoomOccupySwitch param where param.department= department and param.calendar.id = :calendarId)",
              getLong(request, "calenarId")));
    } else {
      query
          .add(new Condition(
              "not exists (select param.department from RoomOccupySwitch param where param.department = department and param.calendar.id = :calendarId and param.id != :paramsId)",
              getLong(request, "calenarId"), paramsId));
      request.setAttribute("roomOccupySwitch", utilService.load(RoomOccupySwitch.class, paramsId));
    }

    addCollection(request, "departments", utilService.search(query));
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    RoomOccupySwitch param = (RoomOccupySwitch) populateEntity(request, RoomOccupySwitch.class,
        "roomOccupySwitch");
    EntityQuery query = new EntityQuery(RoomOccupySwitch.class, "roomOccupySwitch");
    query.add(new Condition("roomOccupySwitch.calendar.id = :calendarId", param.getCalendar().getId()));
    if (null == param.getDepartment()) {
      query.add(new Condition("roomOccupySwitch.department is null"));
    } else {
      query.add(new Condition("roomOccupySwitch.department = :deparment", param.getDepartment()));
    }
    if (null != param.getId()) {
      query.add(new Condition("roomOccupySwitch != :param", param));
    }
    List<RoomOccupySwitch> switchs = (List<RoomOccupySwitch>) utilService.search(query);
    if (CollectionUtils.isNotEmpty(switchs)) {
      System.out.println(switchs.get(0).getStartDate().equals(param.getStartDate()));
      if ((switchs.get(0).getStartDate().equals(param.getStartDate()))
          && (switchs.get(0).getFinishDate().equals(param.getFinishDate()))) return redirect(request,
          "search", "info.save.failure.overlapAcross");
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    param.setStartDate(sdf.parse(get(request, "startDate") + " " + get(request, "startTime")));
    param.setFinishDate(sdf.parse(get(request, "endDate") + " " + get(request, "endTime")));
    roomApplySwitchService.saveRoomApplySwitch(param);
    return redirect(request, "search", "info.save.success");
  }

  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] paramsIds = SeqStringUtil.transformToLong(get(request, "paramsIds"));
    if (ArrayUtils.isEmpty(paramsIds)) { return redirect(request, "search", "error.electParams.id.needed"); }
    utilService.remove(utilService.load(RoomOccupySwitch.class, "id", paramsIds));
    return redirect(request, "search", "info.delete.success");
  }

  public void setRoomApplySwitchService(RoomApplySwitchService roomApplySwitchService) {
    this.roomApplySwitchService = roomApplySwitchService;
  }

}
