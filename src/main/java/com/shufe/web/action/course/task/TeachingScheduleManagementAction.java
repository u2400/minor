/**
 * 
 */
package com.shufe.web.action.course.task;

import java.io.File;
import java.net.URLEncoder;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.mvc.web.download.DownloadHelper;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.course.task.TeachingSchedule;

/**
 * @author zhouqi
 */
public class TeachingScheduleManagementAction extends TeachingScheduleAction {

  @SuppressWarnings("unchecked")
  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Boolean isBinding = getBoolean(request, "isBinding");

    EntityQuery query1 = new EntityQuery(TeachTask.class, "task");
    populateConditions(request, query1);
    if (null != isBinding) {
      if (isBinding.booleanValue()) {
        query1.add(new Condition("exists (from " + TeachingSchedule.class.getName()
            + " schedule where schedule.task = task)"));
      } else {
        query1.add(new Condition("not exists (from " + TeachingSchedule.class.getName()
            + " schedule where schedule.task = task)"));
      }
    }
    query1.setLimit(getPageLimit(request));
    query1.addOrder(OrderUtils.parser(get(request, "orderBy")));
    Collection<TeachTask> tasks = utilService.search(query1);

    Map<String, TeachingSchedule> scheduleMap = new HashMap<String, TeachingSchedule>();
    if ((null == isBinding || isBinding.booleanValue()) && CollectionUtils.isNotEmpty(tasks)) {
      EntityQuery query2 = new EntityQuery(TeachingSchedule.class, "schedule");
      populateConditions(request, query2);
      query2.add(new Condition("schedule.task in (:tasks)", tasks));
      Collection<TeachingSchedule> schedules = utilService.search(query2);

      for (TeachingSchedule schedule : schedules) {
        scheduleMap.put(schedule.getTask().getSeqNo(), schedule);
      }
    }

    addCollection(request, "tasks", tasks);
    addSingleParameter(request, "scheduleMap", scheduleMap);
    return forward(request);
  }

  public ActionForward download(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TeachingSchedule schedule = (TeachingSchedule) utilService.get(TeachingSchedule.class,
        getLong(request, "syllabusId"));
    String fileName = schedule.getName();
    String agent = request.getHeader("USER-AGENT");
    if (null != agent && -1 != agent.indexOf("MSIE")) {
      fileName = URLEncoder.encode(fileName, "UTF8");
    } else if (null != agent && -1 != agent.indexOf("Mozilla")) {
      fileName = MimeUtility.encodeText(fileName, "UTF8", "B");
    }
    String path = getFileRealPath(request);
    if (!path.endsWith(File.separator)) {
      path += File.separator;
    }
    path += schedule.getPath();
    download(request, response, path, fileName);
    return null;
  }

  protected void download(HttpServletRequest request, HttpServletResponse response, String fileAbsolutePath,
      String displayFileName) throws Exception {
    File file = new File(fileAbsolutePath);
    if (!file.exists()) {
      response.getWriter().write("without file path:[" + fileAbsolutePath + "]");
      return;
    }
    DownloadHelper.download(request, response, file, displayFileName);
  }
}
