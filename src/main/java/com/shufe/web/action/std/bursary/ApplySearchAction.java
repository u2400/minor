package com.shufe.web.action.std.bursary;

import java.io.File;
import java.util.Collection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.beanfuse.lang.SeqStringUtil;

import com.ekingstar.commons.mvc.struts.misc.StrutsMessageResource;
import com.ekingstar.commons.mvc.web.download.DownloadHelper;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.transfer.exporter.Context;
import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;
import com.ekingstar.commons.transfer.exporter.PropertyExtractor;
import com.ekingstar.eams.system.config.SystemConfig;
import com.ekingstar.eams.system.config.SystemConfigLoader;
import com.shufe.model.std.bursary.BursaryApply;
import com.shufe.model.std.bursary.BursaryApplySetting;
import com.shufe.model.std.bursary.BursaryAward;
import com.shufe.model.std.bursary.BursaryStatementSubject;
import com.shufe.model.system.file.FilePath;
import com.shufe.web.action.common.RestrictionSupportAction;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class ApplySearchAction extends RestrictionSupportAction {

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    setDataRealm(request, hasStdTypeCollege);

    EntityQuery query = new EntityQuery(BursaryApplySetting.class, "setting");
    List<BursaryApplySetting> settings = (List<BursaryApplySetting>) utilService.search(query);
    Long settingId = getLong(request, "setting.id");
    if (null != settingId) {
      for (BursaryApplySetting setting : settings) {
        if (setting.getId().equals(settingId)) {
          addSingleParameter(request, "setting", setting);
          break;
        }
      }
    } else {
      if (!settings.isEmpty()) addSingleParameter(request, "setting", settings.get(0));
    }
    addCollection(request, "settings", settings);
    return forward(request);
  }

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    EntityQuery query = buildQuery(request);
    addCollection(request, "applies", utilService.search(query));
    return forward(request);
  }

  protected Collection getExportDatas(HttpServletRequest request) {
    EntityQuery query = buildQuery(request);
    query.setLimit(null);
    return utilService.search(query);
  }

  protected String getExportKeys(HttpServletRequest request) {
    Long awardId = getLong(request, "apply.award.id");
    String head = "std.code,std.name,std.grade,std.department.name,std.major.name,std.firstMajorClass.name,"
        + "std.basicInfo.mobile,std.basicInfo.mail,std.basicInfo.politicVisage.name,std.basicInfo.nation.name,std.studentStatusInfo.originalAddress,"
        + "gradeAchivement.moralScore2,gradeAchivement.ieScoreText,gradeAchivement.peScoreText,gradeAchivement.score,gradeAchivement.gpa,"
        + "gradeAchivement.cet4Score,award.name,instructorOpinion,collegeOpinion,schoolOpinion";
    if (null != awardId) {
      BursaryAward award = (BursaryAward) utilService.get(BursaryAward.class, awardId);
      StringBuilder subjectAttrs = new StringBuilder();
      for (BursaryStatementSubject subject : award.getSubjects()) {
        subjectAttrs.append(",").append("subject.").append(subject.getId());
      }
      head += subjectAttrs;
    }
    return head;
  }

  protected String getExportTitles(HttpServletRequest request) {
    Long awardId = getLong(request, "apply.award.id");
    String head = "学号,姓名,年级,学院,专业,班级,手机,邮箱,政治面貌,民族,生源地,德育分数,智育分数,体育分数,总分,绩点,英语四级,申请奖项,辅导员审核情况,学院审核情况,校级评审意见";
    if (null != awardId) {
      BursaryAward award = (BursaryAward) utilService.get(BursaryAward.class, awardId);
      StringBuilder subjectAttrs = new StringBuilder();
      for (BursaryStatementSubject subject : award.getSubjects()) {
        subjectAttrs.append(",").append(subject.getName());
      }
      head += subjectAttrs;
    }
    return head;
  }

  protected PropertyExtractor getPropertyExtractor(HttpServletRequest request) {
    return new ApplyPropertyExtractor(getLocale(request), new StrutsMessageResource(getResources(request)));
  }

  protected void configExportContext(HttpServletRequest request, Context context) {
    Collection datas = getExportDatas(request);
    context.getDatas().put("items", datas);
  }

  protected final EntityQuery buildQuery(HttpServletRequest request) {
    EntityQuery query = new EntityQuery(BursaryApply.class, "apply");
    String applyIds = request.getParameter("applyIds");
    if (null != applyIds) {
      query.add(new Condition("apply.id in (:applyIds)", SeqStringUtil.transformToLong(applyIds)));
    }
    populateConditions(request, query);
    query.setLimit(getPageLimit(request));
    buildQuery(request, query);
    return query;
  }

  protected void buildQuery(HttpServletRequest request, EntityQuery query) {

  }

  public ActionForward approveForm(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "apply", getApply(request));
    return forward(request);
  }

  protected BursaryApply getApply(HttpServletRequest request) {
    Long applyId = getLong(request, "apply.id");
    if (null == applyId) applyId = getLong(request, "applyId");
    return (BursaryApply) utilService.get(BursaryApply.class, applyId);
  }

  /** display apply info */
  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "apply", getApply(request));
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

  public ActionForward attachment(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String path = getFileRealPath(request);
    Long applyId = getLong(request, "apply.id");
    BursaryApply exited = (BursaryApply) utilService.get(BursaryApply.class, applyId);
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
