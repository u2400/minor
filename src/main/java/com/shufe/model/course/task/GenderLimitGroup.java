//$Id: GenderGroup.java,v 1.1 2011-11-22 下午01:20:12 zhouqi Exp $
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
 * zhouqi              2011-11-22             Created
 *  
 ********************************************************************************/

package com.shufe.model.course.task;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.eams.system.basecode.state.Gender;

/**
 * @author zhouqi
 */
public class GenderLimitGroup extends LongIdObject {

  private static final long serialVersionUID = -662914972571946292L;

  /** 教学任务 */
  private TeachTask task;

  /** 性别 */
  private Gender gender;

  /** 男生/女生 人数上限 */
  private Integer limitCount;

  /** 男生/女生 实际人数 */
  private Integer count;

  public TeachTask getTask() {
    return task;
  }

  public void setTask(TeachTask task) {
    this.task = task;
  }

  public Gender getGender() {
    return gender;
  }

  public void setGender(Gender gender) {
    this.gender = gender;
  }

  public Integer getCount() {
    return count;
  }

  public void setCount(Integer count) {
    this.count = count;
  }

  public Integer getLimitCount() {
    return limitCount;
  }

  public void setLimitCount(Integer limitCount) {
    this.limitCount = limitCount;
  }
}
