//$Id: EcuplSsoUserProviderImpl.java,v 1.1 2007-9-14 下午05:56:37 chaostone Exp $
/*
 *
 * KINGSTAR MEDIA SOLUTIONS Co.,LTD. Copyright c 2005-2006. All rights reserved.
 * 
 * This source code is the property of KINGSTAR MEDIA SOLUTIONS LTD. It is intended 
 * only for the use of KINGSTAR MEDIA application development. Reengineering, reproduction
 * arose from modification of the original source, or other redistribution of this source 
 * is not permitted without written permission of the KINGSTAR MEDIA SOLUTIONS LTD.
 * 
 */
/********************************************************************************
 * @author chaostone
 * 
 * MODIFICATION DESCRIPTION
 * 
 * Name                 Date                Description 
 * ============         ============        ============
 * chenweixiong              2007-9-14         Created
 *  
 ********************************************************************************/

package com.ekingstar.eams.system.security.service.impl;

import java.net.URL;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.net.URLCodec;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.InitializingBean;

import com.wiscom.is.IdentityFactory;
import com.wiscom.is.IdentityManager;

public class EcuplSsoUserProviderImpl extends
    com.ekingstar.security.monitor.providers.AbstractSsoUserProvider implements InitializingBean {

  protected static Log log = LogFactory.getLog(EcuplSsoUserProviderImpl.class);

  private String clientFile;

  private IdentityManager im;

  protected String doGetUserLoginName(HttpServletRequest request) {
    Cookie all_cookies[] = request.getCookies();
    String decodedCookieValue = null;
    if (all_cookies != null) {
      for (int i = 0; i < all_cookies.length; i++) {
        Cookie myCookie = all_cookies[i];
        if (myCookie.getName().equals("iPlanetDirectoryPro")) {
          try {
            decodedCookieValue = new URLCodec().decode(myCookie.getValue(), "GB2312");
          } catch (Exception e) {
          }
          break;
        }
      }
    }
    String curUser = null;
    if (decodedCookieValue != null && null != im) {
      curUser = im.getCurrentUser(decodedCookieValue);
    }
    if (null != curUser && curUser.length() > 0) return curUser;
    else return null;
  }

  public String getClientFile() {
    return clientFile;
  }

  public void setClientFile(String ldapPropertyFile) {
    this.clientFile = ldapPropertyFile;
  }

  public void afterPropertiesSet() throws Exception {
    if (null == clientFile) return;
    URL url = getClass().getResource(clientFile);
    if (null != url) {
      this.clientFile = url.getPath();
      try {
        IdentityFactory factory = IdentityFactory.createFactory(clientFile);
        im = factory.getIdentityManager();
        log.info("Create identity factory from " + clientFile);
      } catch (Exception e) {
        log.error("Cannot create identity factory of :" + clientFile);
      }
    } else {
      throw new RuntimeException("Cannot find clientFile " + clientFile + " in classpath.");
    }
  }

  public IdentityManager getIm() {
    return im;
  }

}
