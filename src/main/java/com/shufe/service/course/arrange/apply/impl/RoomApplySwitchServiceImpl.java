package com.shufe.service.course.arrange.apply.impl;

import java.io.Serializable;
import java.util.Collections;
import java.util.List;

import com.ekingstar.commons.model.pojo.PojoExistException;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.shufe.dao.course.arrange.RoomApplySwitchDAO;
import com.shufe.dao.course.task.ManualArrangeParamDao;
import com.shufe.model.course.arrange.resource.RoomOccupySwitch;
import com.shufe.model.course.arrange.task.ManualArrangeParam;
import com.shufe.service.BasicService;
import com.shufe.service.course.arrange.apply.RoomApplySwitchService;

public class RoomApplySwitchServiceImpl extends BasicService implements RoomApplySwitchService {

  RoomApplySwitchDAO roomApplySwitchDAO;

  public void setRoomApplySwitchDAO(RoomApplySwitchDAO roomApplySwitchDAO) {
    this.roomApplySwitchDAO = roomApplySwitchDAO;
  }

  public RoomOccupySwitch getRoomOccupySwitch(Serializable id) {
    return (RoomOccupySwitch) roomApplySwitchDAO.load(RoomOccupySwitch.class, id);
  }

  public List getRoomApplySwitch(Long calendarId) {
    if (null != calendarId) {
      EntityQuery entityQuery = new EntityQuery(RoomOccupySwitch.class, "roomOccupySwitch");
      entityQuery.add(new Condition("roomOccupySwitch.calendar.id=" + calendarId));
      List list = (List) utilDao.search(entityQuery);
      return list;
    } else return Collections.EMPTY_LIST;
  }

  public void saveRoomApplySwitch(RoomOccupySwitch roomOccupySwitch) throws PojoExistException {
    if (roomOccupySwitch == null) { return; }
    roomApplySwitchDAO.saveRoomApplySwitch(roomOccupySwitch);
  }

}
