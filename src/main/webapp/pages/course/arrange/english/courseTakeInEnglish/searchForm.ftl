<table width="100%">
    <tr style="font-size:10pt;font-weight:bold">
        <td class="infoTitle" align="left" valign="bottom" colspan="2"><img src="images/action/info.gif" align="top"/>&nbsp;查询条件(模糊匹配)</td>
    </tr>
    <tr>
        <td style="font-size:0pt" colspan="2"><img src="images/action/keyline.gif" height="2" width="100%" align="top"/></td>
    </tr>
    <tr>
        <td width="40%">学号：</td>
        <td><input type="text" name="student.code" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>姓名：</td>
        <td><input type="text" name="student.name" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>年份：</td>
        <td><input type="text" name="student.enrollYear" value="" maxlength="7" style="width:100%"/></td>
    </tr>
    <tr>
        <td>所在院系：</td>
        <td><@htm.i18nSelect datas=departmentList selected="" name="student.department.id" style="width:100%"><option value="">...</option></@></td>
    </tr>
    <tr>
        <td>学生类别：</td>
        <td><@htm.i18nSelect datas=stdTypeList selected="" name="student.type.id" style="width:100%"><option value="">...</option></@></td>
    </tr>
    <tr>
        <td>语种能力：</td>
        <td><@htm.i18nSelect datas=languageAbilitys?sort_by("name") selected="" name="student.languageAbility.id" style="width:100%"><option value="">...</option></@></td>
    </tr>
    <tr>
        <td>课程类别：</td>
        <td><input name="courseTake.task.courseType.name" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>课程序号：</td>
        <td><input name="courseTake.task.seqNo" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>课程代码：</td>
        <td><input name="courseTake.task.course.code" value="" maxlength="10" style="width:100%"/></td>
    </tr>
    <tr>
        <td>课程名称：</td>
        <td><input name="courseTake.task.course.name" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>行政班：</td>
        <td><input name="adminClassName" value="" maxlength="30" style="width:100%"/></td>
    </tr>
    <tr>
        <td>修读类别：</td>
        <td><@htm.i18nSelect datas=courseTakeTypes selected="" name="courseTake.courseTakeType.id" style="width:100%"><option value="">...</option></@></td>
    </tr>
    <tr>
        <td>语种要求：</td>
        <td><@htm.i18nSelect datas=languageAbilitys?sort_by("name") selected="" name="languageAbilityId" style="width:100%"><option value="">...</option></@></td>
    </tr>
    <tr height="50px">
        <td colspan="2" align="center"><button onclick="search()">查询</button></td>
    </tr>
</table>