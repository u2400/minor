package com.shufe.web.action.std.bursary;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionForward;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.model.Entity;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.Order;
import com.shufe.model.std.bursary.BursaryApplySetting;
import com.shufe.model.std.bursary.BursaryAward;
import com.shufe.model.system.calendar.TeachCalendar;
import com.shufe.web.action.common.ExampleTemplateAction;

/**
 * 助学金学生申请开关
 * 
 * @author chaostone
 */
public class SettingAction extends ExampleTemplateAction {
  {
    this.entityClass = BursaryApplySetting.class;
    this.entityName = "setting";
  }

  @SuppressWarnings("unchecked")
  protected void editSetting(HttpServletRequest request, Entity entity) throws Exception {
    BursaryApplySetting setting = (BursaryApplySetting) getEntity(request, BursaryApplySetting.class,
        "setting");
    this.addSingleParameter(request, "setting", setting);

    EntityQuery calendarQuery = new EntityQuery(TeachCalendar.class, "calendar");
    calendarQuery.addOrder(new Order("calendar.year desc"));
    calendarQuery.add(new Condition("calendar.term='2'"));

    addCollection(request, "calendars", utilService.search(calendarQuery));
    List<BursaryAward> awards = utilService.loadAll(BursaryAward.class);
    awards.removeAll(setting.getAwards());
    addCollection(request, "awards", awards);
  }

  @Override
  protected ActionForward saveAndForwad(HttpServletRequest request, Entity entity) throws Exception {
    String[] awards = request.getParameterValues("selectedAwards");
    BursaryApplySetting setting = (BursaryApplySetting) entity;
    setting.getAwards().clear();
    if (null != awards && awards.length > 0) {
      for (Long id : SeqStringUtil.transformToLong(awards)) {
        setting.getAwards().add((BursaryAward) utilService.get(BursaryAward.class, id));
      }
    }
    TeachCalendar calendar =(TeachCalendar) utilService.get(TeachCalendar.class, setting.getToSemester().getId());
    setting.setFromSemester(calendar.getPrevious());
    return super.saveAndForwad(request, entity);
  }
}
