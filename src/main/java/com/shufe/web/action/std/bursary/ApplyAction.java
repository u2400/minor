package com.shufe.web.action.std.bursary;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
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

import com.ekingstar.commons.mvc.web.download.DownloadHelper;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.Order;
import com.ekingstar.commons.security.utils.EncryptUtil;
import com.ekingstar.eams.system.config.SystemConfig;
import com.ekingstar.eams.system.config.SystemConfigLoader;
import com.shufe.model.course.achivement.GradeAchivement;
import com.shufe.model.std.Student;
import com.shufe.model.std.bursary.BursaryApply;
import com.shufe.model.std.bursary.BursaryApplySetting;
import com.shufe.model.std.bursary.BursaryAward;
import com.shufe.model.std.bursary.BursaryStatementSubject;
import com.shufe.model.system.file.FilePath;
import com.shufe.web.action.common.DispatchBasicAction;

/**
 * 学生申请
 * 
 * @author chaostone
 */
@SuppressWarnings("unchecked")
public class ApplyAction extends DispatchBasicAction {

  /** Display applied record */
  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = new EntityQuery(BursaryApply.class, "ba");
    query.add(new Condition("ba.std=:std", getStudentFromSession(request.getSession())));
    query.addOrder(new Order("ba.applyAt desc"));
    addCollection(request, "bursaryApplies", utilService.search(query));

    EntityQuery settingQuery = new EntityQuery(BursaryApplySetting.class, "bas");
    settingQuery.add(new Condition(":now between bas.beginAt and bas.endAt", new Date()));
    addCollection(request, "settings", utilService.search(settingQuery));
    return forward(request);
  }

  public ActionForward cancel(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long applyId = getLong(request, "apply.id");
    BursaryApply apply = (BursaryApply) utilService.get(BursaryApply.class, applyId);
    if (apply.getSubmited() && (null != apply.getInstructorApproved() || null != apply.getCollegeApproved()
        || null != apply.getApproved())) { return redirect(request, "info", "已经提交的不能撤销",
            "&apply.id" + applyId); }
    apply.setSubmited(false);
    utilService.saveOrUpdate(apply);
    return redirect(request, "index", "撤销成功");
  }

  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long applyId = getLong(request, "apply.id");
    BursaryApply apply = (BursaryApply) utilService.get(BursaryApply.class, applyId);
    if (apply.getSubmited() && (null != apply.getInstructorApproved() || null != apply.getCollegeApproved()
        || null != apply.getApproved())) { return redirect(request, "info", "已经提交的不能删除",
            "&apply.id" + applyId); }
    utilService.remove(apply);
    return redirect(request, "index", "删除成功");
  }

  /**
   * save or submit apply
   */
  public ActionForward apply(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long applyId = getLong(request, "apply.id");
    if (null != applyId) {
      BursaryApply exited = (BursaryApply) utilService.get(BursaryApply.class, applyId);
      if (exited.getSubmited()) { return redirect(request, "info", "已经提交的不能修改", "&apply.id" + applyId); }
    }
    Student std = getStudentFromSession(request.getSession());


    BursaryApply apply = (BursaryApply) populateEntity(request, BursaryApply.class, "apply");
    Long gradeAchivementId = getLong(request, "apply.gradeAchivement.id");
    if (null != gradeAchivementId) {
      EntityQuery myAchivementQuery = new EntityQuery(GradeAchivement.class, "gav");
      myAchivementQuery.add(new Condition("gav.id = :gavId and gav.std = :std", gradeAchivementId, std));
      GradeAchivement myAchivement = (GradeAchivement) utilService.search(myAchivementQuery).iterator()
          .next();
      if (null != myAchivement.getAdminClass()) {
        EntityQuery query = new EntityQuery(GradeAchivement.class, "gav");
        query.add(new Condition("gav.fromSemester = :fromSemester and gav.toSemester = :toSemester",
            myAchivement.getFromSemester(), myAchivement.getToSemester()));
        query.add(new Condition("gav.adminClass = :adminClass", myAchivement.getAdminClass()));
        query.add((new Condition("gav.moralScore >= :score", myAchivement.getMoralScore())));
        query.setSelect("count(distinct gav.moralScore)");
        List<Number> rs = (List<Number>) utilService.search(query);
        apply.setMoralGradeClassRank(Integer.valueOf(rs.get(0).intValue()));
      }
    } else {
      apply.setGradeAchivement(null);
    }

    apply.setStd(std);
    apply.setApplyAt(new Date());
    BursaryAward award = (BursaryAward) utilService.get(BursaryAward.class, apply.getAward().getId());
    apply.getStatements().clear();

    for (BursaryStatementSubject subject : award.getSubjects()) {
      String value = request.getParameter("apply_subject_" + subject.getId());
      if (StringUtils.isNotBlank(value)) apply.getStatements().put(subject, value);
    }
    utilService.saveOrUpdate(apply);
    return redirect(request, "index", "申请成功");
  }

  /** edit apply or issue a new apply */
  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    BursaryApply apply = (BursaryApply) populateEntity(request, BursaryApply.class, "apply");
    BursaryAward award = (BursaryAward) utilService.get(BursaryAward.class, apply.getAward().getId());
    BursaryApplySetting setting = (BursaryApplySetting) utilService.get(BursaryApplySetting.class,
        apply.getSetting().getId());
    Student std = getStudentFromSession(request.getSession());
    addSingleParameter(request, "std", std);
    addSingleParameter(request, "award", award);
    addSingleParameter(request, "apply", apply);
    EntityQuery query = new EntityQuery(GradeAchivement.class, "ga");
    query.add(new Condition("ga.std=:std", std));
    query.add(new Condition("ga.fromSemester = :fromSemester and ga.toSemester = :toSemester",
        setting.getFromSemester(), setting.getToSemester()));
    List<GradeAchivement> achivements = (List<GradeAchivement>) utilService.search(query);
    if (achivements.size() == 1) apply.setGradeAchivement(achivements.get(0));
    addSingleParameter(request, "achivements", achivements);
    return forward(request);
  }

  /** display personal info and award selection */
  public ActionForward applyForm(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    BursaryApplySetting setting = (BursaryApplySetting) utilService.get(BursaryApplySetting.class,
        getLong(request, "apply.setting.id"));
    Student std = getStudentFromSession(request.getSession());
    addSingleParameter(request, "std", std);
    EntityQuery query = new EntityQuery(BursaryApply.class, "ba");
    query.add(new Condition("ba.setting=:setting", setting));
    query.add(new Condition("ba.std=:std", std));
    List<BursaryAward> awards = new ArrayList<BursaryAward>(setting.getAwards());
    List<BursaryApply> exiteds = (List<BursaryApply>) utilService.search(query);
    for (BursaryApply exited : exiteds) {
      awards.remove(exited.getAward());
    }
    addSingleParameter(request, "setting", setting);
    addSingleParameter(request, "awards", awards);
    return forward(request);
  }

  /** display apply info */
  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long applyId = getLong(request, "apply.id");
    EntityQuery query = new EntityQuery(BursaryApply.class, "apply");
    query.add(new Condition("apply.id=:applyId", applyId));
    query.add(new Condition("apply.std=:std", getStudentFromSession(request.getSession())));
    List<BursaryApply> applies = (List<BursaryApply>) utilService.search(query);
    if (applies.size() == 1) {
      addSingleParameter(request, "apply", applies.get(0));
    }
    return forward(request);
  }

  protected String getFileRealPath(HttpServletRequest request) {
    SystemConfig config = SystemConfigLoader.getConfig();
    String defaultPath = request.getSession().getServletContext().getRealPath(FilePath.fileDirectory);
    String filePath = FilePath.getRealPath(config, "doc", defaultPath) + "bursary/";
    File dir = new File(filePath);
    if (!dir.exists()) dir.mkdirs();
    return filePath;
  }

  protected String getFileName(HttpServletRequest request, String uploadAbsolutePath) {
    int commaIndex = uploadAbsolutePath.lastIndexOf(".");
    if (-1 != commaIndex) {
      return EncryptUtil.encodePassword(uploadAbsolutePath)
          + uploadAbsolutePath.substring(commaIndex, uploadAbsolutePath.length());
    } else return EncryptUtil.encodePassword(uploadAbsolutePath);
  }

  public ActionForward uploadForm(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    return forward(request);
  }

  /**
   * 上传文件
   */
  public ActionForward upload(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long applyId = getLong(request, "apply.id");
    BursaryApply exited = (BursaryApply) utilService.get(BursaryApply.class, applyId);
    String storeAbsolutePath = getFileRealPath(request);
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
        int fileSize = new File(storeAbsolutePath).list().length;
        String newFileName = fileSize + "_" + getFileName(request, fileName);
        File newFile = new File(storeAbsolutePath + newFileName);
        FileUtils.touch(newFile);
        itemtemp.write(newFile);
        if (null != exited.getAttachmentFileName()) {
          File exitedAttachment = new File(storeAbsolutePath + exited.getAttachmentFileName());
          if (exitedAttachment.exists()) exitedAttachment.delete();
        }
        exited.setAttachment(newFileName + ":" + fileName);
        utilService.saveOrUpdate(exited);
      }
    }
    return redirect(request, "index", "申请成功");
  }

  public ActionForward attachment(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String path = getFileRealPath(request);
    Long applyId = getLong(request, "apply.id");
    Student std = getStudentFromSession(request.getSession());
    BursaryApply exited = (BursaryApply) utilService.get(BursaryApply.class, applyId);
    if (!std.equals(exited.getStd())) { return null; }
    String attachment = exited.getAttachment();
    if (null != attachment) {
      File file = new File(path + exited.getAttachmentFileName());
      DownloadHelper.download(request, response, file, exited.getAttachmentDisplayName());
    } else {
      response.getWriter().write("without file path:[" + attachment + "]");
    }
    return null;
  }
}
