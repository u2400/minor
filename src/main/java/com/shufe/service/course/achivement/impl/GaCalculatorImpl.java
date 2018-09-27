package com.shufe.service.course.achivement.impl;

import com.shufe.model.course.achivement.GradeAchivement;
import com.shufe.service.course.achivement.GaCalculator;

public class GaCalculatorImpl implements GaCalculator {

  /**
   * 德育×30%+智育×65%+体育×5%
   */
  @Override
  public Float calc(GradeAchivement ga) {
    float score = 0;
    if (null != ga.getMoralScore()) score += ga.getMoralScore() * 0.30;
    if (null != ga.getIeScore()) score += ga.getIeScore() * 0.65;
    if (null != ga.getPeScore()) score += ga.getPeScore() * 0.05;
    return score;
  }

}
