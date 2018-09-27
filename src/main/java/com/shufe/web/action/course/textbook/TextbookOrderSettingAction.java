package com.shufe.web.action.course.textbook;

import javax.servlet.http.HttpServletRequest;

import com.ekingstar.commons.model.Entity;
import com.shufe.model.course.textbook.TextbookOrderSetting;
import com.shufe.web.action.common.CalendarRestrictionExampleTemplateAction;

public class TextbookOrderSettingAction extends CalendarRestrictionExampleTemplateAction {

  {
    this.entityName = TextbookOrderSetting.class.getName();
    this.entityClass = TextbookOrderSetting.class;
  }

  protected void indexSetting(HttpServletRequest request) throws Exception {
    
  }

  protected void editSetting(HttpServletRequest request, Entity entity) throws Exception {
    ;
  }
}
