package com.shufe.service.course.textbook.impl;

import java.util.List;
import java.util.Map;

import com.ekingstar.commons.model.EntityUtils;
import com.ekingstar.commons.model.predicate.ValidEntityKeyPredicate;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.transfer.importer.ItemImporterListener;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.shufe.model.course.textbook.Textbook;

public class TextbookImportListener extends ItemImporterListener {
  ;
  private UtilService utilService;

  public TextbookImportListener(UtilService utilService) {
    this.utilService = utilService;
  }

  public void startTransferItem(TransferResult tr) {
    Map params = importer.curDataMap();
    String code = (String) params.get("code");
    if (ValidEntityKeyPredicate.INSTANCE.evaluate(code)) {
      List textbooks = (List) utilService.load(Textbook.class, "code", code);
      if (textbooks.size() == 1) importer.setCurrent(textbooks.get(0));
    }
  }

  public void endTransferItem(TransferResult tr) {
    Textbook book = (Textbook) importer.getCurrent();
    EntityUtils.evictEmptyProperty(book);
    utilService.saveOrUpdate(importer.getCurrent());
  }
}
