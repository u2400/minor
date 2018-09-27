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
    <form name="stdSearch" method="post" action="" onsubmit="return false;">
        <input type="hidden" name="pageNo" value="1"/>
        <input name="courseGrade.majorType.id" value="2" type="hidden"/>
    	<tr>
	     <td  class="infoTitle" width="35%"><@bean.message key="attr.stdNo"/>:</td>
	     <td>
	      <input type="text" name="courseGrade.std.code" maxlength="32" size="10" value="${RequestParameters['student.code']?if_exists}"/>
	     </td>
		</tr>
    	<tr>
	     <td class="infoTitle"><@msg.message key="attr.personName"/>:</td>
	     <td>
	      <input type="text" name="courseGrade.std.name" maxlength="20" size="10" value="${RequestParameters['student.name']?if_exists}"/>
	     </td>
		</tr>
	   <tr>
	     <td class="infoTitle">就读年级:</td>
	     <td><input type="text" name="courseGrade.std.enrollYear" maxlength="7" id='student.enrollYear' style="width:60px;"></td>
	   </tr>
       <tr> 
	     <td class="infoTitle"><@bean.message key="entity.studentType"/>:</td>
	     <td>
	          <select id="stdTypeOfSpeciality" name="courseGrade.std.type.id" style="width:100px;">               
	            <option value="${RequestParameters['student.type.id']?if_exists}"><@bean.message key="filed.choose"/></option>
	          </select>	 
         </td>
		</tr>
    	<tr>
	     <td class="infoTitle"><@bean.message key="common.college"/>:</td>
	     <td>
           <select id="department" name="department.id"  style="width:100px;" >
         	  <option value=""><@bean.message key="filed.choose"/>...</option>
           </select>
         </td>       
        </tr> 
	   <tr>
	     <td class="infoTitle"><@bean.message key="entity.speciality"/>:</td>
	     <td>
           <select id="speciality" name="speciality.id"  style="width:100px;" >
         	  <option value=""><@bean.message key="filed.choose"/>...</option>
           </select>     	             
         </td>
        </tr>
	   <tr>
	     <td class="infoTitle"><@bean.message key="entity.specialityAspect"/>:</td>
	     <td>
           <select id="specialityAspect" name="specialityAspect.id"  style="width:100px;" >
         	  <option value=""><@bean.message key="filed.choose"/>...</option>
           </select>
         </td>
        </tr>
        <tr>
		   <td class="infoTitle" style="width:60px;"><@bean.message key="attr.year2year"/>:</td>
		   <td style="width:100px;">
		     <select id="year" name="courseGrade.calendar.year"  style="width:100px;">                
		        <option value=""></option>
		      </select>
		   </td>
      </tr>
      <tr>
	    <td class="infoTitle" style="width:50px;"><@bean.message key="attr.term"/>:</td>
	    <td style="width:50px;">     
	     <select id="term" name="courseGrade.calendar.term" style="width:80px;">
	        <option value=""></option>
	      </select>
	   </td>
	   </tr>
    	<tr>
	     <td class="infoTitle"><@msg.message key="attr.taskNo"/>:</td>
	     <td>
	      <input type="text" name="courseGrade.taskSeqNo" value="" style="width:100px;" maxlength="32"/>
         </td>
        </tr>
    	<tr>
	     <td class="infoTitle"><@msg.message key="attr.courseNo"/>:</td>
	     <td>
	      <input type="text" name="courseGrade.course.code" value="" style="width:100px;" maxlength="32"/>
         </td>
        </tr>
    	<tr>
	     <td class="infoTitle"><@msg.message key="attr.courseName"/>:</td>
	     <td>
	      <input type="text" name="courseGrade.course.name" value="" style="width:100px;" maxlength="20"/>
         </td>
        </tr>
	    <tr align="center">
	     <td colspan="2">
		     <button  class="buttonStyle" onClick="search(1)" style="width:60px"><@bean.message key="action.query"/></button>
	     </td>               
	    </tr>
    </form>
  </table> 
<#include "/templates/stdTypeDepart3Select.ftl"/>  
<script src='dwr/interface/calendarDAO.js'></script>
<script src='scripts/common/CalendarSelect.js'></script>
<script>
    var stdTypeArray = new Array();
    <#list stdTypeList as stdType>
    stdTypeArray[${stdType_index}]={'id':'${stdType.id?if_exists}','name':'<@i18nName stdType/>'};
    </#list>
    var dd = new CalendarSelect("stdTypeOfSpeciality","year","term",false,true,false);
    dd.init(stdTypeArray);
    sds.firstSpeciality=2;
    
    function changeSpecialityType(event){
       var select = getEventTarget(event);
       sds.firstSpeciality=select.value;
       fireChange($("department"));
    }
</script> 