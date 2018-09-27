/**
 * 
 */
package com.shufe.web.action.course.arrange.base;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.shufe.dao.course.base.PlaceTakeDao;
import com.shufe.model.course.arrange.base.PlaceTake;
import com.shufe.model.course.arrange.base.PlaceTakeSwitch;
import com.shufe.model.course.arrange.base.SwitchPlace;
import com.shufe.model.std.Student;
import com.shufe.web.action.common.RestrictionSupportAction;

/**
 * 学生界面基地选择
 * 
 * @author zhouqi
 */
public class PlaceTakeAction extends RestrictionSupportAction {

  protected PlaceTakeDao placeTakeDao;

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "placeSwitches", utilService.loadAll(PlaceTakeSwitch.class));
    addSingleParameter(request, "student", getStudentFromSession(request.getSession()));
    addSingleParameter(request, "nowAt", new Date());
    return forward(request);
  }

  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    PlaceTakeSwitch placeSwitch = (PlaceTakeSwitch) utilService.get(PlaceTakeSwitch.class,
        getLong(request, "placeSwitchId"));
    if (!placeSwitch.getOpen().booleanValue()) { return redirect(request, "index",
        "info.action.failure.timeover2"); }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    int nowAtValue = Integer.parseInt(sdf.format(new Date()));
    int beginOnValue = Integer.parseInt(sdf.format(placeSwitch.getBeginOn()));
    int endOnValue = Integer.parseInt(sdf.format(placeSwitch.getEndOn()));
    if (nowAtValue < beginOnValue || nowAtValue > endOnValue) { return redirect(request, "index",
        "info.action.failure.timeover2"); }

    Student student = getStudentFromSession(request.getSession());
    if (!StringUtils.contains("," + placeSwitch.getGrades() + ",", "," + student.getEnrollYear() + ",")
        || !placeSwitch.getStdTypes().contains(student.getType())
        || !placeSwitch.getDepartments().contains(student.getDepartment())) { return redirect(request,
        "index", "info.action.failure.timeover2"); }

    addSingleParameter(request, "placeSwitch", placeSwitch);
    addSingleParameter(request, "student", student);
    return forward(request);
  }

  public ActionForward add(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    SwitchPlace switchPlace = (SwitchPlace) utilService.get(SwitchPlace.class,
        getLong(request, "switchPlaceId"));

    if (!switchPlace.getPlaceSwitch().getOpen().booleanValue()) { return redirect(request, "index",
        "info.action.failure.timeover2"); }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    int nowAtValue = Integer.parseInt(sdf.format(new Date()));
    int beginOnValue = Integer.parseInt(sdf.format(switchPlace.getPlaceSwitch().getBeginOn()));
    int endOnValue = Integer.parseInt(sdf.format(switchPlace.getPlaceSwitch().getEndOn()));
    if (nowAtValue < beginOnValue || nowAtValue > endOnValue) { return redirect(request, "index",
        "info.action.failure.timeover2"); }

    Student student = getStudentFromSession(request.getSession());
    if (!StringUtils.contains("," + switchPlace.getPlaceSwitch().getGrades() + ",",
        "," + student.getEnrollYear() + ",")
        || !switchPlace.getPlaceSwitch().getStdTypes().contains(student.getType())
        || !switchPlace.getPlaceSwitch().getDepartments().contains(student.getDepartment())) { return redirect(
        request, "index", "info.action.failure.timeover2"); }
    // 防“非法操作”
    if (switchPlace.getPlaceSwitch().hasTake(student)) { return redirect(request, "search",
        "info.action.invalid"); }

    if (0 == placeTakeDao.addStdCount(switchPlace.getId())) { return redirect(request, "search",
        "info.action.failure.over"); }

    // switchPlace.setStdCount(switchPlace.getStdCount() + 1);
    utilService.saveOrUpdate(new PlaceTake(switchPlace, student));

    return redirect(request, "search", "info.action.success");
  }

  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    SwitchPlace switchPlace = (SwitchPlace) utilService.get(SwitchPlace.class,
        getLong(request, "switchPlaceId"));

    if (!switchPlace.getPlaceSwitch().getOpen().booleanValue()) { return redirect(request, "index",
        "info.action.failure.timeover2"); }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    int nowAtValue = Integer.parseInt(sdf.format(new Date()));
    int beginOnValue = Integer.parseInt(sdf.format(switchPlace.getPlaceSwitch().getBeginOn()));
    int endOnValue = Integer.parseInt(sdf.format(switchPlace.getPlaceSwitch().getEndOn()));
    if (nowAtValue < beginOnValue || nowAtValue > endOnValue) { return redirect(request, "index",
        "info.action.failure.timeover2"); }

    Student student = getStudentFromSession(request.getSession());
    if (!StringUtils.contains("," + switchPlace.getPlaceSwitch().getGrades() + ",",
        "," + student.getEnrollYear() + ",")
        || !switchPlace.getPlaceSwitch().getStdTypes().contains(student.getType())
        || !switchPlace.getPlaceSwitch().getDepartments().contains(student.getDepartment())) { return redirect(
        request, "index", "info.action.failure.timeover2"); }

    placeTakeDao.removeStdCount(switchPlace.getId());
    // if (0 == placeTakeDao.removeStdCount(switchPlace.getId())) {
    // return redirect(request, "search", "info.action.failure.null");
    // }

    utilService.remove(utilService.get(PlaceTake.class, getLong(request, "takeId")));
    // switchPlace.setStdCount(switchPlace.getStdCount() - 1);
    // utilService.saveOrUpdate(switchPlace);

    return redirect(request, "search", "info.action.success");
  }

  public void setPlaceTakeDao(PlaceTakeDao placeTakeDao) {
    this.placeTakeDao = placeTakeDao;
  }
}
