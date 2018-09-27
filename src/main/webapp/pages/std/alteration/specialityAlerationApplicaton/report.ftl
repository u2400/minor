<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table align="center" cellpadding="0" cellspacing="0" style="font-size:14pt;font-weight:bold">
        <tr>
            <td><div style="height:20px"></div>${systemConfig.school.name}全日制${application.std.type.name}转专业（方向）申请表<div style="height:20px"></div></td>
        </tr>
    </table>
    <table id="applicationReportTable" class="listTable" align="center" style="text-align:center;vertical-align:middle;font-size:12pt;table-layout:fixed;word-break:break-all">
        <tr style="height:1cm">
            <td style="width:2.52cm">姓名</td>
            <td style="width:2.42cm;padding-left:2px;padding-right:2px">${application.std.name}</td>
            <td style="width:1.18cm">学号</td>
            <td style="width:2.48cm;padding-left:2px;padding-right:2px">${application.std.code}</td>
            <td style="width:2.87cm">性别</td>
            <td style="width:1.17cm;padding-left:2px;padding-right:2px">${(application.std.basicInfo.gender.name)?if_exists}</td>
            <td style="width:1.69cm">班级</td>
            <td style="width:2.23cm;padding-left:2px;padding-right:2px">${(application.std.firstMajorClass.name)?if_exists}</td>
        </tr>
        <tr style="height:1cm">
            <td>手机</td>
            <td colspan="3">${(application.std.basicInfo.mobile)?if_exists}</td>
            <td>住址电话</td>
            <td colspan="3">${(application.std.basicInfo.phone)?if_exists}</td>
        </tr>
        <tr style="height:1cm">
            <td>所在院系</td>
            <td style="padding-left:2px;padding-right:2px">${(application.std.department.name)?if_exists}</td>
            <td colspan="2">所学专业</td>
            <td style="padding-left:2px;padding-right:2px">${(application.std.firstMajor.name)?if_exists}</td>
            <td colspan="2">专业方向</td>
            <td style="padding-left:2px;padding-right:2px">${(application.std.firstAspect.name)?if_exists}</td>
        </tr>
        <tr style="height:1cm">
            <td>拟转入院系</td>
            <td style="padding-left:2px;padding-right:2px">${(application.majorPlan.major.department.name)?if_exists}</td>
            <td colspan="2">拟转入专业</td>
            <td style="padding-left:2px;padding-right:2px">${(application.majorPlan.major.name)?if_exists}</td>
            <td colspan="2">拟转入方向</td>
            <td style="padding-left:2px;padding-right:2px">${(application.majorPlan.majorField.name)?if_exists}</td>
        </tr>
        <tr style="height:1cm">
            <td colspan="5" style="text-align:left;padding-left:5px"><span style="letter-spacing:5.5pt">第一学年平均学分绩点</span>（学校填写）</td>
            <td colspan="3"></td>
        </tr>
        <tr style="height:1cm">
            <td colspan="5" style="text-align:left;padding-left:5px"><span style="letter-spacing:5.5pt">学分绩点排名</span>（学校填写）</td>
            <td colspan="3"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px">转专业（方向）理由，并提供相应材料（附后）：</td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:369px;border-bottom-width:0px">申请人签名</td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:475px"><span style="letter-spacing:24pt">年月日</span></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px">学生所在院系推荐意见：</td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:369px;border-bottom-width:0px">签名（盖章）：</td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:475px"><span style="letter-spacing:24pt">年月日</span></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px">拟转入院系面试意见：</td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:369px;border-bottom-width:0px">面试教师签名：</td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:475px"><span style="letter-spacing:24pt">年月日</span></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px">拟转入院系意见：</td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:369px;border-bottom-width:0px">签名（盖章）：</td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:475px"><span style="letter-spacing:24pt">年月日</span></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px">教务处意见：</td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:369px;border-bottom-width:0px">签名（盖章）：</td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:475px"><span style="letter-spacing:24pt">年月日</span></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px">学校审批意见：</td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:21px;border-bottom-width:0px"></td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:369px;border-bottom-width:0px">签名（盖章）：</td>
        </tr>
        <tr style="height:0.6cm">
            <td colspan="8" style="text-align:left;padding-left:475px"><span style="letter-spacing:24pt">年月日</span></td>
        </tr>
    </table>
    <script>
        var oBar = new ToolBar("bar", "转专业（方向）申请表", null, true, true);
        oBar.setMessage('<@getMessage/>');
        oBar.addPrint();
        oBar.addClose();
        
        <#--单元格缩写字体填充-->
        function update() {
            var oTable = document.getElementById("applicationReportTable");
            for (var i = 0; i < 4; i++) {
                for (var j = 0; j < oTable.rows[i].cells.length; j++) {
                    oTable.rows[i].cells[j].style.fontSize = oTable.style.fontSize;
                    var iHeight = oTable.rows[i].cells[j].scrollHeight;
                    autofs(oTable.rows[i].cells[j]);
                    if (iHeight != oTable.rows[i].cells[j].scrollHeight && oTable.rows[i].cells[j].scrollHeight > 20) {
                        oTable.rows[i].cells[j].style.paddingTop = "5px";
                    }
                }
            }
        }
        
        function autofs(o){
            var fs = o.style.fontSize;
            fs = Number(fs.replace("pt",""));
            var sh = o.scrollHeight;
            var oh = o.offsetHeight;
            //alert(o.innerHTML + " : " + sh + ", " + oh + " , " + fs);
            if (sh > oh - 10) {
                fs -= 0.1;
                o.style.fontSize = fs + "pt";
                autofs(o);
            }
        }
        
        update();
        
        alert("打印前请核对手机号码与住址号码是否正确，\n若不正确，请至学籍信息——个人信息——\n基本信息自行修改并且提交。");
    </script>
</body>
<#include "/templates/foot.ftl"/>