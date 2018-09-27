/*jadclipse*/// Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/kpdus/jad.html
// Decompiler options: packimports(3) radix(10) lradix(10) 
// Source File Name:   UtilService.java

package com.ekingstar.commons.utils.persistence;

import com.ekingstar.commons.model.Entity;
import com.ekingstar.commons.query.AbstractQuery;
import com.ekingstar.commons.query.limit.Page;
import com.ekingstar.commons.query.limit.PageLimit;
import java.io.Serializable;
import java.util.*;
import org.hibernate.Criteria;
import org.hibernate.Query;

// Referenced classes of package com.ekingstar.commons.utils.persistence:
//            UtilDao

public interface UtilService {

  public abstract Entity load(Class class1, Serializable serializable);

  public abstract List load(Class class1, String s, Collection collection);

  public abstract <T> List<T> load(Class<T> entity, String attr, Object values[]);

  public abstract List load(String s, String s1, Object aobj[]);

  public abstract List load(Class class1, String s, Object obj);

  public abstract List load(Class class1, String as[], Object aobj[]);

  public abstract List load(Class class1, Map map);

  public abstract List loadAll(Class class1);

  public abstract Entity get(Class class1, Serializable serializable);

  public abstract Entity get(String s, Serializable serializable);

  public abstract Collection search(AbstractQuery abstractquery);

  public abstract List searchNamedQuery(String s, Map map);

  public abstract List searchNamedQuery(String s, Object aobj[]);

  public abstract List searchNamedQuery(String s, Map map, boolean flag);

  public abstract List searchHQLQuery(String s);

  public abstract List searchHQLQuery(String s, Map map);

  public abstract List searchHQLQuery(String s, Object aobj[]);

  public abstract List searchHQLQuery(String s, Map map, boolean flag);

  public abstract Page paginateNamedQuery(String s, Map map, PageLimit pagelimit);

  public abstract Page paginateHQLQuery(String s, Map map, PageLimit pagelimit);

  public abstract Page paginateCriteria(Criteria criteria, PageLimit pagelimit);

  public abstract Page paginateQuery(Query query, Map map, PageLimit pagelimit);

  public abstract void remove(Object obj);

  public abstract void remove(Collection collection);

  public abstract boolean remove(Class class1, String s, Object aobj[]);

  public abstract boolean remove(Class class1, String s, Collection collection);

  public abstract boolean remove(Class class1, Map map);

  public abstract int update(Class class1, String s, Object aobj[], Map map);

  public abstract int update(Class class1, String s, Object aobj[], String as[], Object aobj1[]);

  public abstract void saveOrUpdate(Object obj);

  public abstract void saveOrUpdate(String s, Object obj);

  public abstract void evict(Object obj);

  public abstract void refresh(Object obj);

  public abstract void initialize(Object obj);

  public abstract boolean exist(Class class1, String s, Object obj);

  public abstract boolean exist(String s, String s1, Object obj);

  public abstract boolean exist(Class class1, String as[], Object aobj[]);

  public abstract int count(Class class1, String s, Object obj);

  public abstract int count(String s, String s1, Object obj);

  public abstract int count(Class class1, String as[], Object aobj[], String s);

  public abstract boolean duplicate(Class class1, Long long1, String s, Object obj);

  public abstract boolean duplicate(String s, Long long1, Map map);

  public abstract void setUtilDao(UtilDao utildao);

  public abstract UtilDao getUtilDao();
}

/*
 * DECOMPILATION REPORT
 * Decompiled from:
 * /home/zhouqi/workspace_current/eams_ecupl/src/main/webapp/WEB-INF/lib/ekingstar-commons
 * -utils-1.1.3-3.jar Total time: 228 ms Jad reported messages/errors: Exit status: 0 Caught
 * exceptions:
 */
