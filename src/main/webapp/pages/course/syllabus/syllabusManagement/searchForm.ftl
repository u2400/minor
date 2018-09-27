<table width="100%">
    <tr>
        <td colspan="2" style="font-weight:bold"><img src="images/action/info.gif" align="top"/>&nbsp;查询条件（模糊匹配）</td>
    </tr>
    <tr style="font-size:0px">
        <td colspan="2"><img src="images/action/keyline.gif" width="100%" height="2"/></td>
    </tr>
    <tr>
        <td width="40%">课程代码：</td>
        <td><input type="text" name="course.code" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>课程名称：</td>
        <td><input type="text" name="course.name" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>绑定文件：</td>
        <td><input type="text" name="syllabus.name" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>是否绑定：</td>
        <td>
            <select name="isBinding" style="width:100%" onchange="searchControl(this)">
                <option value="" selected>...</option>
                <option value="1">是</option>
                <option value="0">否</option>
            </select>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="text-align:center"><button onclick="search()">查询</button></td>
    </tr>
</table>
