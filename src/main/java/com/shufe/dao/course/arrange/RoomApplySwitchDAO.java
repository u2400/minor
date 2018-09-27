package com.shufe.dao.course.arrange;

import java.util.List;

import com.shufe.dao.BasicDAO;
import com.shufe.model.course.arrange.resource.RoomOccupySwitch;
import com.shufe.model.course.arrange.task.ManualArrangeParam;
import com.shufe.model.system.calendar.TeachCalendar;

public interface RoomApplySwitchDAO extends BasicDAO {

  public List getManualArrangeParam(Long[] stdTypeIds, TeachCalendar calendar);

  public void saveRoomApplySwitch(RoomOccupySwitch roomOccupySwitch);

}
