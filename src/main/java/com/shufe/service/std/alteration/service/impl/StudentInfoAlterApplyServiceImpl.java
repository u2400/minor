package com.shufe.service.std.alteration.service.impl;

import java.util.Collection;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.query.EntityQuery;
import com.shufe.model.std.alteration.StudentPropertyMeta;
import com.shufe.service.BasicService;
import com.shufe.service.std.alteration.service.StudentInfoAlterApplyService;

public class StudentInfoAlterApplyServiceImpl extends BasicService implements StudentInfoAlterApplyService {

  public String getString(StudentPropertyMeta meta, String value) {
    if (meta.getCode().endsWith(".id")) {
      if (StringUtils.isEmpty(value)) {
        return null;
      } else {
        EntityQuery query = new EntityQuery("from " + meta.getValueType() + " where id = " + value);
        Collection<?> rs = this.utilDao.search(query);
        Object obj = rs.iterator().next();
        try {
          return (String) PropertyUtils.getSimpleProperty(obj, "name");
        } catch (Exception e) {
          e.printStackTrace();
          return "";
        }
      }
    } else {
      return value;
    }
  }

  public Object get(StudentPropertyMeta meta, String value) {
    if (meta.getCode().endsWith(".id")) {
      if (StringUtils.isEmpty(value)) {
        return null;
      } else {
        EntityQuery query = new EntityQuery("from " + meta.getValueType() + " where id = " + value);
        Collection<?> rs = this.utilDao.search(query);
        return rs.iterator().next();
      }
    } else {
      return value;
    }
  }
}
