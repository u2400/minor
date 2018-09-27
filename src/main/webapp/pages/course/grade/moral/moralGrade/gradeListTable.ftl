<@table.table width="100%" sortable="true" id="listTable">
   <@table.thead>
     <@table.selectAllTd width="5%" id="moralGradeId"/>
     <@table.sortTd width="13%" name="attr.stdNo" id="moralGrade.std.code"/>
     <@table.sortTd width="12%" name="attr.personName" id="moralGrade.std.name"/>
     <@table.sortTd width="7%"  text="性别" id="moralGrade.std.basicInfo.gender.name"/>
     <@table.sortTd width="7%"  text="年级" id="moralGrade.std.enrollYear"/>
     <@table.sortTd width="17%" text="院系" id="moralGrade.std.department.name"/>
     <@table.td width="20%"     text="班级"/>
     <@table.sortTd width="8%"  text="成绩" id="moralGrade.score"/>
     <@table.sortTd width="9%"  text="状态" id="moralGrade.status"/>
   </@>
   <@table.tbody datas=moralGrades;grade>
    <@table.selectTd  type="checkbox" id="moralGradeId" value="${grade.id}"/>
    <td><A href="studentDetailByManager.do?method=detail&stdId=${grade.std.id}" target="blank" >${grade.std.code}</A></td>
    <td><A href="#" onclick="gradeInfo('${grade.id}');" title="查看成绩详情">${grade.std.name}</a></td>
    <td>${(grade.std.basicInfo.gender.name)!}</td>
    <td>${(grade.std.enrollYear)!}</td>
    <td>${(grade.std.department.name)!}</td>
    <td>${(grade.std.firstMajorClass.name)?default('')}</td>
    <td><#if grade.isPass>${(grade.score?string("#.##"))?if_exists}<#else><font color="red">${(grade.score?string("#.##"))?if_exists}</font></#if></td>
    <td><#if grade.isPublished>已发布<#elseif grade.isConfirmed>录入确认<#else>新增</#if></td>
   </@>
 </@>