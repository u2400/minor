package com.shufe.service.course.arrange.apply;

import java.io.Serializable;
import java.util.List;

import com.ekingstar.commons.model.pojo.PojoExistException;
import com.shufe.model.course.arrange.resource.RoomOccupySwitch;
import com.shufe.model.course.arrange.task.ManualArrangeParam;

public interface RoomApplySwitchService {

  public RoomOccupySwitch getRoomOccupySwitch(Serializable id);

  /**
   * @param stdTypeIds
   * @param calendar
   * @return
   */

  public List getRoomApplySwitch(Long calendarId);

  /**
   * @param params
   * @throws PojoExistException
   */
  public void saveRoomApplySwitch(RoomOccupySwitch roomOccupySwitch) throws PojoExistException;

}
