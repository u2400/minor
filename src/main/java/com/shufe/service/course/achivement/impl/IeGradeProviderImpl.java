package com.shufe.service.course.achivement.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ekingstar.commons.bean.comparators.PropertyComparator;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.eams.system.basecode.industry.CourseCategory;
import com.ekingstar.eams.system.basecode.industry.MajorType;
import com.ekingstar.eams.system.baseinfo.Course;
import com.shufe.model.course.grade.CourseGrade;
import com.shufe.model.course.grade.Grade;
import com.shufe.model.std.Student;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.service.BasicService;
import com.shufe.service.course.achivement.GradeResult;
import com.shufe.service.course.achivement.IeGradeProvider;

/**
 * 智育总评成绩提供者
 * 
 * @author chaostone
 */
public class IeGradeProviderImpl extends BasicService implements IeGradeProvider {

  @SuppressWarnings("unchecked")
  @Override
  public GradeResult getGrade(Student std, List<TeachCalendar> calendars) {
    EntityQuery query = new EntityQuery(CourseGrade.class, "cg");
    query.add(new Condition("cg.std=:std", std));
    query.add(new Condition("cg.calendar in (:calendars)", calendars));
    query.add(new Condition("cg.majorType.id=:majorType", MajorType.FIRST));
    query.add(new Condition("cg.course.category.id != :courseCategoryId", CourseCategory.PHYCIALID));
    query.add(new Condition("cg.courseType.id<>93"));
    query.add(new Condition("cg.status=:status", Grade.PUBLISHED));
    query.add(new Condition("not exists(from " + CourseGrade.class.getName()
        + " cg2 where cg2.std=cg.std and cg2.status=" + Grade.PUBLISHED
        + " and cg2.course=cg.course and cg2.calendar not in(:calendars)"
        + " and cg2.calendar.start < cg.calendar.start and (cg2.isPass=cg.isPass or cg.isPass=false and cg2.isPass=true))", calendars));
    List<CourseGrade> courseGrades = (List<CourseGrade>) utilService.search(query);
    Map<Course, CourseGrade> gradeMaps = new HashMap<Course, CourseGrade>();
    for (CourseGrade g : courseGrades) {
      CourseGrade existed = gradeMaps.get(g.getCourse());
      if (existed == null) {
        gradeMaps.put(g.getCourse(), g);
      } else {
        Float existScore = GaScoreProvider.getScore(existed);
        Float newScore = GaScoreProvider.getScore(g);
        if (null == existScore) {
          gradeMaps.put(g.getCourse(), g);
        } else if (null != newScore) {
          if (Float.compare(newScore, existScore) > 0) gradeMaps.put(g.getCourse(), g);
        }
      }
    }
    courseGrades = new ArrayList<CourseGrade>(gradeMaps.values());
    Collections.sort(courseGrades, new PropertyComparator("calendar.id"));
    float ga = 0;
    float credit = 0;
    boolean passed = true;
    StringBuilder sb = new StringBuilder();
    TeachCalendar calendar = null;
    for (CourseGrade courseGrade : courseGrades) {
      if (null == calendar || !courseGrade.getCalendar().equals(calendar)) {
        calendar = courseGrade.getCalendar();
        if (sb.length() > 0) sb.append("\n");
        sb.append(calendar.getYear()).append('(');
        sb.append(calendar.getTerm()).append(") \n");
      }
      Float score = GaScoreProvider.getScore(courseGrade);
      if (score != null) ga += score * courseGrade.getCourse().getCredits();

      if (!GaScoreProvider.isPassed(score)) passed = false;
      credit += courseGrade.getCourse().getCredits();
      sb.append(GradeSummary.summary(courseGrade, score)).append("\n");
    }
    ga = (credit != 0) ? ga / credit : 0;
    return new GradeResult(ga, passed, sb.toString());
  }
}
