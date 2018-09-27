package com.shufe.service.course.textbook.impl;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.model.EntityUtils;
import com.ekingstar.commons.model.predicate.ValidEntityKeyPredicate;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.transfer.importer.ItemImporterListener;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.ekingstar.eams.system.baseinfo.model.Course;
import com.shufe.model.course.textbook.Textbook;

public class CourseTextbookImportListener extends ItemImporterListener {
  ;
  private UtilService utilService;

  public CourseTextbookImportListener(UtilService utilService) {
    this.utilService = utilService;
  }

  public void startTransferItem(TransferResult tr) {
    Map params = importer.curDataMap();
    String code = (String) params.get("course.code");
    if (ValidEntityKeyPredicate.INSTANCE.evaluate(code)) {

      List courses = (List) utilService.load(Course.class, "code", code);
      if (courses.size() == 1) {
        com.shufe.model.system.baseinfo.Course course = (com.shufe.model.system.baseinfo.Course) courses
            .get(0);
        String textbookCodes = (String) params.get("textbook.codes");
        textbookCodes = textbookCodes.replace("  ", ",");
        textbookCodes = textbookCodes.replace(" ", ",");
        textbookCodes = textbookCodes.replace("，", ",");
        String[] textbookCodeArray = StringUtils.split(textbookCodes, ',');
        List textbooks = (List) utilService.load(Textbook.class, "code", Arrays.asList(textbookCodeArray));
        if (textbooks.size() != textbookCodeArray.length) {
          tr.addFailure("不能找到对应的教材代码或数量不正确", textbookCodes);
        } else {
          course.getTextbooks().clear();
          course.getTextbooks().addAll(textbooks);
          utilService.saveOrUpdate(course);
          // importer.setCurrent(course);
        }
      } else {
        tr.addFailure("不能找到对应的课程代码", code);
      }
    }
  }

  public void endTransferItem(TransferResult tr) {
//    Textbook book = (Textbook) importer.getCurrent();
//    EntityUtils.evictEmptyProperty(book);
//    utilService.saveOrUpdate(importer.getCurrent());
  }
}
