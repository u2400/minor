<#include "/templates/head.ftl"/>
<BODY>
    <form method="post" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="searchFormFlag" value="noStat"/>
    </form>
    <script>
        var form = document.actionForm;
        
        // 初始化统计
        function initStat() {
            form.action = "evaluateDetailStat.do?method=index";
            form.target = "_self";
            form.submit();
        }
        
        initStat();
    </script>
</body>
<#include "/templates/foot.ftl"/>