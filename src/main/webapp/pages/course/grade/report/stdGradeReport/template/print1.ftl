		<table style="width:100%" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td align="right">
					<#assign gradePerColumn=(setting.pageSize/2)?int>
					<#assign style>style="font-size:${setting.fontSize}px"  width="93%"</#assign>
					<#assign isPrint=true/>
					<#assign ifShow>style="font-size:${setting.fontSize}px;display:none"  width="93%"</#assign>
					<#include "reportContent.ftl"/>
				</td>
			</tr>
		</table>
