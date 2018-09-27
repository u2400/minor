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
 * chaostone             2006-6-10            Created
 *  
 ********************************************************************************/
package com.shufe.model.course.election;

import java.io.Serializable;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import com.ekingstar.eams.system.basecode.industry.CourseType;
import com.shufe.model.course.arrange.CourseArrangeSwitch;
import com.shufe.model.course.arrange.resource.TimeTable;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.system.baseinfo.AdminClass;

/**
 * 学生选课的状态数据
 * 
 * @author chaostone
 */
public class ElectState implements Serializable {

  private static final long serialVersionUID = -7987996716147870563L;

  /** 学生选课用的简要信息 */
  public SimpleStdInfo std;

  /** 是否完成评教 */
  public Boolean isEvaluated;

  /** 学分上限(已有上限+奖励学分+浮动学分) */
  public float maxCredit;

  /** 奖励学分 */
  public float awardedCredit;

  /** 已选学分 */
  public float electedCredit;

  /** 排课发布状态 */
  public CourseArrangeSwitch arrangeSwitch;

  /** 选课参数 */
  public ElectParams params;

  /** 历史已选的课程IDs course.id->Boolean */
  public Map<Long, Boolean> hisCourses = new HashMap<Long, Boolean>(0);

  /** 本次已选的课程IDs */
  public Set<Long> electedCourseIds = new HashSet<Long>();

  /** 历史已选课程名称，用以检查同名课程 */
  public Set<String> hisCourseNames = new HashSet<String>();

  // 选课状态中的计划信息，三部分，1: 每个组对应的学分，2: 每个课程对应的课程类别 3:不包含课程的课程组课程类型
  /** courseType.id -> credits */
  public final Map<CourseType, Float> typeCredits = new HashMap<CourseType, Float>();

  /** course.id->courseType.id */
  public final Map<Long, Long> planCourse2Types = new HashMap<Long, Long>();

  /** 计划中没有课程的课程组类型 */
  public final Set<Long> emptyTypes = new HashSet<Long>(5);

  /** 时间占用表 */
  public TimeTable table;

  /** 建议必修课 */
  public Set compulsoryCourseIds = new HashSet();

  /** 替代课程id */
  public Set<Long> substituteIds = new HashSet<Long>();

  public boolean majorChanged;

  /** 参数内允许不遵循先选必修课再选选修课规则的学生学籍状态 */
  public Set studentStates2 = new HashSet();

  /** 已经修读 通识 公选 限选 -> credits */
  public Map<String, Float> completedMap = new HashMap<String, Float>();
  /** 需要修读 通识 公选 限选 -> credits */
  public Map<String, Float> requiredMap = new HashMap<String, Float>();
  /** 正在修读 通识 公选 限选 -> credits */
  public Map<String, Float> electedMap = new HashMap<String, Float>();

  public ElectState(StdCreditConstraint constraint, ElectParams params) {
    std = new SimpleStdInfo();
    Student student = constraint.getStd();
    std.setId(constraint.getStd().getId());
    std.setStdNo(student.getCode());
    std.setEnrollTurn(student.getEnrollYear());
    std.setGenderId(student.getGender().getId());
    std.setStdTypeId(student.getType().getId());
    std.setDepartId(student.getDepartment().getId());
    std.setSpecialityId((student.getFirstMajor() == null) ? null : student.getFirstMajor().getId());
    std.setAspectId((student.getFirstAspect() == null) ? null : student.getFirstAspect().getId());
    std.setSchoolDistrictId(
        (student.getSchoolDistrict() == null) ? null : student.getSchoolDistrict().getId());
    std.setInSchool(student.isInSchool());

    for (Iterator iter = student.getAdminClasses().iterator(); iter.hasNext();) {
      AdminClass adminClass = (AdminClass) iter.next();
      this.std.adminClassIds.add(adminClass.getId());
    }
    if (null != student.getAbroadStudentInfo()) {
      if (null == student.getAbroadStudentInfo().getHSKDegree()) {
        std.HSKDegree = new Integer(1);
      } else {
        std.HSKDegree = student.getAbroadStudentInfo().getHSKDegree().getDegree();
      }
    }
    std.languageAbility = (null == student.getLanguageAbility()) ? Student.ENGLISH_ABILITY_DEFAULT
        : student.getLanguageAbility().getId();
    this.params = params;
    updateCredit(constraint);
  }

  public Set<Long> getUnPassedCourseIds() {
    if (null == hisCourses) {
      return Collections.emptySet();
    } else {
      Set<Long> unPassedCourseIds = new HashSet<Long>();
      for (Iterator<Long> iterator = hisCourses.keySet().iterator(); iterator.hasNext();) {
        Long courseId = iterator.next();
        Boolean rs = (Boolean) hisCourses.get(courseId);
        if (Boolean.FALSE.equals(rs)) {
          unPassedCourseIds.add(courseId);
        }
      }
      return unPassedCourseIds;
    }
  }

  /**
   * 依据学分限制，更新学分
   * 
   * @param constraint
   */
  public void updateCredit(StdCreditConstraint constraint) {
    float awarded = 0;
    if (params.getIsAwardCreditConsider().equals(Boolean.TRUE)) {
      awarded = (null == constraint.getAwardedCredit()) ? 0 : constraint.getAwardedCredit().floatValue();
    }
    // 更新评教和学分上限(已有上限+奖励学分+浮动学分)
    maxCredit = constraint.getMaxCredit().floatValue() + awarded + params.getFloatCredit().floatValue();
    electedCredit = (null == constraint.getElectedCredit()) ? 0 : constraint.getElectedCredit().floatValue();
    awardedCredit = awarded;
  }

  public void elect(TeachTask task) {
    this.electedCourseIds.add(task.getCourse().getId());
    this.table.addArrangement(task);
    this.electedCredit += task.getCourse().getCredits().floatValue();
    String category = courseTypeCategory(task);
    this.electedMap.put(category, electedMap.get(category).floatValue() + task.getCourse().getCredits());
  }

  private String courseTypeCategory(TeachTask task) {
    if (task.getCourseType().getName().contains("公选")) {
      return "公选";
    } else if (task.getCourseType().getName().contains("通识")) {
      return "通识";
    } else if (task.getCourseType().getName().contains("限选")
        || task.getCourseType().getName().contains("限制性选")) {
      return "限选";
    } else return "限选";
  }

  public void cancel(TeachTask task) {
    this.electedCredit -= task.getCourse().getCredits().floatValue();
    this.table.removeArrangement(task);
    this.electedCourseIds.remove(task.getCourse().getId());
    String category = courseTypeCategory(task);
    this.electedMap.put(category, electedMap.get(category).floatValue() - task.getCourse().getCredits());
  }

  public float getAwardedCredit() {
    return awardedCredit;
  }

  public float getElectedCredit() {
    return electedCredit;
  }

  public Set<Long> getElectedCourseIds() {
    return electedCourseIds;
  }

  public Map<Long, Boolean> getHisCourses() {
    return hisCourses;
  }

  public float getMaxCredit() {
    return maxCredit;
  }

  public CourseArrangeSwitch getArrangeSwitch() {
    return arrangeSwitch;
  }

  public ElectParams getParams() {
    return params;
  }

  public SimpleStdInfo getStd() {
    return std;
  }

  public TimeTable getTable() {
    return table;
  }

  public Boolean getIsEvaluated() {
    return isEvaluated;
  }

  public Set getCompulsoryCourseIds() {
    return compulsoryCourseIds;
  }

  public boolean isCoursePass(Long courseId) {
    Boolean rs = (Boolean) hisCourses.get(courseId);
    return Boolean.TRUE.equals(rs);
  }

  public Set<Long> getSubstituteIds() {
    return substituteIds;
  }

  public Set<String> getHisCourseNames() {
    return hisCourseNames;
  }

  public Map<CourseType, Float> getTypeCredits() {
    return typeCredits;
  }

  public Map<Long, Long> getPlanCourse2Types() {
    return planCourse2Types;
  }

  public Set<Long> getEmptyTypes() {
    return emptyTypes;
  }

  public boolean isMajorChanged() {
    return majorChanged;
  }

  public Float getCredits(CourseType type) {
    return typeCredits.get(type);
  }

  public Set getStudentStates2() {
    return studentStates2;
  }

  public void setStudentStates2(Set studentStates2) {
    this.studentStates2 = studentStates2;
  }

  public static long getSerialversionuid() {
    return serialVersionUID;
  }

  public Map<String, Float> getCompletedMap() {
    return completedMap;
  }

  public Map<String, Float> getRequiredMap() {
    return requiredMap;
  }

  public Map<String, Float> getElectedMap() {
    return electedMap;
  }

}
