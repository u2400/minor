package com.shufe.model.std.bursary;

import com.ekingstar.commons.model.pojo.LongIdObject;

/**
 * @author chaostone
 */
public class BursaryStatement extends LongIdObject {

  private static final long serialVersionUID = -6382687657771401878L;

  private BursaryStatementSubject subject;

  private BursaryApply apply;

  private String content;

  private int idx;

  public BursaryStatementSubject getSubject() {
    return subject;
  }

  public void setSubject(BursaryStatementSubject subject) {
    this.subject = subject;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String content) {
    this.content = content;
  }

  public int getIdx() {
    return idx;
  }

  public void setIdx(int idx) {
    this.idx = idx;
  }

  public BursaryApply getApply() {
    return apply;
  }

  public void setApply(BursaryApply apply) {
    this.apply = apply;
  }

}
