/**
 * 
 */
package com.ekingstar.commons.transfer.importer;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.model.Entity;

/**
 * @author zhouqi
 */
public class StudentAlterationImporter extends DefaultEntityImporter {

  public StudentAlterationImporter(Class entityClass) {
    super(entityClass);
  }

  protected List checkAttrs() {
    List errorAttrs = new ArrayList();
    try {
      Entity example = (Entity) this.entityClass.newInstance();
      for (int i = 0; i < this.attrs.length; i++) {
        if (StringUtils.isBlank(this.attrs[i])) {
          continue;
        }
        if (StringUtils.contains(this.attrs[i], "adminClassAfter.code")) {
          continue;
        }
        try {
          this.populator.initPropertyPath(this.attrs[i], example, this.entityName);
        } catch (Exception e) {
          errorAttrs.add(this.attrs[i]);
        }
      }
    } catch (Exception e) {
      if (logger.isDebugEnabled()) {
        logger.error(this.entityClass.toString(), e);
      }
    }
    return errorAttrs;
  }
}
