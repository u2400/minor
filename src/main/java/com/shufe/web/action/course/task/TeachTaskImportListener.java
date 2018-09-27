package com.shufe.web.action.course.task;

import java.sql.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.model.EntityUtils;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.transfer.importer.ItemImporterListener;
import com.ekingstar.commons.utils.persistence.UtilDao;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.ekingstar.eams.system.basecode.industry.TeachLangType;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.model.course.arrange.AvailableTime;
import com.shufe.model.course.grade.GradeState;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.course.task.TeachTaskService;

public class TeachTaskImportListener extends ItemImporterListener {
  private UtilDao utilDao;
  private UtilService utilService;
  private TeachTaskService teachTaskService;

  // private Map<String,TeachTask> courseMap=new HashMap<String,TeachTask>();
  public TeachTaskImportListener(TeachTaskService teachTaskService, UtilService utilService) {
    this.teachTaskService = teachTaskService;
    this.utilService = utilService;
  }

  public void startTransferItem(TransferResult tr) {
    // String reasonCode=(String) importer.curDataMap().get("course.code");
    // if(StringUtils.isNotBlank(reasonCode)){
    // Collection<TeachTask> alterReason=utilService.load(TeachTask.class,
    // "course.code",reasonCode);
    // if(CollectionUtils.isEmpty(alterReason)){
    // courseMap.put(reasonCode, alterReason.iterator().next());
    // }
    // }
  }

  public void endTransferItem(TransferResult tr) {
    TeachTask teachTask = (TeachTask) importer.getCurrent();
    if (teachTask != null && null != teachTask.getId()) {
      if (null != teachTask && StringUtils.isNotBlank(teachTask.getCourse().getCode())) {
        tr.addFailure("error.parameters.needed", "code is null or blank");
      } else {
        tr.addFailure("error.model.notExist", "No found Student in " + teachTask.getCourse().getCode()
            + " of code");
      }
    }
    if (tr.errors() == 0) {
      EntityQuery query = new EntityQuery(TeachCalendar.class, "calendar");
      query.add(new Condition("calendar.year=:year", teachTask.getCalendar().getYear()));
      query.add(new Condition("calendar.term=:term", teachTask.getCalendar().getTerm()));
      TeachCalendar calendar = null;
      List cas = (List) utilService.search(query);
      if (cas.size() > 0) {
        calendar = (TeachCalendar) cas.get(0);
      } else {
        tr.addFailure("日历错误", "日历错误");
        return;
      }
      TeachTask defaultTask = TeachTask.getDefault();
      EntityUtils.evictEmptyProperty(defaultTask);
      /**
       * 教学任务对应的成绩状态
       */
      defaultTask.setGradeState(new GradeState(defaultTask));

      // 计算总学时
      teachTask.getArrangeInfo().calcOverallUnits();
      EntityUtils.merge(defaultTask, teachTask);
      List<Department> departments = utilService.load(Department.class, "code", teachTask.getArrangeInfo()
          .getTeachDepart().getCode());
      if (departments.size() > 0) {
        defaultTask.getArrangeInfo().setTeachDepart((Department) departments.get(0));
      }
      List<Department> department2s = utilService.load(Department.class, "code", teachTask.getTeachClass()
          .getDepart().getCode());
      if (department2s.size() > 0) {
        defaultTask.getTeachClass().setDepart((Department) department2s.get(0));
      }

      // FIXME
      if (null != defaultTask.getArrangeInfo().getSuggest()) {
        defaultTask.getArrangeInfo().getSuggest()
            .setTime(new AvailableTime(AvailableTime.commonTeacherAvailTime));
      }

      List<Course> courses = utilService.load(Course.class, "code", teachTask.getCourse().getCode());
      Course course = courses.get(0);
      defaultTask.setCourse(course);
      if (null != course.getExtInfo().getCourseType()) defaultTask.setCourseType(course.getExtInfo()
          .getCourseType());
      // defaultTask.getTeachClass().setName(course.getName());

      defaultTask.getArrangeInfo().setWeeks(calendar.getWeeks());
      defaultTask.setCalendar(calendar);
      defaultTask.getArrangeInfo().setOverallUnits(course.getExtInfo().getPeriod());
      defaultTask.getArrangeInfo().calcWeekUnits();
      defaultTask.getRequirement().setTeachLangType(new TeachLangType(TeachLangType.CHINESE));
      defaultTask.getRequirement().setEvaluateByTeacher(Boolean.FALSE);
      defaultTask.getRequirement().getRoomConfigType().setId(57L);
      defaultTask.getRequirement().getTeachLangType().setId(1L);
      teachTaskService.saveTeachTask(defaultTask);
    }
  }
}
