<#include "/templates/simpleHead.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/course/TaskActivity.js"></script>
<script language="JavaScript" type="text/JavaScript" src="scripts/prompt.js"></script> 
<style  type="text/css">
<!--
.trans_msg
    {
    filter:alpha(opacity=100,enabled=1) revealTrans(duration=.2,transition=1) blendtrans(duration=.2);
    }
--> 
</style> 
<body LEFTMARGIN="0" TOPMARGIN="0">
 <div id="toolTipLayer" style="position:absolute; visibility: hidden"></div>
 <script>initToolTips()</script>
 <div id="processDIV" style="display:block"><@msg.message key="common.pageLoading"/></div>
 <div id="contentDIV" style="display:none">
 <table id="taskListBar"></table>
  <script>
    var bar = new ToolBar("taskListBar"," <#if RequestParameters["isRestudy"]?default('0')=='1'>重修课程列表<#else>一般课程列表</#if>",null,true,false);
    <#if RequestParameters["weekName"]?exists&&RequestParameters["weekName"]!="">
    <#assign timeUnit><div id="timeUnitTD">${RequestParameters["weekName"]},${RequestParameters["unitName"]}<@msg.message key="course.beenCourse"/></div></#assign>
    bar.setMessage('${timeUnit}');
    bar.addItem("<@msg.message key="course.ignoreTime"/>",'evictTime()','action.gif');
    </#if>
    <#if (electState.params.isRestudyAllowed)>
    bar.addItem("一般课程",'query(null,null,0)','list.gif');
    bar.addItem("重修课程",'query(null,null,1)','list.gif');
    <#else>
    bar.addItem("刷新",'query(null,null,0)','refresh.gif');
    </#if>
    <!-- 确认选择 -->
    bar.addItem("<@msg.message key="action.sureAndChoice"/>",'elect()','new.gif','<@msg.message key="course.manuallyAddTask"/>');
  </script>
    <table width="100%" class="listTable">
      <form name="taskListForm" action="" method="post" onsubmit="return false;">
      <input type="hidden" name="timeUnit.weekId" value="${RequestParameters['timeUnit.weekId']?if_exists}"/>
      <input type="hidden" name="timeUnit.startUnit" value="${RequestParameters['timeUnit.startUnit']?if_exists}"/>
      <input type="hidden" name="weekName" value="${RequestParameters['weekName']?if_exists}"/>
      <input type="hidden" name="unitName" value="${RequestParameters['unitName']?if_exists}"/>
      <input type="hidden" name="isRestudy" value="${RequestParameters['isRestudy']?if_exists}"/>
     <tr bgcolor="#ffffff" onKeyDown="javascript:enterQuery(event)">
      <td align="center">
        <img src="images/action/search.gif" align="top" onClick="query()" alt="<@bean.message key="info.filterInResult"/>"/>
      </td>
      <td><input style="width:100%" type="text" name="task.seqNo" maxlength="32" value="${RequestParameters['task.seqNo']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="task.course.code" maxlength="32" value="${RequestParameters['task.course.code']?if_exists}"/></td>      
      <td><input style="width:100%" type="text" name="task.course.name" maxlength="20" value="${RequestParameters['task.course.name']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="task.courseType.name" maxlength="20" value="${RequestParameters['task.courseType.name']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="teacher.name" maxlength="20" value="${RequestParameters['teacher.name']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="task.course.credits" maxlength="2" value="${RequestParameters['task.course.credits']?if_exists}"/></td>
      <td><input style="width:100%" type="text" name="task.arrangeInfo.weekUnits" maxlength="3" value="${RequestParameters['task.arrangeInfo.weekUnits']?if_exists}"/></td>
       <#assign electCountCompare=''/>
      <#if RequestParameters['task.electInfo.electCountCompare']?exists>
        <#assign electCountCompare=RequestParameters['task.electInfo.electCountCompare']/>
      </#if>
      <td>
         <select name="task.electInfo.electCountCompare" style="width:100%">
            <option value="" <#if electCountCompare='0'> selected</#if>>全部</option>
            <option value="1" <#if electCountCompare='1'> selected</#if>>实选>上限</option>
            <option value="0" <#if electCountCompare='0'> selected</#if>>实选=上限</option>
            <option value="-1" <#if electCountCompare='-1'> selected</#if>>实选&lt;上限</option>
         </select>
      </td>
        <td><input style="width:100%" type="text" name="task.electInfo.minStdCount" maxlength="3" value="${RequestParameters["task.electInfo.minStdCount"]?if_exists}"/></td>
       <td> 
		 <#macro yesOrNoOptions(selected)>
		 	<option value="0"<#if "0"==selected> selected</#if>><@bean.message key="common.no"/></option> 
		    <option value="1"<#if "1"==selected> selected</#if>><@bean.message key="common.yes"/></option> 
		    <option value=""<#if ""==selected> selected</#if>><@bean.message key="common.all"/></option> 
		 </#macro>
        <select  name="task.requirement.isGuaPai" style="width:100%">
          <@yesOrNoOptions RequestParameters['task.requirement.isGuaPai']?if_exists/>
        </select>
      </td>
      <td></td>
      <td></td>
      <td><input style="width:100%" type="text" name="task.remark" maxlength="20" value="${RequestParameters['task.remark']?if_exists}"/></td>
    </tr>
    </form>
    <tr align="center" class="darkColumn">
      <td align="center" width="3%"></td>
      <td width="6%"><@bean.message key="attr.taskNo"/></td>
      <td width="6%"><@bean.message key="attr.courseNo"/></td>
      <td width="12%"><@bean.message key="attr.courseName"/></td>
      <td width="12%"><@bean.message key="entity.courseType"/></td>
      <td width="5%"><@bean.message key="entity.teacher"/></td>
      <td width="5%"><@msg.message key="attr.credit"/></td>
      <td width="5%"><@bean.message key="attr.weekHour"/></td>
      <td width="6%"><@msg.message key="course.chooseOrMaximum"/></td>
      <td width="6%">选课下限</td>
      <td width="5%"><@msg.message key="attr.GP"/></td>
      <td width="6%">是否双语</td>
      <td>上课时间</td>
      <td width="10%">备注</td>
    </tr>
    <#list taskList as task>
   	  <#if task_index%2==1 ><#assign class="grayStyle" ></#if>
	  <#if task_index%2==0 ><#assign class="brightStyle" ></#if>
     <tr class="${class}" align="center" 
     onmouseover="swapOverTR(this,this.className);displayRemark('${task.id},${task.course.id}');" 
     onmouseout="swapOutTR(this);eraseRemark('${task.id},${task.course.id}');" 
     onclick="onRowChange(event)">
      <td width="2%" class="select">
        <input type="radio" name="taskCourseId" value="${task.id},${task.course.id}" id="${task.id},${task.course.id}">
      </td>
      <#assign seqNo>
		<#--      
      <a href="courseTableForStd.do?method=taskTable&task.id=${task.id}" target="_blank" title="<@msg.message key="common.displayTeachTaskArrange"/>">${task.seqNo?if_exists}</a>
      -->
      <a href="teachTask.do?method=jxbInfo&task.id=${(task.id)!}" target="_blank" title="<@msg.message key="common.displayTeachTaskArrange"/>">${task.seqNo?if_exists}</a>
      </#assign>
      <td>${seqNo}</td>
      <input type="hidden" id="seqNo${task.id}" value="${seqNo?html}"/>
      <td>${task.course.code}</td>
      <input type="hidden" id="courseId${task.id}" value="${task.course.id?if_exists}"/>
      <input type="hidden" id="courseCode${task.id}" value="${task.course.code?if_exists}"/>
      <td><a href="teachTaskSearch.do?method=courseInfo&type=course&courseId=${task.course.id}" target="_blank"><@i18nName task.course/></a></td>
      <input type="hidden" id="courseName${task.id}" value="${task.course.name?html}"/>
      <td><@i18nName task.courseType/></td>
      <input type="hidden" id="courseTypeName${task.id}" value="${task.courseType.name?if_exists}"/>
      <#assign teachersName><#list task.arrangeInfo.teachers as teacher><A href="teacherSearch.do?method=intro&teacherId=${teacher.id}" target="_blank" title="点击此处查看教师个人简介">${teacher.name}</A>&nbsp;</#list></#assign>
      <td>${teachersName}</td>
      <input type="hidden" id="teachersName${task.id}" value="${teachersName?html}"/>
      <td>${task.course.credits}</td>
      <input type="hidden" id="credits${task.id}" value="${task.course.credits}"/>
      <td>${task.arrangeInfo.weekUnits}</td>
      <input type="hidden" id="weekUnits${task.id}" value="${task.arrangeInfo.weekUnits}"/>
      <td>${task.teachClass.stdCount}/${(task.electInfo.maxStdCount == 999)?string("无", (task.electInfo.maxStdCount)?default(0)?string)}</td>
      <input type="hidden" id="stdCount${task.id}" value="${task.teachClass.stdCount}"/>
      <input type="hidden" id="maxStdCount${task.id}" value="${task.electInfo.maxStdCount}"/>
      <td>${(task.electInfo.minStdCount)?default(0)}</td>
      <input type="hidden" id="minStdCount${task.id}" value="${task.electInfo.minStdCount}"/>
      <td><#if task.requirement.isGuaPai == true><@bean.message key="common.yes"/> <#else> <@bean.message key="common.no"/> </#if></td>
      <td><#if task.requirement.teachLangType.id == BILINGUAL><@bean.message key="common.yes"/><#else><@bean.message key="common.no"/></#if></td>
      <input type="hidden" id="isGuaPai${task.id}" value="${task.requirement.isGuaPai?string("是", "否")}"/>
      <input type="hidden" id="remark${task.id}" value="${task.remark?default("")?html}"/>
      <div>
      <input type="hidden" id="minStdCount${task.id}" value="${task.electInfo.minStdCount}"/>
      <input type="hidden" id="isCancelable${task.id}" value="${task.electInfo.isCancelable?string}"/>
      <input type="hidden" id="prerequisteCoursesIds${task.id}" value="<#list task.electInfo.prerequisteCourses as course>${course.id}<#if course_has_next>,</#if></#list>"/>
      <input type="hidden" id="teachLangType${task.id}" name="teachLangType${task.id}" value="<@i18nName task.requirement.teachLangType/>"/>
      <input type="hidden" id="languageAbility${task.id}" name="languageAbility${task.id}" value="${(task.course.languageAbility.level)?default(0)}"/>
      </div>
      <td>${task.arrangeInfo.digest(task.calendar, Request["org.apache.struts.action.MESSAGE"], localName, ":day :units" + ((state.arrangeSwitch.isArrangeAddress)?default(false) && (state.arrangeSwitch.isPublished)?default(false))?string(" :room", ""))?replace(" ,", "<br>")}</td>
      <td>${task.remark?default("")?html}</td>
    </tr>
	</#list>
	<#include "/templates/newPageBar.ftl"/>
	</table>
	</div>
	<script>
 	 var unitCount = ${(electState.params.calendar.timeSetting.courseUnits)?size};
	 var remarkContents = new Object();
	 var HSKDegrees=new Object();
	 var preCourses= new Object();
     <#list taskList as task>
     remarkContents['${task.id},${task.course.id}']={'remark':'${task.remark?default("")?js_string}'};
     HSKDegrees['${task.id}']=${task.electInfo.HSKDegree?if_exists.degree?default(0)};
     preCourses['${task.id}']='<#list task.electInfo.prerequisteCourses as course>${course.id},</#list>'
	 </#list>
	 
    document.getElementById('processDIV').style.display="none";
    document.getElementById('contentDIV').style.display="block";
    adaptFrameSize();
	var tables = new Object();
	var scopes = new Object();
	var year =${electState.params.calendar.startYear};
	<#list taskList as task>
      tables['${task.id}']=new CourseTable(year,7*unitCount);
      <#list task.arrangeInfo.activities as activity>
       var activity = new TaskActivity("${(activity.teacher.id)?if_exists}","${(activity.teacher.name)?if_exists}","${task.course.id}","${task.course.name}","${(activity.room.id)?if_exists}","<#if (state.arrangeSwitch.isArrangeAddress)?default(false) && (state.arrangeSwitch.isPublished)?default(false)>${(activity.room.name)?if_exists}</#if>","${activity.time.validWeeks}",'${task.id}');
       <#list 1..activity.time.unitCount as unit>
       index =${(activity.time.weekId-1)}*unitCount+${activity.time.startUnit-1+unit_index};
       tables['${task.id}'].activities[index][ tables['${task.id}'].activities[index].length]=activity;
       </#list>
   	  </#list>
      
      scopes['${task.id}']= new Array();
   	  <#list task.electInfo.electScopes as scope>
      scopes['${task.id}'][${scope_index}]=new ElectScope('${scope.enrollTurns?if_exists}','${scope.stdTypeIds?if_exists}','${scope.departIds?if_exists}','${scope.specialityIds?if_exists}','${scope.aspectIds?if_exists}','${scope.adminClassIds?if_exists}','${scope.startNo?if_exists}','${scope.endNo?if_exists}');
   	  </#list>
   	</#list>
   
    function enterQuery(event) {
       if (portableEvent(event).keyCode == 13) {
            query();
        }
    }
    function ElectScope(enrollTurns,stdTypeIds,departIds,specialityIds,aspectIds,adminClassIds,startNo,endNo){
      this.enrollTurns =enrollTurns;
      this.stdTypeIds=stdTypeIds;
      this.departIds=departIds;
      this.specialityIds=specialityIds;
      this.aspectIds=aspectIds;
      this.adminClassIds=adminClassIds;
      this.startNo=startNo;
      this.endNo=endNo;
    }
    
    function pageGoWithSize(pageNo,pageSize){
        query(pageNo,pageSize);
    }
    
    function query(pageNo,pageSize,isRestudy){
        var form = document.taskListForm;
        form.action="quickElectCourse.do?method=taskList";
        if(isRestudy!=null){
           form['isRestudy'].value=isRestudy;
        }
        if(pageNo!=null)
            form.action+="&pageNo="+pageNo;
        if(pageSize!=null)
            form.action+="&pageSize="+pageSize;
        form.target = "_self";
        form.submit();
    }
    function evictTime(){
        document.getElementById("timeUnitTD").innerHTML="";
        document.taskListForm['timeUnit.weekId'].value="";
        document.taskListForm['timeUnit.startUnit'].value="";
        document.taskListForm['weekName'].value="";
        document.taskListForm['unitName'].value="";
        query(null,null,0);
    }

   <#assign  TS_yx = electState.completedMap['通识'] /><!-- 通识类已修学分-->
   <#assign  GX_yx = electState.completedMap['公选'] /><!-- 公选类已修学分-->
   <#assign  XX_yx = electState.completedMap['限选'] /><!-- 限选类已修学分-->

   <#assign  TS_xx = electState.requiredMap['通识'] /><!-- 通识类需修学分-->
   <#assign  GX_xx = electState.requiredMap['公选'] /><!-- 公选类需修学分-->
   <#assign  XX_xx = electState.requiredMap['限选']/><!-- 限选类需修学分-->

   <#assign  creditTS = electState.electedMap['通识'] /><!-- 通识类已选学分-->
   <#assign  creditGX = electState.electedMap['公选'] /><!-- 公选类已选学分-->
   <#assign  creditXX = electState.electedMap['限选']/><!-- 限选类已选学分-->
    <!-- 选课 -->
    function elect(){
        var taskCourseId = getCheckBoxValue(document.getElementsByName('taskCourseId'));
        if(taskCourseId==""){alert("请选择一门教学任务");return;}
        parent.operation="add";
        // 防止反复提交
        if(!parent.canSubmitElection()) return;
        var selectTR = document.getElementById(taskCourseId).parentNode.parentNode;
        var ids = taskCourseId.split(",");

        parent.parent.parent.document.title = parent.curTask.course.nameCaption;
        var courseTakeId=parent.elective;
        
        var form = document.taskListForm;

        parent.curTask.id=ids[0];
        parent.curTask.course.id=ids[1];
        parent.curTask.seqNo=document.getElementById("seqNo" + ids[0]).value;
        parent.curTask.course.id=document.getElementById("courseId" + ids[0]).value;
        parent.curTask.course.code=document.getElementById("courseCode" + ids[0]).value;
        parent.curTask.course.name=document.getElementById("courseName" + ids[0]).value;
        parent.curTask.courseType.name=document.getElementById("courseTypeName" + ids[0]).value;
        parent.curTask.arrangeInfo.teachers=document.getElementById("teachersName" + ids[0]).value;
        parent.curTask.credit= Number(document.getElementById("credits" + ids[0]).value);
        parent.curTask.arrangeInfo.weekUnits=document.getElementById("weekUnits" + ids[0]).value;
        parent.curTask.electInfo.maxStdCount= Number(document.getElementById("maxStdCount" + ids[0]).value);
        parent.curTask.teachClass.stdCount= Number(document.getElementById("stdCount" + ids[0]).value);
        parent.curTask.requirement.isGuaPai=document.getElementById("isGuaPai" + ids[0]).value;
        parent.curTask.remark = document.getElementById("remark" + ids[0]).value;
        parent.curTask.electInfo.minStdCount=document.getElementById("minStdCount" + ids[0]).value;
        parent.curTask.electInfo.isCancelable=document.getElementById("isCancelable" + ids[0]).value;
        parent.curTask.electInfo.prerequisteCoursesIds=document.getElementById("prerequisteCoursesIds" + ids[0]).value;
        parent.curTask.requirement.teachLangType=document.getElementById("teachLangType" + ids[0]).value;
        parent.curTask.course.languageAbility=document.getElementById("languageAbility" + ids[0]).value;
        parent.curTask.table=tables[parent.curTask.id];
        parent.curTask.scopes=scopes[parent.curTask.id];
 		//所选的课程类别
        var courseType = parent.curTask.courseType.name;
        //所选课程的学分
        var courseCredit = parent.curTask.credit;
        var pattTS = new RegExp('通识');
        if((courseCredit+${creditTS}+${TS_yx}) > ${TS_xx}) {
          if(pattTS.test(courseType)) {
             if(!confirm("通识类课程的总学分(已修${TS_yx}+已选${creditTS}+本次" +courseCredit +") > 本类课程需修的学分(${TS_xx})\n是否继续选择？"))  return;
          }
        }
        var pattGX = new RegExp('公选');
        if((courseCredit+${creditGX}+${GX_yx}) > ${GX_xx}) {
           if(pattGX.test(courseType)) {
             if(!confirm("公选类课程的总学分(已修${GX_yx}+已选${creditGX}+本次" +courseCredit +") > 本类课程需修的学分(${GX_xx})\n是否继续选择？"))  return;
          }
        }
        var pattXX = new RegExp('限选');
        var pattXX2 = new RegExp('限制性选');
        if((courseCredit+${creditXX}+${XX_yx}) > ${XX_xx}) {
          if(pattXX.test(courseType) || pattXX2.test(courseType)) {
            if(!confirm("限选类课程的总学分(已修${XX_yx}+已选${creditXX}+本次" +courseCredit +") > 本类课程需修的学分(${XX_xx})\n是否继续选择？"))  return;
          }
        }
        
        var url="quickElectCourse.do?stdCode=${electState.std.stdNo}&method=elect&task.id=" + parent.curTask.id+"&courseTakeType.id=";
        var errorInfo = parent.canElect(parent.electState,parent.curTask,parent.subsMap);
        if(""!=errorInfo){
           if(parent.errors.reStudySubstituteElected==errorInfo){
              if(!confirm("要重修这门替代课程吗?"))
                 return;
              else{
              	 courseTakeId=parent.reStudy;
              }
           }else if(parent.errors.reStudyElected==errorInfo){
              if(!confirm("该课程你已经修过，是否选择重修?"))
                 return;
              else{
              	 courseTakeId=parent.reStudy;
              }
           }else{
              parent.setMessage(errorInfo);
              alert(errorInfo);
              return;
           }
        }
        <#--判断是否同名课程已选过-->
        if(courseTakeId != parent.reStudy && null != parent.electState.hisCourseNames[parent.curTask.course.name]){
        	if (!confirm(autoWardString("你已选同名课程“" + parent.curTask.course.name + "”，请参照“同名课程认定原则”确定是否选择，是否仍要选该门课？", 60))) {
                return;
            }
        }
		//时间冲突
        if (parent.courseTable.isTimeConflictWith(tables[parent.curTask.id])) {
           parent.setMessage(parent.errors.timeConfilict);
           alert(parent.errors.timeConfilict);
           return;
        } else {
           if(!confirm("确定选择“"+ document.getElementById("courseName" + ids[0]).value +"”课程吗?")) {
            return;
           }
        }
		//开始提交
        var submitTime=new Date();
        url+=courseTakeId;
        url+="&submitTime="+submitTime.getTime();
        parent.setMessage(parent.waiting);
        parent.openElectResult(url);
    }
    function displayRemark(taskId){
      if(""!=remarkContents[taskId].remark){
         toolTip(remarkContents[taskId].remark,'#000000', '#FFFF00',250);
      }
    }
    function eraseRemark(taskId){
     if(""!=remarkContents[taskId].remark){
        toolTip();
     }
    }
    function refreshCourseTable(isSuccess){
      parent.refreshCourseTable(isSuccess);
    }
    function italicItem(id,otherId){
       var td = document.getElementById(id);
       td.style.fontStyle="italic";
       var otherTd = document.getElementById(otherId);
       otherTd.style.fontStyle="";
    }
    </script>
</body> 
<#include "/templates/foot.ftl"/> 