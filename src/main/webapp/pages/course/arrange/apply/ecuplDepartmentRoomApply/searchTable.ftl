<table width="100%" id="menuTable" onkeypress="DWRUtil.onReturn(event, search)">
    <tr class="infoTitle" valign="top">
        <td class="infoTitle" align="left" valign="bottom" colspan="2">
            <img src="images/action/info.gif" align="top"/>
            <b>借用查询</b>
        </td>
    </tr>
    <tr>
        <td style="font-size:0px" colspan="2">
            <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
        </td>
    </tr>
    <tr>
      <td colspan="2">
         <fieldSet  align=center> 
         <legend>日期区间</legend>
            开始：<input type="text" name="applyTime.dateBegin" value="${RequestParameters['roomApply.applyTime.dateBegin']?if_exists}" onfocus="calendar()" size="10" maxlength="10"/><br>
            结束：<input type="text" name="applyTime.dateEnd" value="${RequestParameters['roomApply.applyTime.dateEnd']?if_exists}" onfocus="calendar()" size="10" maxlength="10"/>
        </fieldSet>
        </td>
    </tr>
    <tr>
     <td colspan="2" id="f_Time">
         <fieldset align=center>
         <legend>时间区间</legend>
            开始：<input type="text" name="applyTime.timeBegin" value="${RequestParameters['applyTime.timeBegin']?if_exists}" size="10" maxlength="5"/><br>
            结束：<input type="text" name="applyTime.timeEnd" value="${RequestParameters['applyTime.timeEnd']?if_exists}" size="10" maxlength="5"/>
        </fieldset>
        </td>
    </tr>
    <tr>
        <td colspan="2" id="f_Time">
         <fieldset align=center>
         <legend>申请时间1</legend>
         从:<input type="text" name="applyAtBegin" onfocus="calendar()" maxlength="10" style="width:100px"/>
        到： <input type="text" name="applyAtEnd" onfocus="calendar()" maxlength="10" style="width:100px"/>
         </fieldset>
        </td>
    </tr>
    <tr>
        <td colspan="2">
         <fieldSet  align=center> 
         <legend>教室</legend>
            可借：<select name="classroom.id" style="width:90px">
                <option value="">...</option>
                <#list classrooms?sort_by("name") as classroom>
                <option value="${classroom.id}">${classroom.name}</option>
                </#list>
            </select>
        </fieldSet>
        </td>
    </tr>
    <input type="hidden" name="lookContent" value="2"/>
    <input type="hidden" name="orderBy" value="roomApply.applyAt desc"/>
    <tr class="title">
        <td colspan="2" align="center">
         <button onClick="this.form.reset()">重置</button>&nbsp;
         <button onClick="search(document.searchRoomApplyApproveForm)" id="searchRoom">查询</button>
        </td>
    </tr>
</table>