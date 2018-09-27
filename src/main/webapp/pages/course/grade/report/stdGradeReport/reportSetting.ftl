<div id="reportSetting" style="display:none;width:650px;height:230px;position:absolute;top:28px;right:0px;border:solid;border-width:1px;background-color:white">
 <table class="settingTable">
   <tr>
     <input type="hidden" name="reportSetting.majorType.id" value="${RequestParameters['majorTypeId']}" >
     <input type="hidden" name="orderBy" value="${RequestParameters['orderBy']?default('null')}">
     <td style="width:14%">&nbsp;<@msg.message key="grade.printTemplate"/>：</td>
     <td colspan="2" width="30%">
        <select name="reportSetting.template" style="width:190px">
            <option value="default" selected>默认模板（居中）</font>
            <option value="print">打印模板（归档）</font>
            <option value="english">English Transcript</font>
            <option value="print1">打印模板（归档1）</option>
            <option value="single">缺省模板（无院系、专业）</font>
        </select>
     </td>
       <td>&nbsp;<@msg.message key="grade.printScope"/>：</td>
       <td><input type="radio" value="0" name="reportSetting.gradePrintType"><@msg.message key="grade.pass"/>
           <input type="radio" name="reportSetting.gradePrintType" value="1"><@msg.message key="grade.all"/>
           <input type="radio" value="2" name="reportSetting.gradePrintType" checked>最好成绩
       </td>
   </tr>
   <tr>
     <td colspan="5" style="height:5px;font-size:0px;">
       <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
     </td>
   </tr>
   <tr>
       <td id="f_pageSize" colspan="2">&nbsp;<@msg.message key="common.maxRecodesEachPage"/><font color="red">*</font>：</td>
       <td><input value="100" type="text" maxlength="5" style="width:50px" name="reportSetting.pageSize"/></td>
       <td id="f_fontSize">&nbsp;<@msg.message key="common.foneSize"/><font color="red">*</font>：</td>
       <td><input type="text" name="reportSetting.fontSize" value="11" style="width:50px" maxlength="2"/>px</td>
   </tr>
   <tr>
     <td colspan="5" style="height:5px;font-size:0px;">
       <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
     </td>
   </tr>
   <tr>
       <td>&nbsp;打印绩点：</td>
       <td colspan="2">
         <input type="radio" value="1" name="reportSetting.printGP" checked><@msg.message key="yes"/> 
         <input type="radio" name="reportSetting.printGP" value="0"/><@msg.message key="no"/>
       </td>
       <td>&nbsp;<@msg.message key="grade.deploy"/>：</td>
       <td>
           <input type="radio" value="1" name="reportSetting.published" checked/><@msg.message key="grade.beenDeployed"/>
           <input type="radio" value="0" name="reportSetting.published"/><@msg.message key="grade.all"/>
       </td>
   </tr>
   <tr>
     <td colspan="5" style="height:5px;font-size:0px;">
       <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
     </td>
   </tr>
   <tr>
       <td>&nbsp;<@msg.message key="grade.sort"/>：</td>
       <td><select name="reportSetting.order.property" >
            <option value="calendar.yearTerm"><@msg.message key="attr.yearTerm"/></option>
            <option value="course.name"><@msg.message key="attr.courseName"/></option>
            <option value="credit"><@msg.message key="attr.credit"/></option>
           </select>
       </td>
       <td>
           <@msg.message key="common.order"/>:
           <select name="reportSetting.order.direction">
            <option value="1"><@msg.message key="action.asc"/></option>
            <option value="2"><@msg.message key="action.desc"/></option>
           </select>
       </td>
       <td>&nbsp;<@msg.message key="grade.printType"/>：</td>
       <td>
          <select name="reportSetting.gradeType.id">
            <#list gradeTypes?sort_by("code") as gradeType>
            <option value="${gradeType.id}"><@i18nName gradeType/></option>
            </#list>
           </select>
       </td>
   </tr>
   <tr>
     <td colspan="5" style="height:5px;font-size:0px;">
       <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
     </td>
   </tr>
   <tr>
     <td>&nbsp;校外考试：</td>
     <td colspan="2">
         <input type="radio" value="1" name="reportSetting.printOtherGrade" checked/>是
         <input type="radio" value="0" name="reportSetting.printOtherGrade"/>否
     </td>
     <td>&nbsp;打印学期绩点：</td>
     <td>
         <input type="radio" value="1" name="reportSetting.printTermGP" checked/>是
         <input type="radio" value="0" name="reportSetting.printTermGP"/>否
     </td>
   </tr>
   <tr>
     <td colspan="5"  style="height:5px;font-size:0px;">
       <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
     </td>
   </tr>
   <tr>
     <td>&nbsp;成绩的显示：</td>
     <td colspan="4"><input type="checkbox" name="isPassOtherGrade" value="1" checked/>校外考试“是否合格”&nbsp;<input type="checkbox" name="showAbsence" value="1" checked/>无成绩显示“缺考”<input type="checkbox" name="zero" value="1" checked/>0分显示“缺考”</td>
   </tr>
   <tr>
     <td colspan="5"  style="height:5px;font-size:0px;">
       <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
     </td>
   </tr>
   <tr>
     <td>&nbsp;<@msg.message key="common.printPerson"/>：</td>
     <td colspan="2"><input name="reportSetting.printBy" value="" style="width:100px" maxlength="20"/></td>
     <td>&nbsp;打印日期：</td>
     <td><input name="reportSetting.printAt" value="${RequestParameters["reportSetting.printAt"]?default(printAt?string("yyyy-MM-dd"))}" onfocus="calendar()" style="width:100px"/>（默认当天）<input type="checkbox" name="isShowPrintAt" value="1" checked/>显示
</td>
   </tr>
   <#--
   <tr>
     <td colspan="5"  style="height:5px;font-size:0px;">
       <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
     </td>
   </tr>
   <tr>
     <td>&nbsp;<@msg.message key="common.printPerson"/>：</td>
     <td><input name="reportSetting.printBy" value="" style="width:100px" maxlength="20"/></td>
     <td><input type="checkbox" name="isShowPrintBy" value="1"/>显示</td>
     <td>&nbsp;院长/系主任：</td>
     <td colspan="2"><input name="reportSetting.prior" value="" style="width:100px" maxlength="20"/>&nbsp;<input type="checkbox" name="isShowPrior" value="1"/>显示</td>
   </tr>
   <tr>
     <td colspan="5"  style="height:5px;font-size:0px;">
       <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
     </td>
   </tr>
   <tr>
     <td>&nbsp;教务处长：</td>
     <td><input name="reportSetting.chief" value="" style="width:100px" maxlength="20"/></td>
     <td><input type="checkbox" name="isShowChief" value="1"/>显示</td>
     <td>&nbsp;打印日期：</td>
     <td><input name="reportSetting.printAt" value="${RequestParameters["reportSetting.printAt"]?default(printAt?string("yyyy-MM-dd"))}" onfocus="calendar()" style="width:100px" maxlength="10"/>（默认当天）&nbsp;<input type="checkbox" name="isShowPrintAt" value="1" checked/>显示</td>
   </tr>
   -->
   <tr>
     <td colspan="5"  style="height:5px;font-size:0px;">
       <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
     </td>
   </tr>
   <tr>
    <td colspan="5">&nbsp;<@msg.message key="grade.stdGradeReport.tip"/></td>
   </tr>
   <tr align="center">
      <td colspan="5"><button onclick="printGrade();closeSetting()" class="buttonStyle" accesskey="P"><@msg.message key="action.preview"/>(<U>P</U>)</button>
         &nbsp;<button accesskey="c" class="buttonStyle" onclick="closeSetting();"><@msg.message key="action.close"/>(<U>C</U>)</button></td>
   </tr>
 </table>
  <script>
    function displaySetting(){
       if(reportSetting.style.display=="block"){
           reportSetting.style.display='none';
       }else{
           reportSetting.style.display="block";
           f_frameStyleResize(self);
       }
    }
    function closeSetting(){
       reportSetting.style.display='none';
    }
  </script>
 </div>
