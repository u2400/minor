//$Id: EcuplManualArrangeAction.java,v 1.1 2009-4-7 上午11:43:54 zhouqi Exp $
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
 * zhouqi              2009-4-7             Created
 *  
 ********************************************************************************/

package com.shufe.web.action.course.arrange.task;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.utils.web.RequestUtils;
import com.ekingstar.commons.web.dispatch.Action;
import com.ekingstar.eams.system.basecode.industry.CourseCategory;
import com.ekingstar.eams.system.security.model.EamsRole;
import com.shufe.model.Constants;
import com.shufe.model.course.arrange.task.ManualArrangeParam;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.web.helper.RestrictionHelper;

/**
 * @author zhouqi
 */
public class EcuplManualArrangeAction extends ManualArrangeAction {

  protected RestrictionHelper dataRealmHelper;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setCalendarDataRealm(request, hasStdTypeCollege);
    setCalendarDataRealm(request, hasStdType);
    // 获得开课院系和上课教师列表
    String stdTypeDataRealm = getStdTypeIdSeq(request);
    String departDataRealm = getDepartmentIdSeq(request);
    addCollection(request, "courseCategories", baseCodeService.getCodes(CourseCategory.class));
    addCollection(
        request,
        "courseTypes",
        teachTaskService.getCourseTypesOfTask(stdTypeDataRealm, departDataRealm,
            (TeachCalendar) request.getAttribute(Constants.CALENDAR)));
    addCollection(
        request,
        "teachDepartList",
        teachTaskService.getTeachDepartsOfTask(stdTypeDataRealm, departDataRealm,
            (TeachCalendar) request.getAttribute(Constants.CALENDAR)));
    addCollection(
        request,
        Constants.DEPARTMENT_LIST,
        teachTaskService.getDepartsOfTask(stdTypeDataRealm, departDataRealm,
            (TeachCalendar) request.getAttribute(Constants.CALENDAR)));
    return forward(request);
  }

  protected String validDepartmentIdSeq(HttpServletRequest request) {
    return validDepartmentIdSeq(request, null);
  }

  protected String validDepartmentIdSeq(HttpServletRequest request, TeachCalendar calendar) {
    String departDataRealm = getDepartmentIdSeq(request);
    if (StringUtils.isBlank(departDataRealm)) { return "#"; }

    Date sysdate = new Date();
    Set<EamsRole> roles = getUser(request.getSession()).getRoles();
    for (EamsRole eamsRole : roles) {
      if (eamsRole.getId().longValue() == 1L) {
        addSingleParameter(request, "isAdmin", Boolean.TRUE);
        addSingleParameter(request, "validDepartIdSeq", departDataRealm);
        return departDataRealm;
      }

      EntityQuery query = new EntityQuery(ManualArrangeParam.class, "param");
      query.add(new Condition("param.calendar = :calendar", null == calendar ? getTeachCalendar(request)
          : calendar));
      query.add(new Condition(":nowAt between param.startDate and param.finishDate", sysdate));
      query.add(new Condition("param.department.id in (:departmentIds) or param.department is null",
          SeqStringUtil.transformToLong(departDataRealm)));
      Collection<ManualArrangeParam> arrangeParams = utilService.search(query);

      Long[] openDepartIds = new Long[StringUtils.split(departDataRealm, ",").length];
      int openDepartId_index = 0;
      Long[] closeDepartIds = new Long[openDepartIds.length];
      int closeDepartId_index = 0;
      ManualArrangeParam paramInNull = null;
      for (ManualArrangeParam param : arrangeParams) {
        if (null == param.getDepartment()) {
          paramInNull = param;
          departDataRealm += ",1";
          continue;
        }
        if (param.isValid(sysdate)) {
          openDepartIds[openDepartId_index++] = param.getDepartment().getId();
        } else {
          closeDepartIds[closeDepartId_index++] = param.getDepartment().getId();
        }
      }

      if ((null == paramInNull || paramInNull.isInvalid(sysdate))) {
        if (null == openDepartIds[0]) {
          departDataRealm = StringUtils.EMPTY;
        } else {
          departDataRealm = StringUtils.remove(SeqStringUtil.transformToSeq(openDepartIds, ","), ",null");
        }
      } else {
        if (null == closeDepartIds[0]) {
          break;
        }
        departDataRealm = "," + departDataRealm + ",";
        for (int i = 0; i < closeDepartIds.length && null != closeDepartIds[i]; i++) {
          departDataRealm = StringUtils.replace(departDataRealm, "," + closeDepartIds[i] + ",", ",");
        }
        departDataRealm = StringUtils.removeStart(departDataRealm, ",");
        departDataRealm = StringUtils.removeEnd(departDataRealm, ",");
      }
      break;
    }

    addSingleParameter(request, "validDepartIdSeq", departDataRealm);
    return departDataRealm;
  }

  /**
   * 找出分配归属院系的教学任务
   * 
   * @param request
   * @return
   */
  protected EntityQuery buildQuery(HttpServletRequest request, Boolean isArrangeCompleted) {
    String departIdSeq = validDepartmentIdSeq(request);
    TeachCalendar calendar = getTeachCalendar(request);

    EntityQuery query = teachTaskSearchHelper.buildTaskQuery(request, Boolean.FALSE);

    StringBuilder hql = new StringBuilder();
    hql.append("exists (");
    hql.append("  from TaskInDepartment taskIn join taskIn.tasks as taskInTask");
    hql.append(" where task.id = taskInTask.id");
    if (StringUtils.isBlank(departIdSeq)) {
      hql.append("   and taskIn is null");
    } else {
      hql.append("   and taskIn.department.id in (:departmentIds)");
    }
    hql.append("   and taskIn.calendar = :calendar");
    hql.append(")");
    if (StringUtils.isBlank(departIdSeq)) {
      query.add(new Condition(hql.toString(), calendar));
    } else {
      query.add(new Condition(hql.toString(), SeqStringUtil.transformToLong(departIdSeq), calendar));
    }
    Long stdTypeId = RequestUtils.getLong(request, "task.teachClass.stdType.id");
    if (null == stdTypeId) {
      stdTypeId = RequestUtils.getLong(request, "calendar.studentType.id");
    }
    if (null != stdTypeId) {
      dataRealmHelper.addStdTypeTreeDataRealm(query, stdTypeId, "task.teachClass.stdType.id", request);
    }
    if (null != isArrangeCompleted) {
      query.add(new Condition("task.arrangeInfo.isArrangeComplete = :isComplete", isArrangeCompleted));
    }
    return query;
  }

  /**
   * 列举手动排课中全部教学任务
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    validDepartmentIdSeq(request);

    Boolean isAll = getBoolean(request, "task.arrangeInfo.isArrangeComplete");
    Boolean isArrangeCompleted = isAll;
    if (null == isArrangeCompleted) {
      isArrangeCompleted = getBoolean(request, "isArrangeCompleted");
    }
    addCollection(request, "tasks", utilService.search(buildQuery(request, isArrangeCompleted)));
    if (null == isAll) {
      return forward(request);
    } else {
      return forward(request, "taskList");
    }
  }

  protected boolean isTimeOver(HttpServletRequest request, TeachCalendar calendar, Collection<TeachTask> tasks) {
    String validDepartIdSeq = validDepartmentIdSeq(request, calendar);
    if (StringUtils.contains(validDepartIdSeq, "#")) { return true; }

    Set<EamsRole> roles = getUser(request.getSession()).getRoles();
    for (EamsRole eamsRole : roles) {
      if (eamsRole.getId().longValue() == 1L) { return false; }
    }

    Collection<Department> departs = utilService.load(Department.class, "id",
        SeqStringUtil.transformToLong(validDepartIdSeq));

    Collection<TeachTask> task_s = new ArrayList<TeachTask>();
    if (null == tasks) {
      EntityQuery query = new EntityQuery(TeachTask.class, "task");
      query.add(new Condition("task.calendar = :calendar", calendar));
      query.add(new Condition("task.arrangeInfo.teachDepart in (:departs)", departs));
      task_s.addAll(utilService.search(query));
    } else {
      task_s.addAll(tasks);
    }

    for (TeachTask task : task_s) {
      if (null != task.getArrangeInfo().getTeachDepart()
          && null != task.getArrangeInfo().getTeachDepart().getId()
          && (!departs.contains(task.getArrangeInfo().getTeachDepart()) || 1L != task.getArrangeInfo()
              .getTeachDepart().getId().longValue())) { return false; }
    }

    return true;
  }

  public ActionForward editInSuggest(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TeachTask task = (TeachTask) utilService.load(TeachTask.class, getLong(request, Constants.TEACHTASK_KEY));
    if (null == task) { return forwardError(mapping, request, "error.model.notExist"); }

    // 院系排课需要此步
    Collection<TeachTask> tasks = new ArrayList<TeachTask>();
    tasks.add(task);
    if (isTimeOver(request, task.getCalendar(), tasks)) { return forwardError(mapping, request,
        "info.action.failure.timeover"); }

    return forward(request, new Action("arrangeSuggest", "edit"));
  }

  public ActionForward arrangeAlterationIndex(ActionMapping mapping, ActionForm form,
      HttpServletRequest request, HttpServletResponse response) throws Exception {
    // 院系排课需要此步
    if (isTimeOver(request, getTeachCalendar(request), null)) { return forwardError(mapping, request,
        "info.action.failure.timeover"); }

    return forward(request, new Action(CourseArrangeAlterationAction.class, "index"));
  }

  public ActionForward editTeachTask(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    // 院系排课需要此步
    TeachTask task = (TeachTask) utilService.get(TeachTask.class, getLong(request, "task.id"));
    Collection<TeachTask> tasks = new ArrayList<TeachTask>();
    tasks.add(task);
    if (isTimeOver(request, task.getCalendar(), tasks)) { return forwardError(mapping, request,
        "info.action.failure.timeover"); }

    return forward(request, new Action("teachTaskCollege", "edit"));
  }

  protected ActionForward forwardInSave(ActionMapping mapping, HttpServletRequest request, String forward)
      throws Exception {
    return redirect(request, "search", "info.save.success");
  }

  public void setDataRealmHelper(RestrictionHelper dataRealmHelper) {
    this.dataRealmHelper = dataRealmHelper;
  }
}
