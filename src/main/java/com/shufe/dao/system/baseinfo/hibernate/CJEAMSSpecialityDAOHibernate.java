//$Id: SpecialityDAOHibernate.java,v 1.2 2007/01/05 01:22:42 duanth Exp $
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
import java.util.List;

import org.hibernate.Query;

import com.ekingstar.eams.system.baseinfo.StudentType;

public class CJEAMSSpecialityDAOHibernate extends SpecialityDAOHibernate {

  /**
   * @see com.shufe.dao.system.baseinfo.SpecialityDAODWRFacade#getSpecialityNames(java.lang.Long,
   *      java.lang.Long)
   */
  public List getSpecialityNames(Long departId, Long stdTypeId, Long majorTypeId) {
    if (null == departId) return Collections.EMPTY_LIST;
    StringBuffer hql = new StringBuffer("select s.id,s.name,s.engName"
        + " from Speciality as s where s.state=true");
    if (null != majorTypeId) {
      hql.append(" and s.majorType.id=:majorTypeId");
    }
    if (null != stdTypeId) hql.append(" and s.stdType.id=:stdTypeId");
    hql.append(" order by s.name");
    Query query = getSession().createQuery(hql.toString());
    if (null != majorTypeId) {
      query.setParameter("majorTypeId", majorTypeId);
    }
    // 级联查找,首先查找上级的基础类别
    if (null != stdTypeId) {
      StudentType type = (StudentType) get(StudentType.class, stdTypeId);
      if (null == type) {
        return Collections.EMPTY_LIST;
      } else {
        List rs = Collections.EMPTY_LIST;
        while (type != null) {
          query.setParameter("stdTypeId", type.getId());
          rs = query.list();
          if (!rs.isEmpty()) {
            return rs;
          } else {
            if (type.getSuperType() == type) {
              return rs;
            } else {
              type = (StudentType) type.getSuperType();
            }
          }
        }
        return rs;
      }
    }
    throw new RuntimeException();
  }
}
