/**
 * 
 */
package com.shufe.web.action.course.syllabus;

import java.io.File;
import java.net.URLEncoder;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.mail.internet.MimeUtility;
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

import com.ekingstar.commons.mvc.web.download.DownloadHelper;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.security.utils.EncryptUtil;
import com.ekingstar.eams.system.config.SystemConfig;
import com.ekingstar.eams.system.config.SystemConfigLoader;
import com.ekingstar.security.User;
import com.shufe.model.course.syllabus.Syllabus;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.file.FilePath;
import com.shufe.web.action.common.RestrictionSupportAction;

/**
 * 课程大纲管理
 * 
 * @author zhouqi
 */
public class SyllabusManagementAction extends RestrictionSupportAction {

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Boolean isBinding = getBoolean(request, "isBinding");

    String pageName = "";

    // 全部
    if (null == isBinding) {
      pageName = "course_syllabus_list.ftl";

      EntityQuery query1 = new EntityQuery(Course.class, "course");
      populateConditions(request, query1);
      String name = get(request, "syllabus.name");
      if (StringUtils.isNotBlank(name)) {
        query1.add(new Condition("exists (from " + Syllabus.class.getName()
            + " syllabus where syllabus.course = course and syllabus.name like :name)", "%" + name + "%"));
      }
      query1.setLimit(getPageLimit(request));
      query1.addOrder(OrderUtils.parser(get(request, "orderBy")));
      Collection<?> courses = utilService.search(query1);
      addCollection(request, "courses", courses);

      if (CollectionUtils.isNotEmpty(courses)) {
        EntityQuery query2 = new EntityQuery(Syllabus.class, "syllabus");
        query2.add(new Condition("syllabus.course in (:courses)", courses));
        Collection<Syllabus> syllabuses = utilService.search(query2);
        Map<String, Syllabus> syllabusMap = new HashMap<String, Syllabus>();
        if (CollectionUtils.isNotEmpty(syllabuses)) {
          for (Syllabus syllabus : syllabuses) {
            syllabusMap.put(syllabus.getCourse().getId().toString(), syllabus);
          }
        }
        addSingleParameter(request, "syllabusMap", syllabusMap);
      }
    } else {
      // 绑定或未
      if (isBinding.booleanValue()) {
        pageName = "syllabus_list.ftl";

        EntityQuery query = new EntityQuery(Syllabus.class, "syllabus");
        populateConditions(request, query);
        query.setLimit(getPageLimit(request));
        query.addOrder(OrderUtils.parser(get(request, "orderBy")));
        addCollection(request, "syllabuses", utilService.search(query));
      } else {
        pageName = "course_list.ftl";

        EntityQuery query = new EntityQuery(Course.class, "course");
        populateConditions(request, query);
        query.add(new Condition("not exists (from " + Syllabus.class.getName()
            + " syllabus where syllabus.course = course)"));
        query.setLimit(getPageLimit(request));
        query.addOrder(OrderUtils.parser(get(request, "orderBy")));
        addCollection(request, "courses", utilService.search(query));
      }
    }

    addSingleParameter(request, "pageName", pageName);
    return forward(request);
  }

  public ActionForward download(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Syllabus syllabus = (Syllabus) utilService.get(Syllabus.class, getLong(request, "syllabusId"));
    String fileName = syllabus.getName();
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
    path += syllabus.getPath();
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

  protected String getFileRealPath(HttpServletRequest request) {
    SystemConfig config = SystemConfigLoader.getConfig();
    String defaultPath = request.getSession().getServletContext().getRealPath(FilePath.fileDirectory);
    return FilePath.getRealPath(config, FilePath.DOC, defaultPath);
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long courseId = getLong(request, "courseId");

    Syllabus syllabus = null;
    if (null == courseId) {
      syllabus = (Syllabus) utilService.get(Syllabus.class, getLong(request, "syllabusId"));
    } else {
      Collection<Syllabus> syllabuses = utilService.load(Syllabus.class, "course.id", courseId);
      if (CollectionUtils.isEmpty(syllabuses)) {
        syllabus = new Syllabus();
        syllabus.setCourse((Course) utilService.get(Course.class, courseId));
      } else {
        syllabus = syllabuses.iterator().next();
      }
    }
    if (null != syllabus) {
      addSingleParameter(request, "syllabus", syllabus);
    }
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Syllabus syllabus = (Syllabus) populateEntity(request, Syllabus.class, "syllabus");

    String path = getFileRealPath(request);
    if (!path.endsWith(File.separator)) {
      path += File.separator;
    }

    User user = getUser(request);
    if (null != syllabus && null != syllabus.getId()) {
      File oldFile = new File(path + syllabus.getPath());
      if (oldFile.delete()) {
        log.info("user [" + user.getName() + "] delete file[" + oldFile.getAbsolutePath() + "]");
      }
    }

    if (!FilePath.isPathExists(path)) {
      request.setAttribute("filePath", path);
      return forward(request, "/pages/system/systemConfig/filePathError");
    }
    if (null == syllabus) {
      request.setAttribute("filePath", "处理异常！");
      return forward(request, "/pages/system/systemConfig/filePathError");
    }
    ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());
    upload.setHeaderEncoding("utf-8");
    List items = upload.parseRequest(request);
    if (!path.endsWith(File.separator)) {
      path += File.separator;
    }
    for (Iterator iter = items.iterator(); iter.hasNext();) {
      FileItem element = (FileItem) iter.next();
      FileItem itemtemp = element;
      if (!element.isFormField()) {
        String fileName = element.getName();
        if (StringUtils.isEmpty(fileName)) {
          continue;
        }
        File newFile = new File(path + getFileName(request, fileName));
        syllabus.setName(fileName);
        syllabus.setPath(newFile.getName());
        FileUtils.touch(newFile);
        itemtemp.write(newFile);
        break;
      }
    }

    syllabus.setUploadBy(user);
    syllabus.setUploadAt(new Date());
    utilService.saveOrUpdate(syllabus);
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
}
