  <#assign unitList =electState.params.calendar.timeSetting.courseUnits>
  <table width="100%" align="center" class="listTable">
  <#assign calendar=electState.params.calendar>
   <#include "/pages/system/calendar/timeSetting/timeSettingBar.ftl"/> 
    <tr class="darkColumn">
        <td width="5%"></td>
        <#list unitList as unit>
        <td align="center" width="7%">${unit_index+1}</td>
        </#list>
    </tr>
    <#list weekList as week>
    <tr>
       <td class="darkColumn"><@i18nName week/></td>
        <#list 1..unitList?size as unit>
        <td id="TD${week_index*unitList?size+unit_index}"  style="backGround-Color:#ffffff;" onclick="select(event)" onDblclick="getTaskList()"></td>
        </#list>
    </tr>
    </#list>
</table>
<table id="stdCourseTableBar"></table> 
<table width="100%" border="0" class="listTable" id="myCourseListTable">
    <tr align="center" class="darkColumn">
      <td align="center" width="2%"></td>
      <td width="6%"><@msg.message key="attr.taskNo"/></td>
      <td width="6%"><@msg.message key="attr.courseNo"/></td>
      <td width="22%"><@msg.message key="attr.courseName"/></td>
      <td width="15%"><@msg.message key="entity.courseType"/></td>
      <td width="10%"><@msg.message key="entity.teacher"/></td>
      <td width="5%"><@msg.message key="attr.weekHour"/></td>
      <td width="4%"><@msg.message key="attr.credit"/></td>
      <td width="6%"><@msg.message key="attr.teachLangType"/></td> 
      <td width="5%"><@msg.message key="attr.isGuaPai"/></td>
      <td width="6%">选课下限</td>
      <td>备注</td>
    </tr>
    <#list taskList?sort_by("courseType","name") as task>
      <#if task_index%2==1><#assign class="grayStyle"/></#if>
      <#if task_index%2==0><#assign class="brightStyle"/></#if>
     <tr class="${class}" align="center" onmouseover="swapOverTR(this,this.className)" 
        onmouseout="swapOutTR(this)" onclick="onRowChange(event)">
      <td width="2%" class="select"><input type="radio" name="taskId" value="${task.id}" id="${task.id}"><input type="hidden" name="courseId" value="${task.course.id}"></td>
      <td><A href="courseTableForStd.do?method=taskTable&task.id=${task.id}" target="_blank" title="<@msg.message key="common.displayTeachTaskArrange"/>">${task.seqNo?if_exists}</a></td>
      <td>${task.course.code}</td>
      <td><A href="teachTaskSearch.do?method=courseInfo&type=course&courseId=${task.course.id}" target="_blank"><@i18nName task.course/></a></td>
      <td><@i18nName task.courseType/></td>
      <td><#list task.arrangeInfo.teachers as teacher><A href="teacherSearch.do?method=intro&teacherId=${teacher.id}" target="_blank" title="点击此处查看教师个人简介">${teacher.name}</A>&nbsp;</#list></td>
      <td>${task.arrangeInfo.weekUnits}</td>
      <td>${task.course.credits}</td>
      <td><@i18nName task.requirement.teachLangType?if_exists/></td>
      <td><#if task.requirement.isGuaPai == true><@msg.message key="yes"/><#else><@msg.message key="no"/></#if></td>
      <td>${(task.electInfo.minStdCount)?default(0)}</td>
      <td>${task.remark?default("")?html}</td>
    </tr>
    </#list>
</table>
<p style="font-size:10pt"><@msg.message key="common.noticeItemOfElectCourse"/></p>
<script>
    var unitsPerWeek=${unitList?size*weekList?size};
    var courseTable = new CourseTable(${calendar.startYear},unitsPerWeek);
    var unitCount = ${unitList?size};
    var index=0;
    var activity=null;
    var tipContents = new Array(unitsPerWeek);
    <#list taskList as task>
      <#list task.arrangeInfo.activities as activity>
       activity = new TaskActivity("${(activity.teacher.id)?if_exists}","${activity.teacher?if_exists.name?if_exists}","${activity.task.course.id}","${activity.task.course.name}","${(activity.room.id)?if_exists}","<#if (state.arrangeSwitch.isArrangeAddress)?default(false) && (state.arrangeSwitch.isPublished)?default(false)>${(activity.room.name)?if_exists}</#if>","${activity.time.validWeeks}","${activity.task.id}");
       <#list 1..activity.time.unitCount as unit>
       index =${(activity.time.weekId-1)}*unitCount+${activity.time.startUnit-1+unit_index};
       courseTable.activities[index][courseTable.activities[index].length]=activity;
       </#list>
      </#list>
    </#list>
    for(var k=0;k<unitsPerWeek;k++){
        var td = document.getElementById("TD"+k);
        if(courseTable.activities[k].length>0){
            td.innerHTML=tipContents[k] = courseTable.marshal(k,${electState.params.calendar.weekStart},1,${electState.params.calendar.weeks});
        }else{
          td.innerHTML="";
          tipContents[k]="<@msg.message key="course.infoOfNoCourses"/>" 
        }
        td.className="infoTitle";
        td.onmouseover= function(event){ myToolTip(event);}
        td.onmouseout= function clearOtherInfo(){ toolTip();}
        if(td.innerHTML=="") {
            td.style.backgroundColor = "#94aef3";
        } else {
            td.style.backgroundColor="yellow";
        }
    }
   // 鼠标提示信息
    function myToolTip(event){
      var tdId = new String (getEventTarget(event).id);
      var tip=tipContents[tdId.substring(2)];
      if(tip!=null){
          toolTip(tip,'#000000', '#FFFF00');
      }
    }
    
    var weekListInfo=new Array();
    var unitListInfo=new Array();
    <#list weekList as week>
        weekListInfo[${week_index}]="<@i18nName week/>";
    </#list>
    <#list unitList as unit>
        unitListInfo[${unit.index}]="<@i18nName unit/>"
    </#list>
    
    var orginalColor= new Array(unitsPerWeek);
    // select a td
    var selectedIndex =null;
    function select(event){
        var td = getEventTarget(event);
        var tdId =td.id;
        if(orginalColor[tdId.substring(2)]==null)
            orginalColor[tdId.substring(2)]=td.style.backgroundColor;
            
        for(var k=0;k<unitsPerWeek;k++){
           otherTd = document.getElementById("TD"+k);
           if(otherTd.style.backgroundColor=="green")  otherTd.style.backgroundColor=orginalColor[k];
        }
        selectedIndex= td.id.substring(2);
        td.style.backgroundColor="green";
    }
   var bar = new ToolBar('stdCourseTableBar','<@bean.message key="info.courseList" />',null,true,true);
   bar.setMessage('<@getMessage/>');
   bar.addItem("<@msg.message key="course.withdraw"/>","cancelTask('${electState.std.stdNo}');",'delete.gif');
</script>