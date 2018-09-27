package com.ekingstar.security.model;

import com.ekingstar.security.UserCategory;
import com.ekingstar.security.management.ManagedRole;
import com.ekingstar.security.management.RoleManager;
import com.ekingstar.security.portal.model.MenuAuthorityObject;
import java.util.HashSet;
import java.util.Set;

public class Role extends AbstractAuthorityObject implements com.ekingstar.security.Role, ManagedRole,
    MenuAuthorityObject {

  public Role() {
    users = new HashSet();
  }

  public Role(Long id) {
    users = new HashSet();
    setId(id);
  }

  public boolean isEnabled() {
    return enabled;
  }

  public void setEnabled(boolean enabled) {
    this.enabled = enabled;
  }

  public Set getUsers() {
    return users;
  }

  public void setUsers(Set users) {
    this.users = users;
  }

  public RoleManager getCreator() {
    return creator;
  }

  public void setCreator(RoleManager creator) {
    this.creator = creator;
  }

  public UserCategory getCategory() {
    return category;
  }

  public void setCategory(UserCategory userCategory) {
    category = userCategory;
  }

  // public String toString()
  // {
  // return (new ToStringBuilder(this)).append("name", getName()).append("id",
  // id).append("description", getRemark()).append("users", users).toString();
  // }

  private static final long serialVersionUID = -3404181949500894284L;
  private Set users;
  private RoleManager creator;
  private UserCategory category;
  public boolean enabled;
}
