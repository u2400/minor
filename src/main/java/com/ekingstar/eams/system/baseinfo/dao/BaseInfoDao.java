// Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/kpdus/jad.html
// Decompiler options: packimports(3) radix(10) lradix(10) 
// Source File Name:   BaseInfoDao.java

package com.ekingstar.eams.system.baseinfo.dao;

import java.util.List;

public interface BaseInfoDao {

  public abstract <T> List<T> getBaseInfos(Class<T> class1);
}

/*
 * DECOMPILATION REPORT
 * Decompiled from:
 * /home/zhouqi/workspace_current/eams_ecupl/src/main/webapp/WEB-INF/lib/eams-system
 * -baseinfo-1.0.6.jar Total time: 320 ms Jad reported messages/errors: Exit status: 0 Caught
 * exceptions:
 */
