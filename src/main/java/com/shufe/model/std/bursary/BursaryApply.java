package com.shufe.model.std.bursary;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.course.achivement.GradeAchivement;
import com.shufe.model.std.Student;

/**
 * 助学金申请
 * 
 * @author chaostone
 */
public class BursaryApply extends LongIdObject {
  private static final long serialVersionUID = 2357376274194497981L;

  /** 申请的学生 */
  private Student std;

  /** 助学金项目 */
  private BursaryAward award;

  /** 申请设定 */
  private BursaryApplySetting setting;

  /** 陈述理由 */
  private Map<BursaryStatementSubject, String> statements = new HashMap<BursaryStatementSubject, String>();

  /** 德育成绩排名 */
  private Integer moralGradeClassRank;

  /** 综合测评情况 */
  private GradeAchivement gradeAchivement;

  /** 申请日期 */
  private Date applyAt;

  /** 是否提交 */
  private Boolean submited;

  /** 辅导员是否同意 */
  private Boolean instructorApproved;

  /** 辅导员意见 */
  private String instructorOpinion;

  /** 院系是否同意 */
  private Boolean collegeApproved;

  /** 院系意见 */
  private String collegeOpinion;

  /** 学校意见 */
  private String schoolOpinion;

  /** 最终学校是否批准同意 */
  private Boolean approved;

  /** 附件路径 */
  private String attachment;

  public String getStatementString() {
    StringBuilder sb = new StringBuilder();
    for (BursaryStatementSubject subject : award.getSubjects()) {
      String content = statements.get(subject);
      sb.append(subject.getName()).append(":").append((null == content) ? "" : content).append("\n");
    }
    return sb.toString();
  }

  public String getAttachmentFileName() {
    if (null == attachment) {
      return null;
    } else {
      return StringUtils.substringBefore(attachment, ":");
    }
  }

  public String getAttachmentDisplayName() {
    if (null == attachment) {
      return null;
    } else {
      return StringUtils.substringAfter(attachment, ":");
    }
  }

  public Student getStd() {
    return std;
  }

  public void setStd(Student std) {
    this.std = std;
  }

  public BursaryApplySetting getSetting() {
    return setting;
  }

  public void setSetting(BursaryApplySetting setting) {
    this.setting = setting;
  }

  public String getStatement(BursaryStatementSubject subject) {
    return statements.get(subject);
  }

  public BursaryAward getAward() {
    return award;
  }

  public void setAward(BursaryAward award) {
    this.award = award;
  }

  public Date getApplyAt() {
    return applyAt;
  }

  public void setApplyAt(Date applyAt) {
    this.applyAt = applyAt;
  }

  public Map<BursaryStatementSubject, String> getStatements() {
    return statements;
  }

  public void setStatements(Map<BursaryStatementSubject, String> statements) {
    this.statements = statements;
  }

  public GradeAchivement getGradeAchivement() {
    return gradeAchivement;
  }

  public void setGradeAchivement(GradeAchivement gradeAchivement) {
    this.gradeAchivement = gradeAchivement;
  }

  public Boolean getInstructorApproved() {
    return instructorApproved;
  }

  public void setInstructorApproved(Boolean instructorApproved) {
    this.instructorApproved = instructorApproved;
  }

  public String getInstructorOpinion() {
    return instructorOpinion;
  }

  public void setInstructorOpinion(String instructorOpinion) {
    this.instructorOpinion = instructorOpinion;
  }

  public Boolean getCollegeApproved() {
    return collegeApproved;
  }

  public void setCollegeApproved(Boolean collegeApproved) {
    this.collegeApproved = collegeApproved;
  }

  public String getCollegeOpinion() {
    return collegeOpinion;
  }

  public void setCollegeOpinion(String collegeOpinion) {
    this.collegeOpinion = collegeOpinion;
  }

  public String getSchoolOpinion() {
    return schoolOpinion;
  }

  public void setSchoolOpinion(String schoolOpinion) {
    this.schoolOpinion = schoolOpinion;
  }

  public Boolean getApproved() {
    return approved;
  }

  public void setApproved(Boolean approved) {
    this.approved = approved;
  }

  public Boolean getSubmited() {
    return submited;
  }

  public void setSubmited(Boolean submited) {
    this.submited = submited;
  }

  public Integer getMoralGradeClassRank() {
    return moralGradeClassRank;
  }

  public void setMoralGradeClassRank(Integer moralGradeClassRank) {
    this.moralGradeClassRank = moralGradeClassRank;
  }

  public String getAttachment() {
    return attachment;
  }

  public void setAttachment(String attachment) {
    this.attachment = attachment;
  }

}
