//$Id: EvaluateTeacherStat.java,v 1.1 2008-5-15 上午11:21:02 zhouqi Exp $
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
 * zhouqi              2008-5-15         	Created
 *  
 ********************************************************************************/

package com.shufe.model.quality.evaluate.stat;

import java.util.Iterator;

import com.ekingstar.eams.system.basecode.state.TeacherTitleLevel;
import com.shufe.model.quality.evaluate.Questionnaire;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.model.system.baseinfo.Teacher;

/**
 * 教师个人问题评教统计
 * 
 * @author zhouqi
 */
public class EvaluateTeacherStat extends QuestionnaireState {

  private static final long serialVersionUID = 8355028741190515253L;

  private Course course;

  private Teacher teacher;

  /** 教师评教时所在的院系/部门 */
  private Department department;

  /** 教师评教时该教师职称 */
  private TeacherTitleLevel titleLevel;

  /** 全校排名 */
  private Integer rank;

  /** 院系排名 */
  private Integer departRank;

  /** 投票人数 */
  private Integer validTickets;

  private Questionnaire questionnaire;

  public Course getCourse() {
    return course;
  }

  public void setCourse(Course course) {
    this.course = course;
  }

  public Teacher getTeacher() {
    return teacher;
  }

  public void setTeacher(Teacher teacher) {
    this.teacher = teacher;
  }

  public Integer getRank() {
    return rank;
  }

  public void setRank(Integer courseRank) {
    this.rank = courseRank;
  }

  public Integer getDepartRank() {
    return departRank;
  }

  public void setDepartRank(Integer departRank) {
    this.departRank = departRank;
  }

  public Department getDepartment() {
    return department;
  }

  public void setDepartment(Department department) {
    this.department = department;
  }

  public Integer getValidTickets() {
    return validTickets;
  }

  // public Integer getValidTickets(Option option) {
  // Set students = new HashSet();
  // for (Iterator it1 = getQuestionsStat().iterator(); it1.hasNext();) {
  // QuestionTeacherStat questionTeacher = (QuestionTeacherStat) it1.next();
  // for (Iterator it2 = questionTeacher.getQuestionResults().iterator(); it2.hasNext();) {
  // QuestionResult questionResult = (QuestionResult) it2.next();
  // if (questionResult.getOption().getId().longValue() == option.getId().longValue()) {
  // students.add(questionResult.getResult().getStudent());
  // }
  // }
  // }
  // return new Integer(students.size());
  // }

  public void setValidTickets(Integer validTickets) {
    this.validTickets = validTickets;
  }

  /**
   * 计算平均分
   */
  public void statSumSorce() {
    double sum = 0;// , total = 0;
    for (Iterator it = getQuestionsStat().iterator(); it.hasNext();) {
      QuestionTeacherStat questionStat = (QuestionTeacherStat) it.next();
      sum += questionStat.getEvgPoints().doubleValue();
      // total += questionStat.getQuestion().getScore().doubleValue();
    }
    // setSumScore(new Double(sum / total * 100.0));
    setSumScore(sum);
  }

  public TeacherTitleLevel getTitleLevel() {
    return titleLevel;
  }

  public void setTitleLevel(TeacherTitleLevel titleLevel) {
    this.titleLevel = titleLevel;
  }

  public Questionnaire getQuestionnaire() {
    return questionnaire;
  }

  public void setQuestionnaire(Questionnaire questionnaire) {
    this.questionnaire = questionnaire;
  }
}
