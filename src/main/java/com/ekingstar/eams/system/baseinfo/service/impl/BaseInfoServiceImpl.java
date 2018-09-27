// Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/kpdus/jad.html
// Decompiler options: packimports(3) radix(10) lradix(10) 
// Source File Name:   BaseInfoServiceImpl.java

package com.ekingstar.eams.system.baseinfo.service.impl;

import java.util.List;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.utils.persistence.impl.BaseServiceImpl;
import com.ekingstar.eams.system.baseinfo.BaseInfo;
import com.ekingstar.eams.system.baseinfo.dao.BaseInfoDao;
import com.ekingstar.eams.system.baseinfo.service.BaseInfoService;

public class BaseInfoServiceImpl extends BaseServiceImpl implements BaseInfoService {

  public BaseInfoServiceImpl() {
    queryCacheable = Boolean.TRUE;
  }

  public void setBaseInfoDao(BaseInfoDao baseInfoDao) {
    this.baseInfoDao = baseInfoDao;
  }

  public <T> List<T> getBaseInfos(Class<T> clazz) {
    if ((com.ekingstar.eams.system.baseinfo.BaseInfo.class).isAssignableFrom(clazz)) return baseInfoDao
        .getBaseInfos(clazz);
    else throw new RuntimeException(clazz.getName() + " is not a baseInfo ");
  }

  public BaseInfo getBaseInfo(Class clazz, Long id) {
    EntityQuery query = new EntityQuery(clazz, "info");
    query.add(new Condition("info.id=:infoId", id));
    query.setCacheable(queryCacheable.booleanValue());
    List rs = (List) utilDao.search(query);
    if (!rs.isEmpty()) return (BaseInfo) rs.get(0);
    else return null;
  }

  public Boolean getQueryCacheable() {
    return queryCacheable;
  }

  public void setQueryCacheable(Boolean queryCacheable) {
    this.queryCacheable = queryCacheable;
  }

  private BaseInfoDao baseInfoDao;

  private Boolean queryCacheable;
}

/*
 * DECOMPILATION REPORT
 * Decompiled from:
 * /home/zhouqi/workspace_current/eams_ecupl/src/main/webapp/WEB-INF/lib/eams-system
 * -baseinfo-1.0.6.jar Total time: 112 ms Jad reported messages/errors: Exit status: 0 Caught
 * exceptions:
 */
