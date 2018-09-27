// Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/kpdus/jad.html
// Decompiler options: packimports(3) radix(10) lradix(10) 
// Source File Name:   BaseInfoService.java

package com.ekingstar.eams.system.baseinfo.service;

import com.ekingstar.eams.system.baseinfo.BaseInfo;
import java.util.List;

public interface BaseInfoService {

  public abstract <T> List<T> getBaseInfos(Class<T> class1);

  public abstract BaseInfo getBaseInfo(Class class1, Long long1);
}

/*
 * DECOMPILATION REPORT
 * Decompiled from:
 * /home/zhouqi/workspace_current/eams_ecupl/src/main/webapp/WEB-INF/lib/eams-system
 * -baseinfo-1.0.6.jar Total time: 102 ms Jad reported messages/errors: Exit status: 0 Caught
 * exceptions:
 */
