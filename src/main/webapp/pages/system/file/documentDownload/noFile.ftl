<#include "/templates/head.ftl"/>
<body>
<#assign labInfo>没有找到相应文档</#assign>
<#include "/templates/back.ftl"/>
<p>没有找到相应文档(id=${documentId?default('')})。</p>
</body>
<#include "/templates/foot.ftl"/>