<table width="100%"></table>
<table width="100%" onkeypress="DWRUtil.onReturn(event, searchCourse)">
    <tr>
      <td colspan="2" class="infoTitle" align="left" valign="bottom">
       <img src="images/action/info.gif" align="top"/>
          <B><@msg.message key="baseinfo.searchCourse"/></B>
      </td>
    <tr>
      <td colspan="2" style="font-size:0px">
          <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
      </td>
    </tr>
    <tr><td class="infoTitle"><@bean.message key="attr.code"/>:</td><td><input type="text" name="course.code" style="width:100px;" maxlength="32"/></td></tr>
    <tr><td><@bean.message key="attr.infoname"/>:</td><td><input type="text" name="course.name" style="width:100px;" maxlength="30"/></td></tr>
   	<tr><td><@bean.message key="entity.studentType"/>：</td><td>
   	  <@htm.i18nSelect datas=stdTypes selected="" name="course.stdType.id" style="width:100px;">
   	     <option value="">...</option>
   	  </@>
    </td></tr>
    <tr>
        <td>课程类别：</td>
        <td><@htm.i18nSelect datas=courseTypes selected="" name="course.extInfo.courseType.id" style="width:100px;">
         <option value="">...</option>
      </@></td>
    </tr>
    ${extraSearchOptions?default("")}
    <tr>
       <td>创建时间:</td>
       <td><input type="text" name="courseCreateAt" style="width:100px;" maxlength="32"/></td>
    </tr>
    <tr>
       <td>修改时间:</td>
       <td><input type="text" name="courseModifyAt"  style="width:100px;" maxlength="32"/></td>
    </tr>   
    <tr height="50px">
        <td colspan="2" align="center">
            <button onclick="searchCourse()" accesskey="Q"><@bean.message key="action.query"/>(<U>Q</U>)</button>
        </td>
    </tr>
  </table>
