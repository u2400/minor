<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="myBar" width="100%"></table>
      <table width="90%" align="center" class="formTable">
       <tr class="darkColumn">
	    <td align="center" colspan="4">${apply.award.name} 助学金申请</td>
	   </tr>
	   <tr>
	      <td class="title">综合测评结果：</td>
	      <td class="content">
	             <#if apply.gradeAchivement??>
	             <#if apply.gradeAchivement.confirmed>
	               ${apply.gradeAchivement.score} 徳育成绩班级: 第${apply.moralGradeClassRank}名
	             <#else>
	                 综合测评结果尚未公布,不影响助学金申请
	             </#if>
	             <#else>找不到德育成绩</#if>
	      </td>
	   </tr>
	   <#if apply.attachment??>
	   <tr>
	      <td class="title">附件：</td>
	      <td class="content"><a href="?method=attachment&apply.id=${apply.id}">${apply.attachmentDisplayName}</a></td>
	   </tr>
	   </#if>
	   <#list apply.award.subjects as subject>
	   <tr>
	     <td width="20%" class="title">${subject.name}:</td>
	     <td width="80%" class="content"><pre>${apply.getStatement(subject)!}</pre></td>
	   </tr>
	   </#list>
	   <#if apply.approved??>
	   <tr>
	     <td class="title">学校评审意见:</td>
	     <td class="content">${apply.schoolOpinion!}</td>
	   </tr>
	   </#if>
   </table>
<script>
    var bar = new ToolBar("myBar", "助学金申请明细", null, true, true);
    bar.setMessage('<@getMessage/>');
    bar.addBack();
</script>
</body>
<#include "/templates/foot.ftl"/>
