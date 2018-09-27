<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<@getMessage/>
     <@table.table width="100%" id="listTable" sortable="true">
       <@table.thead>
	     <td class="select"></td>
	     <@table.sortTd width="60%" text="名称" id="subject.name"/>
	     <@table.sortTd width="10%" text="字数限制" id="subject.maxContentLength"/>
	     <@table.sortTd width="10%" text="选项" id="subject.options" />
	     <@table.sortTd width="10%" text="是否必填" id="subject.required" />
	   </@>
	   <@table.tbody datas=subjects;subject>
	    <@table.selectTd type="radio" id='subjectId' value=subject.id/>
	    <td>${(subject.name)?if_exists}</td>
	    <td><#if (subject.maxContentLength>0)>${subject.maxContentLength}</#if></td>
	    <td>${subject.options!}</td>
	    <td>${subject.required?string("是","否")}</td>
	   </@>
     </@>
 </body>
<#include "/templates/foot.ftl"/>