<#include "/templates/head.ftl"/>
 <body>
 <table id="myBar"></table>
 <#function switchStateInfo courseArrangeSwitch>
    <#local addressState = (courseArrangeSwitch.isArrangeAddress)?default(false)>
    <#local publishedState = (courseArrangeSwitch.isPublished)?default(false)>
    <#if addressState && publishedState>
        <#return "已发布"/>
    <#elseif !addressState && publishedState>
        <#return "已发布，但不显示上课地点"/>
    <#elseif addressState && !publishedState>
        <#return "显示上课地点，但未发布"/>
    <#else>
        <#return "未发布"/>
    </#if>
 </#function>
 <@table.table width="100%" sortable="true" id="sortTable">
   <@table.thead>
          <@table.selectAllTd id="courseArrangeSwitchId"/>
           <@table.sortTd width="30%" text="学生类别" id="courseArrangeSwitch.calendar.studentType.name"/>
           <@table.sortTd text="学年" id="courseArrangeSwitch.calendar.year"/>
           <@table.sortTd text="学期" id="courseArrangeSwitch.calendar.term"/>
 	      <td width="30%">发布状态</td>
   </@>
   <@table.tbody datas=courseArrangeSwitchList;courseArrangeSwitch>
      <@table.selectTd id="courseArrangeSwitchId" value=courseArrangeSwitch.id/>
      <td>${(courseArrangeSwitch.calendar.studentType.name)?if_exists}</td>
      <td>${(courseArrangeSwitch.calendar.year)?if_exists}</td>
	  <td>${(courseArrangeSwitch.calendar.term)?if_exists}</td>
	  <td>${switchStateInfo(courseArrangeSwitch)}</td>
   </@>
 </@>
  <@htm.actionForm name="actionForm" action="courseArrangeSwitch.do" entity="courseArrangeSwitch">
     <input type="hidden" name="switchId" value=""/>
     <input type="hidden"  name ="params" value="&courseArrangeSwitch.isPublished=${(isOpen)?if_exists}"/>
  </@>
 <script>
   var bar = new ToolBar('myBar','&nbsp;排课发布信息',null,true,true);
   var form =document.actionForm;
   bar.setMessage('<@getMessage/>');
   bar.addItem("详细设置","edit()");
   bar.addItem("<#if "true"==isOpen>关闭<#else>开放</#if>","openedOrClosed()");
   
    function initData() {
        form["switchId"].value = "";
    }
   
   function openedOrClosed() {
			form.action = "courseArrangeSwitch.do?method=openedOrClosed";
			submitId(form, "courseArrangeSwitchId", true);
	}
 </script>

 </body>
 <#include "/templates/foot.ftl"/>