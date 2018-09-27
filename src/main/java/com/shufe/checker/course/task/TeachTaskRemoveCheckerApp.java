package com.shufe.checker.course.task;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;

public class TeachTaskRemoveCheckerApp extends TeachTaskRemoveCheckerHead {

  public boolean check() {
    boolean result = CollectionUtils.isNotEmpty(checkerEntities);
    if (result) {
      for (CheckerEntity<?> checkerEntity : checkerEntities) {
        result &= canBeRemove(checkerEntity);
        if (!result) {
          break;
        }
      }
    }
    return result;
  }

  protected boolean canBeRemove(CheckerEntity<?> checkerEntity) {
    String shortName = StringUtils.lowerCase(checkerEntity.getClazz().getSimpleName());
    EntityQuery query = new EntityQuery(checkerEntity.getClazz(), shortName);
    if (null == checkerEntity.getStatement() || checkerEntity.getStatement().length() == 0) {
      query.add(new Condition(shortName + "." + checkerEntity.getPropertName() + " in (:"
          + checkerEntity.getPropertName() + "s)", tasks));
    } else {
      query.add(new Condition(checkerEntity.getStatement().toString(), tasks));
    }
    return CollectionUtils.isEmpty(utilService.search(query));
  }
}
