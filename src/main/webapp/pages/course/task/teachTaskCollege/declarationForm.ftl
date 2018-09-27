<#include "/templates/head.ftl"/>
<body>
    <table id="bar"></table>
    <#list tasks?chunk(perPageRows) as teachTasks>
    <table style="table-layout:fixed;word-break:break-all" class="listTable">
        <@table.thead>
            <@table.td name="attr.teachDepart" width="60"/>
            <@table.td name="attr.courseNo" width="60"/>
            <@table.td name="course.titleName" width="90"/>
            <@table.td text="课程性质" width="70"/>
            <@table.td name="attr.credit" width="32"/>
            <@table.td text="上课年级" width="60"/>
            <@table.td name="attr.teach4Depart" width="95"/>
            <@table.td text="上课专业方向" width="100"/>
            <@table.td text="上课班级" width="95"/>
            <@table.td text="学生人数" width="32"/>
            <@table.td text="任课老师所在学院" width="60"/>
            <@table.td text="任课老师" width="60"/>
            <@table.td text="是否挂牌" width="32"/>
            <@table.td text="是否双语" width="32"/>
            <@table.td text="是否指定" width="32"/>
            <@table.td text="教室要求" width="60"/>
            <@table.td text="备注" width="70"/>
        </@>
        <#list teachTasks as task>
        <tr valign="top" style="text-align:justify;text-justify:inter-ideograph;<#if (task.arrangeInfo.teachers)?exists == false || (task.arrangeInfo.teachers)?size == 0>background-color:HotPink</#if>">
            <td><@i18nName (task.arrangeInfo.teachDepart)?if_exists/></td>
            <td align="center">${(task.course.code)?if_exists}</td>
            <td><@i18nName (task.course)?if_exists/></td>
            <td><@i18nName (task.courseType)?if_exists/></td>
            <td align="center">${(task.course.credits)?if_exists?string("0.#")}</td>
            <td align="center">${(task.teachClass.adminClassGrades)?if_exists}</td>
            <td>${(task.teachClass.adminClassDepartments)?if_exists}</td>
            <td>${(task.teachClass.adminClassAspects)?if_exists}</td>
            <td>${(task.teachClass.name)?if_exists}</td>
            <td align="center">${(task.teachClass.planStdCount)?default(0)}</td>
            <td>${(task.arrangeInfo.teacherDepartNames)?default(0)}</td>
            <td align="center">${(task.arrangeInfo.teacherNames)?default(0)}</td>
            <td align="center">${(task.requirement.isGuaPai?string("是", "否"))?if_exists}</td>
            <td align="center"><@i18nName (task.requirement.teachLangType)?if_exists/></td>
            <td align="center">${(task.teachClass.isStdNeedAssign?string("指定", "自由选课"))?if_exists}</td>
            <td><@i18nName (task.requirement.roomConfigType)?if_exists/></td>
            <td align="left"><#if (task.remark)?exists>${(task.remark?html)?if_exists + "<br>"}</#if>${(task.arrangeInfo.suggest.time.remark?html)?if_exists}</td>
        </tr>
        </#list>
    </table>
        <#if teachTasks_has_next><div style='PAGE-BREAK-AFTER: always'></div></#if>
    </#list>
    <table width="100%" style="line-height:4em">
        <tr>
            <td colspan="2">备注：学院签字盖章后有效</td>
        </tr>
        <tr>
            <td></td>
            <td width="30%">所在二级学院院长签名：</td>
        </tr>
        <tr>
            <td></td>
            <td>院（系）盖章</td>
        </tr>
        <tr>
            <td></td>
            <td>填表日期：<#list 1..5 as i>　</#list>年<#list 1..2 as i>　</#list>月<#list 1..2 as i>　</#list>日</td>
        </tr>
    </table>
    <form method="post" action="" name="actionForm">
      <#list RequestParameters?keys as key>
          <input type="hidden" name="${key}" value="${RequestParameters[key]}" />
      </#list>
    </form>
    <script>
        var bar = new ToolBar("bar", "教务任务申报表（每页&nbsp;${perPageRows}&nbsp;行）", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("设置每页行数", "declarationForm()");
        bar.addItem("导出","exportDeclarationForm()");
        bar.addPrint("<@msg.message key="action.print"/>");
        bar.addClose("<@msg.message key="action.close"/>");
        
        var form = document.actionForm;
        function declarationForm() {
            form.action = "teachTaskCollege.do?method=declarationForm";
            var perPageRows = prompt("请指定每页显示的行数，默认为10行。", "${perPageRows}");
            if (perPageRows == null || perPageRows == "" || !/^\d+$/.test(perPageRows) || perPageRows == 0) {
                if (!confirm("您设置的行数不正确，现将按默认行数（10行）设置。\n是否要继续？")) {
                    return;
                }
                perPageRows = 10;
            }
            addInput(form, "perPageRows", perPageRows, "hidden");
            form.target = "_self";
            form.submit();
        }
        function exportDeclarationForm() {
            form.action = "teachTaskCollege.do?method=exportDeclarationForm";
            addInput(form, "template", "taskDeclarationForm.xls", "hidden");
            addInput(form, "fileName", "taskDeclarationForm", "hidden");
            form.submit();
         }
    </script>
</body>
<#include "/templates/foot.ftl"/>