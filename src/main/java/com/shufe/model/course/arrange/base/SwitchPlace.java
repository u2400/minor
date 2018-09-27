/**
 * 
 */
package com.shufe.model.course.arrange.base;

import java.util.Set;

import com.ekingstar.commons.model.pojo.LongIdObject;
import com.shufe.model.std.Student;

/**
 * 毕业实习基地配置
 * 
 * @author zhouqi
 */
public class SwitchPlace extends LongIdObject {

  private static final long serialVersionUID = 4109687137098887961L;

  PlaceTakeSwitch placeSwitch;

  GraduatePlace place;

  int limitCount;

  int stdCount;

  Set<PlaceTake> takes;

  public SwitchPlace() {
    super();
    this.stdCount = 0;
  }

  public SwitchPlace(PlaceTakeSwitch placeSwitch, GraduatePlace place) {
    this();
    this.placeSwitch = placeSwitch;
    this.place = place;
    this.limitCount = this.place.getPlanStdCount();
  }

  public PlaceTakeSwitch getPlaceSwitch() {
    return placeSwitch;
  }

  public void setPlaceSwitch(PlaceTakeSwitch placeSwitch) {
    this.placeSwitch = placeSwitch;
  }

  public GraduatePlace getPlace() {
    return place;
  }

  public void setPlace(GraduatePlace place) {
    this.place = place;
  }

  public int getLimitCount() {
    return limitCount;
  }

  public void setLimitCount(int limitCount) {
    this.limitCount = limitCount;
  }

  public int getStdCount() {
    return stdCount;
  }

  public void setStdCount(int stdCount) {
    this.stdCount = stdCount;
  }

  public Set<PlaceTake> getTakes() {
    return takes;
  }

  public PlaceTake getStudentTake(Student student) {
    for (PlaceTake take : takes) {
      if (take.getStudent().getId().longValue() == student.getId().longValue()) { return take; }
    }
    return null;
  }

  public void setTakes(Set<PlaceTake> takes) {
    this.takes = takes;
  }
}
