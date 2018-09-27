   <td class="infoTitle" align="right" style="width:80px;"><@bean.message key="attr.year2year"/></td>
   <td style="width:150px;">
     <select id="calendar.id" name="calendar.id" style="width:150px;" onchange="changeCalendar(this.form);">
     	<#list calendars as c>
        	<option value="${c.id}" <#if c.id==calendar.id> selected="selected" </#if>>${c.year}</option>
        </#list>
      </select>
    </td>
   <td style="width:80px" >
    <button style="width:80px" id="calendarSwitchButton" onclick="javascript:changeCalendar(this.form);"class="buttonStyle">
      	 切换
    </button>
   </td>
   <script>
      var calendarAction=document.getElementById('calendarSwitchButton').form.action;
      function changeCalendar(form){
	      form.action=calendarAction;
	      form.target="";
	      form.submit();
      }
   </script>
