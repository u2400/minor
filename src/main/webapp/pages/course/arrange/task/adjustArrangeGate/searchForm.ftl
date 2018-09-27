<table width="100%">
    <tr>
        <td align="left" colspan="2" style="font-weight:bold;vertical-align:bottom"><img src="images/action/info.gif" align="top"/>查询条件(模糊匹配)</td>
    </tr>
    <tr>
        <td colspan="2" style="font-size:0px"><img src="images/action/keyline.gif" height="2" width="100%" align="top"/></td>
    </tr>
    <tr>
        <td width="40%">课程序号：</td>
        <td><input type="text" name="adjust.task.seqNo" value="" maxlength="10" style="width:100%"/></td>
    </tr>
    <tr>
        <td>课程代码：</td>
        <td><input type="text" name="adjust.task.course.code" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>课程名称：</td>
        <td><input type="text" name="adjust.task.course.code" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>开课院系：</td>
        <td>
            <@htm.i18nSelect datas=departmentList?sort_by("name") selected="" name="adjust.task.arrangeInfo.teachDepart.id" value="" style="width:100%">
                <option value="">...</option>
            </@>
        </td>
    </tr>
    <tr>
        <td>教师工号：</td>
        <td><input type="text" name="adjust.teacher.code" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>教师姓名：</td>
        <td><input type="text" name="adjust.teacher.name" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>调停状态：</td>
        <td>
            <select name="adjust.status" style="width:100%">
                <option value="">...</option>
                <option value="1">调课</option>
                <option value="2">停课</option>
            </select>
        </td>
    </tr>
    <tr>
        <td>审批状态：</td>
        <td>
            <select name="adjust.isPassed" style="width:100%">
                <option value="">...</option>
                <option value="null" selected>未审核</option>
                <option value="0">未过</option>
                <option value="1">通过</option>
                <option value="final">已终审</option>
            </select>
        </td>
    </tr>
    <tr height="50px">
        <td colspan="2" style="text-align:center"><button onclick="search()">查询</button></td>
    </tr>
</table>