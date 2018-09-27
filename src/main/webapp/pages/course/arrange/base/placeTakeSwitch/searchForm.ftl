<table width="100%">
    <tr class="infoTitle">
        <td colspan="2" style="font-size:10pt;text-align:left;vetical-align:middle;font-weight:bold"><img src="images/action/info.gif" style="vertical-align:middle"/>查询条件（模糊查询）</td>
    </tr>
    <tr style="height:0px;font-size:0pt">
        <td colspan="2"><img src="images/action/keyline.gif" height="2" width="100%" align="top"/></td>
    </tr>
    <tr>
        <td width="40%">年级：</td>
        <td><input type="text" name="takeSwitch.multiGrades" value="" maxlength="100" style="width:100%"/></td>
    </tr>
    <tr>
        <td>学生类别：</td>
        <td>
            <select name="stdTypeId" style="width:100%">
                <option value="">...</option>
                <#list (stdTypes?sort_by("name"))?if_exists as stdType>
                <option value="${stdType.id}">${stdType.name}</option>
                </#list>
            </select>
        </td>
    </tr>
    <tr>
        <td>院系：</td>
        <td>
            <select name="departmentId" style="width:100%">
                <option value="">...</option>
                <#list (departments?sort_by("name"))?if_exists as department>
                <option value="${department.id}">${department.name}</option>
                </#list>
            </select>
        </td>
    </tr>
    <tr>
        <td>是否使用：</td>
        <td>
            <select name="takeSwitch.enabled" style="width:100%">
                <option value="">...</option>
                <option value="1">使用</option>
                <option value="0">禁用</option>
            </select>
        </td>
    </tr>
    <tr height="50px">
        <td colspan="2" style="text-align:center"><button onclick="search()">查询</button><span style="width:10px"></span><button onclick="this.form.reset()">重置</button></td>
    </tr>
</table>