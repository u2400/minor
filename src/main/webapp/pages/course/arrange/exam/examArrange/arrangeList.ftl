<#include "/templates/head.ftl"/>
<body >
    <table id="taskBar"></table>
    <#include "arrangeExamList.ftl"/>
    <form name="actionForm" method="post" onsubmit="return false;" action="" onsubmit="return false;">
        <input type="hidden" name="examType.id" value="${RequestParameters['examType.id']}"/>
        <input type="hidden" name="examActivity.calendar.id" value="${RequestParameters['calendar.id']}"/>
    </form>
    <script>
        var bar = new ToolBar('taskBar', '排考结果列表', null, true, true);
        bar.setMessage('<@getMessage/>');
        printMenu=bar.addMenu("<@msg.message key="action.print"/>", "seatReport()", "print.gif");
        printMenu.addItem("课程排考结果", "examReport()", "print.gif");
        <#if RequestParameters['examType.id'] == "1">
        printMenu.addItem("期末考试日程", "examActivityReport()", "print.gif");
        </#if>
        var menu = bar.addMenu("导出", "exportArrange(0)");
        menu.addItem("按班级导出", "exportArrange(1)");
        bar.addItem("应考学生", "stdList()");
        bar.addItem("调整人数","edit()");
        var advancedMenu= bar.addMenu("高级..");
        advancedMenu.addItem("分配教室", "examReport('&forRoom=1')");
        advancedMenu.addItem("合并教室","mergeSetting()");
        <!--FIXME-->
        bar.addItem("删除", "removeArranges()");
        
        var form = document.actionForm;
        function removeArranges() {
            var taskIds = getSelectIds("taskId");
            if (taskIds == null || taskIds == "") {
                alert("请选择教学任务,删除排考结果");
                return;
            }
            if  (confirm("确定删除" + countId(taskIds) + "个任务的排考结果?")) {
                var params = getInputParams(parent.document.arrangedTaskSearchForm, null, false);
                var examTypeId = parent.document.arrangedTaskSearchForm['examType.id'].value;
                params += "&examType.id=" + examTypeId;
                addParamsInput(form, params);
                addInput(form, "examType.id", examTypeId, "hidden");
                addInput(form, "taskIds", taskIds, "hidden");
                form.action = "examArrange.do?method=removeArrange";
                form.target = "_self";
                form.submit();
            }
        }
        
        function seatReport() {
            var taskIds = getSelectIds("taskId");
            if (taskIds == null || taskIds == "") {
                alert("请选择一个或多个教学任务");
                return;
            }
            window.open("examArrange.do?&method=seatReport&examType.id=${RequestParameters['examType.id']}&taskIds=" + taskIds);
        }
        function exportArrange(byClass) {
            var taskIds = getSelectIds("taskId");
            if (taskIds == null || taskIds == "") {
                alert("请选择一个或多个教学任务");
                return;
            }
            addInput(form, "keys", "teachClass.adminClasses,seqNo,course.code,course.name,teachClass.stdCount,exam.date,exam.time,exam.rooms,arrangeInfo.teachDepart.name,arrangeInfo.teachers,exam.teachers,requirement.isGuaPai", "hidden");
            addInput(form, "titles", "班级,<@msg.message key="attr.taskNo"/>,<@msg.message key="attr.courseNo"/>,<@msg.message key="attr.courseName"/>,上课人数,考试日期,考试时间,考试地点,主考院系,授课教师,主考老师,是否挂牌", "hidden");
            addInput(form, "activityFormat", "第:weeks周 :day :time", "hidden");
            addInput(form, "taskIds", taskIds, "hidden");
            
            form.action = "examArrange.do?method=export&byClass=" + byClass;
            form.target = "_self";
            form.submit();
        }
        
        function stdList() {
            var taskId = getSelectIds("taskId");
            if (taskId == null || taskId == "" || isMultiId(taskId)) {
                alert("请仅选择一个任务");
                return;
            }
            form.action = "examArrange.do?method=stdList&taskId=" + taskId;
            form.target = "_self";
            form.submit();
        }
        
        function examReport(params) {
            var taskIds = getSelectIds("taskId");
            if (taskIds == null || taskIds == "") {
                alert("请选择一个或多个教学任务");
                return;
            }
            addInput(form, "taskIds", taskIds);
            form.action = "examArrange.do?method=examReport";
            if(null!=params){
               form.action+=params;
            }
            form.target = "_blank";
            form.submit();
        }
        
        function edit() {
            var taskId = getSelectIds("taskId");
            if (taskId == null || taskId == "" || isMultiId(taskId)) {
                alert("请仅选择一个任务");
                return;
            }
            
            var params = getInputParams(parent.document.arrangedTaskSearchForm, null, false);
            var examTypeId = parent.document.arrangedTaskSearchForm['examType.id'].value;
            params += "&examType.id=" + examTypeId;
            addParamsInput(form, params);
            
            form.action = "examArrange.do?method=edit&task.id=" + taskId;
            form.target = "_self";
            form.submit();
        }
        function mergeSetting(){
            var taskIds = getSelectIds("taskId");
            if (taskIds == null  || !isMultiId(taskIds)) {
                alert("请 选择多个时间安排相同的任务");
                return;
            }
            var params = getInputParams(parent.document.arrangedTaskSearchForm, null, false);
            var examTypeId = parent.document.arrangedTaskSearchForm['examType.id'].value;
            params += "&examType.id=" + examTypeId;
            addParamsInput(form, params);
            form.action = "examArrange.do?method=mergeSetting&taskIds=" + taskIds;
            form.target = "_self";
            form.submit();
        }
        
        function examActivityReport() {
            form.action = "examArrange.do?method=examActivityReport";
            form.target = "_blank";
            form.submit();
        }
    </script>
</body>
<#include "/templates/foot.ftl"/> 