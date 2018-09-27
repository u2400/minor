<table width="100%">
    <tr>
        <td colspan="2" style="font-weight:bold"><img src="images/action/info.gif" align="top"/>&nbsp;查询条件（模糊匹配）</td>
    </tr>
    <tr style="font-size:0px">
        <td colspan="2"><img src="images/action/keyline.gif" width="100%" height="2"/></td>
    </tr>
    <tr>
        <td width="40%">学号：</td>
        <td><input type="text" name="result.student.code" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>姓名：</td>
        <td><input type="text" name="result.student.name" value="" maxlength="50" style="width:100%"/></td>
    </tr>
    <tr>
        <td>所在班级：</td>
        <td><input type="text" name="adminclassName" value="" maxlength="50" style="width:100%"/></td>
    </tr>
    <tr>
        <td>学生类别:</td>
        <td>
            <select id="stdType" name="result.calendar.studentType.id" style="width:100%;">
                <option value="">...</option>
            </select>
        </td>
    </tr>
    <tr>
        <td>学年度:</td>
        <td>
            <select id="year" name="result.calendar.year" style="width:100%;">
                <option value="">...</option>
            </select>
        </td>
    </tr>
    <tr>
        <td>学期:</td>
        <td>
            <select id="term" name="result.calendar.term" style="width:100%;">
                <option value="">...</option>
            </select>
        </td>
    </tr>
    <tr>
        <td>政治面貌：</td>
        <td>
            <select name="result.student.basicInfo.politicVisage.id" style="width:100%">
                <option value="" selected>...</option>
                <#list politicVisages as politicVisage>
                <option value="${politicVisage.id}">${politicVisage.name}</option>
                </#list>
            </select>
        </td>
    </tr>
    <tr>
        <td>所在学院：</td>
        <td>
            <select name="result.student.department.id" style="width:100%">
                <option value="" selected>...</option>
                <#list departmentList as department>
                <option value="${department.id}">${department.name}</option>
                </#list>
            </select>
        </td>
    </tr>
    <tr>
        <td>专业：</td>
        <td>
            <select name="result.student.speciality.id" style="width:100%">
                <option value="" selected>...</option>
                <#list specialitis as speciality>
                <option value="${speciality.id}">${speciality.name}</option>
                </#list>
            </select>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="text-align:center"><button onclick="search()">查询</button></td>
    </tr>
</table>
<#assign stdTypeNullable = true/>
<#assign yearNullable = true/>
<#assign termNullable = true/>
<#assign stdTypeDefaultFirst = false/>
<#include "/templates/calendarSelect.ftl"/>
