<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/Menu.js"></script>
<body LEFTMARGIN="0" TOPMARGIN="0">
    <table id="electParamsBar"></table>
    <@table.table width="100%" id="teachTaskParam" sortable="true">
        <@table.thead>
          <@table.selectAllTd id="paramsId"/>
          <@table.td width="15%" text="学年度"/>
          <@table.td width="15%" text="学期"/>
          <@table.td width="20%" text="院系"/>
          <@table.td width="20%" text="开始时间"/>
          <@table.td width="20%" text="结束时间"/>
          <@table.td width="10%" text="开关状态"/>
        </@>
        <@table.tbody datas=manualArrangeParamList;params>
          <@table.selectTd id="paramsId" value=params.id/>
          <td>${params.calendar.year}</td>
          <td>${params.calendar.term}</td>
          <td>${(params.department.name)?default("全校(除指定)")}</td>
          <td>${params.startDate?if_exists}</td>
          <td>${params.finishDate?if_exists}</td>
          <td>${params.isOpen?if_exists?string('开放','关闭')}</td>
        </@>
    </@>
    <@htm.actionForm name="actionForm" action="roomApplySwitch.do" entity="params" onsubmit="return false;">
        <input type="hidden" name="calenarId" value="${RequestParameters["roomOccupySwitch.calendar.id"]}"/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if !filterKeys?seq_contains(key)>&${key}=${RequestParameters[key]?if_exists}</#if></#list>&calenarId=${RequestParameters["roomOccupySwitch.calendar.id"]}"/>
    </@>
    <script>
	    var bar = new ToolBar('electParamsBar','教室借用开关',null,true,true);
	    bar.setMessage('<@getMessage/>');
	    bar.addItem("<@bean.message key="action.new"/>","add()",'new.gif');
	    bar.addItem("<@bean.message key="action.modify"/>","edit()",'update.gif');
	    bar.addItem("<@bean.message key="action.delete"/>","remove()");
    </script>
</body>
<#include "/templates/foot.ftl"/> 