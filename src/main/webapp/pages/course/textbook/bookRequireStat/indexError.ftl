<#include "/templates/head.ftl"/>
<BODY>
    <table id="examGroupBar"></table>
   <center><h1><font color="red">请先配置“<a href="studentType.do" target="studentType_window">学生类别</a>”。</font></h1></center>
   <script>
    var bar=new ToolBar("examGroupBar","教材需求统计",null,true,true);
    bar.addBlankItem();
   </script>
</body>
<#include "/templates/foot.ftl"/>
   