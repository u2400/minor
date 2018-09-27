<#include "/templates/head.ftl"/>
<body>
	<table id="stdSubstituteCourseBar"></table>
	<#if (stdTypeList?first.id)?exists>
	<table class="frameTable" width="100%">
	   	<tr>
	   		<td width="20%" class="frameTable_view"><#include "courseSearchForm.ftl"/></td>
	    	<td valign="top">
	 			<iframe src="#" id="stdSubstituteCourseFrame" name="stdSubstituteCourseFrame" marginwidth="0" marginheight="0" scrolling="no" frameborder="0"  height="100%" width="100%"></iframe>
    		</td>
   		</tr>
  	</table>
  	<form name="stdSubstituteCourseForm" method="post" action="" onsubmit="return false;">
	
  	</form>
	<script>
	  	var bar=new ToolBar("stdSubstituteCourseBar","个人替代课程管理",null,true,true);
	  	bar.setMessage('<@getMessage />');
        bar.addHelp();
        
        function searchSubstituteCourse() {
	    	var form = document.stdSubstituteCourseForm;
	    	form.target = "stdSubstituteCourseFrame";
	    	form.action = "stdSubstituteCourse.do?method=search";
	    	form.submit();
	    }
	    searchSubstituteCourse();
	</script>
     <#else>
   <center><h1><font color="red">请先配置“<a href="studentType.do" target="studentType_window">学生类别</a>”。</font></h1></center>
   <script>
    var bar=new ToolBar("stdSubstituteCourseBar","个人替代课程管理",null,true,true);
    bar.addBlankItem();
   </script>
   </#if>
</body>
<#include "/templates/foot.ftl"/>