<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="taskListBar" width="100%"> </table>
<script>
   var bar = new ToolBar("taskListBar","问卷评教",null,true,true);
   bar.setMessage('<@getMessage/>');
   bar.addHelp("<@msg.message key="action.help"/>");
</script>
   <table class="frameTable_title" width="100%" border="0">
    <form name="calendarForm" action="" method="post">
	     <tr style="font-size: 10pt;" align="left">
	     <td>&nbsp;</td>
    <td class="infoTitle" align="right" style="width:80px;"><@bean.message key="attr.year2year"/></td>
   <td style="width:100px;">
     <select id="year" name="calendarYear" style="width:100px;">
     <#assign year=''>
     <#if calendars??>
	     <#list calendars as calendar>
	    	 <#if calendar_index =0>
	    	 <#assign year=calendar>
	    	 </#if>
	        <option value="${(calendar)!}">${(calendar)!}</option>
	     </#list>
     </#if>
      </select>
    </td>
    <td class="infoTitle" align="right" style="width:50px;"><@bean.message key="attr.term"/></td>
    <td style="width:60px;">
     <select id="term" name="calendarTerm" style="width:60px;">
        <option value="1">1</option>
        <option value="2">2</option>
      </select>
   </td>
  <td  style="width:80px" >
				<button style="width:80px" id="button1" onClick="query(this.form);"> 查询</button>
			</td>
	    </tr>
	</form>
    </table>
    <table width="100%" height="100%" class="frameTable">
       <tr><td valign="top">
	     <iframe  src="evaluateTeach.do?method=search&calendarYear=${year}&calendarTerm=1"
	     id="examTableFrame" name="examTableFrame" scrolling="no"
	     marginwidth="0" marginheight="0" frameborder="0"  height="100%" width="100%">
	     </iframe>
        </td>
     </tr>
    </table>
</body>
<script>
  function query(form){
  			var form = document.calendarForm;
			form.action="evaluateTeach.do?method=search";
			form.target = "examTableFrame";
			form.submit();
		}
   </script>
<#include "/templates/foot.ftl"/>