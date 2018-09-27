package com.shufe.checker.course.task;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import com.shufe.model.course.task.TeachTask;
import com.shufe.service.BasicService;

public class TeachTaskRemoveCheckerHead extends BasicService {

  protected Set<CheckerEntity<?>> checkerEntities = new HashSet<CheckerEntity<?>>();

  protected Collection<TeachTaskRemoveChecker> checkers = new ArrayList<TeachTaskRemoveChecker>();

  protected Set<TeachTask> tasks = new HashSet<TeachTask>();

  public <T> void addChecker(Class<T> clazz) {
    checkerEntities.add(new CheckerEntity<T>(clazz));
  }

  public <T> void addChecker(Class<T> clazz, String propertyName) {
    checkerEntities.add(new CheckerEntity<T>(clazz, propertyName));
  }

  public <T> void addChecker(Class<T> clazz, StringBuilder statement) {
    checkerEntities.add(new CheckerEntity<T>(clazz, statement));
  }

  public void clearCheckers() {
    checkers.clear();
  }

  public void addTask(TeachTask task) {
    tasks.add(task);
  }

  public void addTasks(Collection<TeachTask> tasks) {
    this.tasks.addAll(tasks);
  }

  public void clearTasks() {
    tasks.clear();
  }
}

class CheckerEntity<T> {

  private Class<T> clazz;

  private String propertName = "task";

  private StringBuilder statement;

  public CheckerEntity(Class<T> clazz) {
    this.clazz = clazz;
  }

  public CheckerEntity(Class<T> clazz, String propertName) {
    this(clazz);
    this.propertName = propertName;
  }

  public CheckerEntity(Class<T> clazz, StringBuilder statement) {
    this(clazz);
    this.statement = statement;
  }

  public Class<T> getClazz() {
    return clazz;
  }

  public void setClazz(Class<T> clazz) {
    this.clazz = clazz;
  }

  public String getPropertName() {
    return propertName;
  }

  public void setPropertName(String propertName) {
    this.propertName = propertName;
  }

  public StringBuilder getStatement() {
    return statement;
  }

  public void setStatement(StringBuilder statement) {
    this.statement = statement;
  }
}
