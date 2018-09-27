<#include "/templates/head.ftl"/>
<#import "/pages/course/arrange/apply/cycleType.ftl" as RoomApply/>
<BODY>
    <#assign cycyleNames={'1':'天','2':'周','4':'月'}/>
    <table id="myBar" width="100%"></table>
    <table style="font-size:14px;border-bottom:black 1px dotted" width="600px" align="center">
        <tr>
            <td>
                <table style="font-size:14px;line-height:0.75cm" width="100%">
                    <tr>
                        <th style="text-align:center;font-size:20px;height:70px;vertical-align:middle">教室借用凭证（存根）</th>
                    </tr>
                    <tr>
                        <#assign tdStyle="border-bottom:black 1px solid;padding: 0px 0px 2px 0px"/>
                        <#assign departmentValue = department?default('')?replace("学院", "")/>
                        <#assign borrowerDepartment = thisObject.getUserDepartment(roomApply.borrower.user.name)?if_exists/>
                        <td style="text-align:justify;text-justify:inter-ideograph;text-indent:28px;font-family:宋体,MiscFixed">
                          兹有<#if (borrowerDepartment.name)?exists><span style="${tdStyle}">${borrowerDepartment.name}${roomApply.borrower.user.userName}</span>
                          ${(roomApply.borrower.user.defaultCategory.id == STD_USER)?string("同学", "老师")}(<span style="${tdStyle}">${(roomApply.borrower.user.defaultCategory.id == STD_USER)?string("学号", "工号")}&nbsp;${roomApply.borrower.user.name}</span>)
                          <#else><span style="${tdStyle}">&nbsp;${roomApply.borrower.user.userName}&nbsp;</span>管理员(<span style="${tdStyle}">帐号&nbsp;${roomApply.borrower.user.name}</span>)</#if>，Tel<span>&nbsp;${roomApply.borrower.mobile}&nbsp;，
                          因<span style="${tdStyle}">&nbsp;${roomApply.activityName}&nbsp;</span>之需，
                          于<span style="${tdStyle}">&nbsp;${roomApply.applyTime.dateBegin?string("yyyy-MM-dd")}～${roomApply.applyTime.dateEnd?string("yyyy-MM-dd")}（${roomApply.applyTime.timeBegin?replace(":", "")[0..1]}:${roomApply.applyTime.timeBegin?replace(":", "")[2..3]}-${roomApply.applyTime.timeEnd?replace(":", "")[0..1]}:${roomApply.applyTime.timeEnd?replace(":", "")[2..3]}）(<@RoomApply.cycleValue  roomApply.applyTime.cycleCount  roomApply.applyTime.cycleType/>)</span>
                          借用<span style="${tdStyle}">&nbsp;<#list (roomApply.classrooms?sort_by("name"))?if_exists as classroom><@i18nName classroom/><#if classroom_has_next>、</#if></#list>&nbsp;</span>。
                        </td>
                    </tr>
                    <tr>
                        <#assign roomRequestValue = ""/>
                        <#if roomApply.roomRequest?exists && (roomApply.roomRequest?contains("1") || roomApply.roomRequest?contains("1"))>
                            <#if roomApply.roomRequest[0] == "1">
                                <#assign roomRequestValue = "电脑"/>
                            </#if>
                            <#if roomApply.roomRequest[1] == "1">
                                <#assign roomRequestValue = (roomRequestValue?length == 0)?string("", roomRequestValue + "，") + "投影仪"/>
                            </#if>
                            <#if roomApply.roomRequest[2] == "1">
                                <#assign roomRequestValue = (roomRequestValue?length == 0)?string("", roomRequestValue + "，") + "扩音设备"/>
                            </#if>
                        </#if>
                        <td style="text-align:justify;text-justify:inter-ideograph;text-indent:28px;font-family:宋体,MiscFixed">（${(roomApply.roomRequest)?default("000")?contains("1")?string("要", "不")}）使用教学设备<#if roomRequestValue?length != 0>（${roomRequestValue?string}）</#if>。</td>
                    </tr>
                </table>
                <table width="150px" align="right" style="font-size:14px;text-align:center;font-family:宋体,MiscFixed">
                    <tr>
                        <td height="50px" valign="bottom">盖章：<span style="color:white">(各具体学院)</span></td>
                    </tr>
                    <tr>
                        <td height="50px" valign="top">${Session["nowDate"]?string("yyyy-MM-dd")}</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <table style="font-size:14px" width="600px" align="center">
        <tr>
            <td>
                <table style="font-size:14px;line-height:0.75cm" width="100%">
                    <tr>
                        <th style="text-align:center;font-size:20px;height:70px;vertical-align:middle">教室借用凭证（存根）</th>
                    </tr>
                    <tr>
                        <td style="text-align:justify;text-justify:inter-ideograph;text-indent:28px;font-family:宋体,MiscFixed">
                          兹有<#if (borrowerDepartment.name)?exists><span style="${tdStyle}">${borrowerDepartment.name}${roomApply.borrower.user.userName}</span>
                          ${(roomApply.borrower.user.defaultCategory.id == STD_USER)?string("同学", "老师")}(<span style="${tdStyle}">${(roomApply.borrower.user.defaultCategory.id == STD_USER)?string("学号", "工号")}&nbsp;${roomApply.borrower.user.name}</span>)
                          <#else><span style="${tdStyle}">&nbsp;${roomApply.borrower.user.userName}&nbsp;</span>管理员(<span style="${tdStyle}">帐号&nbsp;${roomApply.borrower.user.name}</span>)</#if>，Tel<span>&nbsp;${roomApply.borrower.mobile}&nbsp;，
                          因<span style="${tdStyle}">&nbsp;${roomApply.activityName}&nbsp;</span>之需，
                          于<span style="${tdStyle}">&nbsp;${roomApply.applyTime.dateBegin?string("yyyy-MM-dd")}～${roomApply.applyTime.dateEnd?string("yyyy-MM-dd")}（${roomApply.applyTime.timeBegin?replace(":", "")[0..1]}:${roomApply.applyTime.timeBegin?replace(":", "")[2..3]}-${roomApply.applyTime.timeEnd?replace(":", "")[0..1]}:${roomApply.applyTime.timeEnd?replace(":", "")[2..3]}）(<@RoomApply.cycleValue  roomApply.applyTime.cycleCount  roomApply.applyTime.cycleType/>)</span>
                          借用<span style="${tdStyle}">&nbsp;<#list (roomApply.classrooms?sort_by("name"))?if_exists as classroom><@i18nName classroom/><#if classroom_has_next>、</#if></#list>&nbsp;</span>。
                       </td>
                    </tr>
                    <tr>
                        <td style="text-align:justify;text-justify:inter-ideograph;text-indent:28px;font-family:宋体,MiscFixed">（${(roomApply.roomRequest)?default("000")?contains("1")?string("要", "不")}）使用教学设备<#if roomRequestValue?length != 0>（${roomRequestValue?string}）</#if>。</td>
                    </tr>
                    <tr>
                        <td style="text-align:justify;text-justify:inter-ideograph;text-indent:28px;font-family:宋体,MiscFixed">请管理人员届时开放教室，并于教室使用完毕后予以检查。</td>
                    </tr>
                </table>
                <table width="150px" align="right" style="font-size:14px;text-align:center;font-family:宋体,MiscFixed">
                    <tr>
                        <td height="50px" valign="bottom"></td>
                    </tr>
                    <tr>
                        <td height="20px" valign="top" style="text-align:left">签发人：</td>
                    </tr>
                    <tr>
                        <td height="50px" valign="top">${Session["nowDate"]?string("yyyy-MM-dd")}</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <table style="font-size:14px;border:black 1px solid;text-align:justify;text-justify:inter-ideograph;text-indent:28px;font-family:宋体,MiscFixed;line-height:0.75cm" width="600px" align="center">
        <tr>
            <td>以下部分由物业管理人员填写</td>
        </tr>
        <tr>
            <td>教室借用情况（用“√”表示）</td>
        </tr>
        <tr>
            <td>卫生状况：好<span style="${tdStyle};width:70px"></span>中<span style="${tdStyle};width:70px"></span>差<span style="${tdStyle};width:70px"></span></td>
        </tr>
        <tr>
            <td>课桌复位：已复位<span style="${tdStyle};width:70px"></span>未复位<span style="${tdStyle};width:70px"></span></td>
        </tr>
        <tr>
            <td>教学设备归还：电脑<span style="${tdStyle};width:70px"></span>投影仪<span style="${tdStyle};width:70px"></span>扩音设备<span style="${tdStyle};width:70px"></span></td>
        </tr>
        <tr>
            <td height="30px"></td>
        </tr>
        <tr>
            <td style="text-indent:${14*20}px">物业保安签名：</td>
        </tr>
        <tr>
            <td style="text-indent:${14*25}px"><span style="width:50px"></span>年<span style="width:50px"></span>月<span style="width:50px"></span>日</td>
        </tr>
    </table>
    <table style="font-size:14px;font-family:宋体,MiscFixed;line-height:0.75cm" width="600px" align="center">
        <tr>
            <td height="80px">注：本回执由教学值班室汇总后交教务处存档</td>
        </tr>
    </table>
    <script>
        var bar =new ToolBar("myBar","教室借用凭证",null,true,true);
        bar.setMessage('<@getMessage/>');
        bar.addPrint("<@msg.message key="action.print"/>");
        bar.addItem("<@msg.message key="action.back"/>", "toBack()", "backward.gif");

        function toBack() {
            try {
                parent.search();
            } catch (e) {
                try {
                    parent.document.getElementById("item2").onclick();
                } catch (e) {
                    back();
                }
            }
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>