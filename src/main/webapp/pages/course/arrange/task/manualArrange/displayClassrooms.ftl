<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="<@bean.message key="validator.js.url"/>"></script>
<body>
    <table id="bar"></table>
    <table width="100%" cellspacing="0" cellpadding="0" style="border-spacing:0px;padding:0px">
        <tr valign="top">
            <td style="border-spacing:0px;padding:0px">
                <table class="listTable" width="100%">
                    <tr>
                        <th class="darkColumn">要被更换的教室（排课结果）</th>
                    </tr>
                </table>
                <@table.table id="taskActivityList" width="100%">
                    <@table.thead>
                        <@table.td text="" width="2%"/>
                        <@table.td text="排课情况" width="35%"/>
                        <@table.td text="所排教室"/>
                    </@>
                    <@table.tbody datas=task.arrangeInfo.activities;activity,activity_index>
                        <td><input name="activityId" value="${activity.id}" type="radio"<#if activity_index == 0> checked</#if> onchange="document.actionForm['activityId'].value = this.checked ? this.value : ''"/></td>
                        <td>${activity.digest(Request["org.apache.struts.action.MESSAGE"],Session["org.apache.struts.action.LOCALE"],":teacher2 :day :units 第:weeks周")}</td>
                        <td>${activity.room.name}（代码：${activity.room.code}）<font color="blue">[实际人数/选课人数上限/容量：${activity.task.teachClass.stdCount?default(0)}/${activity.task.electInfo.maxStdCount?default(0)}/${activity.room.capacityOfCourse?default(0)}]</font></td>
                    </@>
                </@>
            </td>
        </tr>
        <tr valign="top">
            <td style="border-spacing:0px;padding:0px" height="25px">
            </td>
        </tr>
        <tr valign="top">
            <td style="border-spacing:0px;padding:0px">
                <table class="listTable" width="100%">
                    <tr>
                        <td class="darkColumn" colspan="2" style="text-align:center;font-weight:bold">可更换的教室（空闲）</td>
                    </tr>
                    <tr>
                        <td width="50%" style="padding-left:65px;text-indent:-65px">所选教室：<span id="selectedRoom" style="color:blue"></span></td>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="activityId" value=""/>
        <input type="hidden" name="toRoomId" value=""/>
        <input type="hidden" name="orderBy" value="room.capacityOfCourse desc"/>
        <input type="hidden" name="requestURI" value="${RequestParameters["requestURI"]?default("")}"/>
        <input type="hidden" name="params" value="${RequestParameters["params"]?default("")}&isTaskIn=${RequestParameters['isTaskIn']?default('')}&task.arrangeInfo.isArrangeComplete=${RequestParameters['task.arrangeInfo.isArrangeComplete']?default('')}"/>
                        <td><span id="f_maxStdCount">选课人数上限：</span><input type="text" name="maxStdCount" value="0" maxlength="5" style="width:50px;text-align:right"/><span>（默认为所选教室听课人数或为 0 ）</span></td>
    </form>
                    </tr>
                </table>
                <table width="100%" cellspacing="0" cellpadding="0" style="border-spacing:0px;padding:0px">
                    <tr>
                        <td style="border-spacing:0px;padding:0px">
                            <iframe name="pageIframe" src="#" width="100%" frameborder="0" scrolling="no"></iframe>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "<font color=\"blue\">${task.seqNo}（课程序号）教学任务</font>更新教室", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("确定替换", "changeClassroom()");
        bar.addBackOrClose("<@msg.message key="action.back"/>", "<@msg.message key="action.close"/>");
        
        var form = document.actionForm;
        if (isEmpty(form["activityId"].value)) {
            document.getElementsByName("activityId")[0].checked = true;
        }
        if (isEmpty(form["maxStdCount"].value) || isEmpty($("selectedRoom").innerHTML.trim())) {
            form["maxStdCount"].value = 0;
        }
        form["toRoomId"].value = "";
        form["orderBy"].value = "room.capacityOfCourse desc";
        
        function freeClassrooms() {
            form.action = "manualArrange.do?method=freeClassroomList";
            form["activityId"].value = getSelectId("activityId");
            form.target = "pageIframe";
            form.submit();
        }
        
        function changeClassroom() {
            if (isEmpty(form["activityId"].value)) {
                alert("请选择要被替换的排课记录。");
                return;
            }
            if (isEmpty(form["toRoomId"].value)) {
                alert("请选择要替换的教室。");
                return;
            }
            var a_fields = {
                'maxStdCount':{'l':'选课人数上限', 'r':true, 't':'f_maxStdCount', 'f':'unsigned'}
            };
            var v = new validator(form, a_fields, null);
            if (v.exec() && confirm("确认要替换吗？")) {
                form.action = "manualArrange.do?method=changeClassroom";
                form.target = "_self";
                form.submit();
            }
        }
        
        freeClassrooms();
    </script>
</body>
<#include "/templates/foot.ftl"/>