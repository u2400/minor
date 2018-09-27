package com.shufe.service.system.baseinfo;

import java.util.Collection;

import com.shufe.model.system.baseinfo.Course;

public interface CourseDwrService {

  /**
   * 按课程代码查询课程（dwr优先）
   * 
   * @param codes
   * @return
   */
  public abstract Collection<Course> getCourses(String codes);
}
