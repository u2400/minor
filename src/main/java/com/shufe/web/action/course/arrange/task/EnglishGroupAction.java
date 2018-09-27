// Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/kpdus/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   EnglishGroupAction.java

package com.shufe.web.action.course.arrange.task;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.ekingstar.eams.system.basecode.state.Gender;
import com.shufe.model.course.arrange.ArrangeInfo;
import com.shufe.model.course.arrange.task.TaskGroup;
import com.shufe.model.course.task.*;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.baseinfo.Teacher;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.course.arrange.task.TaskGroupService;
import com.shufe.service.course.task.TeachTaskService;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.ekingstar.common.detail.Pagination;
import org.apache.commons.beanutils.BeanComparator;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.*;

public class EnglishGroupAction extends TaskGroupAction {

  public ActionForward activityReport(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(TaskGroup.class, "tGroup");
    Condition content = new Condition();
    StringBuilder hql = new StringBuilder();
    hql.append("exists (");
    hql.append("    from tGroup.directTasks task");
    hql.append("   where exists (from task.arrangeInfo.activities activity)");
    hql.append("     and task.course.name like :courseName");
    content.addValue("%\u82F1\u8BED%");
    hql.append("     and task.calendar = :calendar");
    content.addValue(getTeachCalendar(request));
    String departIdSeq = getDepartmentIdSeq(request);
    if (StringUtils.isBlank(departIdSeq)) {
      hql.append("     and task.arrangeInfo.teachDepart is null");
    } else {
      hql.append("     and task.arrangeInfo.teachDepart.id in (:departIds)");
      content.addValue(SeqStringUtil.transformToLong(departIdSeq));
    }
    String stdTypeIdSeq = getStdTypeIdSeq(request);
    if (StringUtils.isBlank(stdTypeIdSeq)) {
      hql.append("     and task.teachClass.stdType is null");
    } else {
      hql.append("     and task.teachClass.stdType.id in (:stdTypeIds)");
      content.addValue(SeqStringUtil.transformToLong(stdTypeIdSeq));
    }
    hql.append(")");
    content.setContent(hql.toString());
    query.add(content);
    Collection groups = utilService.search(query);
    addCollection(request, "groups", groups);
    Map genderCountsMap = new HashMap();
    TaskGroup group;
    for (Iterator iterator = groups.iterator(); iterator.hasNext(); genderCountsMap.put(group.getId()
        .toString(), getGenderCountsForTasks(group)))
      group = (TaskGroup) iterator.next();

    addSingleParameter(request, "genderCountsMap", genderCountsMap);
    return forward(request);
  }

  public ActionForward groupList(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String departDataRealm = getDepartmentIdSeq(request);
    if (StringUtils.isEmpty(departDataRealm)) return forward(mapping, request,
        "error.depart.dataRealm.notExists", "error");
    TeachCalendar calendar = getTeachCalendar(request);
    if (calendar == null) return forward(mapping, request, new String[] { "entity.calendar",
        "error.model.notExist" }, "error");
    TaskGroup groupInQuery = null;
    String groupName = get(request, "groupName");
    if (StringUtils.isNotBlank(groupName)) {
      groupInQuery = new TaskGroup();
      groupInQuery.setName(groupName);
      groupInQuery.setIsSameTime(null);
      groupInQuery.setPriority(null);
      groupInQuery.setIsClassChange(null);
    }
    Long taskGroupId = getLong(request, "taskGroup.id");
    TaskGroup group = null;
    if (taskGroupId != null) group = (TaskGroup) utilService.load(TaskGroup.class, taskGroupId);
    Pagination groupList = null;
    boolean isHas = false;
    if (group != null) {
      int i = getPageNo(request);
      for (int n = getPageSize(request); i < n; i++) {
        groupList = groupService.getTaskGroups(groupInQuery, getStdTypeIdSeq(request), departDataRealm,
            "\u82F1\u8BED", calendar, i, n, null);
        Set groups = new HashSet(groupList.getItems());
        if (!groups.contains(group)) continue;
        isHas = true;
        break;
      }

    }
    if (!isHas || group == null) groupList = groupService.getTaskGroups(groupInQuery,
        getStdTypeIdSeq(request), departDataRealm, "\u82F1\u8BED", calendar, getPageNo(request),
        getPageSize(request), null);
    Collections.sort(groupList.getItems(), new BeanComparator("name"));
    addOldPage(request, "groupPageList", groupList);
    return forward(request);
  }

  protected Pagination getTeachTasks(HttpServletRequest request, boolean lonely) {
    TeachTask task = (TeachTask) populate(request, TeachTask.class, "task");
    Teacher teacher = (Teacher) populate(request, Teacher.class, "teacher");
    task.getArrangeInfo().getTeachers().add(teacher);
    Long stdTypeId = getLong(request, "calendar.studentType.id");
    Course course = new Course();
    course.setName("\u82F1\u8BED");
    task.setCourse(course);
    Pagination taskList = null;
    if (lonely) taskList = teachTaskService.getTeachTasksOfLonely(task,
        SeqStringUtil.transformToLong(getStdTypeIdSeqOf(stdTypeId, request)),
        SeqStringUtil.transformToLong(getDepartmentIdSeq(request)), getPageNo(request), getPageSize(request));
    else taskList = teachTaskService.getTeachTasksOfTeachDepart(task, getStdTypeIdSeq(request),
        getDepartmentIdSeq(request), getPageNo(request), getPageSize(request));
    return taskList;
  }

  public ActionForward savePlanCount(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long groupId = getLong(request, "taskGroup.id");
    if (groupId == null) return forwardError(mapping, request, "error.model.id.needed");
    TaskGroup group = groupService.getTaskGroup(groupId);
    TeachTask task;
    for (Iterator iter = group.getTaskList().iterator(); iter.hasNext(); utilService.saveOrUpdate(task)) {
      task = (TeachTask) iter.next();
      Integer planStdCount = getInteger(request, (new StringBuilder("planStdCount")).append(task.getId())
          .toString());
      if (planStdCount != null) task.getTeachClass().setPlanStdCount(planStdCount);
      Set limitGroups = new HashSet();
      Integer maleCount = getInteger(request, (new StringBuilder("maleLCount")).append(task.getId())
          .toString());
      if (maleCount != null) {
        GenderLimitGroup maleGroup = task.getTeachClass().getGenderLimitGroup(Gender.MALE);
        if (maleGroup == null) {
          maleGroup = new GenderLimitGroup();
          maleGroup.setTask(task);
          maleGroup.setGender((Gender) utilService.load(Gender.class, Gender.MALE));
          maleGroup.setCount(new Integer(0));
        }
        maleGroup.setLimitCount(Integer.valueOf(maleCount.intValue()));
        limitGroups.add(maleGroup);
      }
      Integer femaleCount = getInteger(request, (new StringBuilder("femaleLCount")).append(task.getId())
          .toString());
      if (femaleCount != null) {
        GenderLimitGroup femaleGroup = task.getTeachClass().getGenderLimitGroup(Gender.FEMALE);
        if (femaleGroup == null) {
          femaleGroup = new GenderLimitGroup();
          femaleGroup.setTask(task);
          femaleGroup.setGender((Gender) utilService.load(Gender.class, Gender.FEMALE));
          femaleGroup.setCount(new Integer(0));
        }
        femaleGroup.setLimitCount(Integer.valueOf(femaleCount.intValue()));
        limitGroups.add(femaleGroup);
      }
      task.getTeachClass().getLimitGroups().clear();
      task.getTeachClass().getLimitGroups().addAll(limitGroups);
      task.getTeachClass().processTaskForClass();
      task.setRemark(get(request, (new StringBuilder("remark")).append(task.getId()).toString()));
    }

    return redirect(request, "info", "info.save.success",
        (new StringBuilder("&taskGroup.id=")).append(groupId).toString());
  }

  private static final String pename = "\u82F1\u8BED";
}
