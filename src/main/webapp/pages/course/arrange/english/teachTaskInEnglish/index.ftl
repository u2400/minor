<#include "/templates/head.ftl"/>
<BODY> 
    <table id="taskBar"></table>
    <table class="frameTable_title">
        <tr>
            <td style="width:50px"><font color="blue"><@bean.message key="action.advancedQuery"/></font></td>
             <td class="infoTitle"><@msg.message key="course.arrangeState"/>:</td>
          <form name="taskForm" target="teachTaskListFrame" method="post" action="?method=index" onsubmit="return false;">
             <td>
                <select name="task.arrangeInfo.isArrangeComplete" style="width:100px" onchange="search()">
                   <option value=""><@bean.message key="common.all"/></option>
                   <option value="1"><@msg.message key="course.beenArranged"/></option>
                   <option value="0" selected><@msg.message key="course.noArrange"/></option>
                </select>
             </td>
            <td>|</td>
            <input type="hidden" name="task.calendar.id" value="${calendar.id}"/>
            <#include "/pages/course/calendar.ftl"/>
        </tr>
    </table>
    <table class="frameTable">
        <tr>
            <td valign="top" width="19%" class="frameTable_view">
                 <table width="100%">
                    <tr>
                      <td class="infoTitle" align="left" valign="bottom">
                       <img src="images/action/info.gif" align="top"/>
                          <B><@msg.message key="action.advancedQuery.like"/></B>
                      </td>
                    </tr>
                    <tr>
                      <td colspan="8" style="font-size:0px">
                          <img src="images/action/keyline.gif" height="2" width="100%" align="top">
                      </td>
                    </tr>
                  </table>
                  <table class="searchTable" onkeypress="DWRUtil.onReturn(event, search)">
                    <tr> 
                     <td class="infoTitle"><@bean.message key="attr.taskNo"/>:</td>
                     <td><input name="task.seqNo" type="text" value="" style="width:100px" maxlength="32"/></td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@bean.message key="attr.courseNo"/>:</td>
                     <td><input name="task.course.code" type="text" value="" style="width:100px" maxlength="32"/></td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@bean.message key="attr.courseName"/>:</td>
                     <td><input type="text" name="task.course.name" value="" style="width:100px" maxlength="20"/></td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@bean.message key="entity.courseType"/>:</td>
                     <td><select name="task.courseType.id"  style="width:100px">
                            <option value=""><@bean.message key="common.all"/></option>
                            <#list sort_byI18nName(courseTypes) as courseType>
                            <option value=${courseType.id}><@i18nName courseType/></option>
                            </#list>
                         </select>
                     </td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@bean.message key="attr.teach4Depart"/>:</td>
                     <td>
                         <select name="task.teachClass.depart.id" value="" style="width:100px">
                            <option value=""><@bean.message key="common.all"/></option>
                            <#list (departmentList)?sort_by("code") as depart>
                            <option value=${depart.id}><@i18nName depart/></option>
                            </#list>
                         </select>
                     </td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@bean.message key="attr.teachDepart"/>:</td>
                     <td>
                         <select name="task.arrangeInfo.teachDepart.id" value="" style="width:100px">
                            <option value=""><@bean.message key="common.all"/></option>
                            <#list (teachDepartList)?sort_by("code") as teachDepart>
                            <option value=${teachDepart.id}><@i18nName teachDepart/></option>
                            </#list>
                         </select>
                     </td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@bean.message key="entity.teacher"/>:</td>
                     <td><input type="text" name="teacher.name" id="teacher.name" value="" style="width:65px" maxlength="20"/><input name="hasTeacher" id="hasTeacher" type="checkbox" value="Y" onClick="displayDiv('teacher.name', 'hasTeacher')"/>空
                     </td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@bean.message key="attr.enrollTurn"/>:</td>
                     <td><input type="text" name="task.teachClass.enrollTurn" value="" maxlength="7" style="width:100px"/></td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@bean.message key="entity.studentType"/>:</td>
                     <td><@htm.i18nSelect datas=calendarStdTypes selected="" name="task.teachClass.stdType.id"  style="width:100px">
                            <option value=""><@bean.message key="common.all"/></option>
                         </@>
                     </td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@msg.message key="attr.credit"/>:</td>
                     <td><input type="text" name="task.course.credits" value="" style="width:100px" maxlength="3"/>
                     </td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@msg.message key="course.weekHours"/>:</td>
                     <td><input type="text" name="task.arrangeInfo.weekUnits" value="" style="width:100px" maxlength="3"/></td>
                    </tr>
                    <tr>
                         <td class="infoTitle"><@msg.message key="course.weekFrom"/>:</td>
                         <td><input name="task.arrangeInfo.weekStart" style="width:100px" value="" maxlength="2"/></td>
                    </tr>
                    <tr>
                         <td class="infoTitle">组名:</td>
                         <td><input name="task.taskGroup.name" style="width:100px" value="" maxlength="50"/></td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@bean.message key="attr.GP"/>:</td>
                     <td>
                        <select name="task.requirement.isGuaPai" style="width:100px">
                           <option value=""><@bean.message key="common.all"/></option>
                           <option value="1"><@bean.message key="common.yes"/></option>
                           <option value="0"><@bean.message key="common.no"/></option>
                        </select>
                     </td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@msg.message key="course.week"/>:</td>
                     <td>
                         <select name="courseActivity.time.week" value="" style="width:100px">
                            <option value=""><@bean.message key="common.all"/></option>
                            <#list weeks as week>
                            <option value=${week.id}><@i18nName week/></option>
                            </#list>
                         </select>
                     </td>
                    </tr>
                    <tr>
                     <td class="infoTitle"><@msg.message key="course.unit"/>:</td>
                     <td>
                         <select name="courseActivity.time.startUnit" value="" style="width:100px">
                            <option value=""><@bean.message key="common.all"/></option>
                            <#list 1..14 as unit>
                            <option value=${unit}>${unit}</option>
                            </#list>
                         </select>
                     </td>
                </tr>
                <tr>
                 <td class="infoTitle" style="width:100%"><@msg.message key="course.affirmState"/>:</td>
                 <td>
                    <select name="task.isConfirm" style="width:100px">
                       <option value=""><@bean.message key="common.all"/></option>
                       <option value="1"><@bean.message key="action.affirm"/></option>
                       <option value="0"><@msg.message key="action.negate"/></option>
                    </select>
                 </td>
                </tr>
                <tr>
                    <td><@msg.message key="entity.schoolDistrict"/>:</td>
                    <td><@htm.i18nSelect datas=schoolDistricts selected="" name="task.arrangeInfo.schoolDistrict.id" style="width:100%"><option value=""><@msg.message key="common.all"/></option></@></td>
                </tr>
                <tr>
                    <td>计划人数:</td>
                    <td><input type="text" name="planStdCountStart" value="" maxlength="3" style="width:30px"/>&nbsp;-&nbsp;<input type="text" name="planStdCountEnd" value="" maxlength="3" style="width:30px"/></td>
                </tr>
                <tr>
                    <td><@msg.message key="course.factNumberOf"/>:</td>
                    <td><input type="text" name="stdCountStart" value="" maxlength="3" style="width:30px"/>&nbsp;-&nbsp;<input type="text" name="stdCountEnd" value="" maxlength="3" style="width:30px"/></td>
                </tr>
                <tr>
                    <td>语种要求:</td>
                    <td><@htm.i18nSelect datas=languageAbilities?sort_by("name") selected="" name="languageAbility.id" style="width:100%"><option value=""><@msg.message key="common.all"/></option></@></td>
                </tr>
                <tr align="center">
                   <td colspan="2">
                     <button onClick="search();" accesskey="Q" class="buttonStyle" style="width:80px">
                       <@bean.message key="action.query"/>(<U>Q</U>)
                     </button>
                    </td>
                </tr>
            </table>
            <script language="javascript">
                  function displayDiv(divId, checkBoxId) {
                        document.getElementById(divId).disabled = $(checkBoxId).checked ? "true" : "";
                    }
             </script>
            </td>
          </form>
            <td valign="top" bgcolor="white">
                <iframe src="#" id="teachTaskListFrame" name="teachTaskListFrame" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"  height="100%" width="100%"></iframe>
            </td>
        </tr>
    </table>
    <script>
        var bar=new ToolBar("taskBar","<@msg.message key="teachTask.title"/>",null,true,true);
        bar.addItem("<@msg.message key="teachTask.checkHour"/>","checkArrangeInfo()")
        bar.addItem("<@msg.message key="teachTask.taskStat"/>","statTeachTask()");
        bar.addItem("<@msg.message key="teachTask.moduleSummary"/>",stateModule);
        bar.addItem("<@msg.message key="teachTask.mutilClassSummary"/>","multiClassTaskList()","action.gif","<@msg.message key="teachTask.mutilClassSummary.explain"/>");
        bar.addItem("<@msg.message key="teachTask.GPSummary"/>","gpList()");
        bar.addItem("上课二维表", "activityReport()");
        
        var form = document.taskForm;
        function search(){
            form.action = "?method=search";
            form.target="teachTaskListFrame";
            form.submit();
        }
        
        function checkArrangeInfo(){
            var url="?method=checkArrangeInfo&calendar.studentType.id=${studentType.id}&calendar.id=${calendar.id}";
            window.open(url, '', 'toolbar=yes, menubar=yes,location=yes,scrollbars=yes,top=0,left=0,width=500,height=550,status=yes,resizable=yes');        
        }
        
        function stateModule(){
            var url="?method=taskOfCourseTypeList&calendar.studentType.id=${studentType.id}&calendar.id=${calendar.id}&orderBy=courseType.name";
            window.open(url, '', 'toolbar=yes, menubar=yes,location=yes,scrollbars=yes,top=0,left=0,width=500,height=550,status=yes,resizable=yes');
        }
        
        function statTeachTask(){
            self.location="teachTaskStat.do?teachTask.calendar.id="+document.taskForm['task.calendar.id'].value+"&method=index";
        }
        
        function multiClassTaskList(){
            self.location="teachTaskStat.do?method=multiClassTaskList&teachTask.calendar.id="+document.taskForm['task.calendar.id'].value;
        }
        
        function gpList(){
            self.location="teachTaskStat.do?method=gpList&teachTask.calendar.id="+document.taskForm['task.calendar.id'].value;
        }
    
        function activityReport() {
            form.action = "?method=activityReport";
            form.target = "_blank";
            form.submit();
        }
        
        search();
    </script>
</body>
<#include "/templates/foot.ftl"/> 
  