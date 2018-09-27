<#function isAllowApplyJS applySwitches>
    <#if (applySwitches?size)?default(0) == 0>
        <#return "var isAllowApply = false;"/>
    <#else>
        <#local js = "var nowAtValue = new Date();\n"/>
        <#local js = js + "var nowAt = parseInt(nowAtValue.getFullYear() + \"\" + (nowAtValue.getMonth() + 101 + \"\").substr(1) + (nowAtValue.getDate() + 100 + \"\").substr(1) + (nowAtValue.getHours() + 100 + \"\").substr(1) + (nowAtValue.getMinutes() + 100 + \"\").substr(1)  + (nowAtValue.getSeconds() + 100 + \"\").substr(1));\n"/>
        <#local js = js + "var isAllowApply = " + applySwitches?first.isOpen?string + " && nowAt >= " + applySwitches?first.startDate?string("yyyyMMddHHmmss") + " && nowAt <= " + applySwitches?first.finishDate?string("yyyyMMddHHmmss") + ";"/>
        <#return js/>
    </#if>
</#function>
