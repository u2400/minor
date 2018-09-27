/**
 * 
 */
package com.shufe.service.course.arrange.base;

import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;

/**
 * 毕业实习基地导出
 * 
 * @author zhouqi
 */
public class PlaceTakePropertyExtractor extends DefaultPropertyExtractor {

  int index = 0;

  public PlaceTakePropertyExtractor() {
    this.index++;
  }

  @Override
  public Object getPropertyValue(Object target, String property) throws Exception {
    if (StringUtils.equals(property, "no")) {
      return this.index++;
    } else {
      return super.getPropertyValue(target, property);
    }
  }
}
