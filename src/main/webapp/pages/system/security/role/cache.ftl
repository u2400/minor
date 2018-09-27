<#include "/templates/head.ftl"/>
<link href="themes/default/css/panel.css" rel="stylesheet" type="text/css">
<body >
<#assign elementCnt=0/>
<#assign memorySize=0/>
<#list statistics.secondLevelCacheRegionNames as cacheRegion>
<div>
<#assign regionStat=statistics.getSecondLevelCacheStatistics(cacheRegion)/>
	<#assign elementCnt=elementCnt+regionStat.elementCountInMemory/>
	<#assign memorySize=memorySize+regionStat.sizeInMemory/>
</div>
</#list>
<H3 align="center">Hibernate 二级缓存使用统计</H3>
<div  align="center">
	二级缓存命中${statistics.secondLevelCacheHitCount} 失效${statistics.secondLevelCacheMissCount} 命中率${statistics.secondLevelCacheHitCount/(0.01+statistics.secondLevelCacheHitCount+statistics.secondLevelCacheMissCount)}
	内存对象：${elementCnt},内存:${memorySize}
</div>
<table class="listTable" align="center">
<tr class="darkColumn">
	<td>缓存区域</td>
	<td>内存对象数量</td>
	<td>内存大小</td>
	<td>命中率</td>
</tr>
<#list statistics.secondLevelCacheRegionNames?sort as cacheRegion>
<tr>
	<#assign regionStat=statistics.getSecondLevelCacheStatistics(cacheRegion)/>
	<td>${cacheRegion}</td>
	<td>${regionStat.elementCountInMemory}</td>
	<td>${regionStat.sizeInMemory}</td>
	<td>${regionStat.hitCount/(0.01+regionStat.hitCount+regionStat.missCount)}</td>
</tr>
</#list>
</table>
<p align="right">统计时间:${now?string("yyyy-MM-dd HH:mm:ss")}</p>
</body>
<#include "/templates/foot.ftl"/>