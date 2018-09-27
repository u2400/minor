<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<script language="JavaScript" type="text/JavaScript" src="scripts/common/gradeCommon.js"></script>
<body>
    <table id="bar1"></table>
    <table class="formTable" width="100%">
    <form method="post" name="actionForm" action="" onsubmit="return false;">
        <input type="hidden" name="taskIds" value="${RequestParameters["taskIds"]}"/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key><#if key != "method">&${key}=${RequestParameters[key]}</#if></#list>"/>
        <tr>
            <td class="title" width="20%">总评记录方式：</td>
            <td width="30%"><@htm.i18nSelect datas=markStyles?sort_by(["code"]) selected="" name="GAMarkStyleId" style="width:150px"/></td>
            <td class="title" width="20%">成绩精确度：</td>
            <td width="30%">
                <select name="precision" style="width:150px">
                    <option value="0">不保留小数</option>
                    <option value="1">保留一位小数</option>
                </select>
            </td>
        </tr>
        <tr>
        <#list gradeTypes?sort_by(["priority"]) as gradeType>
            <td class="title" id="f_percent${gradeType.id}">${gradeType.name}：</td>
            <td><input type="text" name="percent${gradeType.id}" value="0" maxlength="3" style="width:150px"/></td>
                <#if gradeType_index % 2 == 1 && gradeType_has_next>
        </tr>
        <tr>
                </#if>
        </#list>
        <#if gradeTypes?size % 2 != 0>
            <td class="title"></td>
            <td colspan="2"></td>
        </#if>
        </tr>
    </form>
    </table>
    <table id="bar2"></table>
    <@table.table id="teachTaskGradePercent" width="100%">
        <@table.thead>
            <@table.td text="课程序号"/>
            <@table.td text="课程代码"/>
            <@table.td text="课程名称"/>
            <@table.td text="学分"/>
        </@>
        <@table.tbody datas=tasks;task>
            <td>${task.seqNo}</td>
            <td>${task.course.code}</td>
            <td>${task.course.name}</td>
            <td>${task.course.credits}</td>
        </@>
    </@>
    <script>
        var bar1 = new ToolBar("bar1", "批量设置任务百分比", null, true, true);
        bar1.setMessage('<@getMessage/>');
        bar1.addItem("保存", "save()");
        bar1.addBackOrClose("<@bean.message key="action.back"/>", "<@bean.message key="action.close"/>");
        
        var bar2 = new ToolBar("bar2", "所选任务列表", null, true, true);
        bar2.setMessage('<@getMessage/>');
        bar2.addBlankItem();
        
        var form = document.actionForm;
        
        function save() {
            var a_fields = {
                <#list gradeTypes as gradeType>
                'percent${gradeType.id}':{'l':'${gradeType.name}', 'r':true, 't':'f_percent${gradeType.id}', 'f':'unsigned'}<#if gradeType_has_next>,</#if>
                </#list>
            };
            var v = new validator(form, a_fields, null);
            if (v.exec()) {
                if (<#list gradeTypes as gradeType>Number(form["percent${gradeType.id}"].value) > 100 <#if gradeType_has_next> || </#if></#list>) {
                    alert(autoLineFeed("所设成绩类型的百分比数值不能超过100％。"));
                    return
                }
                if (<#list gradeTypes as gradeType>Number(form["percent${gradeType.id}"].value)<#if gradeType_has_next> + </#if></#list> != 100) {
                    alert(autoLineFeed("所设成绩类型的百分比总和不等于100％，请检查。"));
                    return
                }
                if (confirm(autoLineFeed("所选择的任务中可能学生成绩了，确认要如此设置吗？"))) {
                    form.action = "collegeGrade.do?method=saveBatchPercent";
                    form.submit();
                }
            }
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>