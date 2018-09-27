<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="myBar" width="100%"></table>
     <table  width="90%" align="center" class="formTable">
       <tr class="darkColumn">
	    <td align="center" colspan="6">${apply.award.name} 助学金申请明细</td>
	   </tr>
       <tr>
	     <td class="title">学号</td>
	     <td class="content" width="20%"> ${apply.std.code}</td>
	     <td class="title">姓名:</td>
	     <td class="content">${apply.std.name}</td>
	     <td class="title">年级:</td>
	     <td class="content">${apply.std.grade}</td>
	   </tr>
	   <tr>
	     <td class="title">学院</td>
	     <td class="content" width="20%">${apply.std.department.name}</td>
	     <td class="title">专业:</td>
	     <td class="content">${(apply.std.major.name)!}</td>
	     <td class="title">班级:</td>
	     <td class="content">${(apply.std.firstMajorClass.name)!}</td>
	   </tr>
	   <tr>
	     <td class="title">手机</td>
	     <td class="content" width="20%">${apply.std.basicInfo.mobile?default('　')?html}</td>
	     <td class="title">邮箱:</td>
	     <td class="content" colspan="3">${apply.std.basicInfo.mail?default('　')?html}</td>
	   </tr>
	   <tr>
	     <td class="title">政治面貌</td>
	     <td class="content" width="20%">${(apply.std.basicInfo.politicVisage.name)!}</td>
	     <td class="title">民族:</td>
	     <td class="content">${(apply.std.basicInfo.nation.name)!}</td>
	     <td class="title">生源地:</td>
	     <td class="content">${(apply.std.studentStatusInfo.originalAddress)?html}</td>
	   </tr>
	   <#if apply.gradeAchivement??>
	    <#assign gradeAchivement = apply.gradeAchivement>
	   <tr>
	     <td class="title">德育分数:</td>
	     <td class="content">${gradeAchivement.moralScore!} 班级第${apply.moralGradeClassRank}名</td>
	     <td class="title">智育分数:</td>
         <td class="content">${gradeAchivement.ieScore!}
          <#if (gradeAchivement.ieScore?default(0)>0)>${gradeAchivement.iePassed?string("全部及格","有不及格")}</#if>
         </td>
	     <td class="title">体育分数:</td>
         <td class="content">${gradeAchivement.peScore!}
          <#if (gradeAchivement.peScore?default(0)>0)>${gradeAchivement.pePassed?string("全部及格","有不及格")}</#if>
         </td>
	   </tr>
	   <tr>
	     <td class="title">总分:</td>
         <td class="content"><span style="font-size:15pt">${gradeAchivement.score!}</span> <#if gradeAchivement.confirmed>结果已经冻结<#else><font color='red'>尚未最终确认</font></#if></td>
	     <td class="title">绩点:</td>
         <td class="content">${(gradeAchivement.gpa?string("0.###"))!}</td>
	     <td class="title">英语四级:</td>
	     <td class="content">${gradeAchivement.cet4Score!}
	      <#if gradeAchivement.cet4Score?exists>${gradeAchivement.cet4Passed?string("","没通过")}</#if>
	     </td>
	   </tr>
	   </#if>
      </table>
      
      <table width="90%" align="center" class="formTable">
	   <tr>
	     <td class="title">申请奖项:</td>
	     <td class="content">${apply.award.name}</td>
	   </tr>
	   <#if apply.attachment??>
	   <tr>
	      <td class="title">附件：</td>
	      <td class="content"><a href="?method=attachment&apply.id=${apply.id}">${apply.attachmentDisplayName}</a></td>
	   </tr>
	   </#if>
	   <#list apply.award.subjects as subject>
	   <tr>
	     <td width="20%" class="title">${subject.name}:</td>
	     <td width="80%" class="content" >${(apply.getStatement(subject)?replace('\n','<br>'))!}</td>
	   </tr>
	   </#list>
	   <#if apply.instructorOpinion??>
	   <tr>
	     <td class="title">辅导员审核意见:</td>
	     <td class="content">${apply.instructorOpinion!}</td>
	   </tr>
	   </#if>
	   <#if apply.collegeApproved??>
	   <tr>
	     <td class="title">院系审核意见:</td>
	     <td class="content">${apply.collegeOpinion!}</td>
	   </tr>
	   </#if>
	   <#if apply.approved??>
	   <tr>
	     <td class="title">学校评审意见:</td>
	     <td class="content">${apply.schoolOpinion!}</td>
	   </tr>
	   </#if>
   </table>
<script>
    var bar = new ToolBar("myBar", "${apply.std.name}的助学金申请明细", null, true, true);
    bar.setMessage('<@getMessage/>');
    bar.addBack();
</script>
</body>
<#include "/templates/foot.ftl"/>
