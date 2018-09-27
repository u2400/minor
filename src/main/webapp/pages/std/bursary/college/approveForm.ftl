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
	     <td class="content">${gradeAchivement.moralScore!}</td>
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
	     <td width="80%" class="content">${(apply.getStatement(subject)?replace('\n','<br>'))!}</td>
	   </tr>
	   </#list>
   </table>
   <#if  !(apply.approved??)>
   <script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
   <form action="?approve" method="post"   onsubmit="return false;">
   <input type="hidden" name="params" value="&apply.setting.id=${apply.setting.id}"/>
   <input type="hidden" value="${apply.id}" name="apply.id"/>
     <table  width="90%" align="center" class="formTable">
       <tr class="darkColumn">
	    <td align="center" colspan="6">助学金申请审核明细</td>
	   </tr>
       <tr>
          <td class="title" ><font color="red">*</font>辅导员审核结果:</td>
          <td><#if apply.instructorApproved??><#if apply.instructorApproved>同意<#else>不同意</#if>
             <pre>
             ${apply.instructorOpinion}
             </pre>
             <#else>
             辅导员尚未审核
             </#if>
          </td>
       </tr>
       <tr>
          <td class="title" id="f_approved"><font color="red">*</font>审核结果:</td>
          <td>
          <input type="radio" onclick="appendOpinon('同意推荐',this.form,'apply.collegeOpinion')" id="approved_yes" name="apply.collegeApproved" value="1" <#if apply.collegeApproved??><#if apply.collegeApproved>checked</#if></#if>> <label for="approved_yes">同意推荐</label>
          <input type="radio" onclick="appendOpinon('不同意推荐',this.form,'apply.collegeOpinion')" id="approved_no" name="apply.collegeApproved" value="0" <#if apply.collegeApproved??><#if !apply.collegeApproved>checked</#if></#if>> <label for="approved_no">不同意推荐</label>
          </td>
       </tr>
       <tr>
          <td class="title" id="f_opinion">
           <font color="red">*</font>审核意见:
          </td>
          <td>
          <textarea  rows="5" cols="80"  name="apply.collegeOpinion">${apply.collegeOpinion!}</textarea>
          </td>
       </tr>
       <tr align="center" class="darkColumn">
      <td colspan="5">
          <button onclick="save(this.form)" class="buttonStyle">提交</button>
      </td>
     </tr>
     </table>
   </form>
   <script>
   function save(form){
	    var a_fields = {
	         'apply.collegeApproved':{'l':'审核结果', 'r':true, 't':'f_approved'},
	         'apply.collegeOpinion':{'l':'审核意见', 'r':true, 't':'f_opinion',mx:500}
	     };
	     var v = new validator(form , a_fields, null);
	     if (v.exec()) {
	        form.action="bursaryCollege.do?method=approve"
	        form.target = "_self";
	        form.submit();
	     }
     }
    function appendOpinon(text,form,target){
       var o= form[target].value
       if(o.indexOf(text) != 0){
         var commaIdx = o.indexOf(":")
         if(commaIdx<0) form[target].value=(text +":"+ o);
         else  form[target].value=(text +":"+ o.substring(commaIdx+1));
       }
     }
  </script>
  <#else>
    <table  width="90%" align="center" class="formTable">
    <tr>
      <td class="title" width="20%">
     学校审核：
      </td>
      <td>
      ${apply.approved?string("同意","不同意")}
      <pre>${apply.schoolOpinion}
      </td>
    </tr>
  </table>
  </#if>
<script>
    var bar = new ToolBar("myBar", "${apply.std.name}的助学金申请明细", null, true, true);
    bar.setMessage('<@getMessage/>');
    bar.addBack();
</script>
</body>
<#include "/templates/foot.ftl"/>
