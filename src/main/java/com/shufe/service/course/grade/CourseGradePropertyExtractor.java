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
 * chaostone             2006-4-18            Created
 *  
 ********************************************************************************/
package com.shufe.service.course.grade;

import java.util.Locale;

import org.apache.struts.util.MessageResources;

import com.ekingstar.commons.mvc.struts.misc.StrutsMessageResource;
import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;
import com.ekingstar.eams.system.basecode.industry.GradeType;
import com.shufe.model.course.grade.CourseGrade;
import com.shufe.model.course.grade.ExamGrade;

public class CourseGradePropertyExtractor extends DefaultPropertyExtractor {

  protected MessageResources resources;

  public CourseGradePropertyExtractor(Locale locale, MessageResources resources) {
    super();
    this.locale = locale;
    this.resources = resources;
    this.setBuddle(new StrutsMessageResource(resources));
  }

  public Object getPropertyValue(Object target, String property) throws Exception {
    CourseGrade grade = (CourseGrade) target;
    // 授课教师
    if (property.equals("makeup.score")) {
      return grade.getScoreDisplay(GradeType.MAKEUP);
    } else if (property.equals("delayed.score")) {
      return grade.getScoreDisplay(GradeType.DELAY);
    } else if (property.equals("someExamStatusNames")) {
      StringBuilder statuses = new StringBuilder();
      Long[] gradeTypes = new Long[] { GradeType.MAKEUP, GradeType.DELAY, GradeType.USUAL, GradeType.MIDDLE,
          GradeType.END };
      for (int i = 0; i < gradeTypes.length; i++) {
        ExamGrade examGrade = grade.getExamGrade(new GradeType(gradeTypes[i]));
        statuses.append(null == examGrade ? "" : examGrade.getExamStatus().getName());
        if (i + 1 < gradeTypes.length) {
          statuses.append(",");
        }
      }
      return statuses.toString();
    } else {
      return super.getPropertyValue(target, property);
    }
  }

  public MessageResources getResources() {
    return resources;
  }

  public void setResources(MessageResources resources) {
    this.resources = resources;
  }
}
