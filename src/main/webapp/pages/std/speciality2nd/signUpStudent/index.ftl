<#include "/templates/head.ftl"/>
<BODY>
<table id="backBar"></table>
  <table  width="100%" class="frameTable_title">
     <tr>
       <td class="infoTitle"><@bean.message key="info.searchForm"/></td>
       <td>|</td>
       <form name="searchForm" method="post" action="speciality2ndSignUpStudent.do?method=index" onsubmit="return false;">
       <td class="infoTitle">
	     <select name="signUpStd.setting.id" onchange="search()" style="width:200px">
	        <#list settings as setting>
	         <option value="${setting.id}" <#if RequestParameters['signUpStd.setting.id']?default("")==setting.id?string> <#assign signUpSetting=setting>selected</#if>>${setting.name}</option>
	        </#list>
	     </select>
	     <#if signUpSetting?exists><#elseif settings?size!=0><#assign signUpSetting=settings?first></#if>
	   </td>  
       <#include "/pages/course/calendar.ftl"/>
   </tr>
  </table>
  <table class="frameTable" height="85%">
    <tr>
     <td class="frameTable_view" style="width:160px">
     <#include "searchForm.ftl"/>
        <input type="hidden" name="isYear" value="1"/>
        <input type="hidden" name="isYearInAllTerm" value=""/>
        <input type="hidden" name="fileName" value=""/>
        <input type="hidden" name="keys" value=""/>
        <input type="hidden" name="titles" value=""/>
     </td>
     </form>
     <td valign="top">
	     <iframe src="#" id="contentListFrame" name="contentListFrame" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" height="100%" width="100%"></iframe>
     </td>
  </tr>
 <script>
   var bar = new ToolBar('backBar','辅修专业报名管理',null,true,true);
   bar.setMessage('<@getMessage/>');
   <#if (settings?size>0)>
   bar.addItem("报名录取统计","specialitySettingList()",null,"统计各个专业的报名和录取信息");
   bar.addItem("自动录取","autoMatriculate()");
   bar.addItem("自动分班","autoAssignClass()");
   </#if>
   var menu1 = bar.addMenu("年度导出", "exportData1()");
   menu1.addItem("长三角导出", "exportData2()");
   
   var action="speciality2ndSignUpStudent.do";
   var form=document.searchForm;
   
   function search(){
       <#if (settings?size>0)>
	    form.action=action+"?method=search&orderBy=signUpStd.std.code asc";
  	    form.target="contentListFrame";
   	    form.submit();
   	    <#else>
        alert("没有报名设置,不能查询");
        </#if>
    }
   search();
   
   function autoMatriculate(){
      form.action=action+"?method=matriculateSetting";
      form.submit();
   }
   function autoAssignClass(){
      form.action=action+"?method=assignClassSetting";
      form.submit();
   }
   function specialitySettingList(){
      form.action=action+"?method=specialitySettingList&orderBy=[0].limit desc";
      form.submit();
   }
   
    function exportData1(){
        form.action=action+"?method=export";
        form.target = "_self";
        form["isYearInAllTerm"].value = "0";
        form["fileName"].value = "<@i18nName systemConfig.school/>${calendar.start?string("yyyy")}年度辅修报名汇总表";
        form["keys"].value = "seqNo,std.code,std.name,std.gender.name,std.firstMajor.name,std.firstMajor.subjectCategory.name,std.studentStatusInfo.examineeNumber,std.basicInfo.idCard,record[1].school.name,record[1].specialitySetting.speciality.name,record[2].specialitySetting.speciality.name,GPA,std.basicInfo.mobile,std.basicInfo.homeAddress";
        form["titles"].value = "序号,学号,姓名,性别,主修专业,所属学科门类,高考报名号,身份证号,申请学校,第一志愿,第二志愿,平均绩点,手机号码,联系地址";
        form.submit();
    }
   
    function exportData2(){
        form.action=action+"?method=export";
        form.target = "_self";
        form["isYearInAllTerm"].value = "1";
        form["fileName"].value = "长三角交换生计划汇总表（${calendar.year}学年）";
        form["keys"].value = "seqNo,thisSchool,std.code,std.name,thisSchool,std.department.name,std.firstMajor.name,std.enrollYear,std.gender.name,std.basicInfo.birthday,std.basicInfo.politicVisage.name,std.basicInfo.nation.name,std.basicInfo.ancestralAddress,std.studentStatusInfo.originalAddress,std.basicInfo.idCard,std.basicInfo.phone_mobile,std.basicInfo.mail,record[1].specialitySetting.speciality.name,GPA";
        form["titles"].value = "序号,派出学校,学号,姓名,学校,院系,专业,当前年级,性别,出生日期,政治面貌,民族,籍贯,出生地,身份证号码,联系电话,电子邮件,申请学校、专业第一志愿,备注（绩点）";
        form.submit();
    }
 </script>
</body>
<#include "/templates/foot.ftl"/> 