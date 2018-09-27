<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/My97DatePicker/WdatePicker.js"></script>
<script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<BODY> 
    <table id="settingBar"></table>
    <form action="bursarySetting.do?method=save" name="settingForm" method="post"  onsubmit="return false;">
      <input type="hidden" name="setting.id" value="${(setting.id)?if_exists}">
    <table width="90%" align="center" class="formTable">
     <tr class="darkColumn">
	    <td align="center" colspan="4">助学金申请设置</td>
	 </tr>
	 <tr>
      <td class="title" id="f_name"><font color="red">*</font>名称:</td>
      <td class="content"><input type="text" name="setting.name" value="${(setting.name)?if_exists}" maxLength="30" style="width:200px"/></td>
      <td class="title" id="f_calendar"><font color="red">*</font>学年度:</td>
      <td class="content">
         <select name="setting.toSemester.id"  style="width:200px">
           <#list calendars as c>
           <option value="${c.id}" <#if c.id=(setting.toSemester.id)!0>selected="selected"</#if>>${c.year}</option>
           </#list>
         </select>
      </td>
     </tr>
       <tr>
	   	 <td class="title" width="25%" id="f_beginAt">&nbsp;<font color="red">*</font>申请开始时间：</td>
	     <td>
	     	<input type="text" maxlength="19" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'setting.endAt\')}'})"  id="setting.beginAt" name="setting.beginAt" value="${(setting.beginAt?string("yyyy-MM-dd HH:mm:ss"))?if_exists}"/>
	     </td>
	   	 <td class="title" width="25%" id="f_endAt">&nbsp;<font color="red">*</font>申请结束时间：</td>
	     <td>
	     	<input type="text" maxlength="19" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'setting.beginAt\')}'})"  name="setting.endAt" id="setting.endAt" value="${(setting.endAt?string("yyyy-MM-dd HH:mm:ss"))?if_exists}"/>
	     </td>
       </tr>
   <tr>
    <td class="title" id="f_awards"><font color="red">*</font>开放申请的奖项:</td>
    <td colspan="3">
     <table>
      <tr>
       <td>
        <select name="awards" MULTIPLE size="10" style="width:200px" onDblClick="JavaScript:moveSelectedOption(this.form['awards'], this.form['selectedAwards'])" >
         <#list awards?sort_by('name') as award>
          <option value="${award.id}">${award.name}</option>
         </#list>
        </select>
       </td>
       <td  valign="middle">
        <br><br>
        <input OnClick="JavaScript:moveSelectedOption(this.form['awards'], this.form['selectedAwards'])" type="button" value="&gt;"> 
        <br><br>
        <input OnClick="JavaScript:moveSelectedOption(this.form['selectedAwards'], this.form['awards'])" type="button" value="&lt;"> 
        <br>
       </td> 
       <td  class="normalTextStyle">
        <select name='selectedAwards' MULTIPLE size="10" style="width:200px;" onDblClick="JavaScript:moveSelectedOption(this.form['selectedAwards'], this.form['awards'])">
         <#list setting.awards?sort_by('name') as award>
          <option value="${award.id}">${award.name}</option>
         </#list>
        </select>
       </td>             
      </tr>
     </table>
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
  </form> 
  <script language="javascript">
    function save(form){
	         var a_fields = {
	         'setting.name':{'l':'名称', 'r':true, 't':'f_name','mx':'32'},
	         'setting.toSemester.id':{'l':'学年度', 'r':true, 't':'f_calendar'},
	         'setting.beginAt':{'l':'申请开始时间', 'r':true, 't':'f_beginAt'},
	         'setting.endAt':{'l':'申请结束时间', 'r':true, 't':'f_endAt'}
	     };
	     var v = new validator(form , a_fields, null);
	     if (v.exec()) {
	        form.action="bursarySetting.do?method=save"
	        selectAll(form['selectedAwards'])
	        form.target = "_self";
	        form.submit();
	     }
     }
     function selectAll(o){
       for(i=0;i<o.options.length;i++)
         o.options[i].selected=true
     }
 </script>
</body>
<#include "/templates/foot.ftl"/>