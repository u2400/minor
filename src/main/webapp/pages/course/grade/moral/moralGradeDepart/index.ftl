<#include "/templates/head.ftl"/>
 <body >  
 <table id="gradeBar"></table>
 <table  class="frameTable_title">
    <tr>
        <td style="width:50px"><font color="blue"><@bean.message key="action.advancedQuery"/></font></td>
        <td>|</td>
       <form name="calendarForm" target="classListFrame" method="post" action="moralGradeDepart.do?method=index" onsubmit="return false;">
        <#include "../calendar.ftl" />
       </form>
    </tr>
</table>
<table width="100%" border="0" height="100%" class="frameTable">
  <tr >
   <td style="width:20%" valign="top" class="frameTable_view">   
         <form name="stdSearch" method="post" action="" onsubmit="return false;">
           <input type="hidden" name="moralGrade.calendar.id" value="${calendar.id}"/>
           <input type="hidden" name="calendar.id" value="${calendar.id}"/>
		   <#include "searchForm.ftl"/>
		 </form>
     </td>
     <td valign="top">
	     <iframe  src="#" id="gradeFrame" name="gradeFrame" 
	      marginwidth="0" marginheight="0"
	      scrolling="no" 	 frameborder="0"  height="100%" width="100%">
	     </iframe>
     </td>
    </tr>
  <table>
<script>
    function search(pageNo,pageSize,orderBy){
       var form = document.stdSearch;
       if(form['moralGrade.std.code'].value!=""&&null==orderBy){
          orderBy="moralGrade.calendar.start desc";
       }
	   form.action = "moralGradeDepart.do?method=search";
	   form.target="gradeFrame";
       goToPage(form,pageNo,pageSize,orderBy);
    }
    var bar=new ToolBar("gradeBar","德育成绩院系管理",null,true,true);
    bar.addHelp("<@msg.message key="action.help"/>");
    search();
</script> 
 </body>   
<#include "/templates/foot.ftl"/> 