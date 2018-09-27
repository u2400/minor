//$Id: UserDWRServiceImpl.java,v 1.1 2008-11-21 上午09:38:38 zhouqi Exp $
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
 * @author zhouqi
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * zhouqi              2008-11-21             Created
 *  
 ********************************************************************************/

package com.shufe.service.system.security.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.beanfuse.entity.Model;

import com.ekingstar.commons.model.AbstractEntity;
import com.ekingstar.security.User;
import com.ekingstar.security.service.impl.UserServiceImpl;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.model.system.baseinfo.Teacher;
import com.shufe.service.system.security.UserDWRService;

/**
 * @author zhouqi
 */
public class UserDWRServiceImpl extends UserServiceImpl implements UserDWRService {

  /**
   * @see com.shufe.service.system.security.impl.UserDWRService#getEasmUser(java.lang.String)
   */
  public Map<String, Object> getEamsUser(String code) {
    if (StringUtils.isEmpty(code)) {
      return null;
    } else {
      Map<String, Object> userObjectMap = new HashMap<String, Object>();
      List<AbstractEntity> results = utilService.load(Teacher.class, "code", code);
      if (CollectionUtils.isEmpty(results)) {
        results = utilService.load(Student.class, "code", code);
        if (CollectionUtils.isEmpty(results)) {
          results = utilService.load(User.class, "name", code);
          if (CollectionUtils.isEmpty(results)) {
            return null;
          } else {
            User user = (User) results.get(0);
            userObjectMap.put("code", user.getName());
            userObjectMap.put("name", user.getUserName());
            userObjectMap.put("department", new Department(new Long(1)));
            return userObjectMap;
          }
        } else {
          Student student = (Student) results.get(0);
          userObjectMap.put("code", student.getCode());
          userObjectMap.put("name", student.getName());
          student.getDepartment().getName();
          userObjectMap.put("department", student.getDepartment());
          userObjectMap.put("firstMajorClass", student.getFirstMajorClass());
          return userObjectMap;
        }
      } else {
        Teacher teacher = (Teacher) results.get(0);
        userObjectMap.put("code", teacher.getCode());
        userObjectMap.put("name", teacher.getName());
        teacher.getDepartment().getName();
        userObjectMap.put("department", teacher.getDepartment());
        return userObjectMap;
      }
    }
  }
}
