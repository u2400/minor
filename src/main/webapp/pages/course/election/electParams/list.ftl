<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/Menu.js"></script>
<body LEFTMARGIN="0" TOPMARGIN="0">
    <table id="electParamsBar"></table>
    <@table.table width="100%" id="electParameters" sortable="true">
        <@table.thead>
          <@table.selectAllTd id="paramsId"/>
          <@table.sortTd width="5%" name="attr.electTurn" id="params.turn"/>
          <@table.td width="8%" name="entity.studentType"/>
          <@table.td width="8%" name="attr.enrollTurn"/>
          <@table.td width="30%" name="entity.college"/>
          <@table.sortTd width="14%" name="attr.startDate" id="params.startAt"/>
          <@table.sortTd width="14%" name="attr.finishDate" id="params.endAt"/>
        </@>
        <@table.tbody datas=electParamsList;params>
            <@table.selectTd id="paramsId" value=params.id/>
            <td><A href="#" onclick="info(${params.id})">${params.turn}</A></td>
            <td><#list params.stdTypes as stdType><@i18nName stdType/><#if stdType_has_next>，</#if></#list></td>
            <td><#list params.enrollTurns as enrollTurn>${enrollTurn}<#if enrollTurn_has_next>，</#if></#list></td>
            <td><#list params.departs as depart><@i18nName depart/><#if depart_has_next>，</#if></#list></td>
            <td>${params.startAt?string("yyyy-MM-dd HH:mm")}<br/>选课:${params.electStartAt?string("yyyy-MM-dd HH:mm")}</td>
            <td>${params.endAt?string("yyyy-MM-dd HH:mm")}<br/>选课:${params.electEndAt?string("yyyy-MM-dd HH:mm")}</td>
        </@>
    </@>
    <@htm.actionForm name="actionForm" action="electParams.do" entity="params" onsubmit="return false;"></@>
    <script>
	    var bar = new ToolBar('electParamsBar','<@bean.message key="entity.electParams"/><@bean.message key="common.list"/>',null,true,true);
	    bar.setMessage('<@getMessage/>');
	    bar.addItem("<@bean.message key="action.info"/>","info()",'detail.gif');
	    bar.addItem("<@bean.message key="action.new"/>","add()",'new.gif');
	    bar.addItem("<@bean.message key="action.modify"/>","edit()",'update.gif');
	    bar.addItem("<@bean.message key="action.delete"/>","remove()");
    </script>
</body>
<#include "/templates/foot.ftl"/> 