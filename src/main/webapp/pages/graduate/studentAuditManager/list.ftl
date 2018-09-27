<#include "/templates/head.ftl"/>
<body>
    <table id="bar"></table>
     <@table.table width="100%" sortable="true" id="sortTable">
        <@table.thead>
            <@table.selectAllTd id="stdId"/>
            <@table.sortTd id="std.code" name="attr.stdNo" width="10%"/>
            <@table.sortTd id="std.name" name="attr.personName" width="14%"/>
            <@table.sortTd id="std.department.name" name="entity.college" width="20%"/>
            <@table.sortTd id="std.firstMajor.name" name="entity.speciality"/>
            <@table.sortTd id="std.enrollYear" name="filed.enrollYearAndSequence" width="15%"/>
            <@table.sortTd id="std.graduateAuditStatus" name="common.status" width="12%"/>
            <@table.sortTd id="std.remark" name="attr.remark"/>
        </@>
        <@table.tbody datas=studentList; student>
            <@table.selectTd id="stdId" value=student.id/>
            <td>${student.code}</td>
            <td><a href="studentDetailByManager.do?method=detail&stdId=${student.id}"><@i18nName student?if_exists/></a></td>
            <td><@i18nName student.department?if_exists/></td>
            <td><@i18nName student.firstMajor?if_exists/></td>
            <td align="center">${student.enrollYear}</td>
            <td>
                <a href="javascript:showDetail(${student.id});" title="查看培养计划完成情况">
                    <#if student.graduateAuditStatus?exists&&(student.graduateAuditStatus?string=="true")>
                        <@bean.message key="attr.graduate.outsideExam.auditPass"/>
                    <#elseif student.graduateAuditStatus?exists&&(student.graduateAuditStatus?string=="false")>
                        <font color="red"><@bean.message key="attr.graduate.outsideExam.noAuditPass"/></font>
                    <#else>
                        <@bean.message key="attr.graduate.outsideExam.nullAuditPass"/>
                    </#if>
                </a>
            </td>
           <td>
           	<#list student.auditResults as aa>
           		${(aa.remark)!}
           	</#list>
           </td> 
        </@>
    </@>
    <form method="post" action="" name="actionForm">
        <input type="hidden" name="actionPath" value="studentAuditManager"/>
        <input type="hidden" name="auditStandardId" value="${RequestParameters['auditStandardId']?default('')}"/>
        <input type="hidden" name="auditTerm" value="${RequestParameters['auditTerm']?default('')}"/>
        <input type="hidden" name="keys" value="std.code,std.name,std.department.name,std.firstMajor.name,std.enrollYear,std.graduateAuditStatus"/>
        <input type="hidden" name="titles" value="学号,姓名,院系,专业,年级,审核是否通过"/>
        
        <input type="hidden" name="templateDocumentId" value="80"/>
        <input type="hidden" name="document.id" value="80"/>
        <input type="hidden" name="importTitle" value="冲抵学分导入"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "<@bean.message key="std.stdList"/>", null, true, true);
        bar.setMessage('<@getMessage/>');
        var menu = bar.addMenu("冲抵学分");
        menu.addItem("维护",'actAsCredit()');
        menu.addItem("导入","importData()");
        menu.addItem("下载模版","downloadTemplate()",'download.gif');
        bar.addItem("导出列表", "exportECUPLData()");
        <#--bar.addItem("修改备注", "editRemark()");-->
        bar.addItem('审核选中学生', 'batchAutoAudit()');
        bar.addItem('审核通过选中学生', 'batchAudit()');
        bar.addItem('撤销通过选中学生', 'batchDisAudit()');
        bar.addItem('批量审核条件内学生', 'batchAuditWithCondition()');
        
        <#include "graduateListScript.ftl"/>
        
        function exportECUPLData() {
            form.action = "studentAuditManager.do?method=export";
            addHiddens(form, queryStr);
            form.submit();
        }
        function actAsCredit(){
	 		if (!checkAuditStandard()) {
	 			return;
	 		}
	 		var stdId = getSelectIds("stdId");
	        if (stdId == null || stdId == "" || isMultiId(stdId)) {
	            alert("请仅选择一个学生");
	            return;
	        }
	 		var stdIds = getSelectIds("stdId");
	 		form.action="studentAuditManager.do?method=actAsCredit";
	 		form.target = "_self";
	 		addInput(form, "stdIds", stdIds, "hidden");
	 		addInput(form,"queryStr",queryStr);
	 		addParamsInput(form, queryStr);
	 		form.submit();
	 }
	 		
	  function downloadTemplate() {
		    form.action = "dataTemplate.do?method=download";
		    form.target = "_self";
		    form.submit();
           }
      function importData() {
            form.action = "studentAuditManager.do?method=importForm";
            form.target = "_self";
            form.submit();
        }
	 		
    </script>
</body>
<#include "/templates/foot.ftl"/>