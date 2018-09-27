/**
 * 
 */
package com.shufe.dao.course.base.hibernate;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.shufe.dao.BasicHibernateDAO;
import com.shufe.dao.course.base.PlaceTakeDao;

/**
 * 毕业实习基地（后台）
 * 
 * @author zhouqi
 */
public class PlaceTakeDaoHibernate extends BasicHibernateDAO implements PlaceTakeDao {

  public int addStdCount(final Long switchPlaceId) {
    return updateStdCount(switchPlaceId,
        "UPDATE BYSXJD_XKKG_PZ_T SET SJRS = SJRS + 1 WHERE ID = ? AND SJRS < RSSX");
  }

  public int removeStdCount(final Long switchPlaceId) {
    return updateStdCount(switchPlaceId,
        "UPDATE BYSXJD_XKKG_PZ_T SET SJRS = SJRS - 1 WHERE ID = ? AND SJRS > 0");
  }

  @SuppressWarnings("deprecation")
  protected int updateStdCount(final Long switchPlaceId, String sql) {
    Connection con = getSession().connection();
    int count = 0;
    try {
      PreparedStatement cstmt = con.prepareStatement(sql);
      if (null != switchPlaceId) {
        cstmt.setLong(1, switchPlaceId);
      }
      count = cstmt.executeUpdate();
      con.commit();
      cstmt.close();
    } catch (SQLException e) {
      e.printStackTrace();
      try {
        con.rollback();
      } catch (Exception e1) {
        e1.printStackTrace();
      }
    }
    return count;
  }
}
