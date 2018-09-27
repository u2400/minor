<#include "/templates/head.ftl"/>
<#import "../cycleType.ftl" as RoomApply/>
<script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<style>
input,textarea {
border: 1px solid #333333;
}
</style>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
    <table id="bar"></table>
    <table class="formTable" align="center" width="100%">
        <form action="roomApplyApprove.do?method=freeRoomList" method="post" name="roomApplyForm" onsubmit="return false;">
        <input name="classroomIds" type="hidden" value=""/>
        <tr class="darkColumn"  align="center">
            <td colspan="5"><B>教室借用填写表</B></td>
        </tr>
        <tr>
        	<td class="title" align="center" rowspan="2" style="text-align:center">借用人</td>
        	<td class="title" align="right" width="18%" id="f_username"><font color="red">*</font>&nbsp;姓名：</td>
        	<td width="24%"><input type="hidden" name="roomApply.borrower.user.id" value="${user.id}"/>${user.userName}</td>
        	<td class="title" align="right" width="18%" id="f_addr"><font color="red">*</font>&nbsp;地址：</td>
        	<td width="24%"><input type="text" name="roomApply.borrower.addr" size="15" maxlength="200"/></td>
        </tr>
        <tr>
        	<td class="title" align="right" id="f_mobile"><font color="red">*</font>&nbsp;手机：</td>
			<td><input type="text" name="roomApply.borrower.mobile" size="15" maxlength="20"/></td>
			<td class="title" align="right" id="f_email"><font color="red">*</font>&nbsp;E-mail：</td>
			<td><input type="text" name="roomApply.borrower.email" value="${user.email?default('')}" size="15" maxlength="70"/></td>
        </tr>
        <tr>
        	<td class="title" align="center" rowspan="3" style="text-align:center">借用用途、性质</td>
        	<td class="title" align="right" id="f_activityName"><font color="red">*</font>&nbsp;活动名称：</td>
        	<td colspan	="3"><input type="text" name="roomApply.activityName" size="50" maxlength="50"/></td>
        </tr>
        <tr>
        	<td class="title" align="right" id="f_activityType"><font color="red">*</font>&nbsp;活动类型：</td>
        	<td colspan="3">
        		<#list activityTypes as activityType>
        			<input type="radio" name="roomApply.activityType.id" <#if 0=activityType_index>checked</#if> value="${activityType.id}"/>${activityType.name}&nbsp;&nbsp;
        		</#list>
        	</td>
        </tr>
        <tr>
        	<td class="title" align="right" id="f_isFree"><font color="red">*</font>&nbsp;是否具有营利性：</td>
        	<td colspan="3">
        		<input type="radio" name="roomApply.isFree" value="0"/>&nbsp;营利性&nbsp;
        		<input type="radio" name="roomApply.isFree" value="1" checked/>&nbsp;非营利性
        	</td>
        </tr>
        <tr>
        	<td class="title" align="center" rowspan="2" style="text-align:center">主讲人</td>
        	<td colspan="4" id="f_leading"><font color="red">*</font>&nbsp;姓名及背景资料：</td>
        </tr>
        <tr>
        	<td colspan="4"><textarea name="roomApply.leading" rows="3" cols="50"></textarea></td>
        </tr>
        <tr>
        	<td class="title" align="center" rowspan="2" style="text-align:center">出席者情况</td>
        	<td class="title" align="right" id="f_attendance"><font color="red">*</font>&nbsp;出席对象：</td>
        	<td colspan="3"><input type="text" name="roomApply.attendance" size="50" maxlength="50"/></td>
        </tr>
        <tr>
        	<td class="title" align="right" id="f_attendanceNum"><font color="red">*</font>&nbsp;出席人数：</td>
        	<td colspan="3"><input type="text" name="roomApply.attendanceNum" maxlength="5"/>&nbsp;人&nbsp;&nbsp;&nbsp;(填写数字)</td>
        </tr>
        <tr>
        	<td class="title" style="text-align:center"id="f_roomRequest" rowspan="3" style="text-align:center">&nbsp;借用场所要求</td>
        	<td class="title" align="right" id="f_isFree"><font color="red">*</font>&nbsp;是否使用多媒体设备：</td>
        	<td colspan="3">
        		<input type="radio" name="roomApply.isMultimedia" value="1"<#if (roomApply.isMultimedia)?exists == false || (roomApply.isMultimedia)?exists && roomApply.isMultimedia?string("true", "false") == "true"> checked</#if>/>&nbsp;使用&nbsp;
        		<input type="radio" name="roomApply.isMultimedia" value="0"<#if (roomApply.isMultimedia)?exists && roomApply.isMultimedia?string("true", "false") == "false"> checked</#if>/>&nbsp;不使用
        	</td>
        </tr>
        <tr>
        	<td class="title"><font color="red">*</font>&nbsp;借用校区：</td>
        	<td colspan="3"><@htm.i18nSelect datas=schoolDistricts selected=(roomApply.schoolDistrict.id?string)?default("") name="roomApply.schoolDistrict.id" style="width:200px"/></td>
        </tr>
        <tr>
        	<td class="title">其它要求：</td>
        	<td colspan="3"><textarea name="roomApply.roomRequest" rows="3" cols="35"></textarea></td>
        </tr>
        <tr>
        	<td class="title" align="center" rowspan="3" style="text-align:center">借用时间要求</td>
            <td class="title" id="f_begin_end" align="right"><font color="red">*</font>&nbsp;教室使用日期：</td>
            <td colspan="3"><input type="text" name="roomApply.applyTime.dateBegin" onfocus="calendar()" size="10" maxlength="10"/> - <input type="text" name="roomApply.applyTime.dateEnd" onfocus="calendar()" size="10" maxlength="10"/> (年月日 格式2007-10-20)</td>
        </tr>
        <tr>
            <td class="title" id="f_beginTime_endTime" align="right"><font color="red">*</font>&nbsp;教室使用时间：</td>
            <td colspan="3"><input type="text" name="roomApply.applyTime.timeBegin" size="10" class="LabeledInput" value="" format="Time"  maxlength="5"/> - <input type="text" name="roomApply.applyTime.timeEnd" size="10" maxlength="5"/> (时分 格式如09:00 共五位)</td>
        </tr>
        <tr >
            <td class="title" id="f_cycleCount" align="right"><font color="red">*</font>&nbsp;时间周期：</td>
            <td colspan="3">每&nbsp;<input type="text" name="roomApply.applyTime.cycleCount" style="width:20px" maxlength="2"/><@RoomApply.cycleTypeSelect  name="roomApply.applyTime.cycleType" cycleType=(roomApply.applyTime.cycleType)?default(1)/></td>
        </tr>
        <tr>
        	<td class="title" align="center" rowspan="4" style="text-align:center">借用方承诺</td>
            <td colspan="4">(1)遵守学校教室场所使用管理要求，保持环境整洁，不吸烟、不乱抛口香糖等杂物。 </td>
        </tr>         
        <tr><td colspan="4">(2)遵守学校治安管理规定，确保安全使用。若因借用人管理和使用不当造成安全事故，借用人自行承担责任。</td></tr>
        <tr><td colspan="4">(3)遵守学校财产物资规定，损坏设备设施按原值赔偿。</td></tr>
        <tr>
          	<td class="title" align="right" id="f_applicant"><font color="red">*</font>&nbsp;申请人签名：</td>
            <td colspan="3"><input type="text" name="roomApply.applicant" maxlength="20"/>
                                  填表申请时间：${applyAt?string("yyyy-MM-dd HH:mm:ss")}<input type="hidden" name="roomApply.applyAt" value="${applyAt?string("yyyy-MM-dd HH:mm:ss")}"/></td>
        </tr>
        <tr>
        	<td class="title" rowspan="5" style="text-align:center">归口审核</td>
        	<td colspan="4">1.各院系学术讲座、办班等院长或系主任负责审批；</td>
        </tr>
        <tr><td colspan="4">2.各院系学生活动由各院系总支副书记负责审批(学生社团活动除外)；</td></tr>
        <tr><td colspan="4">3.校团委、校学生会、社团联合会以及所有学生社团活动归口团委审批。</td></tr>
        <tr><td colspan="4">4.后勤管理处直接审批(适应于“就业指导中心”等特殊部门)。</td></tr>
        <tr>
        	<td class="title"><font color="red">*</font>&nbsp;归口审核部门：</td>
        	<td colspan="3"><@htm.i18nSelect datas=departments?sort_by("name") selected="" name="roomApply.auditDepart.id"/></td>
        </tr>
        <tr class="darkColumn">
            <td colspan="5" align="center"><button onClick="apply()">申请</button>&nbsp;&nbsp;<button onClick="this.form.reset()">重填</button></td>
        </tr>
        </form>
    </table>
    <br><br><br><br><br><br><br><br><br><br>
    <script>
        var bar = new ToolBar("bar", "添加申请", null, true, true);
        bar.setMessage('<@getMessage/>');
        
        bar.addItem("申请", "apply()");
        
        var form = document.roomApplyForm;
        function apply() {
            var a_fields = {
            	'roomApply.borrower.addr':{'l':'借用人地址', 'r':true, 't':'f_addr'},
            	'roomApply.borrower.mobile':{'l':'借用人手机', 'r':true, 't':'f_mobile','f':'unsigned'},
            	'roomApply.borrower.email':{'l':'借用人E-mail', 'r':true, 't':'f_email', 'f':'email'},
            	'roomApply.activityName':{'l':'活动名称', 'r':true, 't':'f_activityName'},
            	'roomApply.activityType.id':{'l':'活动类型','r':true, 't':'f_activityType'},
            	'roomApply.isFree':{'l':'是否具有营利性', 'r':true, 't':'f_isFree'},
            	'roomApply.leading':{'l':'姓名及资料背景', 'r':true, 't':'f_leading','mx':200},
            	'roomApply.attendance':{'l':'出席对象', 'r':true, 't':'f_attendance'},
            	'roomApply.attendanceNum':{'l':'出席人数', 'r':true, 't':'f_attendanceNum', 'f':'unsigned'},
                'roomApply.applyTime.dateBegin':{'l':'教室使用日期的“起始日期”', 'r':true, 't':'f_begin_end','f':'date'},
                'roomApply.applyTime.dateEnd':{'l':'教室使用日期的“结束日期”', 'r':true, 't':'f_begin_end','f':'date'},
                'roomApply.applyTime.timeBegin':{'l':'教室使用的“开始”时间点', 'r':true, 't':'f_beginTime_endTime','f':'shortTime'},
                'roomApply.applyTime.timeEnd':{'l':'教室使用的“结束”时间点', 'r':true, 't':'f_beginTime_endTime','f':'shortTime'},
                'roomApply.applyTime.cycleCount':{'l':'单位数量', 'r':true, 't':'f_cycleCount', 'f':'positiveInteger'},
                'roomApply.applicant':{'l':'申请人签名', 'r':true, 't':'f_applicant'}
            };
            var v = new validator(form, a_fields, null);
            if (v.exec()) {
                if(form['roomApply.applyTime.dateBegin'].value>form['roomApply.applyTime.dateEnd'].value){
                   alert("借用日期不对");return;
                }
                if(form['roomApply.applyTime.timeBegin'].value>=form['roomApply.applyTime.timeEnd'].value){
                   alert("借用时间不对");return;
                }
                
                var dateBegin = form["roomApply.applyTime.dateBegin"].value;
                var dateEnd = form["roomApply.applyTime.dateEnd"].value;
                var cycleCount = form["roomApply.applyTime.cycleCount"].value;
                
                var beginYear = parseInt(dateBegin.substr(0, 4));
                var beginMonth = parseInt(dateBegin.substr(5, 2));
                var beginDate = parseInt(dateBegin.substr(8, 2));
                var date1 = new Date(beginYear, beginMonth - 1, beginDate);
                var endYear = parseInt(dateEnd.substr(0, 4));
                var endMonth = parseInt(dateEnd.substr(5, 2));
                var endDate = parseInt(dateEnd.substr(8, 2));
                var date2 = new Date(endYear, endMonth - 1, endDate);
                
                if (form["roomApply.applyTime.cycleType"].value == "2") {
                    var tmp = new Date(date1.getFullYear(), date1.getMonth(), date1.getDate() + (7 * cycleCount));
                    if (tmp.getFullYear() > date2.getFullYear() || tmp.getMonth() > date2.getMonth() || tmp.getDate() > date2.getDate()) {
                        alert("借用日期与时间周期不匹配。");
                        return;
                    }
                } else if (form["roomApply.applyTime.cycleType"].value == "4") {
                    var tmp = new Date(date1.getFullYear(), date1.getMonth() + cycleCount, date1.getDate());
                    if (tmp.getFullYear() > date2.getFullYear() || tmp.getMonth() > date2.getMonth() || tmp.getDate() > date2.getDate()) {
                        alert("借用日期与时间周期不匹配。");
                        return;
                    }
                }
                
	            form.action = "roomApply.do?method=apply";
	            form.target = "";
	            form.submit();
            }
        }
        
        function lookFreeApply() {
            form.action = "roomApply.do?method=lookFreeApply";
            form.target = "_blank";
            form.submit();
        }
    </script>
</BODY>
<#include "/templates/foot.ftl"/>
