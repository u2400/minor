<table width="100%">
    <tr valign="bottom">
        <td class="infoTitle" style="font-size:10pt;text-align:left;font-weight:bold" colspan="2"><img src="images/action/info.gif" align="top"/>查询条件(模糊匹配)</td>
    </tr>
    <tr style="font-size:0pt">
        <td colspan="2"><img src="images/action/keyline.gif" width="100%" height="2" align="top"/></td>
    </tr>
    <tr>
        <td width="45%">学号：</td>
        <td><input type="text" name="student.code" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>姓名：</td>
        <td><input type="text" name="student.name" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>年级：</td>
        <td><input type="text" name="student.enrollYear" value="" maxlength="7" style="width:100%"/></td>
    </tr>
    <tr>
        <td>学制：</td>
        <td><input type="text" name="student.schoolingLength" value="" maxlength="2" style="width:100%"/></td>
    </tr>
    <tr> 
        <td><@bean.message key="entity.studentType"/>：</td>
        <td>
            <select id="stdTypeOfSpeciality" name="student.type.id" style="width:100%;">
                <option value="${RequestParameters['student.type.id']?if_exists}" selected><@bean.message key="filed.choose"/></option>
            </select>
        </td>
    </tr>
    <tr>
        <td><@bean.message key="common.college"/>：</td>
        <td>
            <select id="department" name="student.department.id" style="width:100%;">
                <option value="" selected><@bean.message key="filed.choose"/>...</option>
            </select>
        </td>
    </tr>
    <tr>
        <td><@bean.message key="entity.speciality"/>：</td>
        <td>
            <select id="speciality" name="student.firstMajor.id" style="width:100%;">
                <option value="" selected><@bean.message key="filed.choose"/>...</option>
            </select>
        </td>
    </tr>
    <tr>
        <td><@bean.message key="entity.specialityAspect"/>：</td>
        <td>
            <select id="specialityAspect" name="student.firstAspect.id" style="width:100%;">
                <option value="" selected><@bean.message key="filed.choose"/>...</option>
            </select>
        </td>
    </tr>
    <tr>
        <td>语种能力：</td>
        <td>
            <@htm.i18nSelect datas=(languageAbilities?sort_by("name"))?if_exists selected="" name="student.languageAbility.id" style="width:100%">
                <option value="" selected>...</option>
            </@>
        </td>
    </tr>
    <tr>
        <td>语种成绩：</td>
        <td><input type="text" name="student.scoreInLanguage" value="" maxlength="5" style="width:100%"/></td>
    </tr>
    <tr>
        <td>是否毕业：</td>
        <td>
            <select name="isGraduated" style="width:100%">
                <option value="" selected>...</option>
                <option value="1">是</option>
                <option value="0">否</option>
            </select>
        </td>
    </tr>
    <tr height="50">
        <td colspan="2" align="center"><button onclick="search()">查询</button></td>
    </tr>
</table>
<#assign stdTypeNullable = true/>
<#include "/templates/stdTypeDepart3Select.ftl"/>
