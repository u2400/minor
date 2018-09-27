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
            <@table.sortTd id="std.enrollYear" name="filed.enrollYearAndSequence" width="10%"/>
            <@table.sortTd id="std.graduateAuditStatus" name="common.status" width="12%"/>
            <@table.td id="offsetCredit.offsetCredit" text="冲抵学分" width="10%"/>
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
            <td><#if offsetCreditMap["${student.id}"]?exists>${offsetCreditMap["${student.id}"].offsetCredit?default('0')}<#else>0</#if></td>
        </@>
    </@>
    <form method="post" action="" name="actionForm">
        <input type="hidden" name="actionPath" value="studentAuditManager"/>
        <input type="hidden" name="auditStandardId" value="${RequestParameters['auditStandardId']?default('')}"/>
        <input type="hidden" name="auditTerm" value="${RequestParameters['auditTerm']?default('')}"/>
        <input type="hidden" name="keys" value="code,name,department.name,firstMajor.name,enrollYear,graduateAuditStatus"/>
        <input type="hidden" name="titles" value="学号,姓名,院系,专业,年级,审核状态"/>
        
        <input type="hidden" name="templateDocumentId" value="80"/>
        <input type="hidden" name="document.id" value="80"/>
        <input type="hidden" name="importTitle" value="冲抵学分导入"/>
    </form>
    <script>
        var bar = new ToolBar("bar", "<@bean.message key="std.stdList"/>", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("修改",'edit()');
        
        function edit(){
	 		var stdId = getSelectIds("stdId");
	        if (stdId == null || stdId == "" || isMultiId(stdId)) {
	            alert("请仅选择一个学生");
	            return;
	        }
	        var form = document.actionForm;
	 		var stdIds = getSelectIds("stdId");
	 		form.action="offsetCredit.do?method=edit";
	 		form.target = "_self";
	 		addInput(form,"queryStr",queryStr);
	 		addInput(form, "stdIds", stdIds, "hidden");
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