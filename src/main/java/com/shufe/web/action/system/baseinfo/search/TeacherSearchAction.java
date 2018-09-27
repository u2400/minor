//$Id: TeacherSearchAction.java,v 1.1 2008-1-30 下午06:07:13 zhouqi Exp $
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
 * @author zhouqi
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * zhouqi              2008-1-30         	Created
 *  
 ********************************************************************************/

package com.shufe.web.action.system.baseinfo.search;

import java.io.File;
import java.util.Collection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.mvc.web.download.DownloadHelper;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.security.utils.EncryptUtil;
import com.ekingstar.eams.system.basecode.industry.TeacherType;
import com.ekingstar.eams.system.basecode.industry.TeacherWorkState;
import com.ekingstar.eams.system.config.SystemConfig;
import com.ekingstar.eams.system.config.SystemConfigLoader;
import com.shufe.model.system.baseinfo.Teacher;
import com.shufe.model.system.file.FilePath;
import com.shufe.service.system.baseinfo.DepartmentService;
import com.shufe.service.system.baseinfo.TeacherService;
import com.shufe.web.action.system.baseinfo.BaseInfoAction;

/**
 * @author zhouqi
 */
public class TeacherSearchAction extends BaseInfoAction {

  protected TeacherService teacherService;

  protected DepartmentService departmentService;

  /**
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "departments", departmentService.getDepartments());
    initBaseCodes(request, "teacherTypes", TeacherType.class);
    initBaseCodes(request, "teacherWorkStateList", TeacherWorkState.class);
    return forward(request);
  }

  /**
   * 查找form中限定的教职工信息.<br>
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   */
  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) {
    addCollection(request, "teachers", baseInfoSearchHelper.searchTeacher(request));
    return forward(request);
  }

  protected Collection getExportDatas(HttpServletRequest request) {
    EntityQuery query = baseInfoSearchHelper.buildTeacherQuery(request);
    query.setLimit(null);
    return utilService.search(query);
  }

  /**
   * 教师详细信息
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    if (!buildInfo(mapping, request)) { return forward(mapping, request, new String[] { "entity.teacher",
        "error.model.id.needed" }, "error"); }
    return forward(request);
  }

  /**
   * @param mapping
   * @param request
   */
  protected boolean buildInfo(ActionMapping mapping, HttpServletRequest request) {
    Long teacherId = getLong(request, "teacherId");
    if (teacherId == null) {
      teacherId = getLong(request, "teacher.id");
    }
    if (teacherId == null) { return false; }
    addSingleParameter(request, "teacher", utilService.load(Teacher.class, teacherId));
    return true;
  }

  /**
   * 教师简介
   * 
   * @param mapping
   * @param form
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public ActionForward intro(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    if (!buildInfo(mapping, request)) { return forward(mapping, request, new String[] { "entity.teacher",
        "error.model.id.needed" }, "error"); }
    return forward(request);
  }

  protected String getFileRealPath(String kind, HttpServletRequest request) {
    SystemConfig config = SystemConfigLoader.getConfig();
    String defaultPath = request.getSession().getServletContext().getRealPath(FilePath.fileDirectory);
    return FilePath.getRealPath(config, kind, defaultPath);
  }

  public void download(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Teacher teacher = (Teacher) utilService.get(Teacher.class, getLong(request, "teacherId"));
    if (StringUtils.isEmpty(teacher.getVideoName())) { return; }

    String fileAbsolutePath = getFileRealPath(FilePath.TEACHER_PHOTO, request);
    if (!fileAbsolutePath.endsWith(File.separator)) {
      fileAbsolutePath += File.separator;
    }
    fileAbsolutePath += EncryptUtil.encodePassword(teacher.getVideoName());
    File file = new File(fileAbsolutePath);
    if (!file.exists()) {
      response.getWriter().write("without file path:[" + fileAbsolutePath + "]");
      return;
    }
    DownloadHelper.download(request, response, file, teacher.getVideoName());
  }

  /**
   * @param teacherService
   *          The teacherService to set.
   */
  public void setTeacherService(TeacherService teacherService) {
    this.teacherService = teacherService;
  }

  public void setDepartmentService(DepartmentService departmentService) {
    this.departmentService = departmentService;
  }

}
