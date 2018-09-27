package com.shufe.web.action.std.bursary;

import java.util.Locale;
import java.util.Map;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;
import com.ekingstar.commons.transfer.exporter.MessageResourceBuddle;
import com.shufe.model.std.bursary.BursaryApply;
import com.shufe.model.std.bursary.BursaryStatementSubject;

public class ApplyPropertyExtractor extends DefaultPropertyExtractor {

  public ApplyPropertyExtractor() {
    super();
  }

  public ApplyPropertyExtractor(Locale locale, MessageResourceBuddle buddle) {
    super(locale, buddle);
  }

  @Override
  protected Object extract(Object obj, String property) throws Exception {
    BursaryApply apply = (BursaryApply) obj;
    if (property.equals("gradeAchivement.moralScore2")) {
      Object score = PropertyUtils.getProperty(apply, "gradeAchivement.moralScore");
      if (null != score) {
        return score.toString() + " 班级第" + PropertyUtils.getProperty(apply, "moralGradeClassRank") + "名";
      } else {
        return "";
      }
    } else if (property.startsWith("subject.")) {
      Long subjectId = Long.valueOf(StringUtils.substringAfterLast(property, "subject."));
      for (Map.Entry<BursaryStatementSubject, String> e : apply.getStatements().entrySet()) {
        if (e.getKey().getId().equals(subjectId)) return e.getValue();
      }
      return "";
    } else return super.extract(obj, property);
  }

}
