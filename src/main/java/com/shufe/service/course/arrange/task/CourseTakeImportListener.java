//$Id: CourseTakeImportListener.java,v 1.1 2012-10-22 zhouqi Exp $
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
 * zhouqi				2012-10-22             Created
 *  
 ********************************************************************************/

package com.shufe.service.course.arrange.task;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.transfer.importer.ItemImporterListener;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.ekingstar.eams.system.basecode.industry.CourseTakeType;
import com.shufe.model.course.arrange.task.CourseTake;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.system.calendar.TeachCalendar;

public class CourseTakeImportListener extends ItemImporterListener {

  protected UtilService utilService;

  protected TeachCalendar calendar;

  protected Collection<Object> errs = new ArrayList<Object>();

  private Map<String, Student> studentMap = new HashMap<String, Student>();

  private Map<String, TeachTask> taskMap = new HashMap<String, TeachTask>();

  private Map<String, CourseTakeType> takeTypeMap = new HashMap<String, CourseTakeType>();

  public CourseTakeImportListener() {
    super();
  }

  public CourseTakeImportListener(TeachCalendar calendar, UtilService utilService) {
    this();
    this.calendar = calendar;
    this.utilService = utilService;
  }

  public void startTransferItem(TransferResult tr) {
    Map<String, Object> params = importer.curDataMap();

    // 第一步，验证必填
    String stdCode = (String) params.get("student.code");
    if (StringUtils.isEmpty(stdCode)) {
      tr.addFailure("error.parameters.needed", "student.code is empty!");
    }

    String seqNo = (String) params.get("task.seqNo");
    if (StringUtils.isEmpty(seqNo)) {
      tr.addFailure("error.parameters.needed", "task.seqNo is empty!");
    }

    String courseTakeTypeCode = (String) params.get("courseTakeType.code");
    if (StringUtils.isEmpty(courseTakeTypeCode)) {
      tr.addFailure("error.parameters.needed", "courseTakeType.code is empty!");
    }

    // 第二步，验证有效性
    Student student = null;
    TeachTask task = null;
    if (!tr.hasErrors()) {
      student = studentMap.get(stdCode);
      if (null == student) {
        Collection<Student> students = utilService.load(Student.class, "code", stdCode);
        if (CollectionUtils.isEmpty(students)) {
          tr.addFailure("error.model.notExist",
              "Not found student code is <span style=\"color:red;font-weight:bold\">" + stdCode + "</span>.");
        } else {
          student = students.iterator().next();
          studentMap.put(stdCode, student);
        }
      }

      task = taskMap.get(seqNo);
      if (null == task) {
        Collection<TeachTask> tasks = utilService.load(TeachTask.class,
            new String[] { "seqNo", "calendar.id" }, new Object[] { seqNo, calendar.getId() });
        if (CollectionUtils.isEmpty(tasks)) {
          tr.addFailure("error.model.notExist",
              "Not found task no is <span style=\"color:red;font-weight:bold\">" + seqNo + "</span> in ["
                  + calendar.getYear() + " " + calendar.getTerm() + "] TeachCalendar.");
        } else {
          task = tasks.iterator().next();
          taskMap.put(seqNo, task);
        }
      }

      CourseTakeType courseTakeType = takeTypeMap.get(stdCode);
      if (null == courseTakeType) {
        Collection<CourseTakeType> courseTakeTypes = utilService.load(CourseTakeType.class, "code",
            courseTakeTypeCode);
        if (CollectionUtils.isEmpty(courseTakeTypes)) {
          tr.addFailure("error.model.notExist",
              "Not found CourseTakeType code is <span style=\"color:red;font-weight:bold\">"
                  + courseTakeTypeCode + "</span>.");
        } else {
          courseTakeType = courseTakeTypes.iterator().next();
          takeTypeMap.put(courseTakeTypeCode, courseTakeType);
        }
      }
    }

    // 第三步，是否同学期重复指定
    if (!tr.hasErrors()) {
      EntityQuery query = new EntityQuery(CourseTake.class, "take");
      query.add(new Condition("take.student = :student", student));
      query.add(new Condition("take.task.calendar = :calendar", calendar));
      query.add(new Condition("take.task = :task", task));
      if (CollectionUtils.isNotEmpty(utilService.search(query))) {
        tr.addFailure(
            "error.data.exists",
            "CourseTake been exists in student code \"<span style=\"color:red;font-weight:bold\">"
                + student.getCode() + "</span>\" and task no \"<span style=\"color:red;font-weight:bold\">"
                + task.getSeqNo() + "</span>\" with [" + calendar.getYear() + " " + calendar.getTerm()
                + "] TeachCalendar.");
      }
    }
  }

  public void endTransferItem(TransferResult tr) {
    Map<String, Object> params = importer.curDataMap();

    String stdCode = (String) params.get("student.code");
    String seqNo = (String) params.get("task.seqNo");
    String courseTakeTypeCode = (String) params.get("courseTakeType.code");

    utilService.saveOrUpdate(new CourseTake(taskMap.get(seqNo), studentMap.get(stdCode), takeTypeMap
        .get(courseTakeTypeCode)));
  }
}
