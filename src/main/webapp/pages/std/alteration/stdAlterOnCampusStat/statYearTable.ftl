<#macro displayStatYearTable(stats,entityName,years)>
 <#assign yearCountMap={}>
 <#assign whatCount=0>
 <@table.table id="statTable" width="100%">
 <@table.thead>
      <@table.td id="what.name" width="150px" name="${entityName}"/>
      <#list years as year>
      <td>${year}</td>
      </#list>
      <td>合计</td>
  </@>
  <@table.tbody datas=stats;statItem>
      <td><@i18nName statItem.what/></td>
      <#assign localWhatCount=0/>
      <#assign localZjWhatCount=0/>
      <#assign localYcWhatCount=0/>
      <#list years as year>
      <#assign yearCount=(statItem.getItem(year).countors[0])?default(0)>
      <#assign yearZjCount=(statItem.getItem(year).countors[1])?default(0)>
      <#assign yearYcCount=(statItem.getItem(year).countors[2])?default(0)>
      <#assign localWhatCount=localWhatCount + yearCount>
      <#assign localZjWhatCount=localZjWhatCount + yearZjCount>
      <#assign localYcWhatCount=localYcWhatCount + yearYcCount>
      <td><#if yearCount!=0>${yearCount!}（在校）<#if yearZjCount!=0><br>${yearZjCount!}（在籍）</#if><#if yearYcCount!=0><br>${yearYcCount!}（延长）</#if></#if></td>
      </#list>
      <td><#if localWhatCount!=0>${localWhatCount!}（在校）<#if localZjWhatCount!=0><br>${localZjWhatCount!}（在籍）</#if><#if localYcWhatCount!=0><br>${localYcWhatCount!}（延长）</#if></#if></td>
      <#assign whatCount=localWhatCount + whatCount>
  </@>
  <tr align="center">
  </tr>
 </@>
</#macro>