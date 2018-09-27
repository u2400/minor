<#include "/templates/head.ftl"/>
<body>
	<table id="bar"></table>
	<#assign examTypeName><@i18nName examType/></#assign>
	<#assign examTeacherTypeValue><#if !RequestParameters["examTeacherType"]?exists || RequestParameters["examTeacherType"] == "examMonitor">监考<#else>主考</#if></#assign>
	<p align="center" style="font-size:20px;font-weight:bold">${calendar.year}学年${calendar.term}${examType.name}${examTeacherTypeValue}安排</p>
	<@table.table id="examActivity" width="100%">
		<@table.thead>
			<@table.td name="attr.index"/>
			<@table.td text=examTeacherTypeValue/>
			<@table.td name="exam.date"/>
			<@table.td name="exam.arrange"/>
			<@table.td name="entity.classroom"/>
			<@table.td name="attr.remark"/>
		</@>
		<@table.tbody datas=examActivities;examActivity,examActivity_index>
			<td>${examActivity_index + 1}</td>
			<td><@i18nName examActivity.teacher/></td>
			<td>${examActivity.task.arrangeInfo.digestExam(examActivity.task.calendar,Request["org.apache.struts.action.MESSAGE"],Session["org.apache.struts.action.LOCALE"],examType.id,"第:weeks周 :day :time")}</td>
			<td>${examActivity.task.arrangeInfo.digestExam(examActivity.task.calendar,Request["org.apache.struts.action.MESSAGE"],Session["org.apache.struts.action.LOCALE"],examType.id,":date")}</td>
			<td><@i18nName (examActivity.room)?if_exists/></td>
			<td></td>
		</@>
	</@>
	<@htm.actionForm name="actionForm" action="examiner.do" entity="examActivity">
		<input type="hidden" name="examTeacherType" value=""/>
		<input type="hidden" name="calendar.id" value="${RequestParameters["calendar.id"]}"/>
		<input type="hidden" name="examType.id" value="${RequestParameters["examType.id"]}"/>
	</@>
	<script>
		var bar = new ToolBar("bar", "监考教师统计", null, true, true);
		bar.setMessage('<@getMessage/>');
		bar.addItem("仅显示主考", "displayContent('teacher')");
		bar.addItem("仅显示监考(默认)", "displayContent('examMonitor')");
		bar.addPrint("<@msg.message key="action.print"/>");
		bar.addBackOrClose("<@msg.message key="action.back"/>", "<@msg.message key="action.close"/>");
		
		function mergeTableTd(tableId, index) {
			var rowsArray = document.getElementById(tableId).rows;
			if (rowsArray.length > 1) {
				var value = rowsArray[1].cells[index];
				for (var i = 2; i < rowsArray.length; i++) {
					var nextTd = rowsArray[i].cells[index];
					if (nextTd.innerHTML == value.innerHTML) {
						rowsArray[i].removeChild(nextTd);
						var rowspanValue = new Number(value.rowSpan);
						rowspanValue++;
						value.rowSpan = rowspanValue;
					} else {
						value = nextTd;
					}
				}
			}
		}
		
		mergeTableTd('examActivity',1);
		
		function displayContent(examTeacherType) {
			form.action = action + "?method=examinerStat";
			form["examTeacherType"].value = examTeacherType;
			form.submit();
		}
	</script>
</body>
<#include "/templates/foot.ftl"/>