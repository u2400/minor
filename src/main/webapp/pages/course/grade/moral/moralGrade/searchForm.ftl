	<table  width="100%">
	    <tr>
	      <td  class="infoTitle" align="left" valign="bottom">
	       <img src="images/action/info.gif" align="top"/>
	          <B>详细查询(模糊输入)</B>      
	      </td>
	    </tr>
	    <tr>
	      <td  colspan="8" style="font-size:0px">
	          <img src="images/action/keyline.gif" height="2" width="100%" align="top">
	      </td>
	   </tr>
	  </table>
    <table   width='100%'  class="searchTable"  onkeypress="DWRUtil.onReturn(event, search)">	    
        <input type="hidden" name="pageNo" value="1"/>
    	<tr>
	     <td  class="infoTitle" width="35%"><@bean.message key="attr.stdNo"/>:</td>
	     <td>
	      <input type="text" name="moralGrade.std.code" maxlength="32" size="10" value="${RequestParameters['student.code']?if_exists}"/>
	     </td>
		</tr>
    	<tr>
	     <td class="infoTitle"><@msg.message key="attr.personName"/>:</td>
	     <td>
	      <input type="text" name="moralGrade.std.name" maxlength="20" size="10" value="${RequestParameters['student.name']?if_exists}"/>
	     </td>
		</tr>
	   <tr>
	     <td class="infoTitle">就读年级:</td>
	     <td ><input type="text" name="moralGrade.std.enrollYear" maxlength="7" id='student.enrollYear' style="width:60px;"></td>
	   </tr>
       <tr> 
	     <td class="infoTitle"><@bean.message key="entity.studentType"/>:</td>
	     <td >
	          <select id="stdTypeOfSpeciality" name="moralGrade.std.type.id" style="width:100px;">               
	            <option value="${RequestParameters['student.type.id']?if_exists}"><@bean.message key="filed.choose"/></option>
	          </select>	 
         </td>
		</tr>
    	<tr>
	     <td class="infoTitle"><@bean.message key="common.college"/>:</td>
	     <td >
           <select id="department" name="department.id"  style="width:100px;" >
         	  <option value=""><@bean.message key="filed.choose"/>...</option>
           </select>
         </td>       
        </tr> 
	   <tr>
	     <td class="infoTitle"><@bean.message key="entity.speciality"/>:</td>
	     <td >
           <select id="speciality" name="speciality.id"  style="width:100px;" >
         	  <option value=""><@bean.message key="filed.choose"/>...</option>
           </select>     	             
         </td>
        </tr>
	   <tr>
	     <td class="infoTitle"><@bean.message key="entity.specialityAspect"/>:</td>
	     <td >
           <select id="specialityAspect" name="specialityAspect.id"  style="width:100px;" >
         	  <option value=""><@bean.message key="filed.choose"/>...</option>
           </select>
         </td>
        </tr>
        <tr> 
         <td class="infoTitle">班级:</td>
         <td><input name="adminClassName" type="text" value="${RequestParameters["adminClassName"]?if_exists}" style="width:100px" maxlength="32"/></td>
        </tr>
        <tr> 
         <td class="infoTitle">德育分数:</td>
         <td>
            <input name="score1" type="text" value="${RequestParameters["score1"]?if_exists}" style="width:40px" maxlength="32"/>
            -
            <input name="score2" type="text" value="${RequestParameters["score2"]?if_exists}" style="width:40px" maxlength="32"/>
         </td>
        </tr> 
        <tr>
	     <td class="infoTitle">状态:</td>
	     <td>
	       <select name="moralGrade.status" style="width:100px;">
  	         <option value="">全部</option>
	         <option value="0"><@msg.message key="action.new"/></option>
	         <option value="1">录入确认</option>
	         <option value="2">已发布</option>
	      </select>
         </td>
        </tr>
       <tr>
	     <td class="infoTitle">是否通过:</td>
	     <td >
	     <select name="isPass" id="isPass" style="width:100px;">
	        <option value="">全部</option>
	        <option value="1">通过</option>
	        <option value="0">未通过</option>
	      </select>
         </td>
       </tr>
	    <tr align="center">
	     <td colspan="2">
		     <button  onClick="search(1)" style="width:60px"><@bean.message key="action.query"/></button>
	     </td>               
	    </tr>
    </form>
  </table> 
<#include "/templates/stdTypeDepart3Select.ftl"/>
<script>
    sds.firstSpeciality=1;
</script> 