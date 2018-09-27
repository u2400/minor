package com.shufe.web.action.system.baseinfo;

import java.io.File;
import java.net.URLEncoder;
import java.sql.Date;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.model.pojo.PojoExistException;
import com.ekingstar.commons.mvc.web.download.DownloadHelper;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.security.utils.EncryptUtil;
import com.ekingstar.commons.web.dispatch.Action;
import com.ekingstar.eams.system.basecode.industry.CourseType;
import com.ekingstar.eams.system.baseinfo.StudentType;
import com.ekingstar.eams.system.baseinfo.model.Department;
import com.ekingstar.eams.system.config.SystemConfig;
import com.ekingstar.eams.system.config.SystemConfigLoader;
import com.shufe.model.system.file.Document;
import com.shufe.model.system.file.FilePath;
import com.shufe.model.system.file.ManagerDocument;
import com.shufe.model.system.file.StudentDocument;
import com.shufe.model.system.file.TeacherDocument;
import com.shufe.web.action.system.file.DocumentAction;

public class TeachingScheduleAction extends BaseInfoAction {
  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "stdTypes", baseInfoService.getBaseInfos(StudentType.class));
    addCollection(request, "courseTypes", baseCodeService.getCodes(CourseType.class));
    addCollection(request, "departments", baseInfoService.getBaseInfos(Department.class));
    return forward(request);
  }

  /**
   * 查找信息action.
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   */
  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) {
    addCollection(request, "courses", utilService.search(baseInfoSearchHelper.buildCourseQuery(request)));
    return forward(request);
  }

  public ActionForward loadUploadPage(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String documentId = request.getParameter("documentId");
    if (null != documentId) {
      request.setAttribute("documentId", documentId);
    }
    return forward(request);
  }

  public ActionForward doUpload(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ActionForward f = upload(request, getFileRealPath(FilePath.DEGREE, request));
    if (f != null) return f;
    return redirect(request, "search", "info.upload.success");
  }

  protected String getFileRealPath(String kind, HttpServletRequest request) {
    SystemConfig config = SystemConfigLoader.getConfig();
    String defaultPath = request.getSession().getServletContext().getRealPath(FilePath.fileDirectory);
    return FilePath.getRealPath(config, kind, defaultPath);
  }

  protected ActionForward upload(HttpServletRequest request, String storeAbsolutePath) throws Exception {
    ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());
    upload.setHeaderEncoding("utf-8");
    List items = upload.parseRequest(request);
    if (!FilePath.isPathExists(storeAbsolutePath)) {
      request.setAttribute("filePath", storeAbsolutePath);
      return forward(request, "/pages/system/systemConfig/filePathError");
    }
    if (!storeAbsolutePath.endsWith(File.separator)) {
      storeAbsolutePath += File.separator;
    }
    for (Iterator iter = items.iterator(); iter.hasNext();) {
      FileItem element = (FileItem) iter.next();
      FileItem itemtemp = element;
      if (!element.isFormField()) {
        String fileName = element.getName();
        if (StringUtils.isEmpty(fileName)) continue;
        File newFile = new File(storeAbsolutePath + getFileName(request, fileName));
        FileUtils.touch(newFile);
        itemtemp.write(newFile);
        afterUpload(request, newFile, fileName);
      }
    }
    return null;
  }

  protected void afterUpload(HttpServletRequest request, File file, String updloadFilePath) {
    log.info(" user upload file from [" + updloadFilePath + "] and store at[" + file.getAbsolutePath()
        + "] on" + new Date(System.currentTimeMillis()));

  }

  protected String getFileName(HttpServletRequest request, String uploadAbsolutePath) {
    int commaIndex = uploadAbsolutePath.lastIndexOf(".");
    if (-1 != commaIndex) {
      return EncryptUtil.encodePassword(uploadAbsolutePath)
          + uploadAbsolutePath.substring(commaIndex, uploadAbsolutePath.length());
    } else return EncryptUtil.encodePassword(uploadAbsolutePath);
  }

}
