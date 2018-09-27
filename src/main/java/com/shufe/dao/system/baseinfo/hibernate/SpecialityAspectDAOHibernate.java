//$Id: SpecialityAspectDAOHibernate.java,v 1.1 2006/08/02 00:53:06 duanth Exp $
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
 * @author chaostone
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * chaostone             2005-9-15         Created
 *  
 ********************************************************************************/

package com.shufe.dao.system.baseinfo.hibernate;

import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import net.ekingstar.common.detail.Pagination;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Example;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;

import com.shufe.dao.BasicHibernateDAO;
import com.shufe.dao.system.baseinfo.SpecialityAspectDAO;
import com.shufe.dao.util.CriterionUtils;
import com.shufe.dao.util.NotEmptyPropertySelector;
import com.shufe.model.system.baseinfo.SpecialityAspect;

public class SpecialityAspectDAOHibernate extends BasicHibernateDAO implements SpecialityAspectDAO {

  /**
   * @see SpecialityAspectDAO#getSpecialityAspect(String)
   */
  public SpecialityAspect getSpecialityAspect(Long id) {
    return (SpecialityAspect) load(SpecialityAspect.class, id);
  }

  /**
   * @see SpecialityAspectDAO#getSpecialityAspects()
   */
  public List getSpecialityAspects() {
    return genSpecialityAspectCriteria(getSession(), null).list();
  }

  /**
   * @see SpecialityAspectDAO#getSpecialityAspects(SpecialityAspect)
   */
  public List getSpecialityAspects(SpecialityAspect aspect) {
    return genSpecialityAspectCriteria(getSession(), aspect).list();
  }

  /**
   * @see SpecialityAspectDAO#getSpecialityAspects(SpecialityAspect, int, int)
   */
  public Pagination getSpecialityAspects(SpecialityAspect aspect, int pageNo, int pageSize) {
    Criteria criteria = genSpecialityAspectCriteria(getSession(), aspect);
    return dynaSearch(criteria, pageNo, pageSize);
  }

  /**
   * @see com.shufe.dao.system.baseinfo.SpecialityAspectDAODWRFacade#getSpecialityAspectNames(java.lang.Long)
   */
  public List getSpecialityAspectNames(Long specialityId) {
    if (null == specialityId) return Collections.EMPTY_LIST;
    else {
      String hql = "select s.id, s.name,s.engName " + "from SpecialityAspect as s"
          + " where s.state=true and s.speciality.id=:specialityId" + " order by s.name";
      Query query = getSession().createQuery(hql);
      query.setParameter("specialityId", specialityId);
      return query.list();
    }
  }

  /**
   * @see com.shufe.dao.system.baseinfo.SpecialityAspectDAO#getAllSpecialityAspects(com.shufe.model.system.baseinfo.SpecialityAspect,
   *      int, int)
   */
  public Pagination getAllSpecialityAspects(SpecialityAspect aspect, int pageNo, int pageSize) {
    Criteria criteria = genSpecialityAspectCriteria(getSession(), aspect);
    getSession().disableFilter("validAspect");
    return dynaSearch(criteria, pageNo, pageSize);
  }

  /**
   * @see SpecialityAspectDAO#removeSpecialityAspect(String)
   */
  public void removeSpecialityAspect(Long id) {
    remove(SpecialityAspect.class, id);
  }

  /**
   * 根据对象构造一个动态查询
   * 
   * @param direction
   * @return
   */
  public static Criteria genSpecialityAspectCriteria(Session session, SpecialityAspect direction) {

    Criteria criteria = session.createCriteria(SpecialityAspect.class);
    if (null != direction) {
      criteria.add(Example.create(direction).setPropertySelector(new NotEmptyPropertySelector())
          .excludeProperty("name").excludeProperty("code"));
      if (null != direction.getId()) {
        criteria.add(Restrictions.eq("id", direction.getId()));
      }
      if (StringUtils.isNotEmpty(direction.getCode())) {
        criteria.add(Restrictions.like("code", direction.getCode(), MatchMode.ANYWHERE));
      }
      if (StringUtils.isNotEmpty(direction.getName())) {
        criteria.add(Restrictions.like("name", direction.getName(), MatchMode.ANYWHERE));
      }
      // 查找同一部门的所有专业方向
      List specialityCriterions = CriterionUtils
          .getEntityCriterions("speciality.", direction.getSpeciality());
      if (!specialityCriterions.isEmpty()) {
        Criteria specialityCriteria = criteria.createCriteria("speciality", "speciality");
        for (Iterator iter = specialityCriterions.iterator(); iter.hasNext();)
          specialityCriteria.add((Criterion) iter.next());
      }
    }
    session.enableFilter("validAspect");
    return criteria;
  }
}
