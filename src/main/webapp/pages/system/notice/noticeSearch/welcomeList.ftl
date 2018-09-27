<#include "/templates/head.ftl"/>
<body>
<table id="backBar"></table>
<script>
   var bar = new ToolBar('backBar','公告列表',null,true,true);
   bar.addBack();
</script>
   <@table.table width="100%" sortable="true" id="listTable" style="word-break: break-all">
     <@table.thead>
        <@table.sortTd width="45%" id="notice.title" text="公告标题"/>
        <@table.sortTd text="发布人"  id="notice.publisher.name"/>
        <@table.sortTd text="发布时间" id="notice.modifyAt"/>
        <@table.sortTd  text="是否置顶" id="document.isUp"/>
       </@>
       <@table.tbody datas=notices;notice>
         <td>${notice.title}</td>
         <td>${notice.publisher.name}</td>
         <td>${notice.modifyAt?string("yyyy-MM-dd")}</td>
         <td>${notice.isUp?if_exists?string("是","否")}</td>
       </@>
      </@>
 </body>
<#include "/templates/foot.ftl"/>