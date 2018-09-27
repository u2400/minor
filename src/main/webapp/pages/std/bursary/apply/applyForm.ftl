<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
 <#assign errorInfoCnt=0>
<table id="myBar" width="100%"></table>
    <table width="85%" align="center" class="formTable">
       <tr class="darkColumn">
         <td align="center" colspan="4">个人信息核对</td>
       </tr>
       <tr>
        <td class="title" width="15%">&nbsp;<@msg.message key="attr.personName"/>：</td>
        <td width="35%"><@i18nName std?if_exists/>&nbsp;</td>
        <td class="title" width="17%">&nbsp;<@msg.message key="attr.stdNo"/>：</td>
        <td>${std.code?if_exists}</td>
       </tr>
       <tr>
        <td class="title" >&nbsp;<@msg.message key="entity.department"/>：</td>
        <td><@i18nName (std.department)?if_exists/></td>
        <td class="title" >&nbsp;<@msg.message key="attr.year2year"/>：</td>
        <td>${setting.toSemester.year?if_exists}</td>
       </tr>    
       <tr>
        <td class="title" >&nbsp;<@msg.message key="entity.speciality"/>：</td>
        <td><@i18nName (std.firstMajor)?if_exists/></td>
        <td class="title" >&nbsp;<@msg.message key="entity.specialityAspect"/>：</td>
        <td><@i18nName (std.firstAspect)?if_exists/></td>
       </tr>
       <tr>
        <td class="title">&nbsp;民族：</td>
        <td><#if std.basicInfo.nation??>${std.basicInfo.nation.name}<#else><#assign errorInfoCnt = errorInfoCnt +1></#if></td>
        <td class="title">&nbsp;政治面貌：</td>
        <td><#if std.basicInfo.politicVisage??>${std.basicInfo.politicVisage.name}<#else><#assign errorInfoCnt = errorInfoCnt +1></#if></td>
       </tr>
       <tr>
             <td class="title"><@msg.message key="attr.mobile"/>：</td>
             <td><#if std.basicInfo.mobile??>${std.basicInfo.mobile}<#else><#assign errorInfoCnt = errorInfoCnt +1></#if></td>
             <td class="title"><@msg.message key="attr.email"/>：</td>
             <td><#if std.basicInfo.mail??>${std.basicInfo.mail}<#else><#assign errorInfoCnt = errorInfoCnt +1></#if></td>
       </tr>
       <tr>
            <td class="title">生源地：</td>
            <td ><#if std.studentStatusInfo.originalAddress??>${std.studentStatusInfo.originalAddress}<#else><#assign errorInfoCnt = errorInfoCnt +1></#if></td>
            <td class="title">注意：</td>
            <td>如信息有误，请<a href="stdDetail.do">进入个人信息页面</a>申请修改</td>
       </tr>
      </table>
      
     <form name="actionForm" action="?method=edit" method="post">
       <input type="hidden" name="apply.setting.id" value="${setting.id}">
         <table width="85%" align="center" class="formTable">
         <tr class="darkColumn">
           <td align="center" colspan="4">助学金申请</td>
         </tr>
         <tr>
          <td class="title">&nbsp;起始时间：</td>
          <td>${setting.beginAt?string("yyyy-MM-dd HH:mm")}</td>
          <td class="title">&nbsp;结束时间：</td>
          <td>${setting.endAt?string("yyyy-MM-dd HH:mm")}</td>
         </tr>
         <tr>
          <td class="title">&nbsp;选择奖项：</td>
          <td colspan="3">
            <#if awards?size==0>
              <font color="red">您已经申请了所有开放的奖项。</font>
            <#else>
             <select name="apply.award.id"  style="width:400px">
               <#list awards as award>
               <option value="${award.id}">${award.name}</option>
               </#list>
             </select>
             <#if errorInfoCnt==0>
             <input type="submit" value="开始申请" />
             <#else>
             个人信息有${errorInfoCnt}空缺，请<a href="stdDetail.do">进入个人信息页面</a>申请修改。
             </#if>
           </#if>
          </td>
         </tr>
       </table>
  </form>
<script>
    var bar = new ToolBar("myBar", "助学金申请", null, true, true);
    bar.setMessage('<@getMessage/>');
    bar.addBack();
</script>
</body>
<#include "/templates/foot.ftl"/>
