package com.shufe.service.std.exemption;

import java.text.DecimalFormat;
import java.util.Collection;
import java.util.Locale;

import org.apache.struts.util.MessageResources;
import org.springframework.util.CollectionUtils;

import com.ekingstar.commons.mvc.struts.misc.StrutsMessageResource;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.ekingstar.eams.system.basecode.industry.MajorType;
import com.shufe.model.course.grade.other.OtherGrade;
import com.shufe.model.std.exemption.ExemptionResult;
import com.shufe.service.course.grade.gp.GradePointService;

public class ExemptionPropertyExtractor extends DefaultPropertyExtractor {

  protected int seqNo = 0;

  protected MessageResources resources;

  protected GradePointService gradePointService;

  protected UtilService utilService;

  public ExemptionPropertyExtractor() {
    super();
    seqNo++;
  }

  public ExemptionPropertyExtractor(Locale locale, MessageResources resources,
      GradePointService gradePointService, UtilService utilService) {
    this();
    this.locale = locale;
    this.resources = resources;
    this.gradePointService = gradePointService;
    this.utilService = utilService;
    this.setBuddle(new StrutsMessageResource(this.resources));
  }

  public Object getPropertyValue(Object target, String property) throws Exception {
    ExemptionResult result = (ExemptionResult) target;
    if (property.equals("seqNo")) {
      return seqNo++ + "";
    } else if (property.equals("student.major_field")) {
      String content = result.getStudent().getFirstMajor().getName();
      if (null != result.getStudent().getFirstAspect()) {
        content += "（" + result.getStudent().getFirstAspect().getName() + "）";
      }
      return content;
    } else if (property.equals("gpa")) {
      return new DecimalFormat("#.##").format(gradePointService.statStdGPA(result.getStudent(),
          new MajorType(MajorType.FIRST), Boolean.TRUE).getGPA());
    } else if (property.equals("ect4")) {
      return getScoreInOtherGrade(result, new Long(2));
    } else if (property.equals("ect6")) {
      return getScoreInOtherGrade(result, new Long(3));
    } else if (property.equals("calendar.year_term")) {
      return result.getCalendar().getYear() + " " + result.getCalendar().getTerm();
    } else {
      return super.getPropertyValue(target, property);
    }
  }

  protected Object getScoreInOtherGrade(ExemptionResult result, Long categoryId) {
    if (null == result || null == result.getStudent() || null == result.getStudent().getId()
        || null == categoryId) { return ""; }
    EntityQuery query = new EntityQuery(OtherGrade.class, "otherGrade");
    query.add(new Condition("otherGrade.category.id = :categoryId", categoryId));
    query.add(new Condition("otherGrade.std = :std", result.getStudent()));
    query.addOrder(OrderUtils.parser("otherGrade.score desc"));
    Collection<OtherGrade> otherGrades = utilService.search(query);
    return CollectionUtils.isEmpty(otherGrades) ? "" : otherGrades.iterator().next().getScoreDisplay();
  }
}
