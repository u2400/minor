package com.shufe.web.action.system;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.springframework.web.struts.DispatchActionSupport;

import com.ekingstar.commons.utils.web.CookieUtils;
import com.ekingstar.eams.system.security.service.impl.EcuplSsoUserProviderImpl;
import com.ekingstar.security.monitor.providers.AuthenticationProvider;

/**
 * @author dell,chaostone
 */
public class LogoutAction extends DispatchActionSupport {

  private AuthenticationProvider ssoUserProvider;

  public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    CookieUtils.deleteCookieByName(request, response, "password");
    request.getSession().invalidate();
    ActionForward forward = mapping.findForward("success");
    if (comefromIDS(request) && ssoUserProvider instanceof EcuplSsoUserProviderImpl
        && forward.getPath().startsWith("/")) {
      String logoutURL = (new StringBuilder(String.valueOf(((EcuplSsoUserProviderImpl) ssoUserProvider)
          .getIm().getLogoutURL()))).toString();
      response.sendRedirect(logoutURL);
      return null;
    } else {
      return forward;
    }
  }

  private Boolean comefromIDS(HttpServletRequest request) {
    Cookie all_cookies[] = request.getCookies();
    Cookie iPlanetDirectoryPro = null;
    if (all_cookies != null) {
      for (int i = 0; i < all_cookies.length; i++) {
        Cookie myCookie = all_cookies[i];
        if (myCookie.getName().equals("iPlanetDirectoryPro")) {
          iPlanetDirectoryPro = myCookie;
          break;
        }
      }
    }
    return null != iPlanetDirectoryPro;
  }

  public void setSsoUserProvider(AuthenticationProvider ssoUserProvider) {
    this.ssoUserProvider = ssoUserProvider;
  }

}
