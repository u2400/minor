<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#list results as result>
    <div><#if result.isOk>${result.student.code}学生成功加入${result.take.task.seqNo}${result.take.task.course.name}<#else>${result.student.code}学生指定“${tasks?first.course.name}”失败</#if></div>
    </#list>
    <script>
        var oBar = new ToolBar("bar", "未选课学生名单<span style=\"color:blue\">（操作结果）</span>", null, true, true);
        oBar.addItem("返回", "parent.search()", "backward.gif");
        
        window.history.back = function() {
            parent.search();
        };
        window.history.go = function() {
            parent.search();
        };
        window.onunload = function() {
            parent.search();
        };
    </script>
</body>
<#include "/templates/foot.ftl"/>