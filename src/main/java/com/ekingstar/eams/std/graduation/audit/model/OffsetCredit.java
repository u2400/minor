package com.ekingstar.eams.std.graduation.audit.model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.ekingstar.eams.system.basecode.industry.CourseType;
import com.shufe.model.std.Student;

/**
 * 可冲抵学分
 * 
 * @author cqq
 */
public class OffsetCredit extends LongIdObject {

  private static final long serialVersionUID = 4409774121935270743L;

  /** 对应学生 */
  private Student std;

  /** 冲抵学分 */
  private Float offsetCredit;

  /** 备注 */
  private String remark;

  public Student getStd() {
    return std;
  }

  public void setStd(Student std) {
    this.std = std;
  }

  public Float getOffsetCredit() {
    return offsetCredit;
  }

  public void setOffsetCredit(Float offsetCredit) {
    this.offsetCredit = offsetCredit;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }

}
