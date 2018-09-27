<#include "/templates/head.ftl"/>
<BODY> 
    <table id="classBar"></table>
    <#include "/pages/components/adminClassListTable.ftl"/>
    <@htm.actionForm name="actionForm" action="moralGradeInstructor.do" entity="adminClass">
      <input type="hidden"  name="calendarId" value="${RequestParameters['calendarId']!}"/>
      <input type="hidden" name="templateDocumentId" value="21"/>
      <input type="hidden" name="document.id" value="21"/>
      <input type="hidden" name="importTitle" value="德育成绩导入"/>
    </@>
	<script>
		var bar=new ToolBar("classBar","班级列表",null,true,true);
		bar.setMessage('<@getMessage/>');
		bar.addItem("查看","gradeInfo()");
   <#if inputSwitch.checkOpen()>
        bar.addItem("录入","inputGrade()");
        var menu1 = bar.addMenu("导入", "importData()");
        menu1.addItem("下载模板", "downloadTemplate()");
		bar.addItem("删除","removeGrade()");
    </#if>
		bar.addItem("打印","printGrade()");
		function inputGrade(){
		   document.actionForm.target="_blank";
		   singleAction("inputGrade");
		}
		function gradeInfo(){
		   document.actionForm.target="_blank";
		   multiAction("gradeInfo");
		}
		function printGrade(){
		   document.actionForm.target="_blank";
		   multiAction("gradeReport");
		}
		function removeGrade(){
		   document.actionForm.target="_self";
		   multiAction("removeReport");
		}
    function importData() {
		var form = document.actionForm;
	    form.action = "?method=importForm";
	    form.target = "_self";
	    form.submit();
    }
		function downloadTemplate(){
    	  self.location="dataTemplate.do?method=download&document.id=21";
        }
	</script>
</body>
<#include "/templates/foot.ftl"/> 
  