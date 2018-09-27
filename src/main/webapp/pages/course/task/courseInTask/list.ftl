<#include "/templates/head.ftl"/>
<BODY>
    <table id="bar" width="100%"></table>
    <script>
        var courseMap = {};
    </script>
    <#assign results = tasks/>
    <@table.table id="listTable" width="100%" sortable="true">
        <@table.thead>
            <@table.selectAllTd id="courseId"/>
            <@table.sortTd name="attr.code" id="course.code" width="15%"/>
            <@table.sortTd name="attr.infoname" id="course.name"/>
            <@table.sortTd name="common.courseLength" id="course.extInfo.period" width="15%"/>
            <@table.sortTd text="周课时" id="course.weekHour" width="15%"/>
            <@table.sortTd name="common.grade" id="course.credits" width="15%"/>
        </@>
        <@table.tbody datas=results;result>
            <#assign course = result[0]/>
            <#---->
            <script>
                courseMap["${course.id}"] = ${result[1]?default(0)};
            </script>
            
            <@table.selectTd id="courseId" value=course.id/>
            <td>${course.code}</td>
            <td><a href="courseSearch.do?method=info&type=course&id=${course.id}">${course.name}</a></td>
            <td>${(course.extInfo.period)?if_exists}</td>
            <td>${course.weekHour?if_exists}</td>
            <td>${course.credits?if_exists}</td>
        </@>
    </@>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="calendar.id" value="${RequestParameters["calendar.id"]}"/>
        <input type="hidden" name="courseIds" value=""/>
        <input type="hidden" name="isExportedTaskList" value=""/>
        <input type="hidden" name="isExportedStdScores" value=""/>
        <input type="hidden" name="keys" value=""/>
        <input type="hidden" name="titles" value=""/>
        <input type="hidden" name="format" value="excel"/>
        <input type="hidden" name="fileName" value=""/>
        <input type="hidden" name="template" value=""/>
    </form>
    <script>
        var bar = new ToolBar("bar", "任务课程列表", null ,true, true);
        bar.setMessage('<@getMessage/>');
        var menuBar = bar.addMenu("查询/选择导出", null, "excel.png");
        menuBar.addItem("任务导出", "exportTasks()");
        menuBar.addItem("成绩导出", "exportStdScores()");
        
        var form = document.actionForm;
        
        function clearParams() {
            form["courseIds"].value = "";
            form["isExportedTaskList"].value = "";
            form["isExportedStdScores"].value = "";
            form["keys"].value = "";
            form["titles"].value = "";
            form["fileName"].value = "";
            form["template"].value = "";
        }
        
        function exportTasks() {
            clearParams();
            
            var courseIds = getSelectIds("courseId");
            if (isEmpty(courseIds)) {
                if (confirm("是否要导入所查询结果的教学任务？")) {
                    form["isExportedTaskList"].value = "1";
                } else {
                    form["isExportedTaskList"].value = "";
                    return;
                }
                form.action = "courseInTask.do?method=export" + queryStr;
            } else {
                if (confirm("是否要导入所选择课程的教学任务？")) {
                    form["isExportedTaskList"].value = "0";
                    form["courseIds"].value = courseIds;
                } else {
                    form["isExportedTaskList"].value = "";
                    return;
                }
                form.action = "courseInTask.do?method=export";
            }
            form["keys"].value = "seqNo,course.code,course.name,courseType.name,teachClass.name,arrangeInfo.teacherCodes,arrangeInfo.teachers,arrangeInfo.teachers.department.name,arrangeInfo.activities.time,arrangeInfo.activities.room,requirement.roomConfigType.name,requirement.teachLangType.name,requirement.isGuaPai,electInfo.maxStdCount,arrangeInfo.activities.room.capacityOfCourse,teachClass.stdCount,arrangeInfo.weeks,arrangeInfo.weekUnits,arrangeInfo.activities.weeks,arrangeInfo.courseUnits,arrangeInfo.overallUnits,credit";
            form["titles"].value = "课程序号,课程代码,课程名称,课程性质,面向班级,教师职工号,授课教师,教师所在院系,上课时间,上课地点,教室设备配置,<@msg.message key="attr.teachLangType"/>,是否挂牌,人数上限,可容纳人数,实选人数,周数,周课时,上课周状态,节次,总课时,学分";
            form["fileName"].value = "课程档案之教学任务";
            form.submit();
        }
        
        function exportStdScores() {
            clearParams();
            
            var courseIds = getSelectIds("courseId");
            if (isEmpty(courseIds)) {
                if (confirm("是否要导入当前所查询结果的学生成绩？")) {
                    form["isExportedStdScores"].value = "1";
                } else {
                    form["isExportedStdScores"].value = "";
                    return;
                }
                <#---->
                if (${(results?first[2])?default(0)} > 10000) {
                    alert("将要导出的成绩记录数会超过10000条，请少选些再试试。");
                    return
                }
                
                form.action = "courseInTask.do?method=export" + queryStr;
            } else {
                if (confirm("是否要导入当前所选择课程的学生成绩？")) {
                    form["isExportedStdScores"].value = "0";
                    form["courseIds"].value = courseIds;
                    <#---->
                    var courseIdArray = (courseIds + "").split(",");
                    var count = 0;
                    //alert(count);
                    for (var i = 0; i < courseIdArray.length; i ++) {
                        if (isNotEmpty(courseIdArray[i])) {
                            count += courseMap[courseIdArray[i]];
                        }
                    //alert(count);
                    }
                    if (count >= 10000) {
                        alert("所选择导出课程的学生成绩记录数超过了10000条，请少选些再试试。");
                        return
                    } else {
                        if (count != 0 && !confirm("将要导出约 " + count + "条成绩记录，可能要需要一些时间，要继续吗？")) {
                            return;
                        }
                    }
                    
                } else {
                    form["isExportedStdScores"].value = "";
                    return;
                }
                form.action = "courseInTask.do?method=export";
                form["template"].value = "teachClassGradeOfCourseInTask.xls";
            }
            
            form["fileName"].value = "课程档案之学生成绩";
            form.submit();
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>