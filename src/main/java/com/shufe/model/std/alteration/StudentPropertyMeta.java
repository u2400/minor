package com.shufe.model.std.alteration;

import java.io.Serializable;

import com.ekingstar.commons.model.pojo.LongIdObject;

public class StudentPropertyMeta extends LongIdObject implements Serializable {
  private static final long serialVersionUID = -3907328342725175951L;
  private String valueType;
  private String code;
  private String name;


  public String getValueType() {
    return valueType;
  }

  public void setValueType(String valueType) {
    this.valueType = valueType;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

}
