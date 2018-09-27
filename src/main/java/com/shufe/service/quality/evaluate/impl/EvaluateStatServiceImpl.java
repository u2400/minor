//$Id: EvaluateStatServiceImpl.java,v 1.1 2010-5-12 下午03:21:04 zhouqi Exp $
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

package com.shufe.service.quality.evaluate.impl;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ObjectUtils;

import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.quality.evaluate.EvaluateResult;
import com.shufe.model.quality.evaluate.Question;
import com.shufe.model.quality.evaluate.Questionnaire;
import com.shufe.model.quality.evaluate.stat.EvaluateCollegeStat;
import com.shufe.model.quality.evaluate.stat.EvaluateDepartmentStat;
import com.shufe.model.quality.evaluate.stat.EvaluateTeacherStat;
import com.shufe.model.quality.evaluate.stat.QuestionStat;
import com.shufe.model.quality.evaluate.stat.QuestionTeacherStat;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.model.system.baseinfo.Teacher;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.BasicService;
import com.shufe.service.quality.evaluate.EvaluateStatService;

/**
 * @author zhouqi
 */
public class EvaluateStatServiceImpl extends BasicService implements EvaluateStatService {

  public boolean evaluateStat(TeachCalendar calendar, Long[] stdTypeIds, Long[] departmentIds) {
    if (null == calendar || null == stdTypeIds || 0 == stdTypeIds.length || null == departmentIds
        || 0 == departmentIds.length) { return false; }
    try {
      // 统计前先清除当前学期的评教统计结果
      EntityQuery query = new EntityQuery(EvaluateTeacherStat.class, "evaluateTeacherStat");
      query.add(new Condition("evaluateTeacherStat.calendar =:calendar", calendar));
      query.add(new Condition("evaluateTeacherStat.department.id in (:departmentIds)", departmentIds));
      Collection evaluateTeacherStatResults = utilService.search(query);
      query = new EntityQuery(EvaluateDepartmentStat.class, "evaluateDepartmentStat");
      query.add(new Condition("evaluateDepartmentStat.calendar =:calendar", calendar));
      query.add(new Condition("evaluateDepartmentStat.department.id in (:departmentIds)", departmentIds));
      Collection evaluateDepartmentStatResults = utilService.search(query);

      query = new EntityQuery(EvaluateCollegeStat.class, "evaluateCollegeStat");
      query.add(new Condition("evaluateCollegeStat.calendar =:calendar", calendar));
      Collection evaluateCollegeStatResults = utilService.search(query);
      if (CollectionUtils.isNotEmpty(evaluateTeacherStatResults)) {
        utilService.remove(evaluateTeacherStatResults);
      }
      if (CollectionUtils.isNotEmpty(evaluateDepartmentStatResults)) {
        utilService.remove(evaluateDepartmentStatResults);
      }
      if (CollectionUtils.isNotEmpty(evaluateCollegeStatResults)) {
        utilService.remove(evaluateCollegeStatResults);
      }
      statTeacher(calendar, stdTypeIds, departmentIds);

      Collection departments = utilService.load(Department.class, "id", departmentIds);
      for (Iterator it = departments.iterator(); it.hasNext();) {
        Department department = (Department) it.next();
        processRinking(calendar, department);
      }
      processRinking(calendar);
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
    return true;
  }

  /**
   * @param sourceValue
   * @param goalList
   * @param sourceCache
   * @return
   */
  private int calcSourcePlace(double sourceValue, List<Object[]> goalList, double[] sourceCache) {
    int i = (int) sourceCache[0];// 准备上一次的存储位置
    // 判断当上一个学生结束时，是小于缓存中得分的存储处理
    if (sourceValue < sourceCache[1]) {
      sourceCache[1] = sourceValue;
      for (; i >= 0; i--) {
        if (sourceCache[1] >= Double.parseDouble(goalList.get(i)[1].toString())) {
          break;
        }
      }
      i++;
    } else if (sourceValue > sourceCache[1]) {
      sourceCache[1] = sourceValue;
      for (; i < goalList.size(); i++) {
        if (sourceCache[1] <= Double.parseDouble(goalList.get(i)[1].toString())) {
          break;
        }
      }
    }
    return i;
  }

  private <E> E getElementObject(Long elementId, Map<Long, E> elementsMap, Class<E> elementClazz,
      String objectName) {
    E e = elementsMap.get(elementId);
    if (null == e) {
      e = (E) utilService.load(elementClazz, elementId);
      if (null == e) { throw new RuntimeException(objectName + "ID = " + elementId + " is invalid ID."); }
      elementsMap.put(elementId, e);
    }
    return e;
  }

  private void statTeacher(TeachCalendar calendar, Long[] stdTypeIds, Long[] departIds) {
    String hql = "select task from TeachTask task where task.calendar=:calendar and task.teachClass.stdType.id in(:stdTypeIds) and task.arrangeInfo.teachDepart.id in(:departIds) order by task.course";
    Map<String, Object> params = new HashMap<String, Object>();
    params.put("calendar", calendar);
    params.put("stdTypeIds", stdTypeIds);
    params.put("departIds", departIds);
    EntityQuery query = new EntityQuery(hql);
    query.setParams(params);
    List<EvaluateTeacherStat> savedCache = new ArrayList<EvaluateTeacherStat>();
    List<TeachTask> tasks = (List<TeachTask>) utilService.search(query);
    Set<List<Object>> existsObjects = new HashSet<List<Object>>();
    for (TeachTask task : tasks) {
      if (null == task.getQuestionnaire()) {
        continue;
      }
      Course course = task.getCourse();
      List<Teacher> teachers = (List<Teacher>) task.getArrangeInfo().getTeachers();
      for (Teacher teacher : teachers) {
        List<Object> keys = new ArrayList<Object>();
        keys.add(course);
        keys.add(teacher);
        if (existsObjects.contains(keys)) {
          continue;
        }
        existsObjects.add(keys);
        EvaluateTeacherStat teacherStat = stateCourse(calendar, (Department) teacher.getDepartment(), course,
            teacher, task.getQuestionnaire());
        if (null != teacherStat) {
          savedCache.add(teacherStat);
        }
      }
      if (savedCache.size() > 100) {
        utilService.saveOrUpdate(savedCache);
        savedCache.clear();
      }
    }
    utilService.saveOrUpdate(savedCache);

    statDepart(calendar, departIds);
  }

  private EvaluateTeacherStat cloneEvaluateTeacherStat(EvaluateTeacherStat stat) {
    EvaluateTeacherStat newOne = new EvaluateTeacherStat();
    newOne.setCalendar(stat.getCalendar());
    newOne.setCourse(stat.getCourse());
    newOne.setDepartment(stat.getDepartment());
    newOne.setTeacher(stat.getTeacher());
    newOne.setSumScore(stat.getSumScore());
    newOne.setValidTickets(stat.getValidTickets());
    List<QuestionTeacherStat> questionStats = stat.getQuestionsStat();
    List<QuestionTeacherStat> newStats = new ArrayList(questionStats.size());
    for (QuestionTeacherStat qstat : questionStats) {
      QuestionTeacherStat newQstat = new QuestionTeacherStat();
      newQstat.setQuestion(qstat.getQuestion());
      newQstat.setEvgPoints(qstat.getEvgPoints());
      newQstat.setEvaluateTeacherStat(newOne);
      newStats.add(newQstat);
    }
    newOne.setQuestionsStat(newStats);
    return newOne;
  }

  private void processValidTickets(TeachCalendar calendar, Department department, Course course,
      Teacher teacher) {
    StringBuilder hql = new StringBuilder();
    hql.append("select er.id,er.score ");
    hql.append("from EvaluateResult er");
    hql.append(" where er.teachCalendar=:calendar");
    hql.append(" and er.task.course=:course");
    hql.append(" and (er.teacher = :teacher");
    hql.append(" or er.teacher is null ");
    hql.append("and exists (from er.task.arrangeInfo.teachers as tt where tt = :teacher))");
    hql.append(" and er.task.course=:course order by er.score");

    Map<String, Object> params = new HashMap<String, Object>();
    params.put("calendar", calendar);
    params.put("course", course);
    params.put("teacher", teacher);
    EntityQuery query = new EntityQuery(hql.toString());
    query.setParams(params);
    List<Object[]> rs = (List<Object[]>) utilService.search(query);
    int subNumberOf = rs.size();// 实际选票人数
    int onSell = (int) Math.floor(subNumberOf * 0.05);// 5%折后
    Set<Object> removedIds = new HashSet<Object>();
    for (int i = 0; i < onSell; i++) {
      Object[] data1 = rs.get(i);
      Object[] data2 = rs.get(rs.size() - 1 - i);
      removedIds.add(data1[0]);
      removedIds.add(data2[0]);
    }
    Map<String, Boolean> updates = new HashMap<String, Boolean>();
    updates.put("statState", Boolean.FALSE);
    utilService.update(EvaluateResult.class, "id", removedIds.toArray(), updates);
  }

  private EvaluateTeacherStat stateCourse(TeachCalendar calendar, Department department, Course course,
      Teacher teacher, Questionnaire questionnaire) {
    processValidTickets(calendar, department, course, teacher);
    StringBuilder hql = new StringBuilder();
    hql.append("select qer.question.id,sum(qer.score)/count(*),count(*)");
    hql.append("from EvaluateResult er");
    hql.append(" join er.questionResultSet as qer");
    hql.append(" where er.teachCalendar=:calendar");
    hql.append(" and er.task.course=:course");
    hql.append(" and (er.teacher = :teacher");
    hql.append(" or er.teacher is null ");
    hql.append("and exists (from er.task.arrangeInfo.teachers as tt where tt = :teacher))");
    hql.append(" and er.statState=true group by qer.question.id");
    Map<String, Object> params = new HashMap<String, Object>();
    params.put("calendar", calendar);
    params.put("course", course);
    params.put("teacher", teacher);
    EntityQuery query = new EntityQuery(hql.toString());
    query.setParams(params);
    List<Object[]> rs = (List<Object[]>) utilService.search(query);
    if (CollectionUtils.isEmpty(rs)) { return null; }
    if (rs.size() > 10) {
      System.out.println("over 10 question for course " + course.getCode());
    }
    EvaluateTeacherStat evaluateTeacherStat = new EvaluateTeacherStat();
    evaluateTeacherStat.setCalendar(calendar);
    evaluateTeacherStat.setTeacher(teacher);
    evaluateTeacherStat.setTitleLevel(teacher.getTitleLevel());
    evaluateTeacherStat.setDepartment((Department) teacher.getDepartment());
    // Questionnaire questionnaireObj = new Questionnaire();
    // questionnaireObj.setId(questionnaire.getId());
    evaluateTeacherStat.setQuestionnaire(questionnaire);
    if (null != teacher) {
      evaluateTeacherStat.setTitleLevel(teacher.getTitleLevel());
    }
    evaluateTeacherStat.setCourse(course);
    List<QuestionTeacherStat> questionStats = new ArrayList<QuestionTeacherStat>();
    evaluateTeacherStat.setQuestionsStat(questionStats);

    for (Object[] data : rs) {
      QuestionTeacherStat questionStat = new QuestionTeacherStat();
      questionStats.add(questionStat);
      questionStat.setEvaluateTeacherStat(evaluateTeacherStat);
      questionStat.setQuestion(new Question((Long) data[0]));
      // questionStat.setQuestionnaire(questionnaire);
      evaluateTeacherStat.setValidTickets(new Integer(((Number) data[2]).intValue()));
      questionStat.setEvgPoints((Double) data[1]);
    }
    evaluateTeacherStat.statSumSorce();
    return evaluateTeacherStat;
  }

  private void statDepart(TeachCalendar calendar, Long[] departmentIds) {
    StringBuilder hql = new StringBuilder();
    hql.append("select ets.department.id,qs.question.id,sum(qs.evgPoints)/count(*),count(*) ");
    hql.append("from EvaluateTeacherStat ets join ets.questionsStat qs ");
    hql.append("where ets.calendar=:calendar and ets.department.id in (:departmentIds) ");
    hql.append("group by ets.department.id,qs.question.id ");
    hql.append("order by ets.department.id");
    Map<String, Object> params = new HashMap<String, Object>();
    params.put("calendar", calendar);
    params.put("departmentIds", departmentIds);
    List<Object[]> datas = (List<Object[]>) utilService.searchHQLQuery(hql.toString(), params);
    Map<Long, EvaluateDepartmentStat> stats = new HashMap<Long, EvaluateDepartmentStat>();
    for (Object[] data : datas) {
      Long nextDepartId = (Long) data[0];
      EvaluateDepartmentStat eds = stats.get(nextDepartId);
      if (null == eds) {
        eds = new EvaluateDepartmentStat();
        eds.setDepartment(new Department(nextDepartId));
        eds.setCalendar(calendar);
        eds.setQuestionsStat(new ArrayList<QuestionStat>());
        String countHql = "select count(*),sum(ets.sumScore)/count(*) from EvaluateTeacherStat ets "
            + "where ets.calendar.id=" + calendar.getId() + " and ets.department.id=" + nextDepartId;
        List<Object[]> cnt = (List<Object[]>) utilService.searchHQLQuery(countHql);
        eds.setCount(new Integer(((Number) cnt.get(0)[0]).intValue()));
        eds.setSumScore((Double) (cnt.get(0)[1]));
        stats.put(nextDepartId, eds);
      }
      Long questionId = (Long) data[1];
      QuestionStat qs = new QuestionStat();
      qs.setQuestion(new Question(questionId));
      qs.setEvgPoints((Double) data[2]);
      eds.getQuestionsStat().add(qs);
      qs.setQuestionnaireState(eds);
    }

    String countHql = "select count(*),sum(ets.sumScore)/count(*) from EvaluateTeacherStat ets where ets.calendar.id = "
        + calendar.getId();
    List<Object[]> cnts = (List<Object[]>) utilService.searchHQLQuery(countHql);
    int cnt = ((Number) cnts.get(0)[0]).intValue();
    Double collegeScore = (Double) cnts.get(0)[1];
    EvaluateCollegeStat ecs = new EvaluateCollegeStat();
    ecs.setCalendar(calendar);
    ecs.setCount(cnt);
    ecs.setSumScore(collegeScore);
    ecs.setQuestionsStat(new ArrayList<QuestionStat>());
    hql = new StringBuilder();
    hql.append("select qs.question.id,sum(qs.evgPoints)/count(*) ");
    hql.append("from EvaluateTeacherStat ets join ets.questionsStat qs ");
    hql.append("where ets.calendar.id=" + calendar.getId());
    hql.append(" group by qs.question.id ");
    List<Object[]> scores = (List<Object[]>) utilService.searchHQLQuery(hql.toString());
    for (Object[] obj : scores) {
      QuestionStat qs = new QuestionStat();
      qs.setQuestion(new Question((Long) obj[0]));
      qs.setEvgPoints((Double) obj[1]);
      qs.setQuestionnaireState(ecs);
      ecs.getQuestionsStat().add(qs);
    }
    List<Object> bulkSave = new ArrayList<Object>();
    bulkSave.addAll(stats.values());
    bulkSave.add(ecs);
    utilService.saveOrUpdate(bulkSave);
  }

  /**
   * @param questionSumCache
   * @param question
   * @param score
   */
  private void addCaleResultOfQuestionSum(Map<Question, Double> questionSumCache, Question question,
      Float score) {
    Double questionScoreCache = questionSumCache.get(question);
    if (null == questionScoreCache) {
      questionScoreCache = score.doubleValue();
      questionSumCache.put(question, questionScoreCache);
    } else {
      questionSumCache.put(question, new Double(questionScoreCache.floatValue() + score.floatValue()));
    }
  }

  // private void processRinking(TeachCalendar calendar, Department department) {
  // NumberFormat nf = NumberFormat.getCurrencyInstance();
  // nf.setMaximumFractionDigits(2);
  // nf.setMinimumFractionDigits(2);
  // EntityQuery query = new EntityQuery(EvaluateTeacherStat.class, "ets");
  // query.add(new Condition("ets.calendar = :calendar", calendar));
  // query.addOrder(OrderUtils.parser("ets.sumScore desc"));
  // Collection rs = utilService.search(query);
  // String previousSumScore = null;
  // Map<Long, EvaluateTeacherStat> sumDepartScoreMap = new HashMap<Long, EvaluateTeacherStat>();
  // int rank = 0, departRank = 0;
  // for (Iterator it = rs.iterator(); it.hasNext();) {
  // EvaluateTeacherStat ets = (EvaluateTeacherStat) it.next();
  // if (null == previousSumScore && MapUtils.isEmpty(sumDepartScoreMap)) {
  // previousSumScore = nf.format(ets.getSumScore());
  // if (ets.getDepartment().getId() == department.getId()) {
  // sumDepartScoreMap.put(ets.getDepartment().getId(), ets);
  // departRank = 1;
  // }
  // rank++;
  // } else {
  // if (!nf.format(ets.getSumScore()).equals(previousSumScore)) {
  // rank++;
  // }
  // previousSumScore = nf.format(ets.getSumScore());
  // if (ets.getDepartment().getId() == department.getId()) {
  // EvaluateTeacherStat previousEts = sumDepartScoreMap.get(ets.getDepartment()
  // .getId());
  // if (null == previousEts) {
  // departRank = 1;
  // } else if (!nf.format(ets.getSumScore()).equals(
  // nf.format(previousEts.getSumScore()))) {
  // departRank = previousEts.getDepartRank() + 1;
  // }
  // sumDepartScoreMap.put(ets.getDepartment().getId(), ets);
  // }
  // }
  // ets.setRank(rank);
  //
  //
  // if (ets.getDepartment().getId() == department.getId()) {
  // ets.setDepartRank(departRank);
  // }
  // }
  // utilService.saveOrUpdate(rs);
  // }
  private void processRinking(TeachCalendar calendar, Department department) {
    NumberFormat nf = NumberFormat.getCurrencyInstance();
    nf.setMaximumFractionDigits(2);
    nf.setMinimumFractionDigits(2);
    EntityQuery query = new EntityQuery(EvaluateTeacherStat.class, "ets");
    query.add(new Condition("ets.calendar = :calendar", calendar));
    query.add(new Condition("ets.department = :department", department));
    query.addOrder(OrderUtils.parser("ets.sumScore desc"));
    Collection rs = utilService.search(query);
    String previousSumScore = null;
    int previousRank = 0, departRank = 0;
    for (Iterator it = rs.iterator(); it.hasNext();) {
      EvaluateTeacherStat ets = (EvaluateTeacherStat) it.next();
      String curSumScore = nf.format(ets.getSumScore());
      departRank++;
      if (!ObjectUtils.equals(curSumScore, previousSumScore)) {
        previousRank = departRank;
      }
      previousSumScore = curSumScore;
      ets.setDepartRank(previousRank);
    }
    utilService.saveOrUpdate(rs);
  }

  private void processRinking(TeachCalendar calendar) {
    NumberFormat nf = NumberFormat.getCurrencyInstance();
    nf.setMaximumFractionDigits(2);
    nf.setMinimumFractionDigits(2);
    EntityQuery query = new EntityQuery(EvaluateTeacherStat.class, "ets");
    query.add(new Condition("ets.calendar = :calendar", calendar));
    query.addOrder(OrderUtils.parser("ets.sumScore desc"));
    Collection rs = utilService.search(query);
    String previousSumScore = null;
    int previousRank = 0, rank = 0;
    for (Iterator it = rs.iterator(); it.hasNext();) {
      EvaluateTeacherStat ets = (EvaluateTeacherStat) it.next();
      String curSumScore = nf.format(ets.getSumScore());
      rank++;
      if (!ObjectUtils.equals(curSumScore, previousSumScore)) {
        previousRank = rank;
      }
      previousSumScore = curSumScore;
      ets.setRank(previousRank);
    }
    utilService.saveOrUpdate(rs);
  }
}
