/**
 * 
 */
package com.shufe.checker.course.task;

import java.util.Collection;

import com.shufe.model.course.task.TeachTask;

/**
 * 教学任务可否删除检查器
 * 
 * @author zhouqi
 */
public interface TeachTaskRemoveChecker {

  public void addTask(TeachTask task);

  public void addTasks(Collection<TeachTask> tasks);

  public void clearTasks();

  public boolean canBeRemove();
}
