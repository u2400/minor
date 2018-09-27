 <#macro displayGrades(grade)>
   <td><@i18nName grade.course/></td>
   <td><#if grade.isPass>${grade.credit?if_exists}<#else>0</#if></td>
   <td>&nbsp;${grade.getScoreDisplay(setting.gradeType)}</td>
   <td align='center'>&nbsp;${grade.calendar.year}(${grade.calendar.term})</td>
 </#macro>
 
 <#list stdGradeReports as report>
     <#assign stdTypeName><@i18nName report.std.type/></#assign>
     <#assign schoolName><@i18nName systemConfig.school/></#assign>
     <div align='center'><h2><@bean.message key="grade.stdGradeReportTitle" arg0="${schoolName}" arg1="${stdTypeName}"/></h2></div>
     <#if !isSingle?exists>
     <table ${style}>
        <tr>
          <td width='43%'><@msg.message key="entity.department"/>：<@i18nName report.std.department/></td>
          <td width='36%'>
            <@msg.message key="entity.speciality"/>：
            <#if setting.majorType.id=1>
                <#assign majorName><@i18nName report.std.firstMajor?if_exists/></#assign>
                <#assign aspectName><@i18nName report.std.firstAspect?if_exists/></#assign>
            <#else>
                <#assign majorName><@i18nName report.std.secondMajor?if_exists/></#assign>
                <#assign aspectName><@i18nName report.std.secondAspect?if_exists/></#assign>
            </#if>
            <#if aspectName?exists>
               <#if aspectName?starts_with(majorName)>
                ${aspectName}
               <#else>
                ${majorName}<#if aspectName?length !=0>(${aspectName})</#if>
               </#if>
            <#else>
               ${majorName}
            </#if>
          </td>
          <td><@msg.message key="entity.adminClass"/>：<@i18nName (report.std.firstMajorClass)?if_exists/></td>
        <tr> 
     </table>
     </#if>
     <table ${style}>
        <tr>
          <td width='25%'>&nbsp;<@msg.message key="attr.stdNo"/>：${report.std.code}</td>
          <td>&nbsp;<@msg.message key="attr.personName"/>：${report.std.name?if_exists}</td>
          <td width='18%'>&nbsp;<@msg.message key="entity.gender"/>：<@i18nName (report.std.basicInfo.gender)?if_exists/></td>
          <td><@msg.message key="grade.creditTotal"/>：${report.credit?if_exists}
          <td>&nbsp;<#if setting.printGP><@msg.message key="filed.averageGradeNod"/>：<@reserve2 report.GPA/></#if></td>
        </tr>
     </table>
     <table ${style} class="listTable">
       <tr align="center">
         <td align="center" width="20%"><@msg.message key="attr.courseName"/></td>
         <td align="center" width="4%">获得<@msg.message key="attr.credit"/></td>
         <td width="5%">成绩</td>
         <td width="10%">学年度</td>
         <td width="4%">学期</td>
         <td align="center" width="20%"><@msg.message key="attr.courseName"/></td>
         <td align="center" width="4%">获得<@msg.message key="attr.credit"/></td>
         <td width="5%">成绩</td>
         <td width="10%">学年度</td>
         <td width="4%">学期</td>
       </tr>
       <#assign grades=report.grades>
       <#assign gradePerColumn=((grades?size+1)/2)?int>
       <#list 0..gradePerColumn-1 as index>
       <#assign count=index*2>
       <tr>
           <#if grades[count]?exists>
           <td align="center">${grades[count].course.name}</td>
           <td align="center"><#if grades[count].isPass>${grades[count].credit}<#else>0</#if></td>
           <#assign scoreValue>${grades[count].getScoreDisplay(setting.gradeType)}</#assign>
           <td align="center" style="font-family:BatangChe">${(scoreValue == "" && RequestParameters["showAbsence"]?exists || scoreValue == "0" && RequestParameters["zero"]?exists)?string("<b>缺考</b>", scoreValue)}</td>
           <td align="center">${grades[count].calendar.year}</td>
           <td align="center">${grades[count].calendar.term}</td>
           <#else>
             <@emptyTd 5/>
           </#if>
           <#if grades[count+1]?exists>
               <td align="center">${grades[count+1].course.name}</td>
               <td align="center"><#if grades[count+1].isPass>${grades[count+1].credit}<#else>0</#if></td>
               <#assign scoreValue>${grades[count+1].getScoreDisplay(setting.gradeType)}</#assign>
               <td align="center" style="font-family:BatangChe">${(scoreValue == "" && RequestParameters["showAbsence"]?exists || scoreValue == "0" && RequestParameters["zero"]?exists)?string("<b>缺考</b>", scoreValue)}</td>
               <td align="center">${grades[count+1].calendar.year}</td>
               <td align="center">${grades[count+1].calendar.term}</td>
           <#else>
             <@emptyTd 5/>
           </#if>
        </tr>
       </#list>
     </table>
     
     <#assign reportOther=otherExamReportMap[report.std.id?string]?if_exists>
     <#if RequestParameters["reportSetting.printOtherGrade"]?exists && RequestParameters["reportSetting.printOtherGrade"] == "1" && (reportOther?size > 0)>
     <br>
     <table ${style} class="listTable">
      <tr align="center">
         <#if RequestParameters["isPassOtherGrade"]?exists>
            <@table.sortTd width="20%" text="校外考试名称" id="otherGrade.category.name"/>
         <td width="20%">学年度</td>
         <td width="10%">学期</td>
         <td width="15%"><@msg.message key="grade.score"/></td>
            <@table.sortTd text="分制" id="otherGrade.category.markStyle" width="15%"/>
         <td width="10%">是否合格</td>
         <#else>
            <@table.sortTd width="20%" text="校外考试名称" id="otherGrade.category.name"/>
         <td width="20%">学年度</td>
         <td width="15%">学期</td>
         <td width="20%"><@msg.message key="grade.score"/></td>
            <@table.sortTd text="分制" id="otherGrade.category.markStyle"/>
         </#if>
       </tr>
       <#if (reportOther?size!=0)>
       <#list 0..reportOther?size-1 as t>
       <tr>
            <td align="center">${reportOther[t].category.name}</td>
            <td align="center">${reportOther[t].calendar.year}</td>
            <td align="center">${reportOther[t].calendar.term}</td>
            <#assign scoreValue>${reportOther[t].scoreDisplay}</#assign>
            <td align="center">${(scoreValue == "0" && RequestParameters["zero"]?exists)?string("<b>缺考</b>", scoreValue)}</td>
            <td align="center">${reportOther[t].markStyle.name}</td>
         <#if RequestParameters["isPassOtherGrade"]?exists>
            <td align="center">${reportOther[t].isPass?string("合格", "不合格")}</td>
         </#if>
       </tr>
       </#list>
      </#if>
     </table>
      </#if>
      
     <#macro displayGradeStat(k)>
         <#if stdGP.GPList[k]?exists>
          <td align="center">${stdGP.GPList[k].calendar.year}(${stdGP.GPList[k].calendar.term})</td>
          <td align="center">${stdGP.GPList[k].credits}</td>
          <td align="center"><@reserve2 stdGP.GPList[k].GPA/></td>
         <#else>
         <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
         </#if>
     </#macro>
     <#assign stdGP=stdGPMap[report.std.id?string]>
     <#if RequestParameters["reportSetting.printTermGP"]?exists && RequestParameters["reportSetting.printTermGP"] == "1" && (stdGP.GPList?size > 0)>
     <br>
     <table ${style} class="listTable">
           <@table.thead>
                <@table.td text="学年度学期"/>
                <@table.td name="std.totalCredit"/>
                <@table.td name="grade.avgPoints"/>
                <@table.td text="学年度学期"/>
                <@table.td name="std.totalCredit"/>
                <@table.td name="grade.avgPoints"/>
                <@table.td text="学年度学期"/>
                <@table.td name="std.totalCredit"/>
                <@table.td name="grade.avgPoints"/>
                <@table.td text="学年度学期"/>
                <@table.td name="std.totalCredit"/>
                <@table.td name="grade.avgPoints"/>
            </@>
            <#list 0..((stdGP.GPList?size+3)/4-1) as k>
            <tr>
              <@displayGradeStat k*4/>
              <@displayGradeStat (k*4)+1/>
              <@displayGradeStat (k*4)+2/>
              <@displayGradeStat (k*4)+3/>
            </tr>
           </#list>
     </table>
     </#if>
    <#if RequestParameters["reportSetting.template"]?default("default") == "print" || RequestParameters["reportSetting.template"]?default("default") == "print1">
     <br>
     <table ${style}>
        <tr>
            <td width='35%'>${(auditResultMap[(report.std.id)?string].graduateState.name)?if_exists}证书号：${(auditResultMap[(report.std.id)?string].diplomaNo)?if_exists}</td>
            <td width='25%'>学科学位：${(auditResultMap[(report.std.id)?string].degree.name)?if_exists}</td>
            <td width='25%'>学位证书号：${(auditResultMap[(report.std.id)?string].certificateNo)?if_exists}</td>
            <td width='15%'>&nbsp;</td>
        </tr>
    </table>
    </#if>
     <br>
    <table ${ifShow?default(style)}>
        <tr>
          <td width="20%"><#if RequestParameters["reportSetting.template"]?default("default") != "default">制表人：${setting.printBy?default(' ')}</#if></td>
          <td width="35%"><#if RequestParameters["reportSetting.template"]?default("default") != "default">学院（系）院长（主任）：${setting.prior?default(' ')}</#if></td>
          <td><#if RequestParameters["reportSetting.template"]?default("default") != "default">教务处长：${setting.chief?default(' ')}</#if></td>
        </tr>
    </table>
	<#if RequestParameters["isShowPrintAt"]?exists>
    <table ${style}>
        <tr>
          <td style="text-align:right">${setting.printAt?string("yyyy年MM月dd日")}</td>
        </tr>
    </table>
	</#if>
     <#if report_has_next>
         <div style='PAGE-BREAK-AFTER: always'></div> 
     </#if>
</#list>
