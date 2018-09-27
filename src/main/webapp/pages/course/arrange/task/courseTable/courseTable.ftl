<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0" > 
<script language="JavaScript" type="text/JavaScript" src="scripts/course/TaskActivity.js"></script> 
<script>
    function fillTable(table,weeks,units,tableIndex){
       for(var i=0;i<weeks;i++){
            for(var j=0;j<units-1;j++){
                var index =units*i+j;
                var preTd=document.getElementById("TD"+index+"_"+tableIndex);
                var nextTd=document.getElementById("TD"+(index+1)+"_"+tableIndex);
                while(table.marshalContents[index]!=null&&table.marshalContents[index+1]!=null&&table.marshalContents[index]==table.marshalContents[index+1]){
                    preTd.parentNode.removeChild(nextTd);
                    var spanNumber = new Number(preTd.colSpan);
                    spanNumber++;
                    preTd.colSpan=spanNumber;
                    j++;
                    if(j>=units-1){
                        break;
                    }
                    index=index+1;
                    nextTd=document.getElementById("TD"+(index+1)+"_"+tableIndex);
                }
            }
        }
        
        for(var k=0;k<table.unitCounts;k++){
             var td=document.getElementById("TD"+k+"_"+tableIndex);
             if(td != null&&table.marshalContents[k]!=null){
                td.innerHTML = table.marshalContents[k];
                td.style.backgroundColor="#94aef3";
                td.className="infoTitle";
             }
        }
    }
    
   function courseInfo(courseId) {
        var form = document.actionForm;
        form.action = "teachTaskSearch.do?method=courseInfo";
        form["courseId"].value = courseId;
        form.target = "_blank";
        form.submit();
    }
</script>
<#if RequestParameters['ignoreHead']?exists>
<#else>
<table id="courseTableBar" width="100%"></table>
<script>
   var bar = new ToolBar("courseTableBar","<@bean.message key="courseTable.printTitle" arg0=(courseTableList?size)?string/>",null,true,true);
   bar.addItem("<@msg.message "action.print"/>","print()");
</script>
</#if>
   <#assign taskPageMap={'std':'taskListOfStd','class','taskListOfClass','teacher':'taskListOfTeacher','room':'taskListOfRoom'}>
   <#assign fontSize=setting.fontSize>
   <#list courseTableList?if_exists as table>
        <#if RequestParameters['ignoreHead']?exists>
        <#else>
           <#assign labInfo><@i18nName table.resource/></#assign>
            <#include "courseTableHead.ftl"/>
        </#if>
        <#assign tableIndex>${table_index}</#assign>
        <#if userCategory == 3 || userCategory != 3 && switch?exists && switch.isPublished>
            <#assign activityList=table.activities>
        </#if>
        <#include "courseTableContent_simple.ftl"/>
        <#include "courseTableRemark.ftl"/>
        
        <#if !setting.ignoreTask>
            <#assign taskList=table.tasks>
            <#include "${taskPageMap[table.kind]}.ftl"/>
        </#if>
        <#if table.kind=="room">
            <#if table_has_next&&(table_index+1)%2=0>
            <div style='PAGE-BREAK-BEFORE: always'></div>
            </#if>
        <#else>
            <#if table_has_next><div style='PAGE-BREAK-AFTER: always'></div> </#if>
        </#if>
        <#include "courseTableFoot.ftl"/>
        <#if table.kind=="teacher">
            <font color="red" size='4'>注：由于学生退课及系统随机筛选等原因，选课期间课程人数实时变动，课程真实选课人数以下学期开学初最后一轮选课结束后为准。<br></font>
                <br><br>
        </#if>
   </#list>
   <form method="post" action="" name="actionForm" onsubmit="return false;">
        <#--下面的两个仅课程使用-->
        <input type="hidden" name="courseId" value=""/>
        <input type="hidden" name="type" value="course"/>
    </form>
<#include "/templates/foot.ftl"/>