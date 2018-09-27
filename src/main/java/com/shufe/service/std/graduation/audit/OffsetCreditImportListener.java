package com.shufe.service.std.graduation.audit;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.transfer.importer.ItemImporterListener;
import com.ekingstar.commons.utils.persistence.UtilDao;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.ekingstar.eams.std.graduation.audit.model.AuditResult;
import com.ekingstar.eams.std.graduation.audit.model.OffsetCredit;
import com.ekingstar.eams.system.basecode.industry.CourseType;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.shufe.model.std.Student;

public class OffsetCreditImportListener extends ItemImporterListener {

  private UtilDao utilDao;

  public OffsetCreditImportListener() {
    super();
  }

  public OffsetCreditImportListener(UtilDao utilDao) {
    super();
    this.utilDao = utilDao;
  }

  public void startTransferItem(TransferResult tr) {
    // 导入冲抵学分的每一项的检查
    Map datas = importer.curDataMap();
    OffsetCredit credit = new OffsetCredit();
    if (null == datas.get("std.code") || ((String) datas.get("std.code")).isEmpty()) {// 检查该学生是否存在
      tr.addFailure("学号为空", importer.curDataMap().get("std.code"));
      return;
    }
    /*
     * if (null == datas.get("courseType.name")) {// 检查课程类别是否存在
     * tr.addFailure("课程类别为空", importer.curDataMap().get("courseType.name"));
     * }
     */
    EntityQuery query = new EntityQuery(OffsetCredit.class, "chongDiCredit");
    query.add(new Condition("chongDiCredit.std.code=:stdCode", datas.get("std.code")));
    /*
     * query.add(new Condition("chongDiCredit.courseType.name=:courseTypeName",
     * datas.get("courseType.name")
     * .toString()));
     */
    List chongDiCredits = (List) utilDao.search(query);
    if (chongDiCredits.size() > 0) {
      credit = (OffsetCredit) chongDiCredits.get(0);
    }
    EntityQuery studentQuery = new EntityQuery(Student.class, "student");
    studentQuery.add(new Condition("student.code=:stdCode", datas.get("std.code")));
    List students = (List) utilDao.search(studentQuery);
    if (students.size() == 0) {
      tr.addFailure("没有该学生", importer.curDataMap().get("std.code"));
      return;
    } else {
      credit.setStd((Student) students.get(0));
    }

    /*
     * EntityQuery courseTypeQuery = new EntityQuery(CourseType.class, "courseType");
     * courseTypeQuery.add(new Condition("courseType.name=:name", datas.get("courseType.name")));
     * List courseTypes = (List)utilDao.search(courseTypeQuery);
     * if(courseTypes.size()==0)
     * tr.addFailure("没有该课程类别", importer.curDataMap().get("courseType.name"));
     * else
     * credit.setCourseType((CourseType)courseTypes.get(0));
     */
    String offsetCredit = (String) datas.get("offsetCredit");
    if (offsetCredit == null || offsetCredit.isEmpty()) {
      tr.addFailure("冲抵学分为空", importer.curDataMap().get("offsetCredit"));
      return;
    } else if (Float.parseFloat(offsetCredit) < 0) {
      tr.addFailure("冲抵学分为非负数", importer.curDataMap().get("offsetCredit"));
      return;
    } else {
      credit.setOffsetCredit(Float.parseFloat(offsetCredit));
    }
    String remark = (String) importer.curDataMap().get("remark");
    if (null == remark) {
      remark = "";
    }
    credit.setRemark(remark);
    importer.setCurrent(credit);

  }

  public void endTransferItem(TransferResult tr) {
    OffsetCredit chongDiCredit = (OffsetCredit) importer.getCurrent();
    if (chongDiCredit.getOffsetCredit() == null) {
      chongDiCredit.setOffsetCredit(Float.parseFloat("0"));
    }
    utilDao.saveOrUpdate(chongDiCredit);// 直接保存
  }

  public void setUtilDao(UtilDao utilDao) {
    this.utilDao = utilDao;
  }
}
