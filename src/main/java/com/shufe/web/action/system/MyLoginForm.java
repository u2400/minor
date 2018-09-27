package com.shufe.web.action.system;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.security.web.formbean.LoginForm;

public class MyLoginForm extends LoginForm {

  @Override
  public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
    ActionErrors errors = new ActionErrors();
    if (getName() == null || getName() == "" || getName().trim().length() < 1) {
      addError(errors, "usrName", "userName.null.error");
    }

    if (getPassword() == null || getPassword() == "" || getPassword().trim().length() < 1) {
      addError(errors, "password", "password.null.error");
    }

    return errors;

  }

}
