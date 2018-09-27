//$Id: StudentAbilityImporterListener.java,v 1.1 2012-8-30 zhouqi Exp $
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
 * @author zhouqi
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * zhouqi				2012-8-30             Created
 *  
 ********************************************************************************/

/**
 * 
 */
package com.shufe.service.course.arrange.english;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.transfer.importer.ItemImporterListener;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.ekingstar.eams.system.basecode.state.LanguageAbility;
import com.shufe.model.std.Student;

/**
 * @author zhouqi
 */
public class StudentAbilityImporterListener extends ItemImporterListener {

  private UtilService utilService;

  private Map<String, LanguageAbility> languageAbilityMap = new HashMap<String, LanguageAbility>();

  public StudentAbilityImporterListener(UtilService utilService) {
    this.utilService = utilService;
  }

  @Override
  public void startTransferItem(TransferResult tr) {
    String stdCode = (String) importer.curDataMap().get("code");
    if (StringUtils.isNotBlank(stdCode)) {
      Collection<Student> students = utilService.load(Student.class, "code", stdCode);
      if (CollectionUtils.isNotEmpty(students)) {
        importer.setCurrent(students.iterator().next());
      }
    }

    String languageAbilityCode = (String) importer.curDataMap().get("languageAbility.code");
    if (StringUtils.isNotBlank(languageAbilityCode) && null == languageAbilityMap.get(languageAbilityCode)) {
      Collection<LanguageAbility> languageAbilities = utilService.load(LanguageAbility.class, "code",
          languageAbilityCode);
      if (CollectionUtils.isNotEmpty(languageAbilities)) {
        languageAbilityMap.put(languageAbilityCode, languageAbilities.iterator().next());
      }
    }
  }

  @Override
  public void endTransferItem(TransferResult tr) {
    Student student = (Student) importer.getCurrent();

    if (null == student || null == student.getId()) {
      if (null == student || StringUtils.isBlank(student.getCode())) {
        tr.addFailure("error.parameters.needed", "code is null or blank");
      } else if (StringUtils.isNotBlank(student.getCode())) {
        tr.addFailure("error.model.notExist", "No found Student in " + student.getCode() + " of code");
      }
    }

    String languageAbilityCode = (String) importer.curDataMap().get("languageAbility.code");
    if (null == languageAbilityMap.get(languageAbilityCode)) {
      if (StringUtils.isBlank(languageAbilityCode)) {
        tr.addFailure("error.parameters.needed", "languageAbility.code is null or blank");
      } else {
        tr.addFailure("error.model.notExist", "No found LanguageAbility in " + languageAbilityCode
            + " of languageAbility.code");
      }
    }

    if (null == student.getScoreInLanguage() || student.getScoreInLanguage().floatValue() < 0) {
      String scoreInLanguageCode = (String) importer.curDataMap().get("scoreInLanguage");
      if (null == student.getScoreInLanguage()) {
        if (StringUtils.isBlank(scoreInLanguageCode)) {
          tr.addFailure("error.parameters.needed", "scoreInLanguage is null or blank");
        } else {
          tr.addFailure("error.parameters.illegal", "scoreInLanguage : " + scoreInLanguageCode);
        }
      } else {
        tr.addFailure("error.parameters.illegal", "scoreInLanguage : " + scoreInLanguageCode);
      }
    }

    if (tr.errors() == 0) {
      utilService.saveOrUpdate(student);
    }
  }
}
