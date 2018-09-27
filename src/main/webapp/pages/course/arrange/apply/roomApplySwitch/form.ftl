<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<body>
	<#assign labInfo><B><#if (roomOccupySwitch.id)?exists>教室借用开关修改<#else>教室借用开关添加</#if></B></#assign>
	<#include "/templates/back.ftl"/>
  	<table width="85%" align="center" class="formTable">
     	<form name="electParamsForm" action="roomApplySwitch.do?method=save&hold=true" method="post" onsubmit="return false;">
	   	 <input type="hidden" value="${(roomOccupySwitch.id)?if_exists}" name="roomOccupySwitch.id"/>
         <input type="hidden" value="${(roomOccupySwitch.calendar.id)?default(RequestParameters["roomOccupySwitch.calendar.id"]?if_exists)}" name="roomOccupySwitch.calendar.id"/>
	   	<tr class="darkColumn">
	     	<td align="center" colspan="4">教室借用开关设置</td>
	   	</tr>
	   <tr>
         <td class="title">&nbsp;开关是否开放<font color="red">*</font>：</td>
         <td><@htm.select2 hasAll=false name="roomOccupySwitch.isOpen" style="width:100px" selected=(roomOccupySwitch.isOpen?string("1","0"))?default("")/></td>
         <td class="title">院系：</td>
         <td><@htm.i18nSelect datas=departments selected=(roomOccupySwitch.department.id?string)?default("1") name="roomOccupySwitch.department.id" style="width:100px"></@></td>
       </tr>
       <tr>
	   	 <td class="darkColumn" colspan="4">&nbsp;借用时间<font color="red">*</font>：</td>
       </tr>
       	<tr>
	 		<td class="title" id="f_startAt"><font color="red">*</font>开始时间:</td>
	 		<td colspan="3">
	 			<input type="text" id="openDate" name="startDate" value="${(roomOccupySwitch.startDate?string("yyyy-MM-dd"))?default("")}" maxlength="10" onfocus="calendar();" style="width:100px;"/>
	 			<input type="text" name="startTime" value="${(roomOccupySwitch.startDate?string("HH:mm"))?default("00:00")}" maxlength="5" style="width:50px"/>&nbsp;<span style="font-size:12px">第一个输入框为日期"yyyy-MM-dd",第二个输入框为时间"HH:ss"</span>
	 		</td>
	 	</tr>
	 	<tr>
	 		<td class="title" id="f_endAt"><font color="red">*</font>结束时间:</td>
	 		<td colspan="3">
	 			<input type="text" id="openDate" name="endDate" value="${(roomOccupySwitch.finishDate?string("yyyy-MM-dd"))?default("")}" maxlength="10" onfocus="calendar();" style="width:100px;"/>
	 			<input type="text" name="endTime" value="${(roomOccupySwitch.finishDate?string("HH:mm"))?default("00:00")}" maxlength="5" style="width:50px"/>&nbsp;<span style="font-size:12px">第一个输入框为日期"yyyy-MM-dd",第二个输入框为时间"HH:ss"</span>
	 		</td>
	 	</tr>
       <tr>
         <td class="darkColumn" colspan="4">&nbsp;</td>
       </tr>
        <tr>
         <td class="title" width="25%" id="f_notice">&nbsp;<@bean.message key="attr.notice"/>：</td>
         <td colspan="3">
           <textarea name="roomOccupySwitch.notice" cols="45" rows="4">${(roomOccupySwitch.notice)?if_exists}</textarea>
         </td>
       </tr>
	   <tr class="darkColumn">
	     <td colspan="6" align="center" >
	       <input type="button" value="<@bean.message key="action.submit"/>" name="saveButton" onClick="save(this.form)" class="buttonStyle"/>&nbsp;
	       <input type="reset" name="resetButton" value="<@bean.message key="action.reset"/>" class="buttonStyle"/>
	     </td>
	   </tr>
	   <input type="hidden" name="params" value="${RequestParameters["params"]?if_exists}"/>
   </form>
  </table>
  <br><br><br><br><br><br><br><br>
   
  <script language="javascript" >
   function save(form){
     var errorInfo="";
     var a_fields = {
				'startDate':{'l':'开始时间的日期', 'r':true, 't':'f_startAt'},
				'startTime':{'l':'开始时间的时间', 'r':true, 't':'f_startAt', 'f':'shortTime'},
				'endDate':{'l':'结束时间的日期', 'r':true, 't':'f_endAt'},
				'endTime':{'l':'结束时间的时间', 'r':true, 't':'f_endAt', 'f':'shortTime'}
			};
			var v = new validator(form, a_fields, null);
			if (v.exec()) {
				if(form['startDate'].value + " " + form['startTime'].value >= form['endDate'].value + " " + form['endTime'].value){
                   alert("开始结束日期时间设定不正确");return;
                }
				form.submit();
			}
     
    
   }
   
   function editList(type){
       var listDiv= document.getElementById(type+'ListDiv');
       var div = document.getElementById(type+'sDiv');
       div.style.display="none";
       listDiv.style.display="block";
       var ids=document.electParamsForm[type+'Ids'].value;
       var select = document.getElementById(type+'ListSelect');
       
       for(var i=0;i<select.options.length;i++){
           if (select.options[i].value == "") {
           	continue;
           }
           select.options[i].selected = (ids.indexOf(select.options[i].value) != -1);
       }
   }
   
   function setList(type){
       var departListDiv= document.getElementById(type+'ListDiv');
       var departsDiv = document.getElementById(type+'sDiv');
       departsDiv.style.display="block";
       departListDiv.style.display="none";
       var ids=",";
       var names="";
       var select = document.getElementById(type+'ListSelect');
       for(var i=0;i<select.options.length;i++){
           if(select.options[i].selected){
	           ids +=select.options[i].value +",";
	           names += select.options[i].innerHTML+",";
	       }
       }
       if (ids != ",") {
           document.electParamsForm[type+'Ids'].value=ids;
           document.electParamsForm[type+'Names'].value=names.substr(0,names.lastIndexOf(","));
       }
   }
   function isDateBefore(first,second){
       var firstYear = first.substring(0,4);
       var secondYear = second.substring(0,4);
       if (firstYear > secondYear) {
       	return false;
       } else if (firstYear < secondYear) {
       	return true;
       }

       var firstMonth = new Number(first.substring(first.indexOf('-')+1,first.lastIndexOf('-')));
       var secondMonth = new Number(second.substring(second.indexOf('-')+1,second.lastIndexOf('-')));

       if (firstMonth > secondMonth) {
       	return false;
       } else if (firstMonth < secondMonth) {
       	return true;
       }
       
       var firstDay = new Number(first.substring(first.lastIndexOf('-')+1));
       var secondDay = new Number(second.substring(second.lastIndexOf('-')+1));
       return firstDay <= secondDay;
   }
  </script>
</body>
<#include "/templates/foot.ftl"/>