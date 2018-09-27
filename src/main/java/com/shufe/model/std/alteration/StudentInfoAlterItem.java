package com.shufe.model.std.alteration;

import java.io.Serializable;

import com.ekingstar.commons.model.pojo.LongIdObject;

public class StudentInfoAlterItem extends LongIdObject implements Serializable {

  private static final long serialVersionUID = -898702474905736190L;

  private StudentInfoAlterApply apply;

  private StudentPropertyMeta meta;

  private String oldValue;
  
  private String newValue;

  
  public StudentInfoAlterApply getApply() {
    return apply;
  }

  public void setApply(StudentInfoAlterApply apply) {
    this.apply = apply;
  }
 
  public String getOldValue() {
    return oldValue;
  }

  public void setOldValue(String oldValue) {
    this.oldValue = oldValue;
  }

  public String getNewValue() {
    return newValue;
  }

  public void setNewValue(String newValue) {
    this.newValue = newValue;
  }

  public StudentPropertyMeta getMeta() {
    return meta;
  }

  public void setMeta(StudentPropertyMeta meta) {
    this.meta = meta;
  }
  
}
