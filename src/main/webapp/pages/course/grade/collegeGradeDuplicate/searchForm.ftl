       <table width="100%">
        <tr>
          <td class="infoTitle" align="left" valign="bottom">
           <img src="images/action/info.gif" align="top"/>
              <B>详细查询(模糊输入)</B>
          </td>
        </tr>
        <tr>
          <td colspan="8" style="font-size:0px">
              <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
          </td>
       </tr>    
      </table>
      <table class="searchTable"  onkeypress="DWRUtil.onReturn(event, searchTask)">
        <tr> 
         <td class="infoTitle"><@bean.message key="attr.taskNo"/>:</td>
         <td><input name="task.seqNo" type="text" value="${RequestParameters["task.seqNo"]?if_exists}" style="width:100px" maxlength="32"/></td>
        </tr>
        <tr>
         <td class="infoTitle"><@bean.message key="attr.courseNo"/>:</td>
         <td><input name="task.course.code" type="text" value="${RequestParameters["task.course.code"]?if_exists}" style="width:100px" maxlength="32"/></td>
        </tr>
        <tr>
         <td class="infoTitle"><@bean.message key="attr.courseName"/>:</td>
         <td><input type="text" name="task.course.name" value="${RequestParameters["task.course.name"]?if_exists}" style="width:100px" maxlength="20"/></td>
        </tr>
        <tr>
         <td class="infoTitle"><@bean.message key="entity.courseType"/>:</td>
         <td><select name="task.courseType.id" style="width:100px" value=" value="${RequestParameters["task.courseType.id"]?if_exists}"">
                <option value=""><@bean.message key="common.all"/></option>
                <#list sort_byI18nName(courseTypes) as courseType>
                    <#if (courseType.isPractice)?default(false)>
                <option value=${courseType.id}><@i18nName courseType/></option>
                    </#if>
                </#list>
             </select>
         </td>
        </tr>
        <tr>
         <td class="infoTitle"><@bean.message key="attr.teachDepart"/>:</td>
         <td>
             <select name="task.arrangeInfo.teachDepart.id" value="${RequestParameters["task.arrangeInfo.teachDepart.id"]?if_exists}" style="width:100px">
                <option value=""><@bean.message key="common.all"/></option>
                <#list sort_byI18nName(teachDepartList) as teachDepart>
                <option value=${teachDepart.id}><@i18nName teachDepart/></option>
                </#list>
             </select>
         </td>
        </tr>
        <tr>
         <td class="infoTitle"><@bean.message key="entity.teacher"/>:</td>
         <td><input type="text" name="teacher.name" value="${RequestParameters["teacher.name"]?if_exists}" style="width:100px" maxlength="20"/>
         </td>
        </tr>
        <tr>
         <td class="infoTitle"><@bean.message key="attr.enrollTurn"/>:</td>
         <td><input type="text" name="task.teachClass.enrollTurn" value="${RequestParameters["task.teachClass.enrollTurn"]?if_exists}" maxlength="7" style="width:100px"></td>
        </tr>
        <tr>
         <td class="infoTitle"><@bean.message key="entity.studentType"/>:</td>
         <td><@htm.i18nSelect datas=calendarStdTypes selected=RequestParameters["task.teachClass.stdType.id"]?default("") name="task.teachClass.stdType.id"  style="width:100px">
                <option value=""><@bean.message key="common.all"/></option>
             </@>
         </td>
        </tr>
        <tr>
         <td class="infoTitle"><@msg.message key="attr.credit"/>:</td>
         <td><input type="text" name="task.course.credits" value="${RequestParameters["task.course.credits"]?if_exists}" style="width:100px" maxlength="2" maxlength="3"/>
         </td>
        </tr>
        <tr>
         <td class="infoTitle">期末成绩:</td>
         <td>
             <select name="gradeState.confirmGA" value="" style="width:100px">
                <option value="0">两次以下</option>
                <option value="1">录入两次</option>
             </select>
         </td>
        </tr>
        <input type ="hidden" name="task.courseType.isPractice" value="1"/>
        <tr align="center" height="50px">
         <td colspan="2">
             <button onClick="if(validateInput(this.form)){searchTask();}" accesskey="Q" class="buttonStyle" style="width:60px">
               <@bean.message key="action.query"/>(<U>Q</U>)
             </button>
         </td>
        </tr>
      </table>
      <script>
         function validateInput(form){
            var errors="";
            if(""!=form['task.course.credits'].value&&!/^\d*\.?\d*$/.test(form['task.course.credits'].value)){
               errors+="学分"+form['task.course.credits'].value+"格式不正确，应为正实数\n";
            }
            if("" != errors) {
               alert(errors);
               return false;
            }
            return true;
         }
      </script>