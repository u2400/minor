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
 * ============         ============        ===================================
 * zq                   2007-09-18          修改或替换了下面所有的info()方法
 ********************************************************************************/
package com.shufe.web.action.course.textbook;

import java.util.Collection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.mvc.struts.misc.ForwardSupport;
import com.ekingstar.commons.mvc.struts.misc.ImporterServletSupport;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.transfer.Transfer;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.utils.query.QueryRequestSupport;
import com.ekingstar.commons.utils.transfer.ImporterForeignerListener;
import com.ekingstar.eams.system.basecode.industry.BookType;
import com.ekingstar.eams.system.basecode.industry.Press;
import com.ekingstar.eams.system.basecode.industry.TextbookAwardLevel;
import com.shufe.model.course.textbook.Textbook;
import com.shufe.service.course.textbook.TextbookService;
import com.shufe.service.course.textbook.impl.TextbookImportListener;
import com.shufe.service.system.codeGen.CodeGenerator;
import com.shufe.web.action.common.DispatchBasicAction;

/**
 * 教材管理响应类
 * 
 * @author chaostone
 */
public class TextbookAction extends DispatchBasicAction {

  private TextbookService textbookService;

  private CodeGenerator codeGenerator;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    request.setAttribute("presses", baseCodeService.getCodes(Press.class));
    addCollection(request, "awardLevels", baseCodeService.getCodes(TextbookAwardLevel.class));
    return forward(request);
  }

  /**
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery entityQuery = buildQuery(request);
    addCollection(request, "textbooks", utilService.search(entityQuery));
    return forward(request);
  }

  private EntityQuery buildQuery(HttpServletRequest request) {
    EntityQuery entityQuery = new EntityQuery(Textbook.class, "textbook");
    QueryRequestSupport.populateConditions(request, entityQuery);
    entityQuery.setLimit(getPageLimit(request));
    entityQuery.addOrder(OrderUtils.parser(request.getParameter("orderBy")));
    return entityQuery;
  }

  protected Collection getExportDatas(HttpServletRequest request) {
    EntityQuery entityQuery = buildQuery(request);
    entityQuery.setLimit(null);
    return utilService.search(entityQuery);
  }

  public ActionForward importData(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TransferResult tr = new TransferResult();
    Transfer transfer = ImporterServletSupport.buildEntityImporter(request, Textbook.class, tr);
    if (null == transfer) { return forward(request, "/pages/components/importData/error"); }
    transfer.addListener(new ImporterForeignerListener(utilService))
        .addListener(new TextbookImportListener(utilService));
    transfer.transfer(tr);
    if (tr.hasErrors()) {
      return forward(request, "/pages/components/importData/error");
    } else {
      return redirect(request, "search", "info.import.success");
    }
  }

  /**
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long textbookId = getLong(request, "textbookId");
    if (null != textbookId) {
      addSingleParameter(request, "textbook", utilService.get(Textbook.class, textbookId));
    }
    addCollection(request, "presses", baseCodeService.getCodes(Press.class));
    addCollection(request, "bookTypes", baseCodeService.getCodes(BookType.class));
    addCollection(request, "awardLevels", baseCodeService.getCodes(TextbookAwardLevel.class));
    return forward(request);
  }

  /**
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Textbook textbook = (Textbook) populateEntity(request, Textbook.class, "textbook");

    EntityQuery query = new EntityQuery(Textbook.class, "textbook");
    if (null != textbook && null != textbook.getId()) {
      query.add(new Condition("textbook != :textbook", textbook));
    }
    query.add(new Condition("textbook.code = :code", textbook.getCode()));
    if (CollectionUtils.isNotEmpty(utilService.search(query))) {
      addSingleParameter(request, "textbook", textbook);
      saveErrors(request.getSession(),
          ForwardSupport.buildMessages(new String[] { "info.save.failure.overlap" }));
      return forward(request, "form");
    }

    utilService.saveOrUpdate(textbook);
    return redirect(request, "search", "info.save.success");
  }

  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "textbook", utilService.get(Textbook.class, getLong(request, "textbookId")));
    return forward(request);
  }

  /**
   * 删除教材信息
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long textbookId = getLong(request, "textbookId");
    if (null == textbookId) { return forward(mapping, request, "error.teachTask.id.needed", "error"); }
    utilService.remove(textbookService.getTextbook(textbookId));
    return redirect(request, "search", "info.save.success");
  }

  public void setTextbookService(TextbookService textbookService) {
    this.textbookService = textbookService;
  }

  public void setCodeGenerator(CodeGenerator codeGenerator) {
    this.codeGenerator = codeGenerator;
  }
}
