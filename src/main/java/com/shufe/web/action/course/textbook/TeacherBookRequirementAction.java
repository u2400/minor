package com.shufe.web.action.course.textbook;

import java.util.ArrayList;
import java.util.Collection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.eams.system.basecode.industry.BookType;
import com.ekingstar.eams.system.basecode.industry.Press;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.course.textbook.BookRequirement;
import com.shufe.model.course.textbook.Textbook;
import com.shufe.service.course.task.TeachTaskService;
import com.shufe.service.course.textbook.BookRequirementService;

public class TeacherBookRequirementAction extends RequirementSearchAction {

  protected BookRequirementService bookRequirementService;

  protected TeachTaskService teachTaskService;

  /**
   * 新增或修改教材需求<br>
   * 如果一个任务需要两种以上的教材，则根据当前选择的教材需求 找到其他同一任务的教材需求。
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long taskId = getLong(request, "task.id");
    TeachTask task = null;
    if (null != taskId) {
      task = teachTaskService.getTeachTask(taskId);
    } else {
      BookRequirement require = (BookRequirement) utilService.get(BookRequirement.class,
          getLong(request, "requireId"));
      task = require.getTask();
    }
    addEntity(request, task);

    EntityQuery entityQuery = new EntityQuery(BookRequirement.class, "require");
    entityQuery.add(new Condition("require.task.id = :taskId", task.getId()));
    addCollection(request, "requires", utilService.search(entityQuery));
    addCollection(request, "presses", baseCodeService.getCodes(Press.class));
    addCollection(request, "bookTypes", baseCodeService.getCodes(BookType.class));
    return forward(request);
  }

  /**
   * 保存新增或修改的教材需求<br>
   * 如果引用了没有的教材,系统将保存该教材.
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    BookRequirement requirement = (BookRequirement) populateEntity(request, BookRequirement.class, "require");
    Textbook book = (Textbook) populateEntity(request, Textbook.class, "book");
    requirement.setTextbook(book);
    // 如果教学任务的要求中,没有该书,则添加进去.
    TeachTask task = teachTaskService.getTeachTask(requirement.getTask().getId());
    if (!task.getRequirement().getTextbooks().contains(book)) {
      task.getRequirement().getTextbooks().add(book);
      utilService.saveOrUpdate(task);
    }
    bookRequirementService.saveBookRequirement(requirement);
    return redirect(request, "search", "info.save.success");
  }

  public ActionForward updateCount(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    utilService.saveOrUpdate(populateEntity(request, BookRequirement.class, "require"));
    return redirect(request, "search", "info.save.success");
  }

  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Collection<BookRequirement> requirements = utilService.load(BookRequirement.class, "id",
        SeqStringUtil.transformToLong(get(request, "requireIds")));
    Collection<TeachTask> tasks = new ArrayList<TeachTask>();
    for (BookRequirement requirement : requirements) {
      tasks.add(requirement.getTask());
      requirement.getTask().getRequirement().getTextbooks().remove(requirement.getTextbook());
    }
    utilService.saveOrUpdate(tasks);
    utilService.remove(requirements);
    return redirect(request, "search", "info.delete.success");
  }

  public void setBookRequirementService(BookRequirementService bookRequirementService) {
    this.bookRequirementService = bookRequirementService;
  }

  public void setTeachTaskService(TeachTaskService teachTaskService) {
    this.teachTaskService = teachTaskService;
  }
}
