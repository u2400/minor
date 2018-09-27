<#assign gradePerColumn=(setting.pageSize/2)?int/>
<#macro enName(entity)><#if entity.engName?if_exists?trim=="">${entity.name?if_exists}<#else>${entity.engName?if_exists}</#if></#macro>
<#assign scores={'优':'A','良':'B','中':'B-','及格':'C','不及格':'D','合格':'Pass','不合格':'Fail'} />
 <#macro displayScore(grade)>
   <#local score=grade.getScoreDisplay(setting.gradeType)/>
   <#local score = scores[score]!score/>
   <#if score=="" || score=="0">
   <#list grade.examGrades as eg>
      <#if eg.gradeType.id==2>
        <#if eg.examStatus.id==2><#local score = "Delay"/>
        <#elseif eg.examStatus.id==3 ><#local score = "Absence"/>
        </#if>
      <#break/>
      </#if>
   </#list>
   </#if>
   ${score!}
 </#macro>
 
<#assign style>style="font-size:${setting.fontSize}px" align="center" valign="top" width="100%"</#assign>
 <#macro displayGrades(grade)>
   <td><@enName grade.course/></td>
   <td><#if grade.isPass>${grade.credit?if_exists}<#else>0</#if></td>
   <td>&nbsp;<@displayScore grade.getScoreDisplay(setting.gradeType)/></td>
   <td align='center'>&nbsp;${grade.calendar.year}(${grade.calendar.term})</td>
 </#macro>
 <#list stdGradeReports as report>
     <div align='center'><h2>EAST CHINA UNIVERSITY OF POLITICAL SCIENCE AND LAW</h2></div>
     <div align='center'><h3>Transcript</h3></div>
     <table ${style}>
        <tr>
          <td width="25%">&nbsp;Name:<@enName report.std/></td>
          <td width="40%" >Class:<@enName (report.std.firstMajorClass)?if_exists/></td>
          <td width="35%" align="right">Student Identification No.${report.std.code}</td>
        </tr>
        <tr>
          <td width="25%" >&nbsp;School:<@enName report.std.department/></td>
          <td width="40%" >Major:
           <#if setting.majorType.id=1>
                <#assign majorName><@enName report.std.firstMajor?if_exists/></#assign>
                <#assign aspectName><@enName report.std.firstAspect?if_exists/></#assign>
            <#else>
                <#assign majorName><@enName report.std.secondMajor?if_exists/></#assign>
                <#assign aspectName><@enName report.std.secondAspect?if_exists/></#assign>
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
           <td width="35%" align="right">Length of Program:${report.std.schoolingLength} Years</td>
        </tr>
        <tr>
          <td>&nbsp;Accumulated Credits:${report.credit?if_exists}</td>
          <td>Sex:<@enName (report.std.basicInfo.gender)?if_exists/></td>
          <td align="right">GPA:<@reserve2 report.GPA/></td>
        </tr>
     </table>
     <table ${style} class="listTable">
       <tr align="center">
         <td align="center" width="25%">Course Name</td>
         <td align="center" width="5%">Credit</td>
         <td width="5%">Score</td>
         <td width="10%">Academic Year</td>
         <td width="5%">Term</td>
         <td align="center" width="25%">Course Name</td>
         <td align="center" width="5%">Credit</td>
         <td width="5%">Score</td>
         <td width="10%">Academic Year</td>
         <td width="5%">Term</td>
       </tr>
       <#assign grades=report.grades>
       <#assign gradePerColumn=((grades?size+1)/2)?int>
       <#list 0..gradePerColumn-1 as index>
       <#assign count=index*2>
       <tr>
           <#if grades[count]?exists>
           <td align="center"><@enName grades[count].course/></td>
           <td align="center"><#if grades[count].isPass>${grades[count].credit}<#else>0</#if></td>
           <td align="center" style="font-family:BatangChe"><@displayScore grades[count]/></td>
           <td align="center">${grades[count].calendar.year}</td>
           <td align="center">${grades[count].calendar.term}</td>
           <#else>
             <@emptyTd 5/>	
           </#if>
           <#if grades[count+1]?exists>
               <td align="center"><@enName grades[count+1].course/></td>
               <td align="center"><#if grades[count+1].isPass>${grades[count+1].credit}<#else>0</#if></td>
               <td align="center" style="font-family:BatangChe"><@displayScore grades[count+1]/></td>
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
         <@table.sortTd width="20%" text="Test outside School" id="otherGrade.category.name"/>
         <td width="20%">Academic Year</td>
         <td width="10%">Term</td>
         <td width="15%">Score</td>
         <@table.sortTd text="Mark System" id="otherGrade.category.markStyle" width="15%"/>
         <td width="10%">Pass/Fail</td>
         <#else>
            <@table.sortTd width="20%" text="Test outside School" id="otherGrade.category.name"/>
         <td width="20%">Academic Year</td>
         <td width="15%">Term</td>
         <td width="20%">Score</td>
            <@table.sortTd text="Mark System" id="otherGrade.category.markStyle"/>
         </#if>
       </tr>
       <#if (reportOther?size!=0)>
       <#list 0..reportOther?size-1 as t>
       <tr>
            <td align="center"><@enName reportOther[t].category/></td>
            <td align="center">${reportOther[t].calendar.year}</td>
            <td align="center">${reportOther[t].calendar.term}</td>
            <#assign scoreValue>${reportOther[t].scoreDisplay}</#assign>
            <td align="center">${(scoreValue == "0" && RequestParameters["zero"]?exists)?string("<b>Absence</b>", scoreValue)}</td>
            <td align="center"><@enName reportOther[t].markStyle/></td>
         <#if RequestParameters["isPassOtherGrade"]?exists>
            <td align="center">${reportOther[t].isPass?string("Pass", "Fail")}</td>
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
                <@table.td text="Academic year,Term"/>
                <@table.td text="Accumulated Credits"/>
                <@table.td text="GPA"/>
                <@table.td text="Academic year,Term"/>
                <@table.td text="Accumulated Credits"/>
                <@table.td text="GPA"/>
                <@table.td text="Academic year,Term"/>
                <@table.td text="Accumulated Credits"/>
                <@table.td text="GPA"/>
                <@table.td text="Academic year,Term"/>
                <@table.td text="Accumulated Credits"/>
                <@table.td text="GPA"/>
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
     
     <#if report_has_next>
         <div style='PAGE-BREAK-AFTER: always'></div> 
     </#if>
</#list>
