<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/itemSelect.js"></script>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table width="100%">
    <tr>
      <td class="infoTitle" style="height:22px;">
       <img src="images/action/info.gif" align="top"/><B>体育课组列表</B>
      </td>
      <td title="刷新排课组列表"><img src="images/action/refresh.gif" onclick="parent.setRefreshGroupListTime(1,true);" align="top"/></td>
    </tr>
    <tr>
      <td  colspan="4" style="font-size:0px" >
          <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
      </td>
   </tr>
  </table>
  <@table.table width="100%" id="groupListTable">
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <#list RequestParameters?keys as key>
            <#assign filterKeys = ["method", "groupName"]/>
            <#if !filterKeys?seq_contains(key)>
        <input type="hidden" name="${key}" value="${RequestParameters[key]?if_exists}"/>
            </#if>
        </#list>
    <tr onKeyDown="javascript:enterQuery(event)">
        <td><img src="images/action/search.png" align="top" onClick="query()" alt="<@bean.message key="info.filterInResult"/>"/></td>
        <td><input type="text" name="groupName" value="${RequestParameters["groupName"]?if_exists}" maxlength="30" style="width:100%"/></td>
    </tr>
    </form>
    <@table.thead>
      <@table.td width="20%" text=""/>
      <@table.td name="attr.groupName"/>
    </@>
    <@table.tbody simplePageBar=true datas=groupPageList;group,group_index>
      <td align="center">${group_index + 1}</td>
      <td class="padding" style="width:120px;height:20px;background-color:#ffffff" id="defaultGroup${group.id}" align="left" title="${group.name}" onclick="javascript:setSelectedRow(groupListTable,this);getGroupInfo('${group.id}')" onmouseover="MouseOver(event)" onmouseout="MouseOut(event)"><span style="display:block;width:150px;overflow:hidden;text-overflow:ellipsis;">${group.name}</span></td>
    </@>
  </@>
<form name="taskGroupListForm" action="" method="post" onsubmit="return false;">
	<input type="hidden" name="calendar.id" value="${RequestParameters["calendar.id"]}"/>
</form>
<script>
    rowStartIndex = 1;
    function getGroupInfo(groupId){
      self.parent.taskGroupContentFrame.window.location="englishGroup.do?method=info&taskGroup.id=" +groupId;
    } 
    function loadFirstGroupInfo(){ 
      <#if groupPageList?size==0>
        self.parent.taskGroupContentFrame.window.location="englishGroup.do?method=info&taskGroup.id=";
      <#else>
        var tdObj = defaultGroup<#if !RequestParameters["taskGroup.id"]?exists || RequestParameters["taskGroup.id"] == "">${groupPageList?first.id}<#else>${RequestParameters["taskGroup.id"]}</#if>;
        if (null != tdObj) {
            tdObj.onclick();
        }
      </#if>
    }
    
    function query() {
        var form = document.actionForm;
        form.target = "_self";
        form.submit();
    }
    
    function enterQuery(event) {
        if (portableEvent(event).keyCode == 13) {
            query();
        }
    }
    
    <#if RequestParameters['displayFirst']?if_exists=="1">
      loadFirstGroupInfo();
    </#if>
</script>
</body>
<#include "/templates/foot.ftl"/> 