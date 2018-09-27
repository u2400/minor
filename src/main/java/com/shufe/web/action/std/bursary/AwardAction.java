package com.shufe.web.action.std.bursary;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionForward;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.model.Entity;
import com.ekingstar.commons.query.EntityQuery;
import com.shufe.model.std.bursary.BursaryAward;
import com.shufe.model.std.bursary.BursaryStatementSubject;
import com.shufe.web.action.common.ExampleTemplateAction;

/**
 * 助学金维护
 * 
 * @author chaostone
 */
public class AwardAction extends ExampleTemplateAction {
  {
    this.entityClass = BursaryAward.class;
    this.entityName = "award";
  }

  @SuppressWarnings("unchecked")
  protected void editSetting(HttpServletRequest request, Entity entity) throws Exception {
    BursaryAward award = (BursaryAward) getEntity(request, BursaryAward.class, "award");
    this.addSingleParameter(request, "award", award);

    EntityQuery subjectQuery = new EntityQuery(BursaryStatementSubject.class, "subject");
    List<BursaryStatementSubject> subjects = (List<BursaryStatementSubject>) utilService.search(subjectQuery);
    subjects.removeAll(award.getSubjects());
    addCollection(request, "subjects", subjects);
  }

  @Override
  protected ActionForward saveAndForwad(HttpServletRequest request, Entity entity) throws Exception {
    String[] subjects = request.getParameterValues("selectedSubjects");
    BursaryAward award = (BursaryAward) entity;
    award.getSubjects().clear();
    if (null != subjects && subjects.length > 0) {
      for (Long id : SeqStringUtil.transformToLong(subjects)) {
        award.getSubjects().add((BursaryStatementSubject) utilService.get(BursaryStatementSubject.class, id));
      }
    }
    return super.saveAndForwad(request, entity);
  }

}
