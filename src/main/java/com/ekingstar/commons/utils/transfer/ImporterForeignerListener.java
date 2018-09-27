package com.ekingstar.commons.utils.transfer;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.model.Entity;
import com.ekingstar.commons.model.EntityUtils;
import com.ekingstar.commons.model.Model;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.transfer.importer.ItemImporterListener;
import com.ekingstar.commons.utils.persistence.UtilDao;
import com.ekingstar.commons.utils.persistence.UtilService;

public class ImporterForeignerListener extends ItemImporterListener {

  protected UtilDao utilDao;

  protected Map foreigersMap = new HashMap();

  private static final int CACHE_SIZE = 500;

  protected String[] foreigerKeys = { "code" };

  public ImporterForeignerListener(UtilService utilService) {
    if (null != utilService) this.utilDao = utilService.getUtilDao();
  }

  public ImporterForeignerListener(UtilDao utilDao) {
    this.utilDao = utilDao;
  }

  public void endTransferItem(TransferResult tr) {
    Object[] values = (Object[]) this.importer.getCurData();

    for (int i = 0; i < this.importer.getAttrs().length; i++) {
      String attr = this.importer.getAttrs()[i];
      int foreigerKeyIndex = 0;
      boolean isforeiger = false;
      for (; foreigerKeyIndex < this.foreigerKeys.length; foreigerKeyIndex++) {
        if (attr.endsWith("." + this.foreigerKeys[foreigerKeyIndex])) {
          isforeiger = true;
          break;
        }
      }
      if (!isforeiger) {
        continue;
      }
      String codeValue = null;
      if (values.length <= i) {
        continue;
      }
      if (null == values[i]) codeValue = null;
      else codeValue = values[i].toString();
      try {
        Object foreiger = null;

        if (StringUtils.isEmpty(codeValue)) {
          continue;
        }
        Object nestedForeigner = null;
        try {
          nestedForeigner = PropertyUtils.getProperty(this.importer.getCurrent(),
              StringUtils.substring(attr, 0, attr.lastIndexOf(".")));
        } catch (Exception e) {
          e.printStackTrace();
          if (e.getMessage().contains("Unknown property")) {
            continue;
          }
        }

        if ((nestedForeigner instanceof Entity)) {
          String className = EntityUtils.getEntityClassName(nestedForeigner.getClass());

          Map foreignerMap = (Map) this.foreigersMap.get(className);
          if (null == foreignerMap) {
            foreignerMap = new HashMap();
            this.foreigersMap.put(className, foreignerMap);
          }
          if (foreignerMap.size() > 500) foreignerMap.clear();
          foreiger = foreignerMap.get(codeValue);
          if (foreiger == null) {
            List foreigners = this.utilDao.load(Class.forName(className),
                this.foreigerKeys[foreigerKeyIndex], new Object[] { codeValue });

            if (!foreigners.isEmpty()) {
              foreiger = foreigners.iterator().next();
              foreignerMap.put(codeValue, foreiger);
            } else {
              tr.addFailure("error.model.notExist", codeValue);
            }
          }
        }
        String parentAttr = StringUtils.substring(attr, 0, attr.lastIndexOf("."));

        Model.populator.populateValue(parentAttr, foreiger, this.importer.getCurrent());
      } catch (Exception e) {
        e.printStackTrace();
        throw new RuntimeException(e.getMessage());
      }
    }
  }

  public void addForeigerKey(String key) {
    String[] foreigers = new String[this.foreigerKeys.length + 1];
    int i = 0;
    for (; i < this.foreigerKeys.length; i++) {
      foreigers[i] = this.foreigerKeys[i];
    }
    foreigers[i] = key;
    this.foreigerKeys = foreigers;
  }
}
