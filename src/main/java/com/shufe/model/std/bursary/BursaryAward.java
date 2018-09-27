package com.shufe.model.std.bursary;

import java.util.ArrayList;
import java.util.List;

import com.ekingstar.commons.model.pojo.LongIdObject;
/**
 * 助学金奖项
 * @author chaostone
 */
public class BursaryAward extends LongIdObject {

  private static final long serialVersionUID = 67542269972237581L;

  private String name;

  private List<BursaryStatementSubject> subjects = new ArrayList<BursaryStatementSubject>();

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public List<BursaryStatementSubject> getSubjects() {
    return subjects;
  }

  public void setSubjects(List<BursaryStatementSubject> subjects) {
    this.subjects = subjects;
  }
  
}
