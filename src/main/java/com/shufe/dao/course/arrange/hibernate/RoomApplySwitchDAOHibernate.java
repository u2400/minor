package com.shufe.dao.course.arrange.hibernate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.shufe.dao.BasicHibernateDAO;
import com.shufe.dao.course.arrange.RoomApplySwitchDAO;
import com.shufe.model.course.arrange.resource.RoomOccupySwitch;
import com.shufe.model.course.arrange.task.ManualArrangeParam;
import com.shufe.model.system.calendar.TeachCalendar;

public class RoomApplySwitchDAOHibernate extends BasicHibernateDAO implements RoomApplySwitchDAO {

  public List getManualArrangeParam(Long[] stdTypeIds, TeachCalendar calendar) {
    Map params = new HashMap();
    params.put("stdTypeIds", stdTypeIds);
    params.put("calendar", calendar);
    return find("getElectParams", params);
  }

  public void saveRoomApplySwitch(RoomOccupySwitch roomOccupySwitch) {
    getSessionFactory().evict(RoomOccupySwitch.class);
    saveOrUpdate(roomOccupySwitch);
  }

}
