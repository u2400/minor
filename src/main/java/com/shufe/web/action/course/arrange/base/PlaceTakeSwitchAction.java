/**
 * 
 */
package com.shufe.web.action.course.arrange.base;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ekingstar.commons.lang.SeqStringUtil;
import com.ekingstar.commons.mvc.struts.misc.ForwardSupport;
import com.ekingstar.commons.query.Condition;
import com.ekingstar.commons.query.EntityQuery;
import com.ekingstar.commons.query.OrderUtils;
import com.ekingstar.commons.transfer.exporter.PropertyExtractor;
import com.ekingstar.eams.system.baseinfo.StudentType;
import com.shufe.model.course.arrange.base.GraduatePlace;
import com.shufe.model.course.arrange.base.PlaceTake;
import com.shufe.model.course.arrange.base.PlaceTakeSwitch;
import com.shufe.model.course.arrange.base.SwitchPlace;
import com.shufe.model.system.baseinfo.Department;
import com.shufe.service.course.arrange.base.PlaceTakePropertyExtractor;
import com.shufe.web.action.common.RestrictionSupportAction;

/**
 * 毕业实习基地开关管理
 * 
 * @author zhouqi
 */
public class PlaceTakeSwitchAction extends RestrictionSupportAction {

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(request, "placeSwitches", utilService.loadAll(PlaceTakeSwitch.class));
    return forward(request);
  }

  @SuppressWarnings("unchecked")
  public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    PlaceTakeSwitch placeSwitch = (PlaceTakeSwitch) utilService.get(PlaceTakeSwitch.class,
        getLong(request, "placeSwitchId"));

    EntityQuery query1 = new EntityQuery(GraduatePlace.class, "place");
    query1.add(new Condition("not exists (from " + SwitchPlace.class.getName()
        + " switchPlace where switchPlace.place = place and switchPlace.placeSwitch = :placeSwitch)",
        placeSwitch));
    query1.add(new Condition("place.status = 1"));
    query1.add(new Condition("place.enabled = true"));
    Collection<GraduatePlace> places = utilService.search(query1);
    if (CollectionUtils.isNotEmpty(places)) {
      Collection<SwitchPlace> switchPlaces = new ArrayList<SwitchPlace>();
      for (GraduatePlace place : places) {
        switchPlaces.add(new SwitchPlace(placeSwitch, place));
      }
      utilService.saveOrUpdate(switchPlaces);
      return redirect(request, "search", "");
    }

    EntityQuery query2 = new EntityQuery(SwitchPlace.class, "switchPlace");
    query2.add(new Condition("switchPlace.placeSwitch = :placeSwitch", placeSwitch));
    query2.addOrder(OrderUtils.parser(get(request, "orderBy")));
    query2.setLimit(getPageLimit(request));
    addCollection(request, "switchPlaces", utilService.search(query2));
    addSingleParameter(request, "placeSwitch", placeSwitch);
    return forward(request);
  }

  public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    if (!BooleanUtils.isTrue(getBoolean(request, "isAdd"))) {
      Long placeSwitchId = getLong(request, "placeSwitchId");
      if (null != placeSwitchId) {
        addSingleParameter(request, "placeSwitch", utilService.get(PlaceTakeSwitch.class, placeSwitchId));
      }
    }
    addCollection(request, "stdTypes", getStdTypes(request));
    addCollection(request, "departments", getDeparts(request));
    return forward(request);
  }

  public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    PlaceTakeSwitch takeSwitch = (PlaceTakeSwitch) populateEntity(request, PlaceTakeSwitch.class,
        "placeSwitch");

    takeSwitch.getStdTypes().clear();
    takeSwitch.getStdTypes().addAll(
        utilService.load(StudentType.class, "id", SeqStringUtil.transformToLong(get(request, "stdTypeIds"))));

    takeSwitch.getDepartments().clear();
    takeSwitch.getDepartments()
        .addAll(
            utilService.load(Department.class, "id",
                SeqStringUtil.transformToLong(get(request, "departmentIds"))));

    if (validator(takeSwitch)) {
      utilService.saveOrUpdate(takeSwitch);
      return redirect(request, "index", "info.action.success");
    } else {
      addSingleParameter(request, "placeSwitch", takeSwitch);
      addCollection(request, "stdTypes", getStdTypes(request));
      addCollection(request, "departments", getDeparts(request));
      saveErrors(request.getSession(),
          ForwardSupport.buildMessages(new String[] { "info.save.failure.overlapAcross" }));
      return forward(request, "form");
    }
  }

  protected boolean validator(PlaceTakeSwitch placeSwitch) {
    if (null == placeSwitch) { return false; }
    EntityQuery query = new EntityQuery(PlaceTakeSwitch.class, "placeSwitch");
    if (null != placeSwitch.getId()) {
      query.add(new Condition("placeSwitch != :placeSwitch", placeSwitch));
    }
    if (StringUtils.isBlank(placeSwitch.getGrades())) { return false; }
    String[] grades = StringUtils.split(placeSwitch.getGrades(), ",");
    Condition condition = new Condition();
    StringBuilder hql = new StringBuilder();
    for (int i = 0; i < grades.length; i++) {
      if (0 != hql.length()) {
        hql.append(" or ");
      }
      hql.append("placeSwitch.grades like :grade" + i);
      condition.addValue("%" + grades[i] + "%");
    }
    condition.setContent(hql.toString());
    query.add(condition);
    if (null == placeSwitch.getBeginOn()) { return false; }
    Calendar c1 = Calendar.getInstance();
    c1.setTime(placeSwitch.getBeginOn());
    c1.add(Calendar.DATE, -1);
    query.add(new Condition("placeSwitch.endOn >= :beginOn", c1.getTime()));
    if (null == placeSwitch.getEndOn()) { return false; }
    Calendar c2 = Calendar.getInstance();
    c2.setTime(placeSwitch.getEndOn());
    c2.add(Calendar.DATE, 1);
    query.add(new Condition("placeSwitch.beginOn <= :endOn", c2.getTime()));
    if (CollectionUtils.isEmpty(placeSwitch.getStdTypes())) { return false; }
    query.add(new Condition("exists (from placeSwitch.stdTypes stdType where stdType in (:stdTypes))",
        placeSwitch.getStdTypes()));
    if (CollectionUtils.isEmpty(placeSwitch.getDepartments())) { return false; }
    query.add(new Condition(
        "exists (from placeSwitch.departments department where department in (:departments))", placeSwitch
            .getDepartments()));
    return CollectionUtils.isEmpty(utilService.search(query));
  }

  public ActionForward info(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "switchPlace",
        utilService.get(SwitchPlace.class, getLong(request, "switchPlaceId")));
    return forward(request);
  }

  public ActionForward remove(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    PlaceTakeSwitch placeSwitch = (PlaceTakeSwitch) utilService.get(PlaceTakeSwitch.class,
        getLong(request, "placeSwitchId"));
    for (SwitchPlace switchPlace : placeSwitch.getSwitchPlaces()) {
      if (CollectionUtils.isNotEmpty(switchPlace.getTakes())) { return redirect(request, "index",
          "error.remove.beenUsed"); }
    }
    utilService.remove(placeSwitch);
    return redirect(request, "index", "info.action.success");
  }

  public ActionForward limitCountEdit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addCollection(
        request,
        "switchPlaces",
        utilService.load(SwitchPlace.class, "id",
            SeqStringUtil.transformToLong(get(request, "switchPlaceIds"))));
    return forward(request, "limitCountForm");
  }

  public ActionForward limitCountSave(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Long[] switchPlaceIds = SeqStringUtil.transformToLong(get(request, "switchPlaceIds"));
    Collection<Object> switchPlaces = new ArrayList<Object>();
    for (Long switchPlaceId : switchPlaceIds) {
      switchPlaces.add(populateEntity(request, SwitchPlace.class, "switchPlace" + switchPlaceId.longValue()));
    }
    utilService.saveOrUpdate(switchPlaces);
    return redirect(request, "search", "info.action.success");
  }

  @Override
  protected PropertyExtractor getPropertyExtractor(HttpServletRequest request) {
    return new PlaceTakePropertyExtractor();
  }

  @Override
  protected Collection<?> getExportDatas(HttpServletRequest request) {
    EntityQuery query = new EntityQuery(PlaceTake.class, "take");
    query.add(new Condition("take.switchPlace.placeSwitch.id = :placeSwitchId", getLong(request,
        "placeSwitchId")));
    return utilService.search(query);
  }
}
