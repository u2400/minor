package com.shufe.web.helper;

import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.model.Entity;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.transfer.TransferResult;
import com.ekingstar.commons.transfer.importer.ItemImporterListener;
import com.ekingstar.commons.utils.persistence.UtilService;
import com.ekingstar.eams.system.basecode.industry.AlterMode;
import com.ekingstar.eams.system.basecode.industry.AlterReason;
import com.shufe.model.std.alteration.StdStatus;
import com.shufe.model.std.alteration.StudentAlteration;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.model.system.baseinfo.Speciality;
import com.shufe.model.system.baseinfo.SpecialityAspect;

/**
 * 学籍导入监听器,实现数据的完整性， 依照学生流水号/学号，做唯一标示
 * 
 * @author
 */

public class StudentAlterationImportListerner extends ItemImporterListener {

  private UtilService utilService;

  private Map<String, AlterMode> alterModeMap = new HashMap<String, AlterMode>();

  private Map<String, AlterReason> alterReasonMap = new HashMap<String, AlterReason>();

  private Map<String, StdStatus> stdStatusMap = new HashMap<String, StdStatus>();

  private Map<String, AdminClass> adminclassMap = new HashMap<String, AdminClass>();

  public StudentAlterationImportListerner(UtilService utilService) {
    this.utilService = utilService;
  }

  public void startTransferItem(TransferResult tr) {
    String stdCode = (String) importer.curDataMap().get("std.code");
    if (StringUtils.isNotBlank(stdCode)) {
      Collection<StudentAlteration> students = utilService.load(StudentAlteration.class, "std.code", stdCode);
      if (CollectionUtils.isNotEmpty(students)) {
        importer.curDataMap().put("student", students.iterator().next());
      }
    }
    // 学籍变动种类
    String alterMode = (String) importer.curDataMap().get("mode.code");
    if (StringUtils.isNotBlank(alterMode)) {
      Collection<AlterMode> mode = utilService.load(AlterMode.class, "code", alterMode);
      if (CollectionUtils.isNotEmpty(mode)) {
        alterModeMap.put(alterMode, mode.iterator().next());
      }
    }
    // 原因
    String reasonCode = (String) importer.curDataMap().get("reason.code");
    if (StringUtils.isNotBlank(reasonCode)) {
      Collection<AlterReason> alterReason = utilService.load(AlterReason.class, "code", reasonCode);
      if (CollectionUtils.isNotEmpty(alterReason)) {
        alterReasonMap.put(reasonCode, alterReason.iterator().next());
      }
    }
    // //变动后学生类别
    // String stdStype=(String) importer.curDataMap().get("afterStatus.stdType.code");
    // if(StringUtils.isNotBlank(stdStype)){
    // Collection<StdStatus>
    // stdStatus=utilService.load(StdStatus.class,"stdType.code",stdStype);
    // if(CollectionUtils.isNotEmpty(stdStatus)){
    // stdStatusMap.put(stdStype, stdStatus.iterator().next());
    // }
    // }
    // 变动后院系
    String departmentCode = (String) importer.curDataMap().get("afterStatus.department.code");
    if (StringUtils.isBlank(departmentCode)) {
      tr.addFailure("error.parameters.needed", "code is null or blank");
    } else {
      Collection<Department> departments = utilService.load(Department.class, "code", departmentCode);
      if (CollectionUtils.isEmpty(departments)) {
        tr.addFailure("error.model.notExist", "Not found department in <span style=\"color:red\">"
            + departmentCode + "</span> of afterStatus.department.code");
      } else {
        Department department = departments.iterator().next();

        // 变动后专业
        String specialityCode = (String) importer.curDataMap().get("afterStatus.speciality.code");
        if (StringUtils.isNotBlank(specialityCode)) {
          Collection<Speciality> majors = utilService.load(Speciality.class, "code", specialityCode);
          if (CollectionUtils.isEmpty(majors)) {
            tr.addFailure("error.model.notExist", "Not found major in <span style=\"color:red\">"
                + specialityCode + "</span> of afterStatus.speciality.code");
          } else {
            Speciality major = majors.iterator().next();

            if (major.getDepartment().getId().longValue() != department.getId().longValue()) {
              tr.addFailure("error.data.invalid", "The code of <span style=\"color:red\">" + specialityCode
                  + "</span> of major is not in the code of <span style=\"color:blue\">" + departmentCode
                  + "</span> of department.");
            }

            // 变动后专业方向
            String aspectCode = (String) importer.curDataMap().get("afterStatus.aspect.code");
            if (StringUtils.isNotBlank(aspectCode)) {
              Collection<SpecialityAspect> directions = utilService.load(SpecialityAspect.class, "code",
                  aspectCode);
              if (CollectionUtils.isEmpty(directions)) {
                tr.addFailure("error.model.notExist", "Not found direction in <span style=\"color:red\">"
                    + aspectCode + "</span> of afterStatus.aspect.code");
              } else {
                if (directions.iterator().next().getSpeciality().getId().longValue() != major.getId()
                    .longValue()) {
                  tr.addFailure("error.data.invalid", "The code of <span style=\"color:red\">" + aspectCode
                      + "</span> of direction is not in the code of <span style=\"color:blue\">"
                      + specialityCode + "</span> of major.");
                }
              }
            }
          }
        }
      }
    }
    // //变动后所在年级
    // String enrollYear=(String) importer.curDataMap().get("afterStatus.enrollYear");
    // if(StringUtils.isNotBlank(enrollYear)){
    // Collection<StdStatus>
    // stdStatus=utilService.load(StdStatus.class,"enrollYear",enrollYear);
    // if(CollectionUtils.isNotEmpty(stdStatus)){
    // stdStatusMap.put(enrollYear, stdStatus.iterator().next());
    // }
    // }
    // 变动后学籍状态
    String stateCode = (String) importer.curDataMap().get("afterStatus.state.code");
    if (StringUtils.isNotBlank(stateCode)) {
      Collection<StdStatus> stdStatus = utilService.load(StdStatus.class, "state.code", stateCode);
      if (CollectionUtils.isNotEmpty(stdStatus)) {
        stdStatusMap.put(stateCode, stdStatus.iterator().next());
      }
    }
    // 变动后班级
    String adminClassCode = (String) importer.curDataMap().get("adminClassAfter.code");
    if (StringUtils.isNotBlank(adminClassCode)) {
      Collection<AdminClass> adminclasses = utilService.load(AdminClass.class, "code", adminClassCode);
      if (CollectionUtils.isEmpty(adminclasses)) {
        tr.addFailure("error.model.notExist", "Not found adminclass in <span style=\"color:red\">"
            + adminClassCode + "</span> of adminClassAfter.code");
      } else {
        adminclassMap.put(adminClassCode, adminclasses.iterator().next());
      }
    }
  }

  public void endTransferItem(TransferResult tr) {
    StudentAlteration alteration = (StudentAlteration) importer.getCurrent();
    if (null != alteration && null != alteration.getId()) {
      if (null != alteration && StringUtils.isNotBlank(alteration.getStd().getCode())) {
        tr.addFailure("error.parameters.needed", "code is null or blank");
      } else if (StringUtils.isBlank(alteration.getStd().getCode())) {
        tr.addFailure("error.model.notExist", "No found Student in " + alteration.getStd().getCode()
            + " of code");
      }
    }
    String alterModeCode = (String) importer.curDataMap().get("mode.code");
    if (null == alterModeMap.get(alterModeCode)) {
      if (StringUtils.isBlank(alterModeCode)) {
        tr.addFailure("error.parameters.needed", "mode.code is null or blank");
      } else {
        tr.addFailure("error.model.notExist", "No found mode in " + alterModeCode + " of mode.code");
      }
    }
    String reasonCode = (String) importer.curDataMap().get("reason.code");
    if (null == alterReasonMap.get(reasonCode)) {
      if (StringUtils.isBlank(reasonCode)) {
        tr.addFailure("error.parameters.needed", "reason.code is null or blank");
      } else {
        tr.addFailure("error.model.notExist", "No found reason in " + reasonCode + " of reason.code");
      }
    }
    String stateCode = (String) importer.curDataMap().get("afterStatus.state.code");
    if (null == stdStatusMap.get(stateCode)) {
      if (StringUtils.isBlank(stateCode)) {
        tr.addFailure("error.parameters.needed", "afterStatus.state.code is null or blank");
      } else {
        tr.addFailure("error.model.notExist", "No found student-state in " + stateCode
            + " of afterStatus.state.code");
      }
    }
    if (tr.errors() == 0) {
      if (alteration.getId() == null || alteration.getBeforeStatus() == null) {
        alteration.beforeStatusSetting();
      }

      // 改变班级
      String adminClassCode = (String) importer.curDataMap().get("adminClassAfter.code");
      if (StringUtils.isNotBlank(adminClassCode)) {
        AdminClass adminclass = adminclassMap.get(adminClassCode);
        if (null != adminclass) {
          alteration.getAfterStatus().setAdminClass(adminclass);
        }
      }

      // 学生状态改变
      alteration.apply();

      // 获取并填写“流水号”
      if (null == alteration.getId()) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
        EntityQuery query = new EntityQuery(StudentAlteration.class, "alteration");
        query.add(new Condition("to_char(alteration.alterBeginOn, 'yyyy') = :alterBeginOn", sdf
            .format(alteration.getAlterBeginOn())));
        query.add(new Condition("alteration.mode = :mode", alteration.getMode()));
        query.setSelect("max(alteration.seqNo)");
        Collection results = utilService.search(query);
        String seqNo = sdf.format(alteration.getAlterBeginOn());
        if (null == results.iterator().next()) {
          seqNo += "0001";
        } else {
          String previousSeqNo = results.iterator().next().toString();
          seqNo = StringUtils.left(previousSeqNo, 4) + alteration.getMode().getCode()
              + StringUtils.leftPad((Integer.parseInt(StringUtils.right(previousSeqNo, 4)) + 1) + "", 4, "0");
        }
        alteration.setSeqNo(seqNo);
      }

      alteration.getAfterStatus().setStdType(alteration.getStd().getStdType());
      utilService.saveOrUpdate(alteration);
    }
  }
}
