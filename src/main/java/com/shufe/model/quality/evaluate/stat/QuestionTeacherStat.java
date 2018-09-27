//$Id: TeacherQuestionStat.java,v 1.1 2009-6-24 下午06:13:44 zhouqi Exp $
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
 * zhouqi              2009-6-24             Created
 *  
 ********************************************************************************/

package com.shufe.model.quality.evaluate.stat;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.quality.evaluate.Question;
import com.shufe.model.quality.evaluate.Questionnaire;

/**
 * @author zhouqi
 */
public class QuestionTeacherStat extends LongIdObject {

  private static final long serialVersionUID = 874201581511308126L;

  private EvaluateTeacherStat evaluateTeacherStat;

  /** 问题所属问卷 */
  private Questionnaire questionnaire;

  private Question question;

  private Double evgPoints;

  public QuestionTeacherStat() {
  }

  /**
   * @param questionnaireState
   * @param question
   * @param evgPoints
   */
  public QuestionTeacherStat(EvaluateTeacherStat evaluateTeacherStat, Question question, Double evgPoints) {
    this.evaluateTeacherStat = evaluateTeacherStat;
    this.question = question;
    this.evgPoints = evgPoints;
  }

  public Double getEvgPoints() {
    return evgPoints;
  }

  public void setEvgPoints(Double evgPoints) {
    this.evgPoints = evgPoints;
  }

  public Question getQuestion() {
    return question;
  }

  public void setQuestion(Question question) {
    this.question = question;
  }

  public EvaluateTeacherStat getEvaluateTeacherStat() {
    return evaluateTeacherStat;
  }

  public void setEvaluateTeacherStat(EvaluateTeacherStat evaluateTeacherStat) {
    this.evaluateTeacherStat = evaluateTeacherStat;
  }

  public Questionnaire getQuestionnaire() {
    return questionnaire;
  }

  public void setQuestionnaire(Questionnaire questionnaire) {
    this.questionnaire = questionnaire;
  }
}
