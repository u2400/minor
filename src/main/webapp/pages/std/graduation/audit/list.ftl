<#include "/templates/head.ftl"/>
 <body >  
  <table id="bar"></table>
 <@table.table width="100%" sortable="true" id="sortTable">
	  <@table.thead>
	     <@table.selectAllTd id="auditResultId"/>
	     <@table.sortTd width="10%" id="std.code" name="attr.stdNo"/>
	     <@table.sortTd width="8%" id="std.name" name="attr.personName"/>
	     <@table.sortTd width="8%" id="std.enrollYear" name="attr.enrollTurn"/>
	     <@table.sortTd width="10%"id="std.department.name" name="entity.college"/>
	     <@table.sortTd id="std.firstMajor.name" name="entity.speciality"/>
	     <@table.td name="entity.adminClass"/>
	     <@table.sortTd width="8%" id="auditResult.certificateNo" text="学位证书号"/>
	     <@table.td width="8%" text="毕业证书号" id="auditResult.diplomaNo"/>
		 <@table.sortTd width="8%" id="auditResult.isPass" text="是否通过"/>
		 <@table.sortTd width="8%" id="auditResult.remarkOfDegree" text="备注"/>
	   </@>
	   <@table.tbody datas=auditResults;auditResult>
	    <@table.selectTd  type="checkbox" id="auditResultId" value="${auditResult.id}"/>
	    <td><A href="studentDetailByManager.do?method=detail&stdId=${auditResult.std.id}" target="blank" >${auditResult.std.code}</A></td>
        <td><A href="degreeAudit.do?method=info&auditResultId=${auditResult.id}&standard.id=${RequestParameters['standard.id']}" title="点击查看审核信息">${auditResult.std.name}</a></td>
        <td>${auditResult.std.enrollYear}</td>
        <td><@i18nName auditResult.std.department/></td>
        <td><@i18nName auditResult.std.firstMajor?if_exists/></td>
        <td><@i18nName (auditResult.std.firstMajorClass)?if_exists/></td>
        <td>${(auditResult.certificateNo)?default("暂无")}</td>
        <td>${(auditResult.diplomaNo)?default("暂无")}</td>
		<td<#if !auditResult.isPass?if_exists> style="color:red"</#if>>${auditResult.isPass?if_exists?string("是","否")}</td>
        <td title="${(auditResult.remarkOfDegree?html)?if_exists}" nowrap><span style="display:block;overflow:hidden;text-overflow:ellipsis;width:60px;">${(auditResult.remarkOfDegree?html)?if_exists}</span></td>
	   </@>
     </@>
 <@htm.actionForm name="actionForm" action="degreeAudit.do" entity="auditResult">
 <input type="hidden" name="standard.id" value="${RequestParameters['standard.id']?default('')}"/>
 <input type="hidden" name="isAudit" value="true"/>
 <input type="hidden" name="target" value="_self"/>
 </@>
 <script>
    var bar = new ToolBar("bar","已审核学生列表",null,true,true);
    bar.setMessage('<@getMessage/>');
    bar.addItem("查看","info()");
    bar.addItem("添加","add()");
    bar.addItem("修改","edit()");
    bar.addItem("导入","importData()");
    bar.addItem("下载数据模板","downloadTemplate()",'download.gif');
    bar.addItem('<@msg.message key="action.export"/>', 'exportData()');
    //var menu = bar.addMenu('<@msg.message key="action.export"/>', 'exportData()');
    //menu.addItem('<@msg.message key="action.export"/>审核信息', 'exportDataWithInfo()');
    bar.addItem("重新审核","audit()");
    
    function audit(){
      if (document.actionForm['standard.id'].value == "") {
        alert("没有审核标准,请先制定标准.");
        return;
      }
      multiAction('audit');
    }
    var form=document.actionForm;
    function downloadTemplate(){
      self.location="dataTemplate.do?method=download&document.id=13";
    }
    function importData(){
       form.action="degreeAudit.do?method=importForm&templateDocumentId=1";
       addInput(form,"importTitle","学生毕业证书号和学位证书号数据上传");
       form["target"].value = "_parent";
       form.submit();
    }
    function exportData(){
       if(confirm("是否导出已经查询出的所有审核结果?")){
          addInput(form,"keys","std.code,std.name,std.enrollYear,std.department.name,std.firstMajor.name,std.firstMajorClass.name,GPA,credits,isPass,diplomaNo,certificateNo,languageGradesStr,computerGradesStr");
          addInput(form,"titles","<@msg.message key="attr.stdNo"/>,<@msg.message key="attr.personName"/>,所在年级,院系,专业,班级,平均绩点,总学分,是否通过,学历证书号,学位证书号,外语水平,计算机水平");
          form["target"].value = "_self";
          exportList();
       }
    }
    
    function exportDataWithInfo(){
       if(confirm("是否导出已经查询出的所有学生审核信息?")){
          addInput(form,"attrs","degreeAuditInfo.auditResult.std.code,degreeAuditInfo.auditResult.std.name,degreeAuditInfo.auditResult.std.enrollYear,degreeAuditInfo.auditResult.std.department.name,degreeAuditInfo.auditResult.std.firstMajor.name,degreeAuditInfo.auditResult.GPA,degreeAuditInfo.auditResult.credits,degreeAuditInfo.pass,degreeAuditInfo.auditResult.diplomaNo,degreeAuditInfo.auditResult.certificateNo,degreeAuditInfo.ruleConfig.rule.name,degreeAuditInfo.description");
          addInput(form,"attrNames","<@msg.message key="attr.stdNo"/>,<@msg.message key="attr.personName"/>,所在年级,院系,专业,平均绩点,总学分,是否通过,学历证书号,学位证书号,规则名称,审核结果,");
          form["target"].value = "_self";
          form.action="degreeAudit.do?method=exportDataWithInfo";
	      addHiddens(form,resultQueryStr);
	      form.submit();
       }
    }
    function edit(){
       addParamsInput(form,queryStr)
       form["target"].value = "_parent";
       submitId(form,"auditResultId",false,"degreeAudit.do?method=edit");
    }
    function add(){
       transferParams(parent.document.stdSearch,form,null,false);
       form.action="degreeAudit.do?method=edit";
       form["target"].value="_parent";
       form.submit();
    }
 </script>
 </body>
<#include "/templates/foot.ftl"/> 