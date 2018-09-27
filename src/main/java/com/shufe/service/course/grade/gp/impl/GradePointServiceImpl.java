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
 * chaostone             2007-1-9            Created
 *  
 ********************************************************************************/

package com.shufe.service.course.grade.gp.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;

import com.ekingstar.commons.bean.comparators.PropertyComparator;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.eams.system.basecode.industry.MajorType;
import com.ekingstar.eams.teach.program.service.GradeFilter;
import com.ekingstar.eams.teach.program.service.SubstituteCourseService;
import com.ekingstar.eams.teach.program.service.impl.SubstituteGradeFilter;
import com.shufe.model.course.grade.CourseGrade;
import com.shufe.model.course.grade.Grade;
import com.shufe.model.course.grade.gp.GPMapping;
import com.shufe.model.course.grade.gp.GradePointRule;
import com.shufe.model.course.grade.gp.MultiStdGP;
import com.shufe.model.course.grade.gp.StdGP;
import com.shufe.model.course.grade.gp.StdGPPerTerm;
import com.shufe.model.std.Student;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.BasicService;
import com.shufe.service.course.grade.gp.GradePointService;

public class GradePointServiceImpl extends BasicService implements GradePointService {

  protected SubstituteCourseService substituteCourseService;

  /**
   * @see GradePointService#statStdGPA(TeachCalendar, Student, Integer, Boolean)
   */
  public Float statStdGPA(Student std, TeachCalendar calendar, MajorType majorType, Boolean isPublished) {
    if (null == calendar) return getBestGpa(std, majorType, isPublished);

    EntityQuery entityQuery = new EntityQuery(CourseGrade.class, "grade");
    entityQuery.add(new Condition("grade.std=:std", std));
    if (null != majorType) {
      entityQuery.add(new Condition("grade.majorType=:majorType", majorType));
    }
    if (null != isPublished) {
      if (isPublished.booleanValue()) {
        entityQuery.add(new Condition("grade.status=:status", Grade.PUBLISHED));
      } else {
        entityQuery.add(new Condition("grade.status<>:status", Grade.PUBLISHED));
      }
    }
    if (null != calendar) {
      entityQuery.add(new Condition("grade.calendar=:calendar", calendar));
    }
    entityQuery.setSelect("select sum(grade.credit*grade.GP)/sum(grade.credit) ");
    List rs = (List) utilDao.search(entityQuery);
    if (rs.isEmpty()) {
      return new Float(0);
    } else {
      Number gpa = (Number) rs.get(0);
      if (null == gpa) {
        return new Float(0);
      } else {
        return new Float(((int) (gpa.doubleValue() * 100)) / 100.0);
      }
    }
  }

  @SuppressWarnings("unchecked")
  public StdGP statStdGPA(Student std, List grades) {
    Map gradeMap = new HashMap();
    // 计算出每学期“学分*绩点”之和
    for (Iterator it = grades.iterator(); it.hasNext();) {
      CourseGrade grade = (CourseGrade) it.next();
      if (grade.getStd().getId().equals(std.getId())) {
        Object key = grade.getCalendar();
        GradeStat value = (GradeStat) gradeMap.get(key);
        if (null == value) {
          value = new GradeStat();
          gradeMap.put(key, value);
        }
        value.addGrade(grade.getIsPass(), grade.getCourse().getCredits().floatValue(),
            grade.getGP().doubleValue());
      }
    }
    // 建立一个StdGP对象，遂将上面计算的每学期“学分*绩点”之和，除以每学期总学分，
    // 保存在StdGP的“”中
    StdGP stdGP = new StdGP(std);
    for (Iterator it = gradeMap.keySet().iterator(); it.hasNext();) {
      Object key = (Object) it.next();
      StdGPPerTerm stdGPPerTerm = new StdGPPerTerm();
      stdGPPerTerm.setCalendar((TeachCalendar) key);
      GradeStat value = (GradeStat) gradeMap.get(key);
      stdGPPerTerm.setGPA(value.getGpa());
      stdGPPerTerm.setCount(value.count);
      stdGPPerTerm.setCredits(value.passedCredits);
      stdGP.add(stdGPPerTerm);
    }
    List gpList = stdGP.getGPList();
    if (gpList != null && gpList.isEmpty() == false) {
      Collections.sort(stdGP.getGPList(), new PropertyComparator("calendar.start"));
    }
    List newGrades=null;
    if(grades.size()>0) {
    GradeFilter filter = new SubstituteGradeFilter(
        substituteCourseService.getStdSubstituteCourses(std, ((CourseGrade) grades.get(0)).getMajorType()));
      newGrades = filter.filter(grades);
    }else {
      newGrades=grades;
    }
    double credits = 0;
    double gp = 0d;

    int passedCount = 0;
    float passedCredits = 0f;
    for (Iterator iter = newGrades.iterator(); iter.hasNext();) {
      CourseGrade courseGrade = (CourseGrade) iter.next();
      credits += courseGrade.getCredit().doubleValue();
      gp += courseGrade.getCourse().getCredits().doubleValue() * courseGrade.getGP().doubleValue();
      if (courseGrade.getIsPass().equals(Boolean.TRUE)) {
        passedCredits += courseGrade.getCourse().getCredits();
        passedCount += 1;
      }
    }
    Float gpa = null;
    if (credits == 0) {
      gpa = new Float(0);
    } else {
      gpa = new Float(gp / credits);
    }
    stdGP.setCount(passedCount);
    stdGP.setCredits(passedCredits);
    stdGP.setGPA(gpa);
    return stdGP;
  }

  /**
   * 首先获得各个学期的学分*绩点和学分(group by calendar),<br>
   * 然后在此基础上生成每学期的绩点<br>
   * 并依照各个学期的学分*绩点和学分计算总的平均绩点
   */
  public StdGP statStdGPA(Student std, MajorType majorType, Boolean isPublished) {
    EntityQuery entityQuery = new EntityQuery(CourseGrade.class, "grade");
    if (null != majorType) {
      entityQuery.add(new Condition("grade.majorType=:majorType", majorType));
    }
    if (null != isPublished) {
      if (isPublished.booleanValue()) {
        entityQuery.add(new Condition("grade.status=:status", Grade.PUBLISHED));
      } else {
        entityQuery.add(new Condition("grade.status<>:status", Grade.PUBLISHED));
      }
    }
    entityQuery.add(new Condition("grade.std=:std", std));
    entityQuery.setSelect("select grade.calendar.id,sum(grade.course.credits), "
        + "sum(grade.credit*grade.GP),sum(grade.credit*grade.score),"
        + "count(*),sum(CASE WHEN grade.isPass=true THEN grade.credit ELSE 0 END)");
    entityQuery.groupBy("grade.calendar.id");
    List rs = (List) utilDao.search(entityQuery);
    StdGP stdGP = new StdGP(std);

    double creditGPs = 0;// 绩点=∑绩点*学分
    double credits = 0;// 总学分
    double receivedCredits = 0;// 获得的总学分
    int counts = 0;// 总们数
    int creditScores = 0;// 分数=∑学分*成绩
    if (!rs.isEmpty()) {
      // 遍历每一个学期的成绩
      for (Iterator iter = rs.iterator(); iter.hasNext();) {
        Object[] gpInfo = (Object[]) iter.next();
        StdGPPerTerm stdGPPerTerm = new StdGPPerTerm();
        stdGPPerTerm.setCalendar((TeachCalendar) utilDao.get(TeachCalendar.class, (Long) gpInfo[0]));
        double creditsTerm = (null == gpInfo[1]) ? 0 : ((Number) gpInfo[1]).doubleValue();
        double creditGPsTerm = (null == gpInfo[2]) ? 0 : ((Number) gpInfo[2]).doubleValue();
        double receivedCreditsPerTerm = (null == gpInfo[5]) ? 0 : ((Number) gpInfo[5]).doubleValue();
        // 计算平均绩点和平均分
        stdGPPerTerm.setCredits(new Float(receivedCreditsPerTerm));
        double creditScoresTerm = 0;
        if (0 != creditsTerm) {
          stdGPPerTerm.setGPA(new Float(creditGPsTerm / creditsTerm));
          creditScoresTerm = (null == gpInfo[3]) ? 0 : ((Number) gpInfo[3]).doubleValue();
          stdGPPerTerm.setGA(new Float(creditScoresTerm / creditsTerm));

        }
        int count = (null == gpInfo[4]) ? 0 : ((Number) gpInfo[4]).intValue();
        stdGPPerTerm.setCount(new Integer(count));

        counts += count;
        creditScores += creditScoresTerm;
        creditGPs += creditGPsTerm;
        credits += creditsTerm;

        receivedCredits += receivedCreditsPerTerm;
        stdGP.add(stdGPPerTerm);
      }
      stdGP.setCredits(new Float(receivedCredits));
      if (0 != credits) {
        stdGP.setGPA(new Float(creditGPs / credits));
        stdGP.setGA(new Float(creditScores / credits));
      }
      stdGP.setCount(new Integer(counts));
    }
    Collections.sort(stdGP.getGPList(), new PropertyComparator("calendar.yearTerm", true));
    stdGP.setGPA(getBestGpa(std, majorType, isPublished));
    return stdGP;
  }

  private Float getBestGpa(Student std, MajorType majorType, Boolean isPublished) {
    EntityQuery entityQuery = new EntityQuery(CourseGrade.class, "grade");
    if (null != majorType) {
      entityQuery.add(new Condition("grade.majorType=:majorType", majorType));
    }
    if (null != isPublished) {
      if (isPublished.booleanValue()) {
        entityQuery.add(new Condition("grade.status=:status", Grade.PUBLISHED));
      } else {
        entityQuery.add(new Condition("grade.status<>:status", Grade.PUBLISHED));
      }
    }
    entityQuery.add(new Condition("grade.std=:std", std));
    List grades = (List) utilService.search(entityQuery);
    GradeFilter filter = new SubstituteGradeFilter(
        substituteCourseService.getStdSubstituteCourses(std, majorType));
    grades = filter.filter(grades);
    double credits = 0;
    double gp = 0;
    for (Iterator iter = grades.iterator(); iter.hasNext();) {
      CourseGrade courseGrade = (CourseGrade) iter.next();
      credits += courseGrade.getCredit().doubleValue();
      gp += courseGrade.getCredit().doubleValue() * courseGrade.getGP().doubleValue();
    }
    if (credits == 0) {
      return new Float(0);
    } else {
      return new Float(gp / credits);
    }
  }

  public StdGP statStdGPAByYear(Student std, MajorType majorType, Boolean isPublished) {
    EntityQuery entityQuery = new EntityQuery(CourseGrade.class, "grade");
    if (null != majorType) {
      entityQuery.add(new Condition("grade.majorType=:majorType", majorType));
    }
    if (null != isPublished) {
      if (isPublished.booleanValue()) {
        entityQuery.add(new Condition("grade.status=:status", Grade.PUBLISHED));
      } else {
        entityQuery.add(new Condition("grade.status<>:status", Grade.PUBLISHED));
      }
    }
    entityQuery.add(new Condition("grade.std=:std", std));
    List<CourseGrade> bestGrades = (List<CourseGrade>) utilService.search(entityQuery);
    if (CollectionUtils.isNotEmpty(bestGrades)) {
      GradeFilter filter = new SubstituteGradeFilter(
          substituteCourseService.getStdSubstituteCourses(std, majorType));
      bestGrades = filter.filter(bestGrades);
      int size = bestGrades.size();
      Long[] gradeIds = new Long[size <= 50 ? size : 50];
      StringBuilder hql = new StringBuilder();
      hql.append("(");
      List<Long[]> paramValues = new ArrayList<Long[]>();
      for (int i = 0, j = 0; i < bestGrades.size(); i++) {
        if (i > 0 && 0 == i % 50) {
          hql.append("grade.id in (:gradeId" + j + ") or ");
          paramValues.add(gradeIds);
          j++;
          gradeIds = new Long[(size - i) <= 50 ? (size - i) : 50];
        }
        gradeIds[i % 50] = bestGrades.get(i).getId();
      }
      hql.append("grade.id in (:gradeIdFF))");
      paramValues.add(gradeIds);
      Condition gradeIdCondition = new Condition(hql.toString());
      gradeIdCondition.getValues().addAll(paramValues);
      entityQuery.add(gradeIdCondition);
    }
    entityQuery.setSelect("select grade.calendar.year,sum(grade.credit), "
        + "sum(grade.credit*grade.GP),sum(grade.credit*grade.score),"
        + "count(*),sum(CASE WHEN grade.isPass=true THEN grade.credit ELSE 0 END)");
    entityQuery.groupBy("grade.calendar.year");
    Collection rs = utilService.search(entityQuery);
    StdGP stdGP = new StdGP(std);

    double creditGPs = 0;// 绩点=∑绩点*学分
    double credits = 0;// 总学分
    double receivedCredits = 0;// 获得的总学分
    int counts = 0;// 总们数
    int creditScores = 0;// 分数=∑学分*成绩
    if (!rs.isEmpty()) {
      // 遍历每一个学期的成绩
      for (Object[] gpInfo : (Collection<Object[]>) rs) {
        StdGPPerTerm stdGPPerTerm = new StdGPPerTerm();
        stdGPPerTerm.setCalendar((TeachCalendar) utilService
            .searchHQLQuery("from TeachCalendar tc where tc.year ='" + (String) gpInfo[0] + "'").get(0));
        double creditsTerm = (null == gpInfo[1]) ? 0 : ((Number) gpInfo[1]).doubleValue();
        double creditGPsTerm = (null == gpInfo[2]) ? 0 : ((Number) gpInfo[2]).doubleValue();
        double receivedCreditsPerTerm = (null == gpInfo[5]) ? 0 : ((Number) gpInfo[5]).doubleValue();
        // 计算平均绩点和平均分
        stdGPPerTerm.setCredits(new Float(receivedCreditsPerTerm));
        double creditScoresTerm = 0;
        if (0 != creditsTerm) {
          stdGPPerTerm.setGPA(new Float(creditGPsTerm / creditsTerm));
          creditScoresTerm = (null == gpInfo[3]) ? 0 : ((Number) gpInfo[3]).doubleValue();
          stdGPPerTerm.setGA(new Float(creditScoresTerm / creditsTerm));

        }
        int count = (null == gpInfo[4]) ? 0 : ((Number) gpInfo[4]).intValue();
        stdGPPerTerm.setCount(new Integer(count));

        counts += count;
        creditScores += creditScoresTerm;
        creditGPs += creditGPsTerm;
        credits += creditsTerm;

        receivedCredits += receivedCreditsPerTerm;
        stdGP.add(stdGPPerTerm);
      }
      stdGP.setCredits(new Float(receivedCredits));
      if (0 != credits) {
        stdGP.setGPA(new Float(creditGPs / credits));
        stdGP.setGA(new Float(creditScores / credits));
      }
      stdGP.setCount(new Integer(counts));
    }
    Collections.sort(stdGP.getGPList(), new PropertyComparator("calendar.yearTerm", true));
    return stdGP;
  }

  public void reStatGP(GradePointRule rule, String calendarIds) {
    if (null != rule) {
      for (Iterator gpMapingIter = rule.getGPMappings().iterator(); gpMapingIter.hasNext();) {
        GPMapping gpMapping = (GPMapping) gpMapingIter.next();
        String hql = "update CourseGrade set GP=" + gpMapping.getGp() + " where (score between "
            + gpMapping.getMinScore() + " and " + gpMapping.getMaxScore() + ") and instr('," + calendarIds
            + ",',','||calendar.id||',')>0 and markStyle.id=" + rule.getMarkStyle().getId();
        utilDao.executeUpdateHql(hql, (Object[]) null);
      }
    }
  }

  public MultiStdGP statMultiStdGPA(Collection<Student> stds, MajorType majorType, Boolean isPublished,
      Boolean isYearInCalendar) {
    MultiStdGP multiStdGP = new MultiStdGP();
    for (Student std : stds) {
      if (Boolean.TRUE.equals(isYearInCalendar)) {
        multiStdGP.getStdGPs().add(statStdGPAByYear(std, majorType, isPublished));
      } else {
        multiStdGP.getStdGPs().add(statStdGPA(std, majorType, isPublished));
      }
    }
    multiStdGP.statCalendarsFromStdGP();
    return multiStdGP;
  }

  public void setSubstituteCourseService(SubstituteCourseService substituteCourseService) {
    this.substituteCourseService = substituteCourseService;
  }

  class GradeStat {
    int count;
    int passedCount;
    float credits;
    float passedCredits;
    double gradePoints;

    public void addGrade(boolean passed, float credit, double gp) {
      credits += credit;
      gradePoints += credit * gp;
      if (passed) {
        passedCount += 1;
        passedCredits += credit;
      }
      count += 1;
    }

    public Float getGpa() {
      return new Float(gradePoints / credits);
    }
  }

}
