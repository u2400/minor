//$Id: OtherExamSignUpImporterListener.java,v 1.1 2012-7-10 zhouqi Exp $
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
 * zhouqi				2012-7-10             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.service.course.grade.other;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.transfer.importer.ItemImporterListener;
import com.ekingstar.commons.utils.persistence.UtilDao;
import com.shufe.model.course.grade.other.OtherExamSignUp;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 报名导入
 * 
 * @author zhouqi
 */
public class OtherExamSignUpImporterListener extends ItemImporterListener {

  protected UtilDao utilDao;

  private Map<String, OtherExamSignUp> otherExamSignUpMap = new HashMap<String, OtherExamSignUp>();

  private Map<String, TeachCalendar> teachCalendarMap = new HashMap<String, TeachCalendar>();

  private Map<String, List<Integer>> duplicateMap = new HashMap<String, List<Integer>>();

  private int proviousErrorCount = 0;

  public void startTransfer(TransferResult tr) {
    teachCalendarMap.clear();
    duplicateMap.clear();
    proviousErrorCount = 0;
    otherExamSignUpMap.clear();
  }

  public void startTransferItem(TransferResult tr) {
    // 物理性验证
    checkMustBeParams(tr, "std.code");
    checkMustBeParams(tr, "category.code");
    checkMustBeParams(tr, "calendar.studentType.code");
    checkMustBeParams(tr, "calendar.year");
    checkMustBeParams(tr, "calendar.term");
  }

  /**
   * 检查必填项
   * 
   * @param tr
   * @param key
   */
  private void checkMustBeParams(TransferResult tr, String key) {
    if (importer.curDataMap().containsKey(key)) {
      if (StringUtils.isBlank(String.valueOf(importer.curDataMap().get(key)))) {
        tr.addFailure("error.parameters.needed", key + " is null");
      }
    } else {
      tr.addFailure("error.parameters.illegal", "std.code");
    }
  }

  public void endTransferItem(TransferResult tr) {
    OtherExamSignUp otherExamSignUp = (OtherExamSignUp) importer.getCurrent();

    // 若物理性检验有错误，将停止本行其余事项，而转入下一行
    if (proviousErrorCount != tr.errors()) {
      proviousErrorCount = tr.errors();
      return;
    }

    // 教学日历Key
    String calendarKey = importer.curDataMap().get("calendar.studentType.code") + "_"
        + importer.curDataMap().get("calendar.year") + "_" + importer.curDataMap().get("calendar.term");

    // 报名对象Key
    String signUpKey = importer.curDataMap().get("std.code") + "_"
        + importer.curDataMap().get("category.code") + "_" + calendarKey;
    // 检查是否重复导入
    List<Integer> duplicates = duplicateMap.get(signUpKey);
    if (CollectionUtils.isEmpty(duplicates)) {
      duplicates = new ArrayList<Integer>();
      duplicateMap.put(signUpKey, duplicates);
    }
    duplicates.add(new Integer(tr.getTransfer().getTranferIndex()));
    if (CollectionUtils.isNotEmpty(duplicates) && duplicates.size() > 1) {
      StringBuilder duplicateIndexSeq = new StringBuilder();
      for (Integer index : duplicates) {
        duplicateIndexSeq.append(index).append(" ");
      }
      tr.addFailure("导入数据重复",
          "Row index : " + StringUtils.replace(StringUtils.trim(duplicateIndexSeq.toString()), " ", ", "));
      proviousErrorCount = tr.errors();
      return;
    }

    // 检查教学日历有效性
    TeachCalendar calendar = teachCalendarMap.get(calendarKey);
    if (null == calendar) {
      EntityQuery query = new EntityQuery(TeachCalendar.class, "calendar");
      query.add(new Condition("calendar.studentType.code = :stdTypeCode", importer.curDataMap().get(
          "calendar.studentType.code")));
      query.add(new Condition("calendar.year = :year", importer.curDataMap().get("calendar.year")));
      query.add(new Condition("calendar.term = :term", importer.curDataMap().get("calendar.term")));
      Collection<TeachCalendar> calendars = utilDao.search(query);
      if (CollectionUtils.isEmpty(calendars)) {
        tr.addFailure(
            "error.model.notExist",
            "[" + importer.curDataMap().get("calendar.studentType.code") + " "
                + importer.curDataMap().get("calendar.year") + " "
                + importer.curDataMap().get("calendar.term") + "] is not exist in TeachCalendar.");
        proviousErrorCount = tr.errors();
        return;
      }
      calendar = calendars.iterator().next();
      teachCalendarMap.put(calendarKey, calendar);
    }
    otherExamSignUp.setCalendar(calendar);

    // 检查导入的对象是否与现有的冲突
    EntityQuery query = new EntityQuery(OtherExamSignUp.class, "signUp");
    query.add(new Condition("signUp.std = :std", otherExamSignUp.getStd()));
    query.add(new Condition("signUp.calendar = :calendar", otherExamSignUp.getCalendar()));
    query.add(new Condition("signUp.category = :category", otherExamSignUp.getCategory()));
    if (CollectionUtils.isNotEmpty(utilDao.search(query))) {
      tr.addFailure("error.model.existed", importer.curDataMap().get("std.code") + " in Student, "
          + importer.curDataMap().get("category.code") + "(" + otherExamSignUp.getCategory().getName()
          + ") in OtherExamCategory and [" + importer.curDataMap().get("calendar.studentType.code") + " "
          + importer.curDataMap().get("calendar.year") + " " + importer.curDataMap().get("calendar.term")
          + "] in TeachCalendar is existed.");
      proviousErrorCount = tr.errors();
      return;
    }

    otherExamSignUp.setSignUpAt(new Date());

    // 暂存有效对象，将最后一次性保存
    otherExamSignUpMap.put(signUpKey, otherExamSignUp);
  }

  public void endTransfer(TransferResult tr) {
    if (MapUtils.isNotEmpty(otherExamSignUpMap)) {
      utilDao.saveOrUpdate(otherExamSignUpMap.values());
    }
  }

  public void setUtilDao(UtilDao utilDao) {
    this.utilDao = utilDao;
  }
}
