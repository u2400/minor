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
 * chaostone             2007-1-28            Created
 *  
 ********************************************************************************/
package com.shufe.model.course.grade.gp;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.calendar.TeachCalendar;

/**
 * 多个学生的绩点汇总
 * 
 * @author chaostone
 */
public class MultiStdGP {

  /**
   * 一般是以班级为单位的
   */
  AdminClass adminClass;

  List<TeachCalendar> calendars;

  /**
   * @see StdGP
   */
  List<StdGP> stdGPs = new ArrayList<StdGP>();

  public List<TeachCalendar> getCalendars() {
    return calendars;
  }

  public void statCalendarsFromStdGP() {
    Set<TeachCalendar> calendarFromStdGP = new HashSet<TeachCalendar>();
    for (StdGP stdGp : stdGPs) {
      for (StdGPPerTerm gpterm : stdGp.getGPList()) {
        calendarFromStdGP.add(gpterm.getCalendar());
      }
    }
    calendars = new ArrayList<TeachCalendar>(calendarFromStdGP);
  }

  public void setCalendars(List<TeachCalendar> calendars) {
    this.calendars = calendars;
  }

  public List<StdGP> getStdGPs() {
    return stdGPs;
  }

  public void setStdGPs(List<StdGP> stdGPs) {
    this.stdGPs = stdGPs;
  }

  public AdminClass getAdminClass() {
    return adminClass;
  }

  public void setAdminClass(AdminClass adminClass) {
    this.adminClass = adminClass;
  }

}
