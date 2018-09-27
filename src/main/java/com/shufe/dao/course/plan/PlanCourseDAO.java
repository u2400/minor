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
 * chaostone             2006-3-24            Created
 *  
 ********************************************************************************/
package com.shufe.dao.course.plan;

import java.util.List;

import com.shufe.model.course.plan.PlanCourse;

public interface PlanCourseDAO {
  /**
   * 列出指定培养计划相应学期的培养计划课程
   * 
   * @param term
   * @param cultivateSchemeId
   * @return
   */
  public List getPlanCourseByTerm(Long cultivateSchemeId, Integer term);

  /**
   * @param id
   * @return
   */
  public PlanCourse getPlanCourse(Long id);
}
