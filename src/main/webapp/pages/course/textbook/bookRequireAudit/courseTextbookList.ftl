<#include "/templates/head.ftl"/>
<BODY>
<script language="JavaScript" type="text/JavaScript" src="scripts/system/BaseInfo.js"></script>
  <@getMessage/>
  <@table.table id="listTable" width="100%" sortable="true">
    <@table.thead>
    	<@table.td text=""/>
        <@table.sortTd width="15%" name="attr.code" id="course.code"/>
        <@table.sortTd width="30%" name="attr.infoname" id="course.name"/>
        <@table.sortTd name="common.grade" id="course.credits"/>
        <@table.sortTd name="common.courseLength" id="course.extInfo.period"/>
        <@table.td width="40%" text="教材" />
     </@>
     <@table.tbody datas=courses;course>
        <@table.selectTd id="courseId" value="${course.id}" type="radio"/>
        <td>${course.code}</td>
        <td><a href="course.do?method=info&type=course&id=${course.id}">${course.name}</a></td>
        <td>${course.credits?if_exists}</td>
        <td>${(course.extInfo.period)?if_exists}</td>
        <td><#list course.textbooks as textbook>${textbook.name}&nbsp;</#list></td>
     </@>
   </@>
</body>
<#include "/templates/foot.ftl"/>