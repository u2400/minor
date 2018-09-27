<#include "/templates/head.ftl"/>
<BODY> 
    <table id="classBar"></table>
    <#include "/pages/components/adminClassListTable.ftl"/>
    <@htm.actionForm name="actionForm" action="moralGradeClass.do" entity="adminClass">
      <input type="hidden"  name="calendar.id" value="${RequestParameters['calendar.id']}"/>
    </@>
	<script>
		var bar=new ToolBar("classBar","班级列表",null,true,true);
		bar.setMessage('<@getMessage/>');
		bar.addItem("查看","gradeInfo()");
		<#if inputSwitch.checkOpen()>bar.addItem("录入","inputGrade()");</#if>
		bar.addItem("打印","printGrade()");
		<#if inputSwitch.checkOpen()>bar.addItem("删除","removeGrade()");</#if>
		function gradeInfo(){
		   document.actionForm.target="_blank";
		   multiAction("gradeInfo");
		}
		function printGrade(){
		   document.actionForm.target="_blank";
		   multiAction("gradeReport");
		}
		<#if inputSwitch.checkOpen()>
		function inputGrade(){
		   document.actionForm.target="_blank";
		   singleAction("inputGrade");
		}
		function removeGrade(){
		   if(confirm("确认删除班级的德育成绩?")){
		     document.actionForm.target="_self";
		     multiAction("removeReport");
		   }
		}
		</#if>
	</script>
</body>
<#include "/templates/foot.ftl"/> 
  