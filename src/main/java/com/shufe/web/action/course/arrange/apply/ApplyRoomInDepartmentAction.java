//$Id: ApplyRoomInDepartmentAction.java,v 1.1 2012-5-9 zhouqi Exp $
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
 * @author zhouqi
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * zhouqi				2012-5-9             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.web.action.course.arrange.apply;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.beanfuse.lang.SeqStringUtil;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.web.dispatch.Action;
import com.shufe.model.course.arrange.apply.ApplyRoomInDepartment;
import com.shufe.model.system.baseinfo.Classroom;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.web.action.common.RestrictionSupportAction;

/**
 * 借教室：分配院系可借用的教室
 * 
 * @author zhouqi
 */
public class ApplyRoomInDepartmentAction extends RestrictionSupportAction {

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(ApplyRoomInDepartment.class, "applyRoomInDepartment");
    populateConditions(request, query);
    List<Department> departments = getDeparts(request);
    if (CollectionUtils.isEmpty(departments)) {
      query.add(new Condition("applyRoomInDepartment is null"));
    } else {
      query.add(new Condition("applyRoomInDepartment.department in (:departs)", departments));
    }
    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(get(request, "orderBy")));
    addCollection(request, "applyRoomInDepartments", utilService.search(query));
    return forward(request);
  }

  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "applyRoomInDepartment",
        utilService.load(ApplyRoomInDepartment.class, getLong(request, "applyRoomInDepartmentId")));
    return forward(request);
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long applyRoomInDepartmentId = getLong(request, "applyRoomInDepartmentId");
    if (null != applyRoomInDepartmentId) {
      addSingleParameter(request, "applyRoomInDepartment",
          utilService.load(ApplyRoomInDepartment.class, applyRoomInDepartmentId));
    }
    addCollection(request, "departments", getDeparts(request));
    addSingleParameter(request, "operator", getUser(request));
    return forward(request);
  }

  /**
   * 院系可分配的教室
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward roomSearch(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] roomIds = SeqStringUtil.transformToLong(get(request, "roomIds"));
    EntityQuery query = new EntityQuery(Classroom.class, "room");
    populateConditions(request, query);
    if (null != roomIds && roomIds.length > 0) {
      query.add(new Condition("room.id not in (:roomIds)", roomIds));
    }
    query.add(new Condition("room.state = true"));
    addCollection(request, "roomsInAll", utilService.search(query));
    query.setLimit(getPageLimit(request));
    query.addOrder(OrderUtils.parser(get(request, "orderBy")));
    addCollection(request, "rooms", utilService.search(query));
    return forward(request, "roomList");
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ApplyRoomInDepartment applyRoomInDepartment = (ApplyRoomInDepartment) populateEntity(request,
        ApplyRoomInDepartment.class, "applyRoomInDepartment");

    EntityQuery query = new EntityQuery(ApplyRoomInDepartment.class, "applyRoomInDepartment");
    query.add(new Condition("applyRoomInDepartment.department = :department", applyRoomInDepartment
        .getDepartment()));
    if (null != applyRoomInDepartment.getId()) {
      query.add(new Condition("applyRoomInDepartment != :applyRoomInDepartment", applyRoomInDepartment));
    }
    if (CollectionUtils.isNotEmpty(utilService.search(query))) {
      addSingleParameter(request, "applyRoomInDepartment", applyRoomInDepartment);
      return forward(request, new Action("", "edit"), "info.save.failure.overlap");
    }

    applyRoomInDepartment.getRooms().clear();
    applyRoomInDepartment.addClassroom(utilService.load(Classroom.class, "id",
        SeqStringUtil.transformToLong(get(request, "roomIds"))));
    applyRoomInDepartment.updateThisObject(getUser(request));

    Collection<Object> toSaveObjs = new ArrayList<Object>();
    toSaveObjs.add(applyRoomInDepartment);

    toSaveObjs.add(logHelper.buildInfo(request, (null == applyRoomInDepartment.getId() ? "Been created"
        : "Been updated")
        + " a ApplyRoomInDepartment Record in \""
        + applyRoomInDepartment.getDepartment().getName() + "\" of department."));
    utilService.saveOrUpdate(toSaveObjs);
    return redirect(request, "search", "info.save.success");
  }

  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Collection<ApplyRoomInDepartment> applyRoomInDepartments = utilService.load(ApplyRoomInDepartment.class,
        "id", SeqStringUtil.transformToLong(get(request, "applyRoomInDepartmentIds")));
    utilService.remove(applyRoomInDepartments);
    logHelper.info(request, applyRoomInDepartments.size()
        + " number of ApplyRoomInDepartment Records been removed.");
    return redirect(request, "search", "info.action.success");
  }
}
