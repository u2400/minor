<table width="100%">
    <tr class"infoTitle" valign="top" style="font-size:10pt;font-weight:bold">
        <td colspan="2" class="infoTitle"><img src="images/action/info.gif" align="top"/>&nbsp;查询条件</td>
    </tr>
    <tr style="font-size:0pt">
        <td colspan="2"><img src="images/action/keyline.gif" width="100%" height="2" align="top"/></td>
    </tr>
    <tr>
        <td width="40%">院系/部门：</td>
        <td>
            <@htm.i18nSelect datas=departmentList selected="" name="applyRoomInDepartment.department.id" style="width:100%">
                <option value="">...</option>
            </@>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="text-align:center"><button onclick="search()">提交</button></td>
    </tr>
</table>