
   <td class="infoTitle" align="right" style="width:80px;"><@bean.message key="attr.year2year"/> 批次</td>
   <td style="width:200px;">
     <select id="setting" name="setting.id" style="width:200px;" onchange="changeCalendar(this.form)">
     	<#list settings as setting>
        	<option value="${setting.id}" <#if setting.id?string==RequestParameters['setting.id']?default('')> selected="selected" </#if>>${setting.toSemester.year} ${setting.name}</option>
        </#list>
      </select>
    </td>
   <td style="width:80px" >
    <button style="width:80px" id="calendarSwitchButton" accessKey="W" onclick="javascript:changeCalendar(this.form);"class="buttonStyle">
      	 切换
    </button>
   </td>
   <script>
      var calendarAction=document.getElementById('calendarSwitchButton').form.action;
      function changeCalendar(form){
	      var errorInfo="";
	      if(errorInfo!="") {alert(errorInfo);return;}
	      form.action=calendarAction;
	      form.target="";
	      form.submit();
      }
   </script>
