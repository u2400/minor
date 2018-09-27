package com.ekingstar.eams.teach.abilityrate.service;

import java.util.Locale;

import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;
import com.ekingstar.commons.transfer.exporter.MessageResourceBuddle;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityGrade;
import com.ekingstar.eams.teach.abilityrate.model.CourseAbilityRateApply;

public class ApplyPropertyExtractor extends DefaultPropertyExtractor {

  public ApplyPropertyExtractor() {
    super();
  }

  public ApplyPropertyExtractor(Locale locale, MessageResourceBuddle buddle) {
    super(locale, buddle);
  }

  @Override
  protected Object extract(Object obj, String property) throws Exception {
    if (property.startsWith("grade.")) {
      property = StringUtils.substringAfter(property, "grade.");
      CourseAbilityRateApply apply = (CourseAbilityRateApply) obj;
      for (CourseAbilityGrade grade : apply.getGrades()) {
        if (grade.getSubject().getId().toString().equals(property)) return grade.getScore();
      }
      return null;
    } else return super.extract(obj, property);
  }

}
