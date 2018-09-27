package com.ekingstar.security.web.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.util.MessageResources;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;

import com.ekingstar.commons.model.predicate.ValidEntityKeyPredicate;
import com.ekingstar.security.User;
import com.ekingstar.security.service.UserService;
import com.ekingstar.security.utils.EncryptUtil;

public class PasswordAction extends SecurityBaseAction {
  private UserService userService;
  private MailSender mailSender;
  private SimpleMailMessage message;

  public void setUserService(UserService userService) {
    this.userService = userService;
  }

  public void setMailSender(MailSender mailSender) {
    this.mailSender = mailSender;
  }

  public void setMessage(SimpleMailMessage message) {
    this.message = message;
  }

  private ActionForward checkAdmin(ActionMapping mapping, HttpServletRequest request) {
    Long myId = getUserId(request);
    if (myId == null || !myId.equals(1L)) {
      ActionMessages actionMessages = new ActionMessages();
      actionMessages.add("org.apache.struts.action.GLOBAL_MESSAGE", new ActionMessage(
          "error.notEnoughAuthority"));
      addErrors(request, actionMessages);
      return mapping.findForward("error");
    }
    return null;
  }

  public ActionForward editUserAccount(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ActionForward af = checkAdmin(mapping, request);
    if (null != af) return af;
    Long userId = getLong(request, "user.id");
    request.setAttribute("user", this.userService.get(userId));
    return forward(request);
  }

  public ActionForward saveOrUpdateAccount(ActionMapping mapping, ActionForm form,
      HttpServletRequest request, HttpServletResponse response) throws Exception {
    ActionForward af = checkAdmin(mapping, request);
    if (null != af) return af;
    Long userId = getLong(request, "user.id");
    if (ValidEntityKeyPredicate.INSTANCE.evaluate(userId)) { return updateAccount(mapping, request, userId); }
    ActionMessages actionMessages = new ActionMessages();
    actionMessages.add("org.apache.struts.action.GLOBAL_MESSAGE",
        new ActionMessage("error.parameters.needed"));
    addErrors(request, actionMessages);
    return mapping.findForward("error");
  }

  public ActionForward resetPassword(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    return forward(request);
  }

  public ActionForward changePassword(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) {
    request.setAttribute("user", getUser(request));
    return forward(request);
  }

  public ActionForward updateUserAccount(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    ActionForward af = checkAdmin(mapping, request);
    if (null != af) return af;
    Long userId = getLong(request, "user.id");
    if (ValidEntityKeyPredicate.INSTANCE.evaluate(userId)) { return updateAccount(mapping, request, userId); }
    return null;
  }

  public ActionForward saveChange(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    return updateAccount(mapping, request, getUserId(request));
  }

  private ActionForward updateAccount(ActionMapping mapping, HttpServletRequest request, Long userId) {
    String email = request.getParameter("email");
    String pwd = request.getParameter("password");
    Map valueMap = new HashMap(2);
    valueMap.put("password", pwd);
    valueMap.put("email", email);
    this.utilService.update(User.class, "id", new Object[] { userId }, valueMap);
    ActionMessage msg = new ActionMessage("info.password.changed");
    ActionMessages msgs = new ActionMessages();
    msgs.add("org.apache.struts.action.GLOBAL_MESSAGE", msg);
    addErrors(request, msgs);
    return mapping.findForward("actionResult");
  }

  public ActionForward sendPassword(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    if ((StringUtils.isEmpty(name)) || (StringUtils.isEmpty(email))) {
      ActionMessages actionMessages = new ActionMessages();
      actionMessages.add("org.apache.struts.action.GLOBAL_MESSAGE", new ActionMessage(
          "error.parameters.needed"));
      addErrors(request, actionMessages);
      return mapping.findForward("error");
    }
    List userList = this.utilService.load(User.class, "name", name);
    User user = null;
    if (userList.isEmpty()) { return goErrorWithMessage(request, "error.user.notExist"); }
    user = (User) userList.get(0);

    if (!StringUtils.equals(email, user.getEmail())) { return goErrorWithMessage(request,
        "error.email.notEqualToOrign"); }
    String longinName = user.getName();
    String password = RandomStringUtils.randomNumeric(6);
    user.setRemark(password);
    user.setPassword(EncryptUtil.encodePassword(password));
    MessageResources messageResources = getResources(request);
    String title = messageResources.getMessage("user.password.sendmail.title");

    List values = new ArrayList();
    values.add(longinName);
    values.add(password);
    String body = messageResources.getMessage("user.password.sendmail.body", values.toArray());
    try {
      SimpleMailMessage msg = new SimpleMailMessage(this.message);
      msg.setTo(user.getEmail());
      msg.setSubject(title);
      msg.setText(body.toString());
      this.mailSender.send(msg);
    } catch (Exception e) {
      e.printStackTrace();
      log.info("reset password error for user:" + user.getName() + " with email :" + user.getEmail());

      return goErrorWithMessage(request, "error.email.sendError");
    }

    this.utilService.saveOrUpdate(user);
    return forward(request, "sendResult");
  }

  private ActionForward goErrorWithMessage(HttpServletRequest request, String key) {
    ActionMessage msg = new ActionMessage(key);
    ActionMessages msgs = new ActionMessages();
    msgs.add("org.apache.struts.action.GLOBAL_MESSAGE", msg);
    addErrors(request, msgs);
    return forward(request, "resetPassword");
  }
}
