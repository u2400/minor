<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <@table.table id="studentInEnglishTable" sortable="true" width="100%">
        <@table.thead>
            <@table.selectAllTd id="applyId"/>
            <@table.sortTd text="学号" id="apply.student.code"/>
            <@table.sortTd text="姓名" id="apply.student.name"/>
            <@table.td text="行政班"  width="8%"/>
            <@table.td text="申请内容"/>
            <@table.sortTd text="审核状态" id="apply.passed"/>
        </@>
        <@table.tbody datas=applies;apply>
            <@table.selectTd id="applyId" value=apply.id/>
            <td><a href="#" onclick="infos('${apply.id}')">${apply.student.code}</a></td>
            <td><a href="searchStudent.do?method=detail&stdId=${apply.student.id}" target="_blank">${apply.student.name}</a></td>
            <td>${(apply.student.adminClasses?first.name)!}</td>
            <td title="${apply.applyAt} @ ${apply.ip}">
            <#list apply.items as item>
            ${item.meta.name} : ${studentInfoAlterApplyService.getString(item.meta,item.oldValue)!} ⇒ ${studentInfoAlterApplyService.getString(item.meta,item.newValue)!} <#if item_index%2==1><br/></#if>
            </#list>
            </td>
            <td>
            <#if !(apply.passed??)>
            未审核
            <#else>
            <input type="hidden" id="state_${apply.id}" value = "${apply.passed?string('1','0')}"/>
            ${apply.passed?string("通过","未通过")}
            </#if>
            </td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="studentId" value=""/>
        <#assign filterKeys = ["method"]/>
        <input type="hidden" name="params" value="<#list RequestParameters?keys as key>&${key}=${RequestParameters[key]?if_exists}</#list>"/>
    </form>
    <form method="post" action="" name="searchForm" onsubmit="return false;">
    </form>
    <script>
        var bar = new ToolBar("bar", "申请修改列表", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("查看", "info()");
        bar.addItem("审核通过","auditPassed()");
        bar.addItem("审核不通过","auditNoPassed()");
        var form = document.actionForm;
        var sForm = document.searchForm;
        
        function info() {
          var applyIds = getSelectId("applyId");
          if (applyIds == null || applyIds == "" || isMultiId(applyIds)) {
	            alert("请仅选择一条记录");
	            return;
	        }
            form.action = "studentInfoAlterAudit.do?method=info";
            form.target = "_self";
            addInput(form,"applyIds",applyIds,"hidden");
            addParamsInput(form, queryStr);
            form.submit(); 
        }
        
        function infos(applyId) {
            form.action = "studentInfoAlterAudit.do?method=info";
            form.target = "_self";
            addInput(form,"applyIds",applyId,"hidden");
            addParamsInput(form, queryStr);
            form.submit(); 
        }
        
        function auditPassed(){
	        var applyIds = getSelectId("applyId");
	        if (applyIds == null || applyIds == "") {
	                alert("请选择一条要操作的记录。");
	                return;
	         }
	         
	        /*if(!canBeAudited(applyIds)){
	           alert("您只能对未审核的信息进行审核");
	           return;
	         }*/
		    if (confirm("确定要'审核通过'所选记录吗？")) {
		           form.action = "studentInfoAlterAudit.do?method=auditPassed";
		           form.target = "_self";
		           addInput(form,"applyIds",applyIds,"hidden");
		           form.submit();
		     }
        }
        
        function auditNoPassed(){
	        var applyIds = getSelectId("applyId");
	        if (applyIds == null || applyIds == "") {
	             alert("请选择一条要操作的记录。");
	              return;
	         }
            if(!canBeAudited(applyIds)){
              alert("您只能对未审核的信息进行审核");
              return;
            }
	         
	       if (confirm("确定要'审核不通过'所选记录吗？")) {
	           form.action = "studentInfoAlterAudit.do?method=auditNoPassed";
	           form.target = "_self";
	           addInput(form,"applyIds",applyIds,"hidden");
	           form.submit();
	       }
        }
        
       
        function canBeAudited(applyIds) {
		var planIds = new Array();
		if(isMultiId(applyIds)) {
			planIds = applyIds.split(",");
		} else {
			planIds.push(applyIds);
		}
		for(var i = 0; i < planIds.length; i++) {
			var plan_status = document.getElementById("state_"+planIds[i]);
			if(plan_status != null) {
				return false;
			}
		}
		return true;
	}
	
        function initData() {
            form["studentId"].value = "";
        }
        
        
        function edit() {
            initData();
            var studentId = getSelectId("studentId");
            if (isEmpty(studentId) || studentId.split(",").length > 1) {
                alert("请选择一条要操作的记录。");
                return;
            }
            form.action = "studentAbility.do?method=edit";
            form.target = "_self";
            form["studentId"].value = studentId;
            form.submit();
        }
        
        function exportData() {
            sForm.action = "studentAbility.do?method=export";
            sForm.target = "_self";
            sForm.submit();
        }
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>