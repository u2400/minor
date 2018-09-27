package com.shufe.model.std.bursary;

import com.ekingstar.commons.model.pojo.LongIdObject;

/**
 * 申请奖学金时，陈述的主题
 * 
 * @author chaostone
 */
public class BursaryStatementSubject extends LongIdObject {
  private static final long serialVersionUID = 2031949634324198181L;

  /** 主题名称 */
  private String name;

  /** 限定长度 */
  private int maxContentLength = 10;

  /**是否必填*/
  private boolean required;
  
  /** 如果不进行文字描述，可供选择的选项 */
  private String options;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public int getMaxContentLength() {
    return maxContentLength;
  }

  public void setMaxContentLength(int maxContentLength) {
    this.maxContentLength = maxContentLength;
  }

  public String getOptions() {
    return options;
  }

  public boolean isRequired() {
    return required;
  }

  public void setRequired(boolean required) {
    this.required = required;
  }

  public void setOptions(String options) {
    this.options = options;
  }

}
