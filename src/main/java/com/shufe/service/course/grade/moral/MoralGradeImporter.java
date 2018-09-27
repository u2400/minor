package com.shufe.service.course.grade.moral;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.transfer.importer.ItemImporterListener;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.ekingstar.eams.system.basecode.industry.MarkStyle;
import com.shufe.model.course.grade.Grade;
import com.shufe.model.course.grade.MoralGrade;
import com.shufe.model.course.grade.MoralGradeInputSwitch;
import com.shufe.model.std.Student;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 德育成绩导入
 * 
 * @author chaostone
 */
public class MoralGradeImporter extends ItemImporterListener {

  protected UtilService utilService;

  protected Boolean tutorFlag = Boolean.FALSE;

  private MarkStyle percent;

  public MoralGradeImporter(UtilService utilService, Boolean tutorFlag) {
    this.utilService = utilService;
    this.tutorFlag = tutorFlag;
    percent = (MarkStyle) utilService.get(MarkStyle.class, MarkStyle.PERCENT);
  }

  @Override
  public void startTransfer(TransferResult tr) {
    String[] attrs = importer.getAttrs();
    for (int i = 0; i < attrs.length; i++) {
      if (attrs[i].equals("std.code")) attrs[i] = "stdCode";
      else if (attrs[i].equals("std.name")) attrs[i] = "stdName";
    }
  }

  @SuppressWarnings({ "rawtypes", "unchecked" })
  public void startTransferItem(TransferResult tr) {
    Map params = importer.curDataMap();
    // String code = (String) params.get("code");
    String calendarYear = (String) params.get("calendarYear");
    if (StringUtils.isBlank(calendarYear)) { return; }
    calendarYear = StringUtils.replace(calendarYear, "——", "-");
    String stdCode = (String) params.get("stdCode");
    if (StringUtils.isBlank(stdCode)) { return; }

    Collection<Student> stds = utilService.load(Student.class, "code", stdCode);
    if (CollectionUtils.isEmpty(stds)) { return; }

    Student std = stds.iterator().next();
    String stdName = (String) params.get("stdName");
    if (null != stdName && StringUtils.isNotBlank(stdName) && !stdName.trim().equals(std.getName())) {
      tr.addFailure("学生姓名不正确，应该是" + std.getName(), stdName);
      return;
    }

    EntityQuery calendarQuery = new EntityQuery(TeachCalendar.class, "tc");
    calendarQuery.add(new Condition("tc.term ='2' and tc.year=:year", calendarYear));
    List<TeachCalendar> calendars = (List<TeachCalendar>) utilService.search(calendarQuery);
    if (calendars.isEmpty()) {
      tr.addFailure("error.parameters.needed", calendarQuery);
      return;
    }

    TeachCalendar calendar = calendars.get(0);
    EntityQuery mgQuery = new EntityQuery(MoralGrade.class, "mg");
    mgQuery.add(new Condition("mg.calendar=:calendar", calendar));
    mgQuery.add(new Condition("mg.std.code=:stdCode", stdCode));

    List<MoralGrade> moralGrades = (List<MoralGrade>) utilService.search(mgQuery);

    MoralGrade moralGrade = new MoralGrade();
    moralGrade.setStatus(Grade.CONFIRMED);
    if (CollectionUtils.isNotEmpty(moralGrades)) {
      moralGrade = moralGrades.get(0);
    } else {
      moralGrade.setCreateAt(new Date());
    }
    if (moralGrade.getStatus() == Grade.PUBLISHED) {
      tr.addFailure("成绩已经发布", std.getCode());
    } else {
      moralGrade.setCalendar(calendar);
      moralGrade.setStd(std);
      moralGrade.setMarkStyle(percent);
      moralGrade.updateScore(Float.valueOf(params.get("score").toString()));
      if (null != params.get("remark")) moralGrade.setRemark(params.get("remark").toString());
    }
    importer.setCurrent(moralGrade);
  }

  public void endTransferItem(TransferResult tr) {
    MoralGrade moralGrade = (MoralGrade) importer.getCurrent();
    int errors = tr.errors();
    if (moralGrade.getCalendar() == null) tr.addFailure("error.parameters.needed", "MoralGrade calendarYear");
    if (moralGrade.getStd() == null) tr.addFailure("error.parameters.needed", "MoralGrade stdCode");
    if (moralGrade.getScore() == null) tr.addFailure("error.parameters.needed", "MoralGrade score");
    if (Boolean.TRUE.equals(tutorFlag)) {
      if (null != moralGrade.getCalendar() && !this.isOpen(moralGrade.getCalendar())) {
        tr.addFailure("error.parameters.needed", "MoralGrade import swith no open");
      }
    }
    if (tr.errors() == errors) utilService.saveOrUpdate(moralGrade);
  }

  private boolean isOpen(TeachCalendar calendar) {
    EntityQuery query = new EntityQuery(MoralGradeInputSwitch.class, "switch");
    query.add(new Condition("switch.calendar = :calendar", calendar));
    query.add(new Condition("switch.opened=true"));
    query.add(new Condition(":now between switch.beginOn and switch.endOn", new Date()));
    query.setCacheable(true);
    return !utilService.search(query).isEmpty();
  }
}
