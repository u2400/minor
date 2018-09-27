/**
 * 
 */
package com.shufe.service.system.baseinfo.impl;

import java.util.Collection;

import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.service.BasicService;
import com.shufe.service.system.baseinfo.CourseDwrService;

/**
 * @author zhouqi
 */
public class CourseDwrServiceImpl extends BasicService implements CourseDwrService {

  public Collection<Course> getCourses(String codes) {
    if (StringUtils.isBlank(codes)) {
      return null;
    } else {
      EntityQuery query = new EntityQuery(Course.class, "course");
      query.add(new Condition("course.code in (:codes)", codes.split(",")));
      return utilService.search(query);
    }
  }
}
