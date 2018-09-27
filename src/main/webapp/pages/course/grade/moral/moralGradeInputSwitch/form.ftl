<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/My97DatePicker/WdatePicker.js"></script>
<script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<BODY> 
    <table id="moralSwitchBar"></table>
    <form action="moralGradeInputSwitch.do?method=save" name="settingForm" method="post"
     onsubmit="return false;">
      <input type="hidden" name="moralGradeInputSwitch.id" value="${(moralGradeInputSwitch.id)?if_exists}">
    <table width="90%" align="center" class="formTable">
     <tr class="darkColumn">
	    <td align="center" colspan="4">综合测评设置</td>
	 </tr>
	 <tr>
      <td class="title" id="f_calendar"><font color="red">*</font>学年度:</td>
      <td class="content">
         <select name="moralGradeInputSwitch.calendar.id" style="width:200px">
           <#list calendars as c>
           <option value="${c.id}" <#if c.id=moralGradeInputSwitch.calendar.id>selected="selected"</#if>>${c.year}</option>
           </#list>
         </select>
      </td>
       <td class="title" id="f_opened"><font color="red">*</font>是否开放:</td>
      <td class="content">
         <input id="moralGradeInputSwitch_open" type="radio" name="moralGradeInputSwitch.opened" value="1" <#if moralGradeInputSwitch.opened>checked="checked"</#if>>
          <label for="moralGradeInputSwitch_open">开放</label>
         <input id="moralGradeInputSwitch_close" type="radio" name="moralGradeInputSwitch.opened" value="0" <#if !moralGradeInputSwitch.opened>checked="checked"</#if>>
          <label for="moralGradeInputSwitch_close">关闭</label>
      </td>
     </tr>
     <tr>
      <td class="title" id="f_beginOn"><font color="red">*</font>起始日期:</td>
      <td class="content">
         <input type="text" name="moralGradeInputSwitch.beginOn" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'});" 
           value="${(moralGradeInputSwitch.beginOn?string('yyyy-MM-dd'))?if_exists}"/>
      </td>
      <td id="f_endOn" class="title"><font color="red">*</font>截至日期(不包含):</td>
      <td class="content">
          <input type="text" name="moralGradeInputSwitch.endOn" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'});" 
           value="${(moralGradeInputSwitch.endOn?string('yyyy-MM-dd'))?if_exists}"/>
      </td>
     </tr>
     <tr align="center" class="darkColumn">
      <td colspan="5">
          <button onclick="save(this.form)" class="buttonStyle">提交</button>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <button onclick="this.form.reset()" class="buttonStyle">重置</button>
      </td>
     </tr>
  </table>
   <input type="hidden" name="params" value="${RequestParameters["params"]}"/>
  </form> 
  <div style="height:200px"></div>
  <script language="javascript">
    function save(form){
	         var a_fields = {
	         'moralGradeInputSwitch.beginOn':{'l':'起始日期', 'r':true, 't':'f_beginOn','mx':'32'},
	         'moralGradeInputSwitch.endOn':{'l':'截至日期', 'r':true, 't':'f_endOn','mx':'40'}
	     };
	     var v = new validator(form , a_fields, null);
	     if (v.exec()) {
	        form.action="moralGradeInputSwitch.do?method=save"
	        form.target = "_self";
	        form.submit();
	     }
     }
 </script>
</body>
<#include "/templates/foot.ftl"/> 