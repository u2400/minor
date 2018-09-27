// Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/kpdus/jad.html
// Decompiler options: packimports(3) radix(10) lradix(10) 
// Source File Name:   BaseInfoDaoHibernate.java

package com.ekingstar.eams.system.baseinfo.dao.hibernate;

import java.util.List;

import org.hibernate.Query;

import com.ekingstar.commons.utils.persistence.hibernate.BaseDaoHibernate;
import com.ekingstar.eams.system.baseinfo.dao.BaseInfoDao;

public class BaseInfoDaoHibernate extends BaseDaoHibernate implements BaseInfoDao {

  public BaseInfoDaoHibernate() {
  }

  public <T> List<T> getBaseInfos(Class<T> infoClass) {
    Query query = getSession().createQuery("from " + infoClass.getName() + " where state=true order by code");
    query.setCacheable(true);
    return query.list();
  }
}

/*
 * DECOMPILATION REPORT
 * Decompiled from:
 * /home/zhouqi/workspace_current/eams_ecupl/src/main/webapp/WEB-INF/lib/eams-system
 * -baseinfo-1.0.6.jar Total time: 161 ms Jad reported messages/errors: Exit status: 0 Caught
 * exceptions:
 */
