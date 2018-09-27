<table width="100%">
    <tr valign="bottom">
        <td class="infoTitle" colspan="2" style="font-size:10pt;text-align:left;font-weight:bold"><image src="images/action/info.gif" align="top/">查询条件(模糊匹配)</td>
    </tr>
    <tr>
        <td colspan="2" style="font-size:0pt"><img src="images/action/keyline.gif" width="100%" height="2" align="top"/></td>
    </tr>
    <tr>
        <td width="45%">序号：</td>
        <td><input type="text" name="place.id" value="" maxlength="19" style="width:100%"/></td>
    </tr>
    <tr>
        <td>单位名称：</td>
        <td><input type="text" name="place.name" value="" maxlength="100" style="width:100%"/></td>
    </tr>
    <tr>
        <td>单位所在地：</td>
        <td><input type="text" name="place.addressInfo" value="" maxlength="250" style="width:100%"/></td>
    </tr>
    <tr>
        <td>单位类型：</td>
        <td>
            <select name="place.corporation.id" style="width:100%">
                <option value="" selected>...</option>
                <#list corporations as corporation>
                <option value="${corporation.id}">${corporation.name}</option>
                </#list>
            </select>
        </td>
    </tr>
    <tr>
        <td>是否校内：</td>
        <td>
            <select name="place.isInSchool" style="width:100%">
                <option value="" selected>...</option>
                <option value="1">校内</option>
                <option value="0">校外</option>
            </select>
        </td>
    </tr>
    <tr>
        <td>合作状态：</td>
        <td>
            <select name="place.status" style="width:100%">
                <option value="" selected>...</option>
                <option value="1">有效期内</option>
                <option value="2">无效期内</option>
                <option value="3">已过期</option>
            </select>
        </td>
    </tr>
    <tr>
        <td>联系人：</td>
        <td><input type="text" name="place.contactPerson" value="" maxlength="100" style="width:100%"/></td>
    </tr>
    <tr>
        <td>联系方式：</td>
        <td><input type="text" name="place.contactInfo" value="" maxlength="150" style="width:100%"/></td>
    </tr>
    <tr>
        <td>所属部门：</td>
        <td>
            <@htm.i18nSelect datas=departmentList selected="" name="place.department.id" style="width:100%">
                <option value="" selected>...</option>
            </@>
        </td>
    </tr>
    <tr>
        <td>接收人数：</td>
        <td><input type="text" name="place.planStdCount" value="" maxlength="150" style="width:100%"/></td>
    </tr>
    <tr>
        <td>是否确认：</td>
        <td>
            <select name="place.enabled" style="width:100%">
                <option value="" selected>...</option>
                <option value="1">是</option>
                <option value="0">否</option>
            </select>
        </td>
    </tr>
    <tr height="50px">
        <td colspan="2" style="text-align:center"><button onclick="search()">查询</button></td>
    </tr>
</table>