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

package com.shufe.model.course.plan.std;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.builder.CompareToBuilder;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.exception.ExceptionUtils;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.eams.system.basecode.industry.HSKDegree;
import com.shufe.model.course.plan.CourseGroup;
import com.shufe.model.system.baseinfo.Course;

/**
 * 培养计划课程实体类.<br>
 * <p>
 * 规定了培养计划中课程组内的课程可能在那个学期开课，有什么院系开课.<br>
 * 学生在上这门课时，必须先上过什么课，需要的汉语水平要多高.<br>
 * 如果这么可不通过，可以有什么课程替代.<br>
 * <p>
 * 一个课程设置只能属于一个课程组.
 * 
 * @author chaostone
 */
public class StdPlanCourse extends LongIdObject implements Comparable, Cloneable {

  private static final long serialVersionUID = -3619832967631930144L;

  /** 课程 */
  private Course course = new Course();

  /**
   * 学分<br>
   * 这里的学分和课程的学分可能不一样.<br>
   * 因为不同的课程类别限制了它的学分取值<br>
   */
  private Float credit = new Float(0);

  /** 开课的学期 */
  private String termSeq;

  /** 先修课程 */
  private List preCourses = new ArrayList();

  /** 可替代课程 */
  private Course substitution = new Course();

  /** HSK约束 */
  private HSKDegree HSKDegree = new HSKDegree();

  /** 所属课程组 */
  private CourseGroup courseGroup = new CourseGroup();

  /** 备注 */
  private String remark;

  /**
   * 全盘比较
   * 
   * @see java.lang.Object#equals(Object)
   */
  public boolean equals(Object object) {
    if (!(object instanceof StdPlanCourse)) { return false; }
    StdPlanCourse rhs = (StdPlanCourse) object;
    return new EqualsBuilder().append(getPreCourses(), rhs.getPreCourses())
        .append(getSubstitution(), rhs.getSubstitution()).append(getHSKDegree(), rhs.getHSKDegree())
        .append(getTermSeq(), rhs.getTermSeq()).append(getRemark(), rhs.getRemark())
        .append(getCourse().getId(), rhs.getCourse().getId()).append(getId(), rhs.getId())
        .append(getCredit(), rhs.getCredit()).isEquals();
  }

  /**
   * 默认按照学分进行排序
   * 
   * @see java.lang.Comparable#compareTo(Object)
   */
  public int compareTo(Object object) {
    StdPlanCourse myClass = (StdPlanCourse) object;
    return new CompareToBuilder().append(getCourse().getCredits(), myClass.getCourse().getCredits())
        .toComparison();
  }

  /**
   * @see java.lang.Object#clone()
   */
  public Object clone() {
    StdPlanCourse planCourse = new StdPlanCourse();
    try {
      PropertyUtils.copyProperties(planCourse, this);
      planCourse.setCourseGroup(null);
      planCourse.setId(null);
      planCourse.setPreCourses(new ArrayList());
      planCourse.getPreCourses().addAll(this.getPreCourses());
    } catch (Exception e) {
      throw new RuntimeException("error in clone planCourse:" + ExceptionUtils.getStackTrace(e));
    }
    return planCourse;
  }

  public boolean inTerm(String terms) {
    if (StringUtils.isEmpty(terms)) {
      return true;
    } else {
      String termArray[] = StringUtils.split(terms, ",");
      for (int i = 0; i < termArray.length; i++) {
        if (StringUtils.contains("," + getTermSeq() + ",", "," + termArray[i] + ",")) return true;
      }
      return false;
    }

  }

  public Course getCourse() {
    return course;
  }

  public void setCourse(Course course) {
    this.course = course;
  }

  public CourseGroup getCourseGroup() {
    return courseGroup;
  }

  public void setCourseGroup(CourseGroup courseGroup) {
    this.courseGroup = courseGroup;
  }

  public HSKDegree getHSKDegree() {
    return HSKDegree;
  }

  public void setHSKDegree(HSKDegree constrain) {
    HSKDegree = constrain;
  }

  public List getPreCourses() {
    return preCourses;
  }

  public void setPreCourses(List prerequisiteCourses) {
    this.preCourses = prerequisiteCourses;
  }

  public Course getSubstitution() {
    return substitution;
  }

  public void setSubstitution(Course substitution) {
    this.substitution = substitution;
  }

  public String getTermSeq() {
    return termSeq;
  }

  public void setTermSeq(String terms) {
    this.termSeq = terms;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }

  /**
   * @return Returns the credit.
   */
  public Float getCredit() {
    return credit;
  }

  /**
   * @param credit The credit to set.
   */
  public void setCredit(Float credit) {
    this.credit = credit;
  }
}
