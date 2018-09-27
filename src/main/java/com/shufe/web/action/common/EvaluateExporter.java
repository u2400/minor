//$Id: EvaluateExporter.java,v 1.1 2008-6-19 下午05:43:38 zhouqi Exp $
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
 * zhouqi              2008-6-19             Created
 *  
 ********************************************************************************/

package com.shufe.web.action.common;

import java.text.DecimalFormat;
import java.util.Map;

import com.ekingstar.commons.transfer.TransferMessage;
import com.ekingstar.commons.transfer.exporter.DefaultEntityExporter;
import com.ekingstar.commons.transfer.exporter.PropertyExtractor;
import com.shufe.model.quality.evaluate.stat.QuestionTeacherStat;

/**
 * @author zhouqi
 */
public class EvaluateExporter extends DefaultEntityExporter {

  /**
   * 导入属性
   */
  protected String[] attrs;

  /**
   * 属性提取器
   */
  protected PropertyExtractor propertyExtractor;

  private DecimalFormat df = new DecimalFormat("0.00");

  /**
   * 转换单个实体
   */
  public void transferItem() {
    Object[] data = (Object[]) getCurrent();
    Map questionMap = ((Map) data[1]);
    int maxQuestionCount = ((Integer) context.getDatas().get("maxQuestionCount")).intValue();
    Object[] values = new Object[this.attrs.length + maxQuestionCount];
    for (int i = 0; i < attrs.length - 1; i++) {
      try {
        values[i] = propertyExtractor.getPropertyValue(data[0], attrs[i]);
      } catch (Exception e) {
        transferResult.addFailure(TransferMessage.ERROR_ATTRS_EXPORT, "occur in get property :" + attrs[i]
            + " and exception:" + e.getMessage());
      }
    }
    for (int i = attrs.length - 1; (i - attrs.length + 1) <= maxQuestionCount; i++) {
      QuestionTeacherStat questionStat = (QuestionTeacherStat) questionMap.get((i - attrs.length + 1) + "");
      if (null != questionStat) {
        values[i] = df.format(questionStat.getEvgPoints());
      }
    }
    try {
      values[values.length - 1] = propertyExtractor.getPropertyValue(data[0], attrs[attrs.length - 1]);
    } catch (Exception e) {
      transferResult.addFailure(TransferMessage.ERROR_ATTRS_EXPORT, "occur in get property :"
          + attrs[attrs.length - 1] + " and exception:" + e.getMessage());
    }
    writer.write(values);
  }

  public PropertyExtractor getPropertyExtractor() {
    return propertyExtractor;
  }

  public void setPropertyExtractor(PropertyExtractor propertyExporter) {
    this.propertyExtractor = propertyExporter;
  }

  protected void beforeExport() {
    int maxQuestionCount = ((Integer) context.getDatas().get("maxQuestionCount")).intValue();
    String[] exportTitles = new String[titles.length + maxQuestionCount];
    for (int i = 0; i < exportTitles.length - 1; i++) {
      if (i >= titles.length - 1) {
        exportTitles[i] = String.valueOf(i - titles.length + 2);
      } else {
        exportTitles[i] = titles[i];
      }
    }
    exportTitles[exportTitles.length - 1] = titles[titles.length - 1];
    writer.writeTitle(exportTitles);
  }

  public String[] getAttrs() {
    return attrs;
  }

  public void setAttrs(String[] attrs) {
    this.attrs = attrs;
  }
}
