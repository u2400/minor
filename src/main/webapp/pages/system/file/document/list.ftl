<#include "/templates/head.ftl"/>
<body>
<table id="backBar"></table>
<script>
   var bar = new ToolBar('backBar','文档列表',null,true,true);
   bar.setMessage('<@getMessage/>');
   bar.addItem('<@bean.message key="action.modify"/>', 'editTeachTask()');
   bar.addItem("查看",'info("${RequestParameters['kind']}")');
   //bar.addItem("下载",'info()','download.gif');
   bar.addItem("上传",'upload("${RequestParameters['kind']}")','action.gif');
   bar.addItem("<@msg.message key="action.delete"/>",'remove("${RequestParameters['kind']}")','delete.gif');
   function info(kind) {
   	addInput(docListForm, "kind", kind, "hidden");
    submitId(docListForm, "documentId", false, "document.do?method=info");
   }
   function upload(kind){
      self.location="document.do?method=uploadSetting&kind="+kind;
   }
   function remove(kind){
     var documentIds= getSelectIds("documentId");
     if(documentIds==""){alert("请选择一个或多个文档进行删除");return;}
     if(confirm("确认删除选定的文档")){
        docListForm.action="document.do?method=remove&documentIds="+documentIds+"&kind="+kind;
        docListForm.submit();
     }
   }
   function editTeachTask(){
       id = getSelectIds("documentId");
       if(id=="") {alert("请选择一条信息");return;}
       if(isMultiId(id)) {alert("请选择不要选择多个信息");return;}
       form1.action = "document.do?method=edit&document.id=" + id;
       form1.submit();
    }
</script>
<form name="form1" method="post" action="" onsubmit="return false;">
   <@table.table width="100%" sortable="true" id="listTable">
     <@table.thead>
       <@table.selectAllTd id="documentId"/>
	   <@table.sortTd  text="文档标题" id="document.name"/>
	   <@table.sortTd  text="上传人" id="document.uploaded.name"/>
	   <@table.sortTd  text="上传时间" id="document.uploadOn"/>
	 </@>
	 <@table.tbody datas=documents;document>
	   <@table.selectTd id="documentId" value="${document.id}" type="checkbox"/>
	    <td><A href="download.do?method=download&document.id=${document.id}">${document.name}</A></td>
	    <td>${document.uploaded.name}</td>
	    <td>${document.uploadOn}</td>
	   </@>
	  </@>
	  </body>
      <form name="docListForm" method="post" action="" onsubmit="return false;"></form>
</form>
<#include "/templates/foot.ftl"/>