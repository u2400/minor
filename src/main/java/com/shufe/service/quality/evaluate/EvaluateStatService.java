//$Id: EvaluateStatService.java,v 1.1 2010-5-12 下午03:18:05 zhouqi Exp $
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
 * zhouqi              2010-5-12             Created
 *  
 ********************************************************************************/

package com.shufe.service.quality.evaluate;

import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 评教统计
 * 
 * @author zhouqi
 */
public interface EvaluateStatService {

  /**
   * 评教统计
   * 
   * @param calendar
   * @param stdTypeIds
   * @param departmentIds
   * @param rankCache
   *          TODO
   * @return
   */
  public boolean evaluateStat(TeachCalendar calendar, Long[] stdTypeIds, Long[] departmentIds);
}
