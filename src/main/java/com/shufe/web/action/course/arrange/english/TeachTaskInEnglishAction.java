//$Id: TeachTaskInEnglishAction.java,v 1.1 2012-8-31 zhouqi Exp $
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
 * zhouqi				2012-8-31             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.web.action.course.arrange.english;

import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.model.EntityUtils;
import com.ekingstar.commons.mvc.struts.misc.ForwardSupport;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.utils.query.QueryRequestSupport;
import com.ekingstar.commons.web.dispatch.Action;
import com.ekingstar.eams.system.basecode.industry.CourseType;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.shufe.model.Constants;
import com.shufe.model.course.arrange.AvailableTime;
import com.shufe.model.course.grade.GradeState;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.web.action.course.task.TeachTaskAction;

/**
 * 学生英语等级教学任务管理
 * 
 * @author zhouqi
 */
public class TeachTaskInEnglishAction extends TeachTaskAction {

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    initBaseCodes(request, "languageAbilities", LanguageAbility.class);
    return super.index(mapping, form, request, response);
  }

  protected void searchQuerySetting(EntityQuery query, HttpServletRequest request) {
    List<Object> conditions = QueryRequestSupport.extractConditions(request, LanguageAbility.class,
        "languageAbility", null);
    if (CollectionUtils.isNotEmpty(conditions)) {
      query.join("task.requirement.languageAbilities", "languageAbility");
      query.add(conditions);
    }
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    initBaseCodes(request, "languageAbilities", LanguageAbility.class);
    return super.edit(mapping, form, request, response);
  }

  /**
   * 转向批量更改课程、学分页面
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward batchUpdateCourseSetting(ActionMapping mapping, ActionForm form,
      HttpServletRequest request, HttpServletResponse response) throws Exception {
    addCollection(request, "tasks",
        utilService.load(TeachTask.class, "id", SeqStringUtil.transformToLong(get(request, "taskIds"))));
    addCollection(request, "courseTypes", baseCodeService.getCodes(CourseType.class));
    addCollection(request, "languageAbilities", baseCodeService.getCodes(LanguageAbility.class));
    return forward(request);
  }

  /**
   * 批量更改课程，学分
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward batchUpdateCourse(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] taskIds = SeqStringUtil.transformToLong(get(request, "taskIds"));
    // 查找课程
    String courseNo = get(request, "course.code");
    Course course = null;
    if (StringUtils.isNotEmpty(courseNo)) {
      List<Course> courses = utilService.load(Course.class, "code", courseNo);
      if (courses.size() != 1) {
        return redirect(request, "search", "error.parameters.illegal");
      } else {
        course = courses.get(0);
      }
    }
    // 获取课程类别
    Long courseTypeId = getLong(request, "course.type.code");
    CourseType courseType = null;
    if (null != courseTypeId) {
      courseType = (CourseType) baseCodeService.getCode(CourseType.class, courseTypeId);
    }

    // 备注
    String remark = get(request, "task.remark");

    String languageAbilityIdSeq = get(request, "languageAbilityIds");
    Collection<LanguageAbility> languageAbilities = null;
    if (StringUtils.isNotBlank(languageAbilityIdSeq)) {
      languageAbilities = utilService.load(LanguageAbility.class, "id",
          SeqStringUtil.transformToLong(languageAbilityIdSeq));
    }

    if (null != taskIds) {
      List tasks = teachTaskService.getTeachTasksByIds(taskIds);
      for (Iterator iter = tasks.iterator(); iter.hasNext();) {
        TeachTask task = (TeachTask) iter.next();
        if (null != course) {
          task.setCourse(course);
        }
        if (null != courseType) {
          task.setCourseType(courseType);
        }
        if (null != remark) {
          task.setRemark(remark);
        }
        if (null != languageAbilities) {
          task.getRequirement().getLanguageAbilities().clear();
          task.getRequirement().getLanguageAbilities().addAll(languageAbilities);
        }
      }
      utilService.saveOrUpdate(tasks);
    }
    return redirect(request, "search", "info.update.success");
  }

  /**
   * 保存教学任务信息<br>
   * 如果教学任务的计划人数为零，则从行政班计算计划人数.<br>
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TeachTask task = (TeachTask) populateEntity(request, TeachTask.class, Constants.TEACHTASK);
    // 获得教学任务关联的行政班级
    Set adminClassSet = new HashSet(utilService.load(AdminClass.class, "id",
        SeqStringUtil.transformToLong(get(request, Constants.ADMINCLASS_KEYSEQ))));
    Boolean autoReName = getBoolean(request, "autoReName");
    // 存储教学任务信息
    Boolean calcStdCount = getBoolean(request, "calcStdCount");
    // 是否需要用户进一步确认后保存，默认为不需要。
    try {
      String teacherIdSeq = get(request, "teacherIds");
      String preCourseCodeSeq = get(request, "preCourseCodeSeq");
      if (task.isVO()) {
        TeachTask defaultTask = TeachTask.getDefault();
        EntityUtils.evictEmptyProperty(defaultTask);

        defaultTask.setGradeState(new GradeState(defaultTask));

        // 计算总学时
        task.getArrangeInfo().calcOverallUnits();
        EntityUtils.merge(defaultTask, task);
        defaultTask.getTeachClass().getAdminClasses().addAll(adminClassSet);
        if (null != calcStdCount && calcStdCount.equals(Boolean.TRUE)) {
          defaultTask.getTeachClass().calcPlanStdCount(true);
        }

        setTeachersAndRooms(teacherIdSeq, defaultTask);
        setPreCourses(preCourseCodeSeq, defaultTask);
        if (Boolean.TRUE.equals(autoReName)) {
          defaultTask.getTeachClass().reNameByClass();
        }
        // FIXME
        if (null != task.getArrangeInfo().getSuggest()) {
          task.getArrangeInfo().getSuggest().setTime(new AvailableTime(AvailableTime.commonTeacherAvailTime));
        }
        task.getRequirement().getLanguageAbilities().clear();
        String languageAbilityIdSeq = get(request, "languageAbilityIds");
        if (StringUtils.isNotBlank(languageAbilityIdSeq)) {
          Long[] languageAbilityIds = SeqStringUtil.transformToLong(languageAbilityIdSeq);
          for (int i = 0; i < languageAbilityIds.length; i++) {
            LanguageAbility languageAbility = new LanguageAbility();
            languageAbility.setId(languageAbilityIds[i]);
            task.getRequirement().getLanguageAbilities().add(languageAbility);
          }
        }
        teachTaskService.saveTeachTask(defaultTask);
        logHelper.info(request, "Create a teachTask with id:" + defaultTask.getId() + " and course name:"
            + defaultTask.getCourse().getName());
      } else {
        Set taskAdminClasses = task.getTeachClass().getAdminClasses();
        // 统计在保存前的班级
        Set adminClasses1 = new HashSet();
        adminClasses1.addAll(taskAdminClasses);
        addCollection(request, "taskAdminClasses", adminClasses1);
        taskAdminClasses.clear();
        taskAdminClasses.addAll(adminClassSet);
        if (null != calcStdCount && calcStdCount.equals(Boolean.TRUE)) {
          task.getTeachClass().calcPlanStdCount(true);
        }
        setTeachersAndRooms(teacherIdSeq, task);
        setPreCourses(preCourseCodeSeq, task);
        if (Boolean.TRUE.equals(autoReName)) {
          task.getTeachClass().reNameByClass();
        }
        if (null != task.getArrangeInfo().getSuggest()
            && null != task.getArrangeInfo().getSuggest().getTime()
            && StringUtils.isNotEmpty(task.getArrangeInfo().getSuggest().getTime().getStruct())) {
          task.getArrangeInfo().getSuggest().setTime(new AvailableTime(AvailableTime.commonTeacherAvailTime));
        }
        task.getRequirement().getLanguageAbilities().clear();
        String languageAbilityIdSeq = get(request, "languageAbilityIds");
        if (StringUtils.isNotBlank(languageAbilityIdSeq)) {
          Long[] languageAbilityIds = SeqStringUtil.transformToLong(languageAbilityIdSeq);
          for (int i = 0; i < languageAbilityIds.length; i++) {
            LanguageAbility languageAbility = new LanguageAbility();
            languageAbility.setId(languageAbilityIds[i]);
            task.getRequirement().getLanguageAbilities().add(languageAbility);
          }
        }
        // 否则就直接保存操作
        teachTaskService.updateTeachTask(task);
        logHelper.info(request, "Update a teachTask with id:" + task.getId() + " and course name:"
            + task.getCourse().getName());

        // 统计在保存后的班级
        Set adminClasses2 = new HashSet();
        adminClasses2.addAll(taskAdminClasses);

        Collection c1 = CollectionUtils.subtract(adminClasses1, adminClasses2);
        Collection c2 = CollectionUtils.subtract(adminClasses2, adminClasses1);
        // 是否要显示同步已指定的学生
        if (CollectionUtils.isNotEmpty(c1) || CollectionUtils.isNotEmpty(c2)) {
          saveErrors(request.getSession(), ForwardSupport.buildMessages(new String[] { "info.save.success" }));
          addSingleParameter(request, "task", task);
          addCollection(request, "adminClassSet", adminClassSet);
          return forward(request, "../teachTaskCollege/taskOperationConfirm");
        }
      }
    } catch (Exception e) {
      logHelper.info(request, "Failure occured in create or update teachTask with id:" + task.getId()
          + " and course name:" + task.getCourse().getName(), e);
      return forward(mapping, request, "error.occurred", "error");
    }
    if (Boolean.TRUE.equals(getBoolean(request, "practiceCourse"))) { return redirect(request, new Action(
        "courseTakeForTaskDuplicate", "taskList"), "info.save.success"); }
    if (StringUtils.isNotEmpty(get(request, "forward"))) {
      saveErrors(request.getSession(), ForwardSupport.buildMessages(new String[] { "info.save.success" }));
      return mapping.findForward(get(request, "forward"));
    } else {
      return redirect(request, "search", "info.save.success");
    }
  }

  protected ActionForward forward(HttpServletRequest request) {
    ActionForward f = ForwardSupport.forward(clazz, request, (String) null);
    if (Results != null) {
      request.setAttribute(DETAIL_RESULT, Results.getDetail());
    }
    return f;
  }
}
