// $Id: ApplyTime.java,v 1.1 2006/12/01 09:47:12 duanth Exp $

package com.shufe.model.course.arrange.apply;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;

import com.ekingstar.commons.model.Component;
import com.ekingstar.eams.system.time.CourseUnit;
import com.ekingstar.eams.system.time.TimeUnit;
import com.shufe.model.system.calendar.TimeSetting;

public class ApplyTime implements Component, Serializable {

  private static final long serialVersionUID = 3010476999373595030L;

  /** 天 */
  public final static Integer DAY = new Integer(1);

  /** 周 */
  public final static Integer WEEK = new Integer(2);

  /** 月 */
  public final static Integer MONTH = new Integer(4);

  /** 开始日期 */
  private Date dateBegin;

  /** 结束日期 */
  private Date dateEnd;

  /** 开始时间 */
  private String timeBegin;

  /** 结束时间 */
  private String timeEnd;

  /** 单位 */
  private Integer cycleType;

  /** 单位数量 */
  private Integer cycleCount;

  public ApplyTime() {
    cycleType = cycleCount = new Integer(1);
  }

  /* 自定义方法 */
  public Float calcHours() {
    if (null == getCycleCount() || getCycleCount().intValue() <= 0) { return new Float(0); }

    Calendar calendarBegin = new GregorianCalendar();
    calendarBegin.setTime(getDateBegin());
    Calendar calendarEnd = Calendar.getInstance();
    calendarEnd.setTime(getDateEnd());
    int cycle = Calendar.DAY_OF_MONTH;
    if (getCycleType().equals(WEEK)) {
      cycle = Calendar.WEEK_OF_YEAR;
    } else if (getCycleType().equals(MONTH)) {
      cycle = Calendar.MONTH;
    }
    int count = 0;
    for (; calendarBegin.before(calendarEnd) || DateUtils.isSameDay(calendarBegin, calendarEnd);) {
      count++;
      calendarBegin.add(cycle, getCycleCount().intValue());
    }
    String timeBegin = StringUtils.leftPad(StringUtils.replace(this.timeBegin, ":", ""), 4, "0");
    int beginHH = Integer.parseInt(StringUtils.left(timeBegin, 2));
    int beginMM = Integer.parseInt(StringUtils.right(timeBegin, 2));
    String timeEnd = StringUtils.leftPad(StringUtils.replace(this.timeEnd, ":", ""), 4, "0");
    int endHH = Integer.parseInt(StringUtils.left(timeEnd, 2));
    int endMM = Integer.parseInt(StringUtils.right(timeEnd, 2));

    return new Float(count * ((endHH + endMM / 60.0) - (beginHH + beginMM / 60.0)));
  }

  public Date getDateBegin() {
    return dateBegin;
  }

  public String getFormatDateBegin() {
    return new SimpleDateFormat("yyyy-MM-dd").format(this.dateBegin);
  }

  public void setDateBegin(Date dateBegin) {
    this.dateBegin = dateBegin;
  }

  public Date getDateEnd() {
    return dateEnd;
  }

  public String getFormatDateEnd() {
    return new SimpleDateFormat("yyyy-MM-dd").format(this.dateEnd);
  }

  public void setDateEnd(Date dateEnd) {
    this.dateEnd = dateEnd;
  }

  public String getTimeBegin() {
    return timeBegin;
  }

  public void setTimeBegin(String timeBegin) {
    this.timeBegin = timeBegin;
  }

  public String getTimeEnd() {
    return timeEnd;
  }

  public void setTimeEnd(String timeEnd) {
    this.timeEnd = timeEnd;
  }

  public Integer getCycleType() {
    return cycleType;
  }

  public void setCycleType(Integer cycleType) {
    this.cycleType = cycleType;
  }

  public Integer getCycleCount() {
    return cycleCount;
  }

  public void setCycleCount(Integer cycleCount) {
    this.cycleCount = cycleCount;
  }

  public TimeUnit[] convert(TimeSetting setting) {
    TimeUnit[] times = convert();
    if (null != times && null != setting) {
      for (int i = 0; i < times.length; i++) {
        TimeUnit unit = (TimeUnit) times[i];
        Integer[] units = setting.getUnitIndexes(unit.getStartTime(), unit.getEndTime());
        if (null != units) {
          unit.setStartUnit(units[0]);
          unit.setEndUnit(units[1]);
        }
      }
    }
    return times;
  }

  public Date getStartUnitDate() {
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String dateStr = dateFormat.format(this.dateBegin);
    String newDate = dateStr + " " + this.timeBegin.substring(0, 2) + ":" + this.timeBegin.substring(2, 4);

    SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    Date date = new Date();
    try {
      date = dateFormat1.parse(newDate);
    } catch (ParseException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    return date;
  }

  public Date getEndUnitDate() {
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String dateStr = dateFormat.format(this.dateEnd);
    String newDate = dateStr + " " + this.timeEnd.substring(0, 2) + ":" + this.timeEnd.substring(2, 4);
    SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    Date date = new Date();
    try {
      date = dateFormat1.parse(newDate);
    } catch (ParseException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    return date;
  }

  /**
   * 转换成时间格式
   * 
   * @return
   */
  public TimeUnit[] convert() {
    Calendar gc1 = Calendar.getInstance();
    gc1.setTime(this.dateBegin);
    Calendar gc2 = Calendar.getInstance();
    gc2.setTime(this.dateEnd);
    int[] units = new int[53];
    String unitstr = "";
    if (ApplyTime.WEEK.equals(cycleType)) {
      int beginYear = gc1.get(Calendar.YEAR);
      int weekid = gc1.get(Calendar.DAY_OF_WEEK) - 1;

      //
      TimeUnit[] times = new TimeUnit[gc2.get(Calendar.YEAR) - gc1.get(Calendar.YEAR) + 1];
      int k = 0;
      for (int i = gc1.get(Calendar.WEEK_OF_YEAR); gc1.getTime().before(gc2.getTime()); i = gc1
          .get(Calendar.WEEK_OF_YEAR), k = gc1.get(Calendar.YEAR) - beginYear, unitstr = "") {
        units[i == 1 ? 52 : i - 1] = 1;
        for (int j = 0; j < units.length; j++) {
          unitstr += units[j];
        }
        times[k] = new TimeUnit();
        times[k].setYear(new Integer(gc1.get(Calendar.YEAR)));
        times[k].setValidWeeks(unitstr);
        times[k].setWeekId(new Integer(weekid == 0 ? 7 : weekid));
        times[k].setStartTime(new Integer(this.timeBegin));
        times[k].setEndTime(new Integer(this.timeEnd));

        // 这里将 WEEK++
        gc1.set(Calendar.DAY_OF_YEAR, gc1.get(Calendar.DAY_OF_YEAR) + 7 * cycleCount.intValue());

        if (gc1.get(Calendar.YEAR) - beginYear != k) {
          units = new int[53];
        }
      }
      if (!gc1.getTime().before(gc2.getTime()) && !gc1.getTime().after(gc2.getTime())) {
        int kk = gc1.get(Calendar.WEEK_OF_YEAR);
        units[kk == 1 ? 52 : kk - 1] = 1;
        for (int j = 0; j < units.length; j++) {
          unitstr += units[j];
        }
        times[k] = new TimeUnit();
        times[k].setYear(new Integer(gc1.get(Calendar.YEAR)));
        times[k].setValidWeeks(unitstr);
        times[k].setWeekId(new Integer(weekid == 0 ? 7 : weekid));
        times[k].setStartTime(new Integer(this.timeBegin));
        times[k].setEndTime(new Integer(this.timeEnd));
      }
      if (null == times[times.length - 1]) {
        TimeUnit[] tu = new TimeUnit[k];
        for (int i = 0; i < tu.length; i++) {
          tu[i] = times[i];
        }
        times = tu;
      }
      return times;
    } else if (ApplyTime.DAY.equals(cycleType)) {
      int days = (int) ((gc2.getTime().getTime() - gc1.getTime().getTime()) / (3600 * 24 * 1000) + 1);

      if (days <= 0) { return null; }
      Calendar gc3 = (Calendar) GregorianCalendar.getInstance();
      gc3.setTime(gc1.getTime());

      TimeUnit[] times = new TimeUnit[days];
      for (int i = 0; i < days; i += cycleCount.intValue()) {
        // 初始清空
        unitstr = "";
        units = new int[53];

        // 得到星期几
        int weekid = gc3.get(Calendar.DAY_OF_WEEK) - 1;
        if (weekid == 0) {
          weekid = 7;
        }
        // 占用周位
        units[gc3.get(Calendar.WEEK_OF_YEAR) - 1] = 1;

        for (int j = 0; j < units.length; j++) {
          unitstr += units[j];
        }

        // 保存这一天的设置
        times[i] = new TimeUnit();
        times[i].setYear(new Integer(gc1.get(Calendar.YEAR)));
        times[i].setValidWeeks(unitstr);
        times[i].setWeekId(new Integer(weekid == 0 ? 7 : weekid));
        times[i].setStartTime(new Integer(this.timeBegin));
        times[i].setEndTime(new Integer(this.timeEnd));

        // 日期的“日”++
        gc3.set(Calendar.DATE, gc3.get(Calendar.DATE) + 1);
      }

      return times;
    } else if (ApplyTime.MONTH.equals(cycleType)) {
      int days = gc2.get(Calendar.MONTH) - gc1.get(Calendar.MONTH) + 1;

      GregorianCalendar gc3 = (GregorianCalendar) GregorianCalendar.getInstance();
      gc3.setTime(gc1.getTime());

      TimeUnit[] times = new TimeUnit[days];

      for (int i = 0; i < days; i += cycleCount.intValue()) {
        // 初始清空
        unitstr = "";
        units = new int[53];

        // 得到星期几
        int weekid = gc3.get(Calendar.DAY_OF_WEEK) - 1;
        if (weekid == 0) {
          weekid = 7;
        }
        // 占用周位
        units[gc3.get(Calendar.WEEK_OF_YEAR) - 1] = 1;

        for (int j = 0; j < units.length; j++) {
          unitstr += units[j];
        }
        // 保存这一天的设置
        times[i] = new TimeUnit();
        times[i].setYear(new Integer(gc1.get(Calendar.YEAR)));
        times[i].setValidWeeks(unitstr);
        times[i].setWeekId(new Integer(weekid == 0 ? 7 : weekid));
        times[i].setStartTime(new Integer(this.timeBegin));
        times[i].setEndTime(new Integer(this.timeEnd));

        // 日期的“日”++
        gc3.set(Calendar.MONTH, gc3.get(Calendar.MONTH) + 1);
      }
      return times;
    }
    return null;
  }

  public String toString() {
    if (null == getDateBegin()) return "";
    else {
      String[] msg = new String[] { "", "天", "周", "", "月" };
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      return "从" + sdf.format(getDateBegin()) + " " + getTimeBegin() + "到" + sdf.format(getDateEnd()) + " "
          + getTimeEnd() + "(每" + ((getCycleCount().intValue() == 1) ? "" : getCycleCount().toString())
          + msg[getCycleType().intValue()] + ")";
    }
  }

}
