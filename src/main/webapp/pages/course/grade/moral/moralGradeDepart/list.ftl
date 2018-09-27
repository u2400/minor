<#include "/templates/head.ftl"/>
 <BODY LEFTMARGIN="0" TOPMARGIN="0" >
  <table id="gradeListBar" width="100%"> </table>
  <#include "../moralGrade/gradeListTable.ftl"/>
  <@htm.actionForm name="actionForm" action="moralGradeDepart.do" entity="moralGrade">
  	 <input type="hidden" name="keys" value="calendar.year,std.code,std.name,std.enrollYear,std.firstMajor.name,std.firstAspect.name,adminclassName,score,remark"/>
  	 <input type="hidden" name="titles" value="学年度,学号,姓名,年级,专业,专业方向,班级,德育成绩,备注"/>
  	 <input type="hidden" name="templateDocumentId" value="21"/>
     <input type="hidden" name="document.id" value="21"/>
     <input type="hidden" name="importTitle" value="德育成绩导入"/>
  </@>
  <script>
    var bar = new ToolBar("gradeListBar","成绩查询结果",null,true,true);
    bar.setMessage('<@getMessage/>');
    
    <#if inputSwitch.checkOpen()>
    bar.addItem("修改","edit()");
    bar.addItem("按班级录入","inputGrade()");
    var menu1 = bar.addMenu("导入", "importData()");
    menu1.addItem("下载模板", "downloadTemplate()");
    </#if>
    bar.addItem("<@msg.message key="action.export"/>", "exportList()");
    
    <#if inputSwitch.checkOpen()>
    function inputGrade(){
       window.open("moralGradeClass.do");
    }
    function publish(status){
       addInput(document.actionForm,"status",status);
       multiAction('updateStatus');
    }
    function downloadTemplate(){
    	self.location="dataTemplate.do?method=download&document.id=21";
    }
    function importData() {
		var form = document.actionForm;
	    form.action = "?method=importForm";
	    form.target = "gradeFrame";
	    form.submit();
    }
    </#if>
    function exportList() {
    	var form = document.actionForm;
    	form.action = "moralGradeDepart.do?method=export";
    	var moralGradeIds = getCheckBoxValue(document.getElementsByName("moralGrade.id"));
    	if (null != moralGradeIds && '' != moralGradeIds){
    		form.action = form.action + "&moralGradeIds=" + moralGradeIds;
    	}
		addHiddens(form, queryStr);
		form.submit();
	}
  </script>
 </body>
<#include "/templates/foot.ftl"/>
