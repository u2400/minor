<#include "/templates/head.ftl"/>
<body>
	<table id="bar"></table>
	<#assign courseTableUnits = {}/>
	<table align="center">
		<tr>
			<td>
				<h2 align="center">课程表</h2>
				<table class="listTable" id="courseTable" style="table-layout:fixed;work-break;break:all;text-align:center;font-size:8.5pt;font-family:宋体">
					<tr>
						<td rowspan="2" width="60">专业<br>(专业方向)</td>
						<td colspan="2" width="70">上课时间</td>
						<#assign width = 14/>
						<#list 1..5 as week>
						<td colspan="${width}" width="${19.5 * width}"><@i18nName weeks[week - 1]/></td>
						</#list>
					</tr>
					<tr>
						<td>班级</td>
						<td>人数</td>
						<#list 1..(5 * width) as units>
						<td<#if (units - 1) % width == 4 || (units - 1) % width == 9> style="border-right-color:red"</#if>><#assign unit = units % width/><#if unit == 0>${width}<#else>${unit}</#if></td>
						</#list>
					</tr>
				<#list adminClasses as adminClass>
					<tr>
						<td id="${(adminClass_index + 2) + "_-3"}" style="font-family:宋体">${(adminClass.speciality.name)?default("")}<#assign majorTypeName = (adminClass.aspect.name)?default("")/><#if majorTypeName != ""><br>(${majorTypeName})</#if></td>
						<td id="${(adminClass_index + 2) + "_-2"}">${adminClass.code}</td>
						<td id="${(adminClass_index + 2) + "_-1"}">${adminClass.actualStdCount}</td>
						
						<#list 1..(5) as week>
						  <#list 1..14 as unit>
						  
						  <#assign hasCourse=0>
					      <#list courseTables[adminClass.id?string] as activity>
							<#if activity.time.weekId = week && (activity.time.startUnit <=unit&& activity.time.endUnit >=unit)>
							    <#assign courseName><@i18nName activity.task.course/></#assign>
						<td id="${(adminClass_index + 2) + "_" + (14 * (week - 1) + unit - 1)}"<#if (unit - 1) % width == 4 || (unit - 1) % width == 9> style="border-right-color:red"</#if>>${courseName?replace("（", "(")?replace("）", ")")}<br><#if activity.task.taskGroup?exists && activity.task.taskGroup.isSameTime><#if (activity.task.taskGroup.teachers?size < 5)><#list activity.task.taskGroup.teachers as teacher><@i18nName teacher/><#if teacher_has_next>，</#if></#list></#if><#else>${activity.task.arrangeInfo.teacherNames}</#if><#if activity.activityFirstWeek != 1 || activity.activityLastWeek != activity.calendar.weeks><br>${activity.activityFirstWeek}-${activity.activityLastWeek}</#if></td>
							<#assign hasCourse=1>
							<#break>
							</#if>
						  </#list>
							<#if hasCourse=0>
								<td id="${(adminClass_index + 2) + "_" + (14 * (week - 1) + unit - 1)}"<#if (unit - 1) % width == 4 || (unit - 1) % width == 9> style="border-right-color:red"</#if>></td>
							</#if>
						</#list>
					</#list>
					</tr>
				</#list>
				</table>
			</td>
		</tr>
	</table>
	<script>
		var bar = new ToolBar("bar", "班级课程表", null, true, true);
		bar.setMessage('<@getMessage/>');
		bar.addPrint("<@msg.message key="action.print"/>");
		bar.addClose("<@msg.message key="action.close"/>");
		
		$("message").innerHTML = "正在处理中……";
		setTimeout("mergeTable()", 1);
		function mergeTable(){
		  mergeCol('courseTable', 2, 0);
		  mergeRow('courseTable', 2, -3, ${courseTables?keys?size + 2}, ${width * 5}, -1);
		  $("message").innerHTML = "";
		  $("message").style.display = "none";
		}
		
		function mergeCol(tableId, rowStart, colStart) {
			var rows = $(tableId).rows;
			for (var i = rowStart; i < rows.length; i++) {
				for (var j = colStart + 1; j < rows[i].cells.length;) {
					var tdId = rows[i].cells[j].id;
					var tdIds = tdId.split("_");
					if (rows[i].cells[j - 1].innerHTML == rows[i].cells[j].innerHTML && "" != rows[i].cells[j - 1].innerHTML && "" != rows[i].cells[j].innerHTML) {
						rows[i].removeChild(rows[i].cells[j]);
						rows[i].cells[j - 1].colSpan++;
					} else {
						j++;
					}
					if (parseInt(tdIds[1]) % ${width} == 4 || parseInt(tdIds[1]) % ${width} == 9) {
					  rows[i].cells[j - 1].style.borderRightColor = "red";
					}
				}
			}
		}
		
		function mergeRow(tableId, rowStart, colStart, rowLen, colLen, exclusiveTd) {
		    if(null==exclusiveTd){
		       exclusiveTd=-200;
		    }
			var rows = document.getElementById(tableId).rows;
			for (var j = colStart; j < colLen; j++) {
			    if(j==exclusiveTd){
			       continue;
			    }
			    mergeTd = rowStart;
			    for (var i = mergeTd + 1; i < rowLen; i++) {
					var tdObj = document.getElementById(mergeTd + "_" + j);
					var toRemoveTd = document.getElementById(i + "_" + j);
			        if(null == toRemoveTd || "" == toRemoveTd.innerHTML || null == tdObj || "" == tdObj.innerHTML || tdObj.colSpan != toRemoveTd.colSpan || tdObj.innerHTML != toRemoveTd.innerHTML){
						mergeTd = i;
			            continue;
			        }
				    if(tdObj.innerHTML == toRemoveTd.innerHTML) {
				      rows[i].removeChild(toRemoveTd);
				      tdObj.rowSpan++;
				    }
			    }
			}
		}
	</script>
</body>
<#include "/templates/foot.ftl"/>
