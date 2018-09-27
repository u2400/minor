//$Id: GenderLimitGroupAction.java,v 1.1 2011-11-22 下午06:08:05 zhouqi Exp $
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
 * zhouqi               2011-11-22          Created
 *  
 ********************************************************************************/

package com.shufe.web.action.course.arrange.task;

import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ekingstar.common.detail.Pagination;

import org.apache.commons.beanutils.BeanComparator;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.eams.system.basecode.state.Gender;
import com.shufe.model.Constants;
import com.shufe.model.course.arrange.task.TaskGroup;
import com.shufe.model.course.task.GenderLimitGroup;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.baseinfo.Teacher;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 制定男女生人数的体育课程排课分组
 * 
 * @author zhouqi
 */
public class GenderLimitGroupAction extends TaskGroupAction {

  private static final String pename = "体育";

  /**
   * 上课二维表
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward activityReport(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(TaskGroup.class, "tGroup");
    Condition content = new Condition();
    StringBuilder hql = new StringBuilder();
    hql.append("exists (");
    hql.append("    from tGroup.directTasks task");
    hql.append("   where exists (from task.arrangeInfo.activities activity)");
    hql.append("     and task.course.name like :courseName");
    content.addValue("%" + pename + "%");
    hql.append("     and task.calendar = :calendar");
    content.addValue(getTeachCalendar(request));
    String departIdSeq = getDepartmentIdSeq(request);
    if (StringUtils.isBlank(departIdSeq)) {
      hql.append("     and task.arrangeInfo.teachDepart is null");
    } else {
      hql.append("     and task.arrangeInfo.teachDepart.id in (:departIds)");
      content.addValue(SeqStringUtil.transformToLong(departIdSeq));
    }
    String stdTypeIdSeq = getDepartmentIdSeq(request);
    if (StringUtils.isBlank(stdTypeIdSeq)) {
      hql.append("     and task.teachClass.stdType is null");
    } else {
      hql.append("     and task.teachClass.stdType.id in (:stdTypeIds)");
      content.addValue(SeqStringUtil.transformToLong(stdTypeIdSeq));
    }
    hql.append(")");
    content.setContent(hql.toString());
    query.add(content);
    Collection<TaskGroup> groups = utilService.search(query);
    addCollection(request, "groups", groups);

    Map<String, Object> genderCountsMap = new HashMap<String, Object>();

    for (TaskGroup group : groups) {
      genderCountsMap.put(group.getId().toString(), getGenderCountsForTasks(group));
    }
    addSingleParameter(request, "genderCountsMap", genderCountsMap);
    return forward(request);
  }

  /**
   * 查找指定学期的课程组
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward groupList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String departDataRealm = getDepartmentIdSeq(request);
    if (StringUtils.isEmpty(departDataRealm)) { return forward(mapping, request,
        "error.depart.dataRealm.notExists", "error"); }
    TeachCalendar calendar = getTeachCalendar(request);
    if (null == calendar) { return forward(mapping, request, new String[] { "entity.calendar",
        "error.model.notExist" }, "error"); }

    TaskGroup groupInQuery = null;
    String groupName = get(request, "groupName");
    if (StringUtils.isNotBlank(groupName)) {
      groupInQuery = new TaskGroup();
      groupInQuery.setName(groupName);
      groupInQuery.setIsSameTime(null);
      groupInQuery.setPriority(null);
      groupInQuery.setIsClassChange(null);
    }

    // 如果刚刚保存了新建的课程组，则定位到该组页面
    Long taskGroupId = getLong(request, "taskGroup.id");
    TaskGroup group = null;
    if (null != taskGroupId) {
      group = (TaskGroup) utilService.load(TaskGroup.class, taskGroupId);
    }
    Pagination groupList = null;
    boolean isHas = false;
    if (null != group) {
      for (int i = getPageNo(request), n = getPageSize(request); i < n; i++) {
        groupList = groupService.getTaskGroups(groupInQuery, getStdTypeIdSeq(request), departDataRealm,
            pename, calendar, i, n, null);
        Set groups = new HashSet(groupList.getItems());
        if (groups.contains(group)) {
          isHas = true;
          break;
        }
      }
    }
    if (!isHas || null == group) {
      groupList = groupService.getTaskGroups(groupInQuery, getStdTypeIdSeq(request), departDataRealm, pename,
          calendar, getPageNo(request), getPageSize(request), null);
    }
    // FIXME 改为 不分页排序
    Collections.sort(groupList.getItems(), new BeanComparator("name"));
    addOldPage(request, "groupPageList", groupList);
    return forward(request);
  }

  /**
   * 查询含有“体育”课程的教学任务
   * 
   * @param request
   * @param isGP
   *          是否挂牌
   * @param excludeGroup
   *          设置要排除的排课组，即结果集没有该组的教学任务
   * @return
   */
  protected Pagination getTeachTasks(HttpServletRequest request, boolean lonely) {
    /*---------------获得查询条件-------------------*/
    TeachTask task = (TeachTask) populate(request, TeachTask.class, Constants.TEACHTASK);
    Teacher teacher = (Teacher) populate(request, Teacher.class, Constants.TEACHER);
    task.getArrangeInfo().getTeachers().add(teacher);
    Long stdTypeId = getLong(request, "calendar.studentType.id");

    Course course = new Course();
    course.setName(pename);
    task.setCourse(course);

    // 查询
    Pagination taskList = null;
    if (lonely) {
      taskList = teachTaskService.getTeachTasksOfLonely(task,
          SeqStringUtil.transformToLong(getStdTypeIdSeqOf(stdTypeId, request)),
          SeqStringUtil.transformToLong(getDepartmentIdSeq(request)), getPageNo(request),
          getPageSize(request));
    } else {
      taskList = teachTaskService.getTeachTasksOfTeachDepart(task, getStdTypeIdSeq(request),
          getDepartmentIdSeq(request), getPageNo(request), getPageSize(request));
    }

    return taskList;
  }

  /**
   * 保存计划人数和男女生人数
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward savePlanCount(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long groupId = getLong(request, Constants.TASKGROUP_KEY);
    if (null == groupId) { return forwardError(mapping, request, "error.model.id.needed"); }
    TaskGroup group = groupService.getTaskGroup(groupId);
    for (Iterator iter = group.getTaskList().iterator(); iter.hasNext();) {
      TeachTask task = (TeachTask) iter.next();
      Integer planStdCount = getInteger(request, "planStdCount" + task.getId());
      if (null != planStdCount) {
        task.getTeachClass().setPlanStdCount(planStdCount);
      }

      // 收集页面上设置的男女生人数
      Set<GenderLimitGroup> limitGroups = new HashSet<GenderLimitGroup>();
      Integer maleCount = getInteger(request, "maleLCount" + task.getId());
      if (null != maleCount) {
        GenderLimitGroup maleGroup = task.getTeachClass().getGenderLimitGroup(Gender.MALE);
        if (null == maleGroup) {
          maleGroup = new GenderLimitGroup();
          maleGroup.setTask(task);
          maleGroup.setGender((Gender) utilService.load(Gender.class, Gender.MALE));
          maleGroup.setCount(new Integer(0));
        }
        maleGroup.setLimitCount(maleCount.intValue());
        limitGroups.add(maleGroup);
      }
      Integer femaleCount = getInteger(request, "femaleLCount" + task.getId());
      if (null != femaleCount) {
        GenderLimitGroup femaleGroup = task.getTeachClass().getGenderLimitGroup(Gender.FEMALE);
        if (null == femaleGroup) {
          femaleGroup = new GenderLimitGroup();
          femaleGroup.setTask(task);
          femaleGroup.setGender((Gender) utilService.load(Gender.class, Gender.FEMALE));
          femaleGroup.setCount(new Integer(0));
        }
        femaleGroup.setLimitCount(femaleCount.intValue());
        limitGroups.add(femaleGroup);
      }
      // 保存收集设置的男女生人数
      task.getTeachClass().getLimitGroups().clear();
      task.getTeachClass().getLimitGroups().addAll(limitGroups);

      task.getTeachClass().processTaskForClass();

      task.setRemark(get(request, "remark" + task.getId()));

      utilService.saveOrUpdate(task);
    }
    return redirect(request, "info", "info.save.success", "&taskGroup.id=" + groupId);
  }
}
