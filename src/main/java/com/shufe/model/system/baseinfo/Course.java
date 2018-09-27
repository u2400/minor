//$Id: Course.java,v 1.2 2006/12/21 13:38:47 duanth Exp $
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
 * @author chaostone
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * chaostone             2005-9-9         Created
 *  
 ********************************************************************************/

package com.shufe.model.system.baseinfo;

import java.util.HashSet;
import java.util.Set;

import com.ekingstar.eams.system.basecode.industry.CourseCategory;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.shufe.model.course.textbook.Textbook;

/**
 * 学校课程基本信息
 * 
 * @author chaostone 2005-9-9
 */
public class Course extends com.ekingstar.eams.system.baseinfo.model.Course {

  private static final long serialVersionUID = 3335349220158433743L;

  /** 语言能力要求 */
  private LanguageAbility languageAbility;

  /** 是否实践课 */
  private Boolean isPractice;

  /** 是否实践课 */
  private String noCancelXjyd;

  private Set<Textbook> textbooks = new HashSet<Textbook>();

  public Boolean getIsPractice() {
    return isPractice;
  }

  public void setIsPractice(Boolean isPractice) {
    this.isPractice = isPractice;
  }

  public Boolean getIs2ndSpeciality() {
    if (null == getCategory()) {
      return Boolean.FALSE;
    } else {
      return Boolean.valueOf(getCategory().getId().equals(CourseCategory.MAJOR2));
    }
  }

  public Course() {
    super();
  }

  public Course(Long id) {
    super(id);
  }

  public LanguageAbility getLanguageAbility() {
    return languageAbility;
  }

  public void setLanguageAbility(LanguageAbility languageAbility) {
    this.languageAbility = languageAbility;
  }

  public String getNoCancelXjyd() {
    return noCancelXjyd;
  }

  public void setNoCancelXjyd(String noCancelXjyd) {
    this.noCancelXjyd = noCancelXjyd;
  }

  public Set<Textbook> getTextbooks() {
    return textbooks;
  }

  public void setTextbooks(Set<Textbook> textbooks) {
    this.textbooks = textbooks;
  }

}
