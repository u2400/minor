/**
 * 
 */
package com.shufe.service.course.textbook;

import java.text.SimpleDateFormat;
import java.util.Collection;

import org.apache.commons.lang.StringUtils;

import com.ekingstar.commons.transfer.exporter.DefaultPropertyExtractor;
import com.ekingstar.eams.system.baseinfo.model.Teacher;
import com.shufe.model.course.textbook.Textbook;
import com.shufe.model.system.baseinfo.AdminClass;
import com.shufe.model.system.baseinfo.Course;
import com.shufe.model.system.baseinfo.Department;

/**
 * @author zhouqi
 */
public class BookRequireStatPropertyExtractor extends DefaultPropertyExtractor {

  public BookRequireStatPropertyExtractor() {
    super();
  }

  @Override
  @SuppressWarnings("unchecked")
  public Object getPropertyValue(Object target, String property) throws Exception {
    Object[] results = (Object[]) target;
    if (StringUtils.equals(property, "department.name")) {
      Department department = (Department) results[0];
      return department.getName();
    } else if (StringUtils.equals(property, "teacherNames")) {
      Collection<Teacher> teachers = (Collection<Teacher>) results[1];
      StringBuilder teacherNames = new StringBuilder();
      for (Teacher teacher : teachers) {
        if (teacherNames.length() != 0) {
          teacherNames.append(",");
        }
        teacherNames.append(teacher.getName());
      }
      return teacherNames.toString();
    } else if (StringUtils.equals(property, "course.code")) {
      Course course = (Course) results[2];
      return course.getCode();
    } else if (StringUtils.equals(property, "course.name")) {
      Course course = (Course) results[2];
      return course.getName();
    } else if (StringUtils.equals(property, "adminClassNames")) {
      Collection<AdminClass> adminClasses = (Collection<AdminClass>) results[3];
      StringBuilder adminClassNames = new StringBuilder();
      for (AdminClass adminClass : adminClasses) {
        if (adminClassNames.length() != 0) {
          adminClassNames.append(",");
        }
        adminClassNames.append(adminClass.getName());
      }
      return adminClassNames.toString();
    } else if (StringUtils.equals(property, "book.name")) {
      Textbook book = (Textbook) results[4];
      return book.getName();
    } else if (StringUtils.equals(property, "book.auth")) {
      Textbook book = (Textbook) results[4];
      return book.getAuth();
    } else if (StringUtils.equals(property, "book.press_publishOn")) {
      Textbook book = (Textbook) results[4];
      return book.getPress().getName() + new SimpleDateFormat("yyyy").format(book.getPublishedOn()) + "年";
    } else if (StringUtils.equals(property, "book.code")) {
      Textbook book = (Textbook) results[4];
      return book.getPress().getCode();
    } else if (StringUtils.equals(property, "takeStudentCount")) {
      return results[5];
    } else {
      return super.getPropertyValue(target, property);
    }
  }
}
