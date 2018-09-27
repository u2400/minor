// $Id: ApplyRoomOperation.java,v 1.3 2006/12/02 08:48:36 duanth Exp $
/*
 *
 * KINGSTAR MEDIA SOLUTIONS Co.,LTD. Copyright c 2005-2006. All rights reserved.
 * 
 * This source code is the property of KINGSTAR MEDIA SOLUTIONS LTD. It is intended 
 * only for the use of KINGSTAR MEDIA application development. Reengineering, reproduction
 * arose from modification of the original source, or other redistribution of this source 
 * is not permitted without written permission of the KINGSTAR MEDIA SOLUTIONS LTD.
 * 
 */
/********************************************************************************
 * @author chaostone
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name           Date          Description 
 * ============         ============        ============
 *chaostone      2007-5-22         Created
 *  
 ********************************************************************************/

package com.shufe.web.action.course.arrange.apply;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.mvc.struts.misc.ForwardSupport;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.utils.web.RequestUtils;
import com.ekingstar.commons.web.dispatch.Action;
import com.ekingstar.eams.system.basecode.industry.ActivityType;
import com.ekingstar.eams.system.basecode.industry.ClassroomType;
import com.ekingstar.eams.system.baseinfo.Building;
import com.ekingstar.eams.system.baseinfo.Department;
import com.ekingstar.eams.system.baseinfo.SchoolDistrict;
import com.ekingstar.eams.system.security.model.EamsRole;
import com.ekingstar.eams.system.time.TimeUnit;
import com.ekingstar.eams.system.time.TimeUnitUtil;
import com.ekingstar.security.Role;
import com.ekingstar.security.User;
import com.ekingstar.security.service.UserService;
import com.shufe.model.course.arrange.Activity;
import com.shufe.model.course.arrange.apply.RoomApply;
import com.shufe.model.course.arrange.resource.RoomOccupySwitch;
import com.shufe.model.course.arrange.resource.RoomPriceCatalogue;
import com.shufe.model.course.arrange.task.CourseActivity;
import com.shufe.model.course.grade.GradeInputSwitch;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.Classroom;
import com.shufe.model.system.baseinfo.Teacher;
import com.shufe.model.system.calendar.TimeSetting;
import com.shufe.service.course.arrange.apply.RoomApplyService;
import com.shufe.service.course.arrange.resource.TeachResourceService;
import com.shufe.web.action.common.RestrictionSupportAction;
import com.shufe.web.helper.LogHelper;

public class RoomApplyAction extends RestrictionSupportAction {

  protected TeachResourceService teachResourceService;

  protected RoomApplyService roomApplyService;

  protected UserService userService;

  protected List getRoomPriceCatalogues(HttpServletRequest request) {
    List roomPriceCatalogues = utilService.loadAll(RoomPriceCatalogue.class);
    if (CollectionUtils.isEmpty(roomPriceCatalogues)) {
      saveErrors(request,
          ForwardSupport.buildMessages(new String[] { "roomApply.withoutRoomPriceCatalogues" }));
      throw new RuntimeException("without roomPriceCatalogues");
    } else {
      return roomPriceCatalogues;
    }
  }

  /**
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward searchRoom(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    initBaseCodes("buildingList", Building.class);
    initBaseCodes("configTypeList", ClassroomType.class);
    if ("search".equals(request.getParameter("flag"))) {
      DynaActionForm dynaForm = (DynaActionForm) form;
      TimeUnit time = TimeUnitUtil.constructTime(java.sql.Date.valueOf(request.getParameter("dateBegin")),
          java.sql.Date.valueOf(request.getParameter("dateEnd")),
          Integer.valueOf(request.getParameter("weekDay")),
          Integer.valueOf(request.getParameter("startUnit")),
          Integer.valueOf(request.getParameter("unitCount")),
          Integer.valueOf(request.getParameter("weekType")));
      Classroom room = (Classroom) dynaForm.get("room");
      Results.addObject("roomList",
          teachResourceService.getFreeRoomsOf(null, new TimeUnit[] { time }, room, CourseActivity.class));
    }

    return this.forward(mapping, request, "searchRoom");
  }

  /**
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    return forward(request);
  }

  /**
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward applyNotice(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    return forward(request);
  }

  /**
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward pricesReview(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    request.setAttribute("catalogues", getRoomPriceCatalogues(request));
    return forward(request);
  }

  /**
   * 查看365校区教室借用价目
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward pricesReview369(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    return forward(request);
  }

  /**
   * 我已申请的教室记录
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward myApplied(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(RoomApply.class, "roomApply");
    query.add(new Condition("roomApply.departApproveBy = (:user)", getUser(request.getSession())));
    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(request.getParameter("orderBy")));
    addCollection(request, "roomApplies", utilService.search(query));
    return forward(request);
  }

  /**
   * 使用教室情况
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward searchHome(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "roomConfigTypes", baseCodeService.getCodes(ClassroomType.class));
    return forward(request);
  }

  /**
   * 跳转到申请教室界面
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward toApply(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "roomConfigTypes", baseCodeService.getCodes(ClassroomType.class));
    return forward(request, "searchHome");
  }

  /**
   * 教室空闲查询
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward freeRoomList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    RoomApply roomApply = (RoomApply) populateEntity(request, RoomApply.class, "roomApply");
    Classroom room = (Classroom) populateEntity(request, Classroom.class, "classroom");

    List<Teacher> teachers = utilService.load(Teacher.class, "code", getUser(request).getName());
    Teacher teacher = CollectionUtils.isEmpty(teachers) ? null : teachers.get(0);

    TimeUnit[] times = roomApply.getApplyTime().convert(
        (TimeSetting) utilService.get(TimeSetting.class, TimeSetting.DEFAULT_ID));
    if (times != null) {
      Collection<Classroom> rooms = teachResourceService.getFreeRoomsOf(null, times, room, Activity.class);// 或页面条件所属的教室

      EntityQuery query = new EntityQuery(Classroom.class, "classroom");// 获取当前登录教师权限内的教室
      if (null == teacher) {
        if (CollectionUtils.isEmpty(rooms)) {
          query.add(new Condition("classroom is null"));
        } else {
          query.add(new Condition("classroom in (:rooms)", rooms));
        }
      } else {

        StringBuilder hql = new StringBuilder();
        hql.append("exists (");
        hql.append("from ApplyRoomInDepartment applyRoomInDepartment ");
        hql.append("where applyRoomInDepartment.department = :department ");
        hql.append("and exists (");
        hql.append("from applyRoomInDepartment.rooms room ");
        hql.append("where room = classroom ");
        if (CollectionUtils.isEmpty(rooms)) {
          hql.append("and room is null");
        } else {
          hql.append("and room in (:rooms)");
        }

        hql.append(")");
        hql.append(")");
        if (CollectionUtils.isEmpty(rooms)) {
          query.add(new Condition(hql.toString(), teacher.getDepartment()));
        } else {
          query.add(new Condition(hql.toString(), teacher.getDepartment(), rooms));
        }
      }
      Integer capacity = getInteger(request, "capacity");
      if (null != capacity) {
        query.add(new Condition("classroom.capacity >= :capacity", capacity));
      }
      Integer capacityOfExam = getInteger(request, "capacityOfExam");
      if (null != capacityOfExam) {
        query.add(new Condition("classroom.capacityOfExam >= :capacityOfExam", capacityOfExam));
      }
      query.add(new Condition("classroom.state = true"));
      query.addOrder(OrderUtils.parser(get(request, "orderBy")));
      query.setLimit(getPageLimit(request));
      Collection<Classroom> roomsByTeacher = utilService.search(query);// 查询当前登录教师权限内的教室
      addCollection(request, "rooms", utilService.search(query));
    }
    return forward(request);
  }

  /**
   * 获取当前时间的教室借用约束
   */
  protected List<RoomOccupySwitch> getCannotApplySwitch(Date startDate, Date endDate) {
    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:ss");
    Map parameterMap = new HashMap();
    String hqlString = "select roomOccupySwitch from RoomOccupySwitch as roomOccupySwitch where roomOccupySwitch.isOpen=0  "
        + "and( (roomOccupySwitch.startDate >= to_date (:beginDate,'yyyy-MM-dd HH24:ss') and roomOccupySwitch.startDate <= to_date (:endDate,'yyyy-MM-dd HH24:ss')) "
        + " or (roomOccupySwitch.finishDate >= to_date(:beginDate,'yyyy-MM-dd HH24:ss') and roomOccupySwitch.finishDate <= to_date(:endDate,'yyyy-MM-dd HH24:ss')) )"
        + " or (roomOccupySwitch.finishDate >= to_date(:endDate,'yyyy-MM-dd HH24:ss') and roomOccupySwitch.startDate <= to_date(:beginDate,'yyyy-MM-dd HH24:ss')) )";
    parameterMap.put("beginDate", simpleDateFormat.format(startDate));
    parameterMap.put("endDate", simpleDateFormat.format(endDate));
    return (List<RoomOccupySwitch>) utilService.searchHQLQuery(hqlString, parameterMap);
  }

  /**
   * 查看申请教室空闲情况
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward freeRoomHome(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    User user = getUser(request);
    List<Teacher> teachers = utilService.load(Teacher.class, "code", user.getName());
    Teacher teacher = CollectionUtils.isEmpty(teachers) ? null : teachers.get(0);

    boolean isSuperman = false;
    for (Iterator it = user.getRoles().iterator(); it.hasNext();) {
      Role role = (Role) it.next();
      if (Role.ADMIN_ID.longValue() == role.getId().longValue()) {
        isSuperman = true;
        break;
      }
    }

    buildBuildingInParams(request, teacher, isSuperman);
    buildClassroomTypeInParams(request, teacher, isSuperman);
    buildCampusInParams(request, teacher, isSuperman);

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

  /**
   * 组建教学楼查询条件
   * 
   * @param request
   * @param teacher
   * @param isSuperman
   */
  protected void buildBuildingInParams(HttpServletRequest request, Teacher teacher, boolean isSuperman) {
    EntityQuery query = new EntityQuery(Building.class, "building");
    if (null == teacher) {
      if (!isSuperman) {
        query.add(new Condition("building is null"));
      }
    } else {
      StringBuilder hql = new StringBuilder();
      hql.append("exists (");
      hql.append("from ApplyRoomInDepartment applyRoomInDepartment ");
      hql.append("where applyRoomInDepartment.department = :department ");
      hql.append("and exists (");
      hql.append("from applyRoomInDepartment.rooms room ");
      hql.append("where room.building = building");
      hql.append(")");
      hql.append(")");
      query.add(new Condition(hql.toString(), teacher.getDepartment()));
    }
    query.add(new Condition("building.state = true"));

    addCollection(request, "buildings", utilService.search(query));
  }

  /**
   * 组建教室设备配置查询条件
   * 
   * @param request
   * @param teacher
   * @param isSuperman
   */
  protected void buildClassroomTypeInParams(HttpServletRequest request, Teacher teacher, boolean isSuperman) {
    EntityQuery query = new EntityQuery(ClassroomType.class, "classroomType");
    if (null == teacher) {
      if (!isSuperman) {
        query.add(new Condition("classroomType is null"));
      }
    } else {
      StringBuilder hql = new StringBuilder();
      hql.append("exists (");
      hql.append("from ApplyRoomInDepartment applyRoomInDepartment ");
      hql.append("where applyRoomInDepartment.department = :department ");
      hql.append("and exists (");
      hql.append("from applyRoomInDepartment.rooms room ");
      hql.append("where room.configType = classroomType");
      hql.append(")");
      hql.append(")");
      query.add(new Condition(hql.toString(), teacher.getDepartment()));
    }
    query.add(new Condition("classroomType.state = true"));

    addCollection(request, "classroomTypes", utilService.search(query));
  }

  /**
   * 组建校区查询条件
   * 
   * @param request
   * @param teacher
   * @param isSuperman
   */
  protected void buildCampusInParams(HttpServletRequest request, Teacher teacher, boolean isSuperman) {
    EntityQuery query = new EntityQuery(SchoolDistrict.class, "campus");
    if (null == teacher) {
      if (!isSuperman) {
        query.add(new Condition("campus is null"));
      }
    } else {
      StringBuilder hql = new StringBuilder();
      hql.append("exists (");
      hql.append("from ApplyRoomInDepartment applyRoomInDepartment ");
      hql.append("where applyRoomInDepartment.department = :department ");
      hql.append("and exists (");
      hql.append("from applyRoomInDepartment.rooms room ");
      hql.append("where room.schoolDistrict = campus");
      hql.append(")");
      hql.append(")");
      query.add(new Condition(hql.toString(), teacher.getDepartment()));
    }
    query.add(new Condition("campus.state = true"));

    addCollection(request, "campuses", utilService.search(query));
  }

  /**
   * 新增教室申请form
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward addApply(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    applyFormInitParams(request);
    return forward(request);
  }

  /**
   * @param request
   */
  protected void applyFormInitParams(HttpServletRequest request) {
    initBaseCodes(request, "activityTypes", ActivityType.class);
    request.setAttribute("user", getUser(request.getSession()));
    request.setAttribute("applyAt", new Date());
    request.setAttribute("departments",
        ((RoomPriceCatalogue) getRoomPriceCatalogues(request).get(0)).getAuditDeparts());
    initBaseInfos(request, "schoolDistricts", SchoolDistrict.class);
  }

  /**
   * 复制教室申请
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward copyApply(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    getRoomApplyDatas(request);
    return forward(request);
  }

  /**
   * 自定义方法<br>
   * 得到修改或复制审核页面中的数据
   * 
   * @param request
   * @return
   */
  protected void getRoomApplyDatas(HttpServletRequest request) {
    RoomApply roomApply = (RoomApply) utilService.load(RoomApply.class,
        new Long(request.getParameter("roomApplyId")));
    request.setAttribute("roomApply", roomApply);
    initBaseCodes(request, "activityTypes", ActivityType.class);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    request.setAttribute("applyAt", sdf.format(new Date()));
    request.setAttribute("departments",
        ((RoomPriceCatalogue) getRoomPriceCatalogues(request).get(0)).getAuditDeparts());
    request.setAttribute("requestAction", RequestUtils.getRequestAction(request));
    initBaseCodes(request, "schoolDistricts", SchoolDistrict.class);
  }

  public ActionForward quickApplySetting(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    // String roomIds = get(request, "classroomIds");
    // String requestParamter = request.getParameter("requestParamter");
    // request.setAttribute("roomIds", roomIds);
    // addCollection(request, "classrooms", utilService.load(Classroom.class, "id",
    // SeqStringUtil.transformToLong(roomIds)));
    // applyFormInitParams(request);
    // request.setAttribute("roomApply", populateEntity(request, RoomApply.class, "roomApply"));
    // request.setAttribute("requestParamter", requestParamter);
    addSingleParameter(request, "user", getUser(request));
    addSingleParameter(request, "thisObject", this);
    return forward(request);
  }

  /**
   * 保存--新建的申请记录
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward quickApply(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    RoomApply roomApply = (RoomApply) populateEntity(request, RoomApply.class, "roomApply");

    roomApply.getBorrower().setUser(userService.get(get(request, "userName")));
    roomApply.updateOperator(getUser(request));
    roomApply.getActivities().clear();
    roomApply.setHours(roomApply.getApplyTime().calcHours());
    if (!roomApplyService.approve(
        roomApply,
        new HashSet<Classroom>(utilService.load(Classroom.class, "id",
            SeqStringUtil.transformToLong(get(request, "roomIds")))))) { return forward(request, new Action(
        this, "search"), "error.timeHasBeen"); }
    return redirect(request, "info", "info.action.success", "&roomApplyId=" + roomApply.getId());
  }

  /**
   * 删除教室的借用申请
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String roomApplyId = request.getParameter("roomApplyId");
    List applies = utilService.load(RoomApply.class, "id", SeqStringUtil.transformToLong(roomApplyId));

    List canceled = new ArrayList();
    for (Iterator iterator = applies.iterator(); iterator.hasNext();) {
      RoomApply apply = (RoomApply) iterator.next();
      if (!Boolean.TRUE.equals(apply.getIsApproved())) {
        canceled.add(apply);
      }
    }
    utilService.remove(canceled);
    logHelper.info(request, LogHelper.DELETE);
    return redirect(request, "myApplied", "info.action.success");
  }

  /**
   * 查看打印版本
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "roomApply",
        utilService.get(RoomApply.class, getLong(request, "roomApplyId")));
    addSingleParameter(request, "thisObject", this);
    addSingleParameter(request, "STD_USER", EamsRole.STD_USER);
    return forward(request);
  }

  /**
   * @param request
   */
  protected void buildRoomApplyInfo(HttpServletRequest request) {
    Long id = getLong(request, "roomApplyId");
    RoomApply roomApply = (RoomApply) utilService.get(RoomApply.class, id);
    request.setAttribute("roomApply", roomApply);
    String department;
    if (roomApply.getBorrower().getUser().getDefaultCategory().getId().equals(EamsRole.STD_USER)) {
      EntityQuery stdQuery = new EntityQuery(Student.class, "std");
      stdQuery.setSelect("std.department.name");
      stdQuery.add(new Condition("std.code=:stdCode", roomApply.getBorrower().getUser().getName()));
      List stdlist = (List) utilService.search(stdQuery);
      if (stdlist.isEmpty()) {
        department = null;
      } else {
        department = (String) stdlist.get(0);
      }
    } else {
      EntityQuery teacherQuery = new EntityQuery(Teacher.class, "teacher");
      teacherQuery.setSelect("teacher.department.name");
      teacherQuery
          .add(new Condition("teacher.code=:teacherCode", roomApply.getBorrower().getUser().getName()));
      List list = (List) utilService.search(teacherQuery);
      if (list.isEmpty()) {
        department = null;
      } else {
        department = (String) list.get(0);
      }
    }
    request.setAttribute("department", department);
  }

  /**
   * 根据用户帐号获取对应有效部门/院系（给页面上使用的，程序也能调用）
   * 
   * @param userName
   * @return
   */
  public Department getUserDepartment(String userName) {
    if (StringUtils.isBlank(userName)) { return null; }

    List<Teacher> teachers = utilService.load(Teacher.class, "code", userName);
    if (CollectionUtils.isEmpty(teachers)) {
      List<Student> students = utilService.load(Student.class, "code", userName);
      if (CollectionUtils.isNotEmpty(students)) {
        return students.get(0).getDepartment();
      } else {
        return null;
      }
    } else {
      return teachers.get(0).getDepartment();
    }
  }

  /**
   * @param teachResourceService
   *          The teachResourceService to set.
   */
  public void setTeachResourceService(TeachResourceService teachResourceService) {
    this.teachResourceService = teachResourceService;
  }

  /**
   * @param roomApplyService
   *          要设置的 roomApplyService.
   */
  public void setRoomApplyService(RoomApplyService roomApplyService) {
    this.roomApplyService = roomApplyService;
  }

  public void setUserService(UserService userService) {
    this.userService = userService;
  }
}
