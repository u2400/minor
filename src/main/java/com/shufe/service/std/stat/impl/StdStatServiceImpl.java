//$Id: StdStatServiceImpl.java,v 1.1 2007-4-2 上午09:28:45 chaostone Exp $
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
 * Name           Date          Description 
 * ============         ============        ============
 *chaostone      2007-4-2         Created
 *  
 ********************************************************************************/

package com.shufe.service.std.stat.impl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.eams.system.baseinfo.StudentType;
import com.shufe.model.std.Student;
import com.shufe.model.std.alteration.StudentAlteration;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.model.system.security.DataRealm;
import com.shufe.service.BasicService;
import com.shufe.service.std.stat.StdStatService;
import com.shufe.service.util.stat.StatGroup;
import com.shufe.service.util.stat.StatHelper;
import com.shufe.util.DataRealmUtils;

public class StdStatServiceImpl extends BasicService implements StdStatService {

  public List statOnCampusByStdType(DataRealm dataRealm) {

    return statOnCampusByStdTypeAndDepart(dataRealm, new Class[] { StudentType.class });
  }

  public List statOnCampusByDepart(DataRealm dataRealm) {
    return statOnCampusByStdTypeAndDepart(dataRealm, new Class[] { Department.class });
  }

  public List statOnCampusByStdTypeDepart(DataRealm dataRealm) {
    return statOnCampusByStdTypeAndDepart(dataRealm, new Class[] { StudentType.class, Department.class });
  }

  public List statOnCampusByDepartStdType(DataRealm dataRealm) {
    return statOnCampusByStdTypeAndDepart(dataRealm, new Class[] { Department.class, StudentType.class });
  }

  public List statAlertOnCampusByStdTypeAndDepart(DataRealm dataRealm) {
    return statAlertOnCampusByStdTypeAndDepart(dataRealm, new Class[] { Department.class, StudentType.class });
  }

  public List statOnCampusByStdTypeAndDepart(DataRealm dataRealm, Class[] groupClasses) {
    EntityQuery entityQuery = new EntityQuery(Student.class, "std");
    if (null != dataRealm) {
      DataRealmUtils
          .addDataRealm(entityQuery, new String[] { "std.type.id", "std.department.id" }, dataRealm);
    }
    StringBuffer selectClause = new StringBuffer("");
    HashMap classAttrMap = new HashMap();
    classAttrMap.put(StudentType.class, "std.type.id");
    classAttrMap.put(Department.class, "std.department.id");
    for (int i = 0; i < groupClasses.length; i++) {
      selectClause.append(classAttrMap.get(groupClasses[i])).append(",");
      entityQuery.groupBy((String) classAttrMap.get(groupClasses[i]));
    }
    entityQuery.setSelect(selectClause.toString() + "std.enrollYear,count(*)");
    entityQuery.add(new Condition("std.inSchool = true and std.active = true"));
    entityQuery.groupBy("std.enrollYear");
    List datas = (List) utilDao.search(entityQuery);
    new StatHelper(utilService).replaceIdWith(datas, groupClasses);
    List statGroups = StatGroup.buildStatGroups(datas);
    return statGroups;
  }

  public List statAlertOnCampusByStdTypeAndDepart(DataRealm dataRealm, Class[] groupClasses) {
    EntityQuery entityQuery = new EntityQuery(Student.class, "std");
    if (null != dataRealm) {
      DataRealmUtils
          .addDataRealm(entityQuery, new String[] { "std.type.id", "std.department.id" }, dataRealm);
    }
    StringBuffer selectClause = new StringBuffer("");
    HashMap classAttrMap = new HashMap();
    classAttrMap.put(StudentType.class, "std.type.id");
    classAttrMap.put(Department.class, "std.department.id");
    for (int i = 0; i < groupClasses.length; i++) {
      selectClause.append(classAttrMap.get(groupClasses[i])).append(",");
      entityQuery.groupBy((String) classAttrMap.get(groupClasses[i]));
    }
    entityQuery.setSelect(selectClause.toString() + "std.enrollYear,count(*),'',''");
    entityQuery.add(new Condition("std.inSchool = true"));
    entityQuery.groupBy("std.enrollYear");
    List datas = (List) utilDao.search(entityQuery);

    // 在籍的人数
    EntityQuery entityQuery2 = new EntityQuery(Student.class, "std");
    if (null != dataRealm) {
      DataRealmUtils.addDataRealm(entityQuery2, new String[] { "std.type.id", "std.department.id" },
          dataRealm);
    }
    selectClause = new StringBuffer("");
    classAttrMap = new HashMap();
    classAttrMap.put(StudentType.class, "std.type.id");
    classAttrMap.put(Department.class, "std.department.id");
    for (int i = 0; i < groupClasses.length; i++) {
      selectClause.append(classAttrMap.get(groupClasses[i])).append(",");
      entityQuery2.groupBy((String) classAttrMap.get(groupClasses[i]));
    }
    entityQuery2.setSelect(selectClause.toString() + "std.enrollYear,count(*)");
    entityQuery2.add(new Condition("std.active = true"));
    entityQuery2.groupBy("std.enrollYear");
    List datas2 = (List) utilDao.search(entityQuery2);

    // 延长的人
    EntityQuery entityQuery3 = new EntityQuery(StudentAlteration.class, "sa");
    if (null != dataRealm) {
      DataRealmUtils.addDataRealm(entityQuery3, new String[] { "sa.std.type.id", "sa.std.department.id" },
          dataRealm);
    }
    selectClause = new StringBuffer("");
    classAttrMap = new HashMap();
    classAttrMap.put(StudentType.class, "sa.std.type.id");
    classAttrMap.put(Department.class, "sa.std.department.id");
    for (int i = 0; i < groupClasses.length; i++) {
      selectClause.append(classAttrMap.get(groupClasses[i])).append(",");
      entityQuery3.groupBy((String) classAttrMap.get(groupClasses[i]));
    }
    entityQuery3.setSelect(selectClause.toString() + "sa.std.enrollYear,count(*)");
    // entityQuery2.add(new Condition("std.active = true"));
    entityQuery3.groupBy("sa.std.enrollYear");
    List datas3 = (List) utilDao.search(entityQuery3);

    for (Iterator iterator = datas.iterator(); iterator.hasNext();) {
      Object[] object = (Object[]) iterator.next();
      // EntityQuery entityQuery3 = new EntityQuery(StudentAlteration.class, "sa");
      // entityQuery2.add(new Condition("sa.std.type.id := typeId",(Long)object[0]));
      // entityQuery2.add(new Condition("sa.std.department.id := departmentId",(Long)object[1]));
      // entityQuery2.add(new
      // Condition("sa.std.enrollYear := enrollYear",String.valueOf(object[2])));
      // entityQuery2.add(new
      // Condition("sa.std.enrollYear := enrollYear",String.valueOf(object[2])));
      for (Iterator iterator2 = datas2.iterator(); iterator2.hasNext();) {
        Object[] object2 = (Object[]) iterator2.next();
        if (String.valueOf(object[0]).equals(String.valueOf(object2[0]))
            && String.valueOf(object[1]).equals(String.valueOf(object2[1]))
            && String.valueOf(object[2]).equals(String.valueOf(object2[2]))) {
          object[4] = object2[3];
          break;
        }
      }
      for (Iterator iterator3 = datas3.iterator(); iterator3.hasNext();) {
        Object[] object2 = (Object[]) iterator3.next();
        if (String.valueOf(object[0]).equals(String.valueOf(object2[0]))
            && String.valueOf(object[1]).equals(String.valueOf(object2[1]))
            && String.valueOf(object[2]).equals(String.valueOf(object2[2]))) {
          object[5] = object2[3];
          break;
        }
      }
    }
    new StatHelper(utilService).replaceIdWith(datas, groupClasses);
    List statGroups = StatGroup.buildStatGroups(datas, 3);
    return statGroups;
  }

}
