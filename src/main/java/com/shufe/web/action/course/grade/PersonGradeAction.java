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
 * chaostone             2007-1-15            Created
 *  
 ********************************************************************************/
package com.shufe.web.action.course.grade;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.eams.system.basecode.industry.ExamStatus;
import com.ekingstar.eams.system.basecode.industry.ExamType;
import com.shufe.model.course.arrange.exam.ExamApplyParam;
import com.shufe.model.course.arrange.exam.ExamTake;
import com.shufe.model.course.arrange.task.CourseTake;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.course.arrange.exam.ExamApplyParamService;
import com.shufe.service.course.grade.GradeService;
import com.shufe.service.course.grade.gp.GradePointService;
import com.shufe.service.course.task.TeachTaskService;
import com.shufe.service.std.StudentService;
import com.shufe.service.system.calendar.TeachCalendarService;
import com.shufe.web.action.common.DispatchBasicAction;
import com.shufe.web.helper.StdGradeHelper;

/**
 * 学生个人成绩
 * 
 * @author chaostone
 */
public class PersonGradeAction extends DispatchBasicAction {
  GradePointService gradePointService;

  GradeService gradeService;

  StdGradeHelper stdGradeHelper;

  TeachTaskService teachTaskService;

  StudentService studentService;

  TeachCalendarService teachCalendarService;

  ExamApplyParamService examApplyParamService;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Student std = getStudentFromSession(request.getSession());
    stdGradeHelper.searchStdGrade(request, std, gradeService, baseCodeService, gradePointService);
    request.setAttribute("hasSpeciality2ndGrade", null != std.getSecondMajor());
    return forward(request);
  }

  public ActionForward examApply(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long stdId = getLong(request, "std");
    Long taskId = getLong(request, "task");
    Long calendarId = getLong(request, "calendar");
    Student std = getStudentFromSession(request.getSession());
    TeachTask teachTask = teachTaskService.getTeachTask(taskId);
    Student student = studentService.getStudent(stdId);
    TeachCalendar teachCalendar = teachCalendarService.getTeachCalendar(calendarId);
    ExamApplyParam param = examApplyParamService.getExamApplyParams(std);
    CourseTake courseTake = null;
    if (null == param) {
      return forwardError(mapping, request, new String[] { "exam.applytime", "exam.applytime.pass" });
    } else {
      EntityQuery query = new EntityQuery(ExamTake.class, "examTake");
      query.add(new Condition("examTake.task.id=" + taskId));
      query.add(new Condition("examTake.std.id=" + stdId));
      query.add(new Condition("examTake.calendar.id=" + calendarId));
      List list = (List) utilService.search(query);
      if (list.size() != 0) {
        return forwardError(mapping, request, new String[] { "exam.apply", "exam.apply.d" });
      } else {
        ExamTake examTake = new ExamTake();
        EntityQuery entityQuery = new EntityQuery(CourseTake.class, "courseTake");
        entityQuery.add(new Condition("courseTake.task.id=" + taskId));
        entityQuery.add(new Condition("courseTake.student.id=" + stdId));
        List courseTakeList = (List) utilService.search(entityQuery);
        if (courseTakeList.size() != 0) {
          courseTake = (CourseTake) courseTakeList.get(0);
        } else {
          return forwardError(mapping, request, new String[] { "exam.apply.z", "exam.apply.x" });
        }
        examTake.setCourseTake(courseTake);
        examTake.setCalendar(teachCalendar);
        examTake.setTask(teachTask);
        examTake.setStd(student);
        examTake.setExamType(new ExamType(new Long(3)));
        examTake.setExamStatus(new ExamStatus(new Long(1)));
        Date dateNow = new Date();
        String userIp = request.getRemoteAddr();
        String applyUser = std.getCode();
        examTake.setUserIp(userIp);
        examTake.setApplyUser(applyUser);
        examTake.setApplyDate(dateNow);
        utilService.saveOrUpdate(examTake);
        return redirect(request, "index", "exam.apply.save", "");
      }

    }

  }

  public void setGradePointService(GradePointService gradePointService) {
    this.gradePointService = gradePointService;
  }

  public void setGradeService(GradeService gradeService) {
    this.gradeService = gradeService;
  }

  public void setStdGradeHelper(StdGradeHelper stdGradeHelper) {
    this.stdGradeHelper = stdGradeHelper;
  }

  public void setExamApplyParamService(ExamApplyParamService examApplyParamService) {
    this.examApplyParamService = examApplyParamService;
  }

  public void setTeachTaskService(TeachTaskService teachTaskService) {
    this.teachTaskService = teachTaskService;
  }

  public void setStudentService(StudentService studentService) {
    this.studentService = studentService;
  }

  public void setTeachCalendarService(TeachCalendarService teachCalendarService) {
    this.teachCalendarService = teachCalendarService;
  }

}
