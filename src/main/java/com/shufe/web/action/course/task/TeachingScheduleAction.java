/**
 * 
 */
package com.shufe.web.action.course.task;

import java.io.File;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.security.utils.EncryptUtil;
import com.ekingstar.commons.web.dispatch.Action;
import com.ekingstar.eams.system.config.SystemConfig;
import com.ekingstar.eams.system.config.SystemConfigLoader;
import com.ekingstar.security.User;
import com.shufe.model.course.syllabus.Syllabus;
import com.shufe.model.course.task.TeachTask;
import com.shufe.model.course.task.TeachingSchedule;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.file.FilePath;
import com.shufe.web.action.common.CalendarRestrictionSupportAction;

/**
 * 教学进度（教师）
 * 
 * @author zhouqi
 */
public class TeachingScheduleAction extends CalendarRestrictionSupportAction {

  @SuppressWarnings("unchecked")
  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long taskId = getLong(request, "task.id");
    if (null == taskId) {
      taskId = getLong(request, "taskId");
    }

    TeachingSchedule schedule = null;
    if (null == taskId) {
      schedule = (TeachingSchedule) utilService.get(TeachingSchedule.class, getLong(request, "scheduleId"));
    } else {
      Collection<TeachingSchedule> schedules = utilService.load(TeachingSchedule.class, "task.id", taskId);
      if (CollectionUtils.isEmpty(schedules)) {
        schedule = new TeachingSchedule();
        schedule.setTask((TeachTask) utilService.get(TeachTask.class, taskId));
      } else {
        schedule = schedules.iterator().next();
      }
    }
    if (null != schedule) {
      addSingleParameter(request, "schedule", schedule);
    }
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    TeachingSchedule schedule = (TeachingSchedule) populateEntity(request, TeachingSchedule.class, "schedule");

    String path = getFileRealPath(request);
    if (!path.endsWith(File.separator)) {
      path += File.separator;
    }

    User user = getUser(request);
    if (null != schedule && null != schedule.getId()) {
      File oldFile = new File(path + schedule.getPath());
      if (oldFile.delete()) {
        log.info("user [" + user.getName() + "] delete file[" + oldFile.getAbsolutePath() + "]");
      }
    }
    schedule.setPath(get(request, "schedulePath"));

    if (!FilePath.isPathExists(path)) {
      request.setAttribute("filePath", path);
      return forward(request, "/pages/system/systemConfig/filePathError");
    }
    ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());
    upload.setHeaderEncoding("utf-8");
    List<?> items = upload.parseRequest(request);
    if (!path.endsWith(File.separator)) {
      path += File.separator;
    }
    for (Iterator<?> iter = items.iterator(); iter.hasNext();) {
      FileItem element = (FileItem) iter.next();
      FileItem itemtemp = element;
      if (!element.isFormField()) {
        String fileName = element.getName();
        if (StringUtils.isEmpty(fileName)) {
          continue;
        }
        File newFile = new File(path + getFileName(request, fileName));
        String[] fileName_values = StringUtils.split(schedule.getPath(), "\\");
        schedule.setName(fileName_values[fileName_values.length - 1]);
        schedule.setPath(newFile.getName());
        FileUtils.touch(newFile);
        itemtemp.write(newFile);
        break;
      }
    }

    schedule.setUploadBy(user);
    schedule.setUploadAt(new Date());
    utilService.saveOrUpdate(schedule);
    String returnPath = get(request, "returnPath");
    String returnMothed = get(request, "returnMothed");
    if (StringUtils.isNotBlank(returnPath) && StringUtils.isNotBlank(returnMothed)) { return redirect(
        request, new Action(returnPath, returnMothed), "info.action.success"); }
    return redirect(request, "search", "info.action.success");
  }

  protected String getFileName(HttpServletRequest request, String uploadAbsolutePath) {
    int commaIndex = uploadAbsolutePath.lastIndexOf(".");
    if (-1 != commaIndex) {
      return EncryptUtil.encodePassword(uploadAbsolutePath + System.currentTimeMillis())
          + uploadAbsolutePath.substring(commaIndex, uploadAbsolutePath.length());
    } else {
      return EncryptUtil.encodePassword(uploadAbsolutePath);
    }
  }

  protected String getFileRealPath(HttpServletRequest request) {
    SystemConfig config = SystemConfigLoader.getConfig();
    String defaultPath = request.getSession().getServletContext().getRealPath(FilePath.fileDirectory);
    return FilePath.getRealPath(config, FilePath.DOC, defaultPath);
  }
}
