<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="myBar" width="100%"></table>
 <table align="center" width="80%"><tr><td>
   <table class="settingTable" border="0">
    <tr>
     <td align="center" colspan="2"><br>
     <font color=red>按照学籍管理规定，选修课（包括公选课、通识类选修课、专业限选课）只需录入期末考查成绩，且一律以中文五级制记分。</font><br>
     </td>
    </tr>
    <form name="gradeStateForm" method="post" onsubmit="return false;" action="">
    <input type="hidden" name="taskId" value="${task.id}"/>
    <tr><td align="right"><@msg.message key="attr.taskNo"/>:</td><td>${task.seqNo}</td></tr>
    <tr><td align="right"><@msg.message key="attr.courseName"/>:</td><td><@i18nName task.course/></td></tr>
    <tr>
        <td align="right">成绩录入方式:</td>
        <td><@htm.i18nSelect datas=markStyles selected=task.gradeState.markStyle.id?string name="gradeState.markStyle.id" style="100px"/></td>
    </tr>
    <tr>
        <td align="right"><@msg.message key="grade.scorePrecision"/>:</td>
        <td>
           <select name="precision">
              <option value="0" <#if task.gradeState.precision=0>selected</#if>><@msg.message key="grade.precision0"/></option>
              <#--
              <option value="1" <#if task.gradeState.precision=1>selected</#if>><@msg.message key="grade.precision1"/></option>
              -->
           </select>
        </td>
    </tr>
    <#list gradeTypes?if_exists?sort_by("priority") as gradeType>
    <tr>
     <td align="right"><@i18nName gradeType/> <@msg.message key="grade.percent"/>:</td>
        <#if percentValue?exists && percentValue != 0>
    <script>document.gradeStateForm["percent${gradeTypes[gradeType_index  - 1].id}"].disabled = "disabled";</script>
        </#if>
     <#assign percentValue = task.gradeState.getPercent(gradeType)?default(0)/>
     <td width="50%"><input name="percent${gradeType.id}" style="width:50px" maxlength="7" value="${percentValue*100}"<#if isAdmin?default(false)><#elseif percentValue != 0> disabled</#if>/>%
       &nbsp;<@msg.message key="grade.percentFormat"/></td>
    </tr>
        <#if isAdmin?default(false)>
        <#elseif percentValue != 0>
    <script>document.gradeStateForm["gradeState.markStyle.id"].disabled = "disabled";</script>
    <script>document.gradeStateForm["precision"].disabled = "disabled";</script>
        </#if>
    </#list>
    <tr><td align="center" colspan="2"><button onclick="saveGradeState()"><@msg.message key="grade.submitStateAndInput"/></button></td></tr>
    </form>
     <tr>
      <td align="center" colspan="2"><br>
   <#--<p align="left" class="STYLE2"><span class="STYLE1"> <font color=red size=3>　　　　　2009－2010学年第二学期国防班必修课程期终成绩的登分说明 </span><br>
        　　由于国防班学生担当世博志愿者，无法参加必修课的期末考试。学校决定，国防生的必修课程考核以其平时成绩作为课程总评成绩。 <br>
        　　成绩录入时， “期末成绩”按“平时成绩”等同录入，系统会自动计算学生的“总评成绩”。 <br>
        　　针对该批学生，系统中在学生姓名后添加了“国防生”的特殊标志，即“姓名（国防生）”。 <br>
        　　请相关课程的授课老师录入成绩的时候按以上要求录入。</font> </p>-->
     </td>
     <tr>
    
   </table>
   </td></tr></table>
   
<script>
    var bar = new ToolBar("myBar","设置录入成绩百分比",null,true,true);
    bar.setMessage('<@getMessage/>');
    bar.addClose();
    var form = document.gradeStateForm;
    function saveGradeState(){
        if (<#if gradePointRules?exists || gradePointRules?size != 0><#list gradePointRules as gradePointRule>form["gradeState.markStyle.id"].value != ${gradePointRule.markStyle.id}<#if gradePointRule_has_next> && </#if></#list><#else>true</#if>) {
            alert("请先配置“" + form["gradeState.markStyle.id"].options[form["gradeState.markStyle.id"].selectedIndex].text + "”的绩点规则。");
            return;
        }
    
        form.action="teacherGrade.do?method=saveGradeState";
        var percent=0;
        <#list gradeTypes?if_exists?sort_by("priority") as gradeType>
        if(!/^\d+$/.test(form['percent${gradeType.id}'].value)){
          alert(form["percent${gradeType.id}"].value +" 不符合要求.");
          return;
        }
        percent += parseInt(form["percent${gradeType.id}"].value);
        </#list>
        if(percent!=100){
           alert("你输入的成绩百分比之和不是100,是:"+percent+"\n请检查.");
           return;
        }
        form.submit();
    }
    </script>
</body>
<#include "/templates/foot.ftl"/>
