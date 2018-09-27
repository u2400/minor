//$Id: TaskGroupServiceImpl.java,v 1.1 2006/11/09 11:22:28 duanth Exp $
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
 * Name                 Date                Description 
 * ============         ============        ============
 * chaostone             2005-11-16         Created
 *  
 ********************************************************************************/

package com.shufe.service.course.arrange.task.impl;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import net.ekingstar.common.detail.Pagination;
import net.ekingstar.common.detail.Result;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.shufe.dao.course.arrange.task.TaskGroupDAO;
import com.shufe.model.course.arrange.task.AddTaskOptions;
import com.shufe.model.course.arrange.task.RemoveTaskOptions;
import com.shufe.model.course.arrange.task.TaskGroup;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.BasicService;
import com.shufe.service.course.arrange.task.TaskGroupService;

public class TaskGroupServiceImpl extends BasicService implements TaskGroupService {

  private TaskGroupDAO groupDAO;

  /**
   * @see com.shufe.service.course.arrange.task.TaskGroupService#getTaskGroup(java.io.Serializable)
   */
  public TaskGroup getTaskGroup(Serializable id) {
    return (null != id) ? groupDAO.getTaskGroup(id) : null;
  }

  /**
   * @see com.shufe.service.course.arrange.task.TaskGroupService#getTaskGroups(java.lang.String,
   *      com.shufe.model.system.calendar.TeachCalendar)
   */
  public List getTaskGroups(String teachDepartIdSeq, TeachCalendar calendar) {
    return (StringUtils.isNotEmpty(teachDepartIdSeq) && calendar.checkId()) ? groupDAO.getTaskGroups(
        SeqStringUtil.transformToLong(teachDepartIdSeq), calendar) : Collections.EMPTY_LIST;
  }

  /**
   * @see com.shufe.service.course.arrange.task.TaskGroupService#getTaskGroups(java.lang.String)
   */
  public List getTaskGroups(String groupIdSeq) {
    return StringUtils.isNotEmpty(groupIdSeq) ? groupDAO.getTaskGroups(SeqStringUtil
        .transformToLong(groupIdSeq.split(","))) : Collections.EMPTY_LIST;
  }

  public void removeTaskFormGroup(TaskGroup group, Collection tasks) {
    removeTaskFormGroup(group, tasks, new RemoveTaskOptions());
  }

  /**
   * 删除组内的在指定集合内的教学任务
   * 
   * @param tasks
   */
  public void removeTaskFormGroup(TaskGroup group, Collection tasks, RemoveTaskOptions options) {
    if (null == tasks || tasks.isEmpty()) return;
    group.removeTasks(tasks, options);
    for (Iterator iter = group.getDirectTasks().iterator(); iter.hasNext();)
      utilDao.saveOrUpdate(iter.next());
    groupDAO.update(group);
  }

  public Integer getTaskCountOfGroup(Serializable groupId) {
    return (groupId != null) ? getTaskCountOfGroup(groupDAO.getTaskGroup(groupId)) : new Integer(0);
  }

  public Integer getTaskCountOfGroup(TaskGroup group) {
    if (null == group) { return new Integer(0); }
    List groups = new ArrayList();
    groups.addAll(group.getAllGroups());
    groups.add(group);
    return groupDAO.getTaskCountOfGroup(groups);
  }

  /**
   * @see com.shufe.service.course.arrange.task.TaskGroupService#addTasks(com.shufe.model.course.arrange.task.TaskGroup,
   *      java.util.Collection, java.lang.Boolean, java.lang.Boolean)
   */
  public void addTasks(TaskGroup group, Collection tasks, AddTaskOptions options) {
    if (null == tasks || tasks.isEmpty()) { return; }
    Set<TaskGroup> oldTaskGroups = new HashSet<TaskGroup>();
    for (Iterator iter = tasks.iterator(); iter.hasNext();) {
      TeachTask task = (TeachTask) iter.next();
      oldTaskGroups.add(task.getTaskGroup());
    }

    group.addTasks(tasks, options);// 放入到排课组中
    Set<Object> toBeRemovedObjects = new HashSet<Object>();
    // 没有合并到组内的任务

    Collection<TeachTask> toBeRemovedTasks = CollectionUtils.subtract(tasks, group.getTaskList());
    for (Iterator iter = toBeRemovedObjects.iterator(); iter.hasNext();) {
      TeachTask task = (TeachTask) iter.next();
      oldTaskGroups.add(task.getTaskGroup());
      task.setTaskGroup(null);
      task.getTeachClass().processTaskForClass();
    }
    toBeRemovedObjects.addAll(toBeRemovedTasks);

    utilDao.saveOrUpdate(group.getDirectTasks());

    EntityQuery query = new EntityQuery(TaskGroup.class, "taskGroup");
    query.add(new Condition("taskGroup in (:taskGroups)", oldTaskGroups));
    query.add(new Condition("not exists (from taskGroup.directTasks task)"));
    toBeRemovedObjects.addAll(utilDao.search(query));

    utilDao.remove(toBeRemovedObjects);

    updateTaskGroup(group);
  }

  /**
   * @see com.shufe.service.course.arrange.task.TaskGroupService#addTasks(com.shufe.model.course.arrange.task.TaskGroup,
   *      java.util.Collection)
   */
  public void addTasks(TaskGroup group, Collection tasks) {
    addTasks(group, tasks, new AddTaskOptions());
  }

  /**
   * @see com.shufe.service.course.arrange.task.TaskGroupService#getTaskGroups(com.shufe.model.course.arrange.task.TaskGroup,
   *      java.lang.String, com.shufe.model.system.calendar.TeachCalendar, int, int,
   *      java.lang.Boolean, java.lang.Boolean)
   */
  public Pagination getTaskGroups(TaskGroup group, String stdTypeSeq, String teachDepartIdSeq,
      TeachCalendar calendar, int pageNo, int pageSize, Boolean isCompleted) {
    return getTaskGroups(group, stdTypeSeq, teachDepartIdSeq, null, calendar, pageNo, pageSize, isCompleted);
  }

  public Pagination getTaskGroups(TaskGroup group, String stdTypeSeq, String teachDepartIdSeq,
      String courseName, TeachCalendar calendar, int pageNo, int pageSize, Boolean isCompleted) {
    if (StringUtils.isNotEmpty(teachDepartIdSeq) && StringUtils.isNotEmpty(stdTypeSeq)) { return getTaskGroups(
        group, SeqStringUtil.transformToLong(stdTypeSeq), SeqStringUtil.transformToLong(teachDepartIdSeq),
        courseName, calendar, pageNo, pageSize, isCompleted); }
    return new Pagination(new Result(0, Collections.EMPTY_LIST));
  }

  /**
   * @see com.shufe.service.course.arrange.task.TaskGroupService#getTaskGroups(com.shufe.model.course.arrange.task.TaskGroup,
   *      java.lang.String, com.shufe.model.system.calendar.TeachCalendar, int, int,
   *      java.lang.Boolean, java.lang.Boolean)
   */
  public Pagination getTaskGroups(TaskGroup group, Long[] stdTypeIds, Long[] teachDepartIds,
      TeachCalendar calendar, int pageNo, int pageSize, Boolean isCompleted) {
    return getTaskGroups(group, stdTypeIds, teachDepartIds, null, calendar, pageNo, pageSize, isCompleted);
  }

  public Pagination getTaskGroups(TaskGroup group, Long[] stdTypeIds, Long[] teachDepartIds,
      String courseName, TeachCalendar calendar, int pageNo, int pageSize, Boolean isCompleted) {
    return groupDAO.getTaskGroups(group, stdTypeIds, teachDepartIds, courseName, calendar, pageNo, pageSize,
        isCompleted);
  }

  /**
   * @see com.shufe.service.course.arrange.task.TaskGroupService#saveTaskGroup(com.shufe.model.course.arrange.task.TaskGroup)
   */
  public void saveTaskGroup(TaskGroup group) {
    if (null != group) groupDAO.saveTaskGroup(group);
  }

  /**
   * @see com.shufe.service.course.arrange.task.TaskGroupService#removeTaskGroup(com.shufe.model.course.arrange.task.TaskGroup)
   */
  public void removeTaskGroup(TaskGroup group) {
    if (null != group) groupDAO.removeTaskGroup(group);
  }

  /**
   * @see com.shufe.service.course.arrange.task.TaskGroupService#removeTaskGroup(java.io.Serializable)
   */
  public void removeTaskGroup(Serializable id) {
    if (null != id) groupDAO.removeTaskGroup(id);
  }

  /**
   * @see com.shufe.service.course.arrange.task.TaskGroupService#setTaskGroupDAO(com.shufe.dao.course.arrange.task.TaskGroupDAO)
   */
  public void setTaskGroupDAO(TaskGroupDAO groupDAO) {
    this.groupDAO = groupDAO;
  }

  /**
   * @see com.shufe.service.course.arrange.task.TaskGroupService#updateTaskGroup(com.shufe.model.course.arrange.task.TaskGroup)
   */
  public void updateTaskGroup(TaskGroup group) {
    if (null != group) groupDAO.update(group);
  }
}
