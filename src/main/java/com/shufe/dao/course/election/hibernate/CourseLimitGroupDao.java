package com.shufe.dao.course.election.hibernate;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.springframework.jdbc.core.JdbcTemplate;

import com.shufe.model.course.task.GenderLimitGroup;

public class CourseLimitGroupDao extends JdbcTemplate {

  public int reserveGroupLimit(GenderLimitGroup group) {
    Connection con = null;
    int result = 0;
    try {
      con = getDataSource().getConnection();
      PreparedStatement statement = con
          .prepareStatement("update JXRW_RSXZ_T set rs=rs+1 where rs<rssx and id=?");
      statement.setLong(1, group.getId());
      result = statement.executeUpdate();
      statement.close();
    } catch (SQLException e) {
      throw new RuntimeException(e);
    } finally {
      if (null != con) try {
        con.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
    return result;
  }

  public int releaseGroupLimit(GenderLimitGroup group) {
    Connection con = null;
    int result = 0;
    try {
      con = getDataSource().getConnection();
      PreparedStatement statement = con.prepareStatement("update JXRW_RSXZ_T set rs=rs-1 where id=?");
      statement.setLong(1, group.getId());
      result = statement.executeUpdate();
      statement.close();
    } catch (SQLException e) {
      throw new RuntimeException(e);
    } finally {
      if (null != con) try {
        con.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
    return result;
  }
}
