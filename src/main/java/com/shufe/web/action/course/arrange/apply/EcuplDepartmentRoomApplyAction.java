package com.shufe.web.action.course.arrange.apply;

import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.springframework.util.CollectionUtils;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.web.dispatch.Action;
import com.ekingstar.eams.system.basecode.industry.ClassroomType;
import com.ekingstar.eams.system.baseinfo.SchoolDistrict;
import com.ekingstar.security.Role;
import com.ekingstar.security.User;
import com.shufe.model.course.arrange.apply.RoomApply;
import com.shufe.model.course.arrange.resource.RoomOccupySwitch;
import com.shufe.model.system.baseinfo.Classroom;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.model.system.baseinfo.Teacher;

/**
 * 院系借用教室
 * 
 * @author zhouqi
 */
public class EcuplDepartmentRoomApplyAction extends EcuplRoomApplyApproveAction {

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    initBaseCodes(request, "roomConfigTypes", ClassroomType.class);
    initBaseCodes(request, "schoolDistricts", SchoolDistrict.class);
    initBaseCodes(request, "classrooms", Classroom.class);
    buildApplySwitches(request);
    return forward(request);
  }

  @SuppressWarnings("unchecked")
  protected List<RoomOccupySwitch> buildApplySwitches(HttpServletRequest request) {
    List<Department> departments = getDeparts(request);
    departments.add(new Department(Department.SCHOOLID));
    EntityQuery query = new EntityQuery(RoomOccupySwitch.class, "ros");
    query.add(new Condition("ros.department in (:departments)", departments));
    query.add(new Condition("ros.isOpen=true"));
    query.add(new Condition(":now between ros.startDate and ros.finishDate", new Date()));
    List<RoomOccupySwitch> applySwitches = (List<RoomOccupySwitch>) utilService.search(query);
    addCollection(request, "applySwitches", applySwitches);
    return applySwitches;
  }

  public ActionForward freeRoomHome(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    User user = getUser(request);
    List<?> teachers = utilService.load(Teacher.class, "code", user.getName());
    Teacher teacher = CollectionUtils.isEmpty(teachers) ? null : (Teacher) teachers.get(0);

    boolean isSuperman = false;
    for (Iterator<?> it = user.getRoles().iterator(); it.hasNext();) {
      Role role = (Role) it.next();
      if (Role.ADMIN_ID.longValue() == role.getId().longValue()) {
        isSuperman = true;
        break;
      }
    }

    buildBuildingInParams(request, teacher, isSuperman);
    buildClassroomTypeInParams(request, teacher, isSuperman);
    buildCampusInParams(request, teacher, isSuperman);
    buildApplySwitches(request);

    String requestParamter = "&applyTime.dateBegin=" + request.getParameter("applyTime.dateBegin")
        + "&applyTime.dateEnd=" + request.getParameter("applyTime.dateEnd") + "&applyTime.timeBegin="
        + request.getParameter("applyTime.timeBegin") + "&applyTime.timeEnd="
        + request.getParameter("applyTime.timeEnd") + "&roomApply.applyTime.cycleCount="
        + request.getParameter("roomApply.applyTime.cycleCount") + "&classroom.name="
        + request.getParameter("classroom.name") + "&classroom.configType.id="
        + request.getParameter("classroom.configType.id") + "&roomApply.isMultimedia="
        + request.getParameter("roomApply.isMultimedia") + "&roomApply.schoolDistrict.id="
        + request.getParameter("roomApply.schoolDistrict.id");
    request.setAttribute("requestParamter", requestParamter);
    return forward(request);
  }

  public ActionForward quickApplySetting(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "user", getUser(request));
    addSingleParameter(request, "thisObject", this);
    buildApplySwitches(request);
    return forward(request);
  }

  public ActionForward quickApply(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    List<RoomOccupySwitch> applySwitches = buildApplySwitches(request);
    Date nowAt = new Date();
    if (CollectionUtils.isEmpty(applySwitches) || !applySwitches.get(0).getIsOpen().booleanValue()
        || nowAt.before(applySwitches.get(0).getStartDate()) || nowAt.after(applySwitches.get(0)
            .getFinishDate())) { return redirect(request, "search", "info.action.failure.timeover2"); }

    RoomApply roomApply = (RoomApply) populateEntity(request, RoomApply.class, "roomApply");
    roomApply.getBorrower().setUser(userService.get(get(request, "userName")));
    roomApply.updateOperator(getUser(request));
    roomApply.getActivities().clear();
    roomApply.setHours(roomApply.getApplyTime().calcHours());
    if (!roomApplyService.approve(roomApply,
        new HashSet<Classroom>(utilService.load(Classroom.class, "id",
            SeqStringUtil.transformToLong(get(request, "roomIds")))))) { return forward(request,
                new Action(this, "search"), "error.timeHasBeen"); }
    return redirect(request, "info", "info.action.success", "&roomApplyId=" + roomApply.getId());
  }
}
