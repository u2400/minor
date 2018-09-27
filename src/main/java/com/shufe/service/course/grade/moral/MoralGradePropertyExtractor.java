package com.shufe.service.course.grade.moral;

import java.util.Locale;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.util.MessageResources;

import com.ekingstar.commons.mvc.struts.misc.StrutsMessageResource;
import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;
import com.shufe.model.course.grade.MoralGrade;
import com.shufe.model.system.baseinfo.AdminClass;

public class MoralGradePropertyExtractor extends DefaultPropertyExtractor {

  protected MessageResources resources;

  public MoralGradePropertyExtractor(Locale locale, MessageResources resources) {
    setLocale(locale);
    this.resources = resources;
    setBuddle(new StrutsMessageResource(resources));
  }

  public Object getPropertyValue(Object target, String property) throws Exception {
    MoralGrade moralScore = (MoralGrade) target;
    if (StringUtils.equals(property, "adminclassName")) {
      if (CollectionUtils.isEmpty(moralScore.getStd().getAdminClasses())) {
        return StringUtils.EMPTY;
      } else {
        return ((AdminClass) moralScore.getStd().getAdminClasses().iterator().next()).getName();
      }
    } else {
      return super.getPropertyValue(target, property);
    }
  }

  public void setResources(MessageResources resources) {
    this.resources = resources;
  }
}
