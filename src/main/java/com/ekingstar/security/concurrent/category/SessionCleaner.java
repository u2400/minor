package com.ekingstar.security.concurrent.category;

import java.util.List;
import java.util.TimerTask;

import org.apache.commons.lang.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ekingstar.security.concurrent.SessionInfo;
import com.ekingstar.security.concurrent.SessionRegistry;
import com.ekingstar.security.concurrent.category.CategorySessionController;

/**
 * @author chaostone
 * @version $Id: SessionCleaner.java Jun 6, 2011 12:21:24 PM chaostone $
 */
public class SessionCleaner extends TimerTask {

  private final Logger logger = LoggerFactory.getLogger(SessionCleaner.class);

  private final SessionRegistry registry;

  private final CategorySessionController controller;
  /**
   * 最大过期时间
   */
  private final long maxOnlineTime;

  // 最大过期时间为6小时
  public SessionCleaner(CategorySessionController controller, SessionRegistry registry) {
    this(controller, registry, 1000 * 60 * 60 * 6);
  }

  public SessionCleaner(CategorySessionController controller, SessionRegistry registry, long maxOnlineTime) {
    super();
    this.registry = registry;
    this.controller = controller;
    this.maxOnlineTime = maxOnlineTime;
  }

  protected boolean shouldRemove(SessionInfo info) {
    return info.isExpired() || (info.getOnlineTime() >= maxOnlineTime);
  }

  @Override
  public void run() {
    StopWatch watch = new StopWatch();
    watch.start();
    logger.debug("clean up expired or over maxOnlineTime session start ...");
    List<SessionInfo> infos = registry.getSessionInfos();
    int removed = 0;
    for (SessionInfo info : infos) {
      if (shouldRemove(info)) {
        try {
          controller.removeAuthentication(info.getSessionId());
          removed++;
        } catch (Exception e) {
          e.printStackTrace();
        }
      }
    }
    if (removed > 0 || watch.getTime() > 50) {
      logger.info("removed {} expired or over maxOnlineTime sessions in {} ms", removed, watch.getTime());
    }
  }

}
