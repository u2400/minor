<#include "/templates/head.ftl"/>
<body>
 <table id="bar" width="100%"></table>
 <span style="color:green">注：学籍状态中的“？”表示状态不明或未设定。</span>
 <br>
<@table.table width="100%" id="listTable" sortable="true">
   <@table.thead>
    <@table.selectAllTd id="alterationId"/>
    <@table.sortTd text="流水号" id="seqNo"/>
    <@table.sortTd name="attr.stdNo" id="std.code"/>
    <@table.sortTd name="attr.personName" id="std.name"/>
    <@table.sortTd name="entity.studentType" id="std.type.name"/>
    <@table.sortTd name="entity.department" id="std.department.name"/>
    <@table.sortTd name="entity.speciality" id="alteration.std.firstMajor.name"/>
    <@table.sortTd id="std.state.name" text="学籍状态"/>
    <@table.sortTd id="alteration.mode.name" text="变动类型"/>
     <@table.sortTd text="变动日期" id="alteration.alterBeginOn"/>
   </@>
   <@table.tbody datas=alterations;alteration>
     <@table.selectTd type="checkbox" id="alterationId" value=alteration.id/>
     <td>${alteration.seqNo}</td>
     <td><a href="studentDetailByManager.do?method=detail&stdId=${alteration.std.id}" title="查看学生基本信息">${(alteration.std.code)?if_exists}</a></td>
     <td><A href="#" onclick="alterationInfo(${alteration.id})" title="查看该学生的学籍变动信息"><@i18nName alteration.std/></A></td>
     <td><@i18nName alteration.std.type/></td>
     <td><@i18nName alteration.std.department/></td>
     <td><@i18nName alteration.std.firstMajor?if_exists/></td>
     <td>${(alteration.beforeStatus.state.name)?default("?")}-${(alteration.afterStatus.state.name)?default("?")}</td>
     <td><@i18nName alteration.mode/></td>
     <td>${alteration.alterBeginOn?string("yyyy-MM-dd")}</td>
   </@>
</@>
<@htm.actionForm name="actionForm" action="studentAlteration.do" entity="alteration">
    <input type="hidden" name="keys" value="seqNo,std.code,std.department.name,std.name,std.firstMajor.name,std.studentStatusInfo.examineeNumber,beforeStatus.adminClass.name,afterStatus.adminClass.name,mode.name,alterBeginOn"/>
    <input type="hidden" name="titles" value="流水号,学号,学院,姓名,专业,考生号,变动前班级,变动后班级,异动种类,异动日期"/>
    <input type="hidden" name="reportTemplate" value=""/>
    <input type="hidden" name="orderBy" value="${RequestParameters["orderBy"]?if_exists}"/>
</@>
<script>
    var bar=new ToolBar("bar","学籍变动管理",null,true,true);
    bar.setMessage('<@getMessage/>');
    bar.addItem("<@msg.message key="action.info"/>", "alterationInfo()", "detail.gif");
    bar.addItem("<@msg.message key="action.new"/>", "add()");
    bar.addItem("<@msg.message key="action.edit"/>", "form.target = '_self';edit()");
    bar.addItem("<@msg.message key="action.delete"/>", "form.target = '_self';remove()");
    bar.addItem("相关处理", "processOthers()", "update.gif", "进一步处理学生的成绩、选课等信息。");
    bar.addItem("导出", "form.target = '_self';exportList()");
    var menu1 = bar.addMenu("延长学年（一）", "report('delay1')", "print.gif");
    menu1.addItem("延长学年（二）", "report('delay2')", "print.gif");
    menu1.addItem("休学决定", "report('suspension')", "print.gif");
    menu1.addItem("复学决定", "report('unSuspension')", "print.gif");
    function alterationInfo(id) {
        if (null == id || "" == id) {
            info();
        } else {
            form.action = "studentAlteration.do?method=info";
            addInput(form, "alterationId", id, "hidden");
            form.target = "_self";
            form.submit();
        }
    }
    function add(){
        form.action = "studentAlteration.do?method=searchStuNo";
        form.target = "_self";
        form.submit();
    }
    
    function processOthers() {
        //form.target = "_blank";
        submitId(form, "alterationId", false, "studentAlteration.do?method=processOthers");
    }
    
        
    function report(reportTemplate) {
        var alterationIds = getSelectId("alterationId");
        if (isEmpty(alterationIds)) {
            alert("请选择要操作的记录。");
            return;
        }
        var form = document.actionForm;
        form.action = "studentAlteration.do?method=report";
        form["reportTemplate"].value = isEmpty(reportTemplate) ? "delay1" : reportTemplate;
        addInput(form, "alterationIds", alterationIds, "hidden");
        form.target = "_blank";
        form.submit();
    }
     
</script>
</body>
<#include "/templates/foot.ftl"/>