<#include "/templates/head.ftl"/>
<body>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="reportSetting.majorType.id" value="1"/>
        <input type="hidden" name="reportSetting.template" value="default"/>
        <input type="hidden" name="reportSetting.gradePrintType" value="2"/>
        <input type="hidden" name="reportSetting.pageSize" value="100"/>
        <input type="hidden" name="reportSetting.fontSize" value="11"/>
        <input type="hidden" name="reportSetting.printGP" value="1"/>
        <input type="hidden" name="reportSetting.published" value="1"/>
        <input type="hidden" name="reportSetting.order.property" value="calendar.yearTerm"/>
        <input type="hidden" name="reportSetting.order.direction" value="1"/>
        <input type="hidden" name="reportSetting.gradeType.id" value="${gradeTypes?sort_by("code")?first.id}"/>
        <input type="hidden" name="reportSetting.printOtherGrade" value="1"/>
        <input type="hidden" name="reportSetting.printTermGP" value="1"/>
        <input type="hidden" name="isPassOtherGrade" value="1"/>
    </form>
    <script>
        var form = document.actionForm;
        
        function report() {
            form.action = "gradeReportForStudent.do?method=report";
            form.target = "_blank";
            form.submit();
        }
        
        report();
    </script>
</body>
<#include "/templates/foot.ftl"/>
