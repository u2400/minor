<#include "/templates/head.ftl"/>
<#include "../status.ftl"/>
<body >
 <table id="bursaryApplyListBar"></table>
  <@table.table  width="100%" id="listTable" sortable="true">
    <@table.thead>
      	<@table.sortTd width="10%" text="学年度" id="apply.setting.toSemester.year"/>
        <@table.sortTd width="40%" text="申请奖项" id="apply.award.name"/>
        <@table.sortTd width="10%" text="状态" id="bursaryApply.peScore"/>
        <@table.sortTd width="20%" text="申请时间" id="bursaryApply.moralScore"/>
        <@table.td width="20%" text="详情操作" />
    </@>
    <@table.tbody datas=bursaryApplies;apply>
      	<td>${(apply.setting.toSemester.year)!}</td>
      	<td>${(apply.award.name)!}</td>
      	<td><@status apply/></td>
      	<td>${(apply.applyAt?string("yyyy-MM-dd HH:mm"))!}</td>
      	<td>
      	  <#if apply.submited>
      	    <#if !(apply.instructorApproved??) && !(apply.collegeApproved??) && !(apply.approved??)>
      	    <a href="bursaryApply.do?method=cancel&apply.id=${apply.id}">撤销</a>&nbsp;&nbsp;
      	    <a href="bursaryApply.do?method=uploadForm&apply.id=${apply.id}">上传附件</a>&nbsp;&nbsp;
      	    </#if>
      	  <#else>
      	   <a href="bursaryApply.do?method=edit&apply.id=${apply.id}">修改</a>&nbsp;&nbsp;
      	   <a href="bursaryApply.do?method=remove&apply.id=${apply.id}">删除</a>&nbsp;&nbsp;
      	  </#if>
      	  <a href="bursaryApply.do?method=info&apply.id=${apply.id}">详情</a>
      	</td>
    </@>
  </@>
  <script>
  	var bar=new ToolBar("bursaryApplyListBar","助学金申请",null,true,true);
    bar.setMessage('<@getMessage/>');
    <#if settings?size!=0>
    bar.addItem("现在申请","apply()");
    function apply(){
      self.location="bursaryApply.do?method=applyForm&apply.setting.id=${settings?first.id}";
    }
    </#if>
    bar.addBack();
  </script>
  <#if bursaryApplies?size==0>
  <p>尚无助学金申请记录</p>
  </#if>
</body> 
<#include "/templates/foot.ftl"/> 