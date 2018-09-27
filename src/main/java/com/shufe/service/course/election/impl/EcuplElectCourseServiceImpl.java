//$Id: ElectCourseServiceImpl.java,v 1.20 2007/01/16 03:41:58 duanth Exp $
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
 * chaostone             2005-12-12         Created
 *  
 ********************************************************************************/

package com.shufe.service.course.election.impl;

import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import net.ekingstar.common.detail.Pagination;
import net.ekingstar.common.detail.Result;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.Order;
import com.ekingstar.commons.query.limit.PageLimit;
import com.ekingstar.eams.system.basecode.industry.CourseTakeType;
import com.ekingstar.eams.system.basecode.state.Gender;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.ekingstar.eams.system.time.TimeUnit;
import com.shufe.dao.course.arrange.task.CourseTakeDAO;
import com.shufe.dao.course.election.ElectRecordDAO;
import com.shufe.dao.course.election.hibernate.CourseLimitGroupDao;
import com.shufe.dao.course.task.TeachTaskDAO;
import com.shufe.model.course.arrange.task.CourseTake;
import com.shufe.model.course.election.ElectParams;
import com.shufe.model.course.election.ElectRecord;
import com.shufe.model.course.election.ElectState;
import com.shufe.model.course.election.ElectStdScope;
import com.shufe.model.course.election.SimpleStdInfo;
import com.shufe.model.course.task.GenderLimitGroup;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.std.Student;
import com.shufe.model.std.alteration.StudentAlteration;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.service.BasicService;
import com.shufe.service.course.election.ElectCourseService;
import com.shufe.service.course.grade.GradeService;
import com.shufe.service.course.plan.TeachPlanService;
import com.shufe.service.course.task.TeachTaskService;
import com.shufe.service.quality.evaluate.EvaluateSwitchService;

/**
 * @author zhouqi
 */
public class EcuplElectCourseServiceImpl extends BasicService implements ElectCourseService {

  /** 港澳台的可不选课程 */
  protected static Set HMT_COURSE_IDS = new HashSet();

  protected TeachTaskDAO teachTaskDAO;

  protected ElectRecordDAO electRecordDAO;

  protected CourseTakeDAO courseTakeDAO;

  protected EvaluateSwitchService evaluateSwitchService;

  protected TeachPlanService teachPlanService;

  protected TeachTaskService teachTaskService;

  protected GradeService gradeService;

  protected CourseLimitGroupDao courseLimitGroupDao;

  /** 指定港澳台可不选的课程 */
  static {
    HMT_COURSE_IDS.add(new Long(360)); // 1000012
    HMT_COURSE_IDS.add(new Long(1582));// 1000042*
    HMT_COURSE_IDS.add(new Long(1641));// 1000051*
    HMT_COURSE_IDS.add(new Long(156)); // 1010013
    HMT_COURSE_IDS.add(new Long(157)); // 1010022
    HMT_COURSE_IDS.add(new Long(109)); // 1010032
    HMT_COURSE_IDS.add(new Long(110)); // 1010042
    HMT_COURSE_IDS.add(new Long(111)); // 1010053
    HMT_COURSE_IDS.add(new Long(112)); // 1010062
    HMT_COURSE_IDS.add(new Long(1227));// 1011333
    HMT_COURSE_IDS.add(new Long(17)); // 1011343
    HMT_COURSE_IDS.add(new Long(18)); // 1011353
    HMT_COURSE_IDS.add(new Long(1228));// 1011362
    HMT_COURSE_IDS.add(new Long(19)); // 1011373
    HMT_COURSE_IDS.add(new Long(1352));// 1011381*
    HMT_COURSE_IDS.add(new Long(1961));// 1011562
    HMT_COURSE_IDS.add(new Long(3047));// 1012112
    HMT_COURSE_IDS.add(new Long(4024));// 1012483*
    HMT_COURSE_IDS.add(new Long(51)); // 1020022
  }

  /**
   * o 查询已选的教学任务
   */
  public Pagination getElectableTasks(TeachTask task, ElectState state, Collection courseIds, TimeUnit time,
      boolean isScopeConstraint, int pageNo, int pageSize, Integer op) {
    return teachTaskDAO.getTeachTasksOfElectable(task, state, courseIds, time, isScopeConstraint, pageNo,
        pageSize, op);
  }

  public Pagination getElectableTasks(TeachTask task, TimeUnit time, Collection calendars, int pageNo,
      int pageSize) {
    if (pageNo > 0 && pageSize > 0)
      return teachTaskDAO.getTeachTasksOfElectable(task, time, calendars, pageNo, pageSize);
    else return new Pagination(new Result(0, Collections.EMPTY_LIST));
  }

  /**
   * 选课
   * 
   * @param std
   * @param task
   * @param params
   * @return
   */
  @SuppressWarnings("deprecation")
  public String elect(TeachTask task, ElectState state, CourseTakeType takeType) {
    SimpleStdInfo std = state.std;
    ElectParams params = (ElectParams) utilDao.get(ElectParams.class, state.params.getId());
    // 过滤不在校的学生
    //if (!std.isInSchool()) { return isNotInSchool; }

    // 2013-04-27 zhouqi 王公悦要求如此做
    // 1. 检查学生教学任务的英语等级匹配情况
    Long stdLangId = std.getLanguageAbility().longValue();
    if (CollectionUtils.isNotEmpty(task.getRequirement().getLanguageAbilities())) {
      LanguageAbility stdLA = new LanguageAbility();
      stdLA.setId(stdLangId);
      if (!task.getRequirement().getLanguageAbilities().contains(stdLA)) { return notMatchLanguageAbility; }
      // if (std.getEnrollTurn().equals("2014-9") && stdLangId == 2
      // && task.getCourseType().getId().equals(41L)) { return notMatchLanguageAbility; }
    }

    // 2. 检查 学生性别与课程要求上课学生性别 是否一致
    Gender gender = task.getTeachClass().getGender();
    if (null != gender && !gender.getId().equals(std.getGenderId())) { return notGenderDistrict; }

    // 3. 检查校区
    if (Boolean.TRUE.equals(params.getIsSchoolDistrictRestrict())
        && null != task.getArrangeInfo().getSchoolDistrict()) {
      if (null == std.getSchoolDistrictId() || !std.getSchoolDistrictId()
          .equals(task.getArrangeInfo().getSchoolDistrict().getId())) { return notInSchoolDistrict; }
    }
    // 4. 检查评教
    if (params.getIsCheckEvaluation().equals(Boolean.TRUE) && state.isEvaluated.equals(Boolean.FALSE)) {
      if (!isPassEvaluation(std.getId())) {
        return notEvaluateComplete;
      } else {
        state.isEvaluated = Boolean.TRUE;
      }
    }
    // 5. 检查人数上限 留给数据库检查
    // if (params.getIsOverMaxAllowed().equals(Boolean.FALSE)) {
    // if (task.getTeachClass().getStdCount().intValue() + 1 >
    // task.getElectInfo()
    // .getMaxStdCount().intValue()) {
    // return overMaxStdCount;
    // }
    // }
    // 6.检查学分上限
    if (state.electedCredit
        + task.getCourse().getCredits().floatValue() > state.maxCredit) { return overCeilCreditConstraint; }

    // 7.是否已经选过该课
    Boolean coursePass = (Boolean) state.hisCourses.get(task.getCourse().getId());
    if (null != coursePass) {
      if (Boolean.FALSE.equals(params.getIsRestudyAllowed())) { return reStudiedNotAllowed; }
      // 选过的再选只能是"重修" 华政可重复修读已考核通过课程
      if (!takeType.getId().equals(CourseTakeType.RESTUDY)
          && !takeType.getId().equals(CourseTakeType.REEXAM)) { return elected; }
    } else {
      takeType.setId(CourseTakeType.ELECTIVE);
    }
    // 8.是否重复选课
    if (state.electedCourseIds.contains(task.getCourse().getId())) { return elected; }

    // 9.检查学生范围
    boolean checkScope = state.getParams().getIsLimitedInTeachClass();
    if (state.majorChanged) {
      checkScope = false;
    }
    if (null != coursePass) {
      checkScope = state.getParams().getIsCheckScopeForReSturdy().booleanValue();
    }
    if (checkScope) {
      boolean inScope = task.getTeachClass().getAdminClasses().isEmpty()
          && task.getElectInfo().getElectScopes().isEmpty();
      for (Iterator clxIter = task.getTeachClass().getAdminClasses().iterator(); clxIter.hasNext();) {
        AdminClass clx = (AdminClass) clxIter.next();
        if (std.getAdminClassIds().contains(clx.getId())) {
          inScope = true;
          break;
        }
      }
      if (!inScope) {
        // 选课范围
        for (Iterator iter = task.getElectInfo().getElectScopes().iterator(); iter.hasNext();) {
          if (((ElectStdScope) iter.next()).isIn(std)) {
            inScope = true;
            break;
          }
        }
        if (!inScope) { return notInElectScope; }
      }
    }

    // 10.检查HSK
    if (null != task.getElectInfo().getHSKDegree() && null != std.getHSKDegree()) {
      if (std.getHSKDegree().intValue() < task.getElectInfo().getHSKDegree().getDegree()
          .intValue()) { return HSKNotSatisfied; }
    }

    // 11.检查先修课程
    if (!task.getElectInfo().getPrerequisteCourses().isEmpty()) {
      for (Iterator iter = task.getElectInfo().getPrerequisteCourses().iterator(); iter.hasNext();) {
        Course course = (Course) iter.next();
        Boolean isPass = (Boolean) state.hisCourses.get(course.getId());
        if (null == isPass || Boolean.FALSE.equals(isPass)) { return prerequisteCoursesNotMeeted; }
      }
    }
    // 12. 如果不是免修不免试的学生，均检查是否时间冲突
    if (!takeType.getId().equals(CourseTakeType.REEXAM)) {
      if (state.table.isTimeConflict(task)) { return timeCollision; }
    }
    // 13. 检查“替代课程 || 培养计划”
    if (params.getIsInPlanOfCourse().booleanValue()) {
      if (!isInPlan(task, state, params) && !isSubstitute(task, state)) { return courseNotInPlan; }
    }
    // 14.先选必修课
    // 20131219 王公悦要求增加特殊学籍状态学生不受此条限制
    Student student = (Student) utilService.get(Student.class, Long.valueOf(state.getStd().getId()));
    if (!(state.getStudentStates2().contains(student.getState()))) {
      // 20091217 段体华修改如下
      if (Boolean.FALSE.equals(task.getCourseType().getIsCompulsory())) {
        Collection s = CollectionUtils.subtract(state.compulsoryCourseIds, state.electedCourseIds);
        for (Iterator iter = s.iterator(); iter.hasNext();) {
          Long courseId = (Long) iter.next();
          if (!state.hisCourses.keySet().contains(courseId)) { return "error.elect.compulsoryFirst"; }
        }
      }
    }

    // 15.是否需要检测人数上限
    boolean checkMaxLimit = state.params.getIsOverMaxAllowed().equals(Boolean.FALSE);
    if (takeType.getId().equals(CourseTakeType.REEXAM)) {
      checkMaxLimit = false;
    }

    GenderLimitGroup occupiedGroup = null;// task.getTeachClass().getGenderLimitGroup(std.getGenderId());
    if (null != occupiedGroup) {
      if (courseLimitGroupDao.reserveGroupLimit(occupiedGroup) == 0) {
        occupiedGroup = null;
        return overGenderLimit;
      }
    }
    // System.out.println("checkMaxLimit : 2" + checkMaxLimit);
    int rs = electRecordDAO.saveElection(task, takeType, state, checkMaxLimit);
    if (rs == 0) {
      state.elect(task);
      logger.debug("Elect Success std:" + state.getStd().getStdNo() + " task:" + task.getId() + " credit:"
          + task.getCourse().getCredits() + " elected :" + state.electedCredit);
      return selectSuccess;
    } else {
      if (null != occupiedGroup) courseLimitGroupDao.releaseGroupLimit(occupiedGroup);
      logger.debug("Elect Failure(" + rs + ") std:" + state.getStd().getStdNo() + " task:" + task.getId()
          + " credit:" + task.getCourse().getCredits() + " elected :" + state.electedCredit);
      if (rs == -2) {
        return overCeilCreditConstraint;
      } else {// -3 or other is overMaxStdCount
        return overMaxStdCount;
      }
    }
  }

  /**
   * @param task
   * @param state
   * @param params
   */
  protected boolean isInPlan(TeachTask task, ElectState state, ElectParams params) {
    /* 现在系统计划中肯定存在通识类大类 或其小类 只要学生选的课程的类别是包含 通识类 的，就让学生选择。 */
    if (task.getCourseType().getName().contains("通识类")) return true;
    Long typeId = state.planCourse2Types.get(task.getCourse().getId());
    return (null != typeId || state.emptyTypes.contains(task.getCourseType().getId()));
  }

  protected boolean isSubstitute(TeachTask task, ElectState state) {
    return state.substituteIds.contains(task.getCourse().getId());
  }

  public void addCompulsoryCourse(ElectState state, Student student, List calendars) {
    boolean isHMT = StringUtils.contains(student.getName(), "港澳台");
    if (!isHMT) {
      isHMT = StringUtils.contains(student.getName(), "留学生");
    }
    if (!isHMT) {
      isHMT = StringUtils.contains(student.getName(), "华侨");
    }
    state.getStd().setHMT(isHMT);
    AdminClass adminClass = student.getFirstMajorClass();
    if (null != adminClass) {
      List<Long> adminClassTasks = getAdminCourseIds(adminClass, calendars);
      state.getCompulsoryCourseIds().addAll(adminClassTasks);
      // 过虑港澳台的可不选课程
      if (isHMT) {
        CollectionUtils.filter(state.getCompulsoryCourseIds(), new Predicate() {

          public boolean evaluate(Object arg0) {
            return !HMT_COURSE_IDS.contains(arg0);
          }
        });
      }
    }
  }

  /**
   * 班级必修课
   */
  public List getAdminCourseIds(AdminClass adminClass, Collection calendars) {
    StringBuilder hql = new StringBuilder();
    hql.append("select task.course.id from TeachTask as task ");
    hql.append(" join task.teachClass.adminClasses as adminClass ");
    hql.append(" where task.calendar in (:calendars) ");
    hql.append(" and adminClass= :adminClass and task.courseType.isCompulsory = true ");
    EntityQuery query = new EntityQuery(hql.toString());
    Map params = new HashMap();
    params.put("calendars", calendars);
    params.put("adminClass", adminClass);
    query.setParams(params);
    query.setCacheable(true);
    return (List) utilService.search(query);
  }

  /**
   * 退课
   */
  public String cancel(TeachTask task, ElectState state) {
    // 不能退没有选过的课程
    if (!state.getElectedCourseIds().contains(task.getCourse().getId())) { return cancelUnElected; }
    Student student = (Student) utilService.get(Student.class, Long.valueOf(state.getStd().getId()));
    ElectParams paramss = state.params;
    Set studentStates = paramss.getStudentStates();
    // 只有对于特定学籍状态的学生才可以退课。q
    if (!(studentStates.contains(student.getState()))) {
      ElectParams params = state.params;
      // 该课不允许退
      if (task.getElectInfo().getIsCancelable().equals(Boolean.FALSE)) { return courseIsNotCancelable; }
      // 查询当前学年最近一条学籍变动类型 是否在当前年份
      String modeName = "";
      Boolean flag = false;
      EntityQuery query = new EntityQuery(StudentAlteration.class, "studentAlteration");
      query.add(new Condition("studentAlteration.std.id=:stdId", state.std.getId()));
      PageLimit limit = new PageLimit();
      limit.setPageNo(1);
      limit.setPageSize(1);
      query.setLimit(limit);
      query.addOrder(new Order("studentAlteration.alterBeginOn desc"));
      Collection sa = utilService.search(query);
      for (Iterator iterator = sa.iterator(); iterator.hasNext();) {
        StudentAlteration sl = (StudentAlteration) iterator.next();
        Date date = new Date();
        Integer year = date.getYear();
        if (year.equals(sl.getAlterBeginOn().getYear())) {
          flag = true;
          modeName = sl.getMode().getName();
        }
      }
      if (flag) {
        // 某种学籍异动的人不能退课
        String noCXjyd = task.getCourse().getNoCancelXjyd();
        if (StringUtils.isNotEmpty(noCXjyd)) {
          String[] noCXjydSz = noCXjyd.split(",");
          for (String string : noCXjydSz) {
            if (string.equals(modeName)) { return courseIsNotCancelable; }
          }
        }
      }

      ElectRecord record = electRecordDAO.getLatestElectRecord(task, state.std.getId());
      // 本轮退课
      CourseTake take = courseTakeDAO.getCourseTask(task.getId(), state.getStd().getId());
      if (params.getIsCancelAnyTime().equals(Boolean.FALSE)) {
        // 指定学生没有选课纪录
        // 如果前几轮中有选中的,则报告不允许自由退课
        if (null != record) {
          if (Boolean.TRUE.equals(record.getIsPitchOn())
              && record.getTurn().compareTo(params.getTurn()) < 0) { return cancelCourseOfPreviousTurn; }
        } else {
          if (take.getCourseTakeType().getId()
              .equals(CourseTakeType.COMPULSORY)) { return "error.cancelElect.cancelAssigned"; }
        }
      } else {
        // 指定课程不能退课
        if (take.getCourseTakeType().getId()
            .equals(CourseTakeType.COMPULSORY)) { return "error.cancelElect.cancelAssigned"; }
        // 非本轮所退之课，不在指定范围之内
        if (null != record && Boolean.TRUE.equals(record.getIsPitchOn())
            && record.getTurn().compareTo(params.getTurn()) < 0 && !params.getNotCurrentCourseTypes()
                .contains(record.getTask().getCourseType())) { return cancelCourseOfPointTurn; }
      }
    }
    // 依据参数检查人数下限
    int rs = electRecordDAO.removeElection(task, state);
    if (rs == 0) {
      state.cancel(task);
      if (logger.isDebugEnabled()) {
        logger.debug("Withdraw Success std:" + state.getStd().getStdNo() + " task " + task.getId()
            + " credit: " + task.getCourse().getCredits() + " elected: " + state.electedCredit);
      }
      GenderLimitGroup occupiedGroup = null;// task.getTeachClass().getGenderLimitGroup(state.getStd().getGenderId());
      if (null != occupiedGroup) courseLimitGroupDao.releaseGroupLimit(occupiedGroup);
      return cancelSuccess;
    } else {
      logger.debug("Withdraw Failure(" + rs + ") std:" + state.getStd().getStdNo() + " task " + task.getId()
          + " credit: " + task.getCourse().getCredits() + " elected: " + state.electedCredit);
      if (rs == -2) { return cancelUnElected; }
      if (rs == -3) { return underMinStdCount; }
      // TODO define unknown error
      return underMinStdCount;
    }
  }

  public boolean isPassEvaluation(Long stdId) {
    List courseTakeList = courseTakeDAO.getCourseTakeIdsNeedEvaluate(stdId,
        evaluateSwitchService.getOpenCalendars(false));
    return courseTakeList.isEmpty();
  }

  public void setElectRecordDAO(ElectRecordDAO electRecordDAO) {
    this.electRecordDAO = electRecordDAO;
  }

  public void setCourseTakeDAO(CourseTakeDAO courseTakeDAO) {
    this.courseTakeDAO = courseTakeDAO;
  }

  public void setEvaluateSwitchService(EvaluateSwitchService evaluateSwitchService) {
    this.evaluateSwitchService = evaluateSwitchService;
  }

  public void setTeachTaskDAO(TeachTaskDAO teachTaskDAO) {
    this.teachTaskDAO = teachTaskDAO;
  }

  public void setTeachPlanService(TeachPlanService teachPlanService) {
    this.teachPlanService = teachPlanService;
  }

  public void setTeachTaskService(TeachTaskService teachTaskService) {
    this.teachTaskService = teachTaskService;
  }

  public void setGradeService(GradeService gradeService) {
    this.gradeService = gradeService;
  }
}
