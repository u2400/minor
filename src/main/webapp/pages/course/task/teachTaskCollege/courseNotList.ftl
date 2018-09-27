<#include "/templates/head.ftl"/>
<#include "/templates/print.ftl"/>
<object id="factory2" style="display:none" viewastext classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="css/smsx.cab#Version=6,2,433,14"></object> 
<style>
.printTableStyle {
	border-collapse: collapse;
    border:solid;
	border-width:2px;
    border-color:#006CB2;
  	vertical-align: middle;
  	font-style: normal; 
	font-size: 10pt; 
}
table.printTableStyle td{
	border:solid;
	border-width:0px;
	border-right-width:2;
	border-bottom-width:2;
	border-color:#006CB2;
        height:26px;
}
</style>
<#assign pagePrintRow = 30 />
<body  onload="SetPrintSettings()">
    <#assign students=studentsNO?sort_by(['code'])>
    <br>
     <table width="100%" align="center">
	   <tr>
	    <td align="center" colspan="4" style="font-size:17pt">
	     <B><@i18nName systemConfig.school/>未选课学生名单</B>
	    </td>
	   </tr>
	   <tr><td>&nbsp;</td></tr>
	   <tr class="infoTitle">
		   <td  ><@msg.message key="attr.courseNo"/>：${course.code}&nbsp;&nbsp;</td>
		   <td  ><@msg.message key="attr.courseName"/>：${course.name}</td>
	   </tr>
	 </table>	 
	 <#assign pageNos=(students?size/(pagePrintRow*2))?int/>
	 <#if ((students?size)>(pageNos*(pagePrintRow*2)))>
	 <#assign pageNos=pageNos+1 />
	 </#if>
	 <#list 0..pageNos-1 as pageNo>
	 <#assign passNo=pageNo*pagePrintRow*2 />

	 <table class="printTableStyle"  width="100%">
	   <tr class="darkColumn" align="center">
	     <td width="6%">序号</td>
	     <td width="10%"><@msg.message key="attr.stdNo"/></td>
	     <td width="10%"><@msg.message key="attr.personName"/></td>
	     <td width="10%">班级</td>
	     <td width="5%">备注</td>
	     <td width="6%">序号</td>
	     <td width="10%"><@msg.message key="attr.stdNo"/></td>
	     <td width="10%"><@msg.message key="attr.personName"/></td>
	     <td width="10%">班级</td>
	     <td width="5%">备注</td>
	     
	     
	   </tr>
	   <#list 0..pagePrintRow-1 as i>
	   <tr class="brightStyle" >
         <#if students[i+passNo]?exists>
	     <td>${i+1+passNo}</td>
	     <td>${students[i+passNo].code}</td>
	     <td>${students[i+passNo].name}</td>
	     <td align="center" <#if (((students[i+passNo].firstMajorClass.name)?default('')?length)>11)>style="font-size:9px"</#if>>${(students[i+passNo].firstMajorClass.name)?default('')}</td>
         <#else><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
         </#if>
	     <td></td>
         <#if students[i+pagePrintRow+passNo]?exists>
	     <td>${i+pagePrintRow+1+passNo}</td>
	     <td>${students[i+pagePrintRow+passNo].code}</td>
	     <td>${students[i+pagePrintRow+passNo].name}</td>
	     <td align="center" <#if (((students[i+passNo].firstMajorClass.name)?default('')?length)>11)>style="font-size:9px"</#if>>${(students[i+passNo].firstMajorClass.name)?default('')}</td>
         <#else><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></#if>
	     <td></td>
	   </tr>
	   </#list>	   
     </table>
     <div style='PAGE-BREAK-AFTER: always'></div>
     </#list>
   <table  width="90%" align="center" class="ToolBar">
	   <tr>
		   <td align="center">
		   <input class="buttonStyle"  type="button" value="<@msg.message key="action.print"/>" onclick="print()"/>
		  </td>
	  </tr>
  </table>
 </body>
<#include "/templates/foot.ftl"/>