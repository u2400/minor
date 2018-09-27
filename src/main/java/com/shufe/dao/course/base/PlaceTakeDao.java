package com.shufe.dao.course.base;

/**
 * 毕业实习基地（后台）
 * 
 * @author zhouqi
 */
public interface PlaceTakeDao {

  public int addStdCount(final Long switchPlaceId);

  public int removeStdCount(final Long switchPlaceId);
}
