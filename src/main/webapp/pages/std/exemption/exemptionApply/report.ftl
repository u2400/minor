<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#assign tdWidthes = [
        "0",
        "width:1.165cm",
        "width:2.89cm",
        "width:1.64cm",
        "width:1.28cm",
        "width:0.35cm",
        "width:0.92cm",
        "width:0.94cm",
        "width:1.19cm",
        "width:1.19cm",
        "width:0.8cm",
        "width:1.76cm",
        "width:0.5cm",
        "width:2.81cm"
    ]/>
    <#--第一页-->
    <div style="height:60px"></div>
    <div style="text-align:center;font-size:16pt;font-family:黑体;font-weight:bold;height:30px;vertical-align:middle"><span style="letter-spacing:8pt">${systemConfig.school.name}</span></div>
    <div style="text-align:center;font-size:15pt;font-family:黑体;font-weight:bold;letter-spacing:0.01cm"><span style="font-family:Times New Roman">${applyResult.calendar.start?string("yyyy")}</span>年推荐优秀应届本科毕业生免试攻读硕士学位研究生申请表</div>
    <table id="exemptionReportTable" class="listTable" align="center" style="text-align:center;font-size:10.5pt;table-layout:fixed;work-break:break-all;vertical-align:middle;border-top-width:0px;border-left-width:0px;border-right-width:0px" cellpadding="0" cellspacing="0">
        <tr style="height:0cm">
            <td style="${tdWidthes[1]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[2]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[3]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[4]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[5]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[6]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[7]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[8]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[9]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[10]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[11]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[12]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[13]}" style="border-left-width:0px;border-right-width:0px"></td>
        </tr>
        <tr style="height:0.88cm">
            <td style="padding-left:0.13cm;padding-right:0.13cm;border-left-width:1px" rowspan="7">申请人基本情况</td>
            <td style="letter-spacing:10.5pt">姓名</td>
            <td colspan="2">${applyResult.student.name}</td>
            <td style="letter-spacing:2.5pt" colspan="3">性别</td>
            <td>${(applyResult.student.basicInfo.gender.name)?if_exists}</td>
            <td colspan="2">出生年月</td>
            <td>${(applyResult.student.basicInfo.birthday?string("yyyy.M"))?if_exists}</td>
            <td rowspan="5" colspan="2">（贴一寸正面免<br>冠近照）</td>
        </tr>
        <tr style="height:0.88cm">
            <td>所在学院</td>
            <td colspan="2">${applyResult.student.department.name}</td>
            <td style="letter-spacing:2.5pt" colspan="3">班级</td>
            <td>${(applyResult.student.firstMajorClass.name)?if_exists}</td>
            <td style="letter-spacing:2.5pt" colspan="2">学号</td>
            <td>${applyResult.student.code}</td>
        </tr>
        <tr style="height:0.88cm">
            <td>专业（方向）</td>
            <td colspan="5">${applyResult.student.firstMajor.name}${("（" + applyResult.student.firstAspect.name + "）")?if_exists}</td>
            <td colspan="2">学位类别</td>
            <td colspan="2">${(applyResult.student.degreeInfo.undergraduate.name)?if_exists}</td>
        </tr>
        <tr style="height:0.88cm">
            <td style="letter-spacing:10.5pt">籍贯</td>
            <td>${(applyResult.student.basicInfo.ancestralAddress)?if_exists}</td>
            <td style="letter-spacing:2.5pt" colspan="2">民族</td>
            <td colspan="2">${(applyResult.student.basicInfo.nation.name)?if_exists}</td>
            <td colspan="2">政治面貌</td>
            <td colspan="2">${(applyResult.student.basicInfo.politicVisage.name)?if_exists}</td>
        </tr>
        <tr style="height:0.88cm">
            <td>手机号码</td>
            <td colspan="5">${(applyResult.student.basicInfo.mobile)?if_exists}</td>
            <td colspan="2">邮政编码</td>
            <td colspan="2">${(applyResult.student.basicInfo.postCode)?if_exists}</td>
        </tr>
        <tr style="height:0.88cm">
            <td>E-mail</td>
            <td colspan="3">${(applyResult.student.basicInfo.mail)?if_exists}</td>
            <td colspan="2">通讯地址</td>
            <td colspan="6">${(applyResult.student.basicInfo.homeAddress)?if_exists}</td>
        </tr>
        <tr style="height:0.88cm">
            <td>英语六级成绩</td>
            <td colspan="11"></td>
        </tr>
        <tr style="height:1.62cm">
            <td style="padding-left:0.13cm;padding-right:0.13cm;border-left-width:1px">二级学院填写</td>
            <td colspan="2">课程平均学分绩点</td>
            <td colspan="3">${(stdGPA.GPA?string("#.##"))?if_exists}</td>
            <td colspan="2">附加分</td>
            <td colspan="2"></td>
            <td colspan="2" style="letter-spacing:10.5pt">总分</td>
            <td>${(stdGPA.credits?string("#.##"))?if_exists}</td>
        </tr>
        <tr style="height:0.88cm">
            <td style="padding-left:0.13cm;padding-right:0.13cm;border-left-width:1px" rowspan="4">申请信息</td>
            <td colspan="2">申请学校名称</td>
            <td colspan="10" style="text-align:left;padding-left:0.13cm;padding-right:0.13cm">${applyResult.schoolName}</td>
        </tr>
        <tr style="height:0.88cm">
            <td colspan="2">申请类型</td>
            <td colspan="10" style="text-align:left;padding-left:0.13cm;padding-right:0.13cm"><#list applyTypes as applyType>${applyType.name}（<span style="width:20px;text-align:center"><#if applyResult.applyType.id == applyType.id>√</#if></span>）<#if applyType_has_next><span style="width:10px"></span></#if></#list></td>
        </tr>
        <tr style="height:0.88cm">
            <td colspan="2">申请专业（方向）名称</td>
            <td colspan="10" style="text-align:left;padding-left:0.13cm;padding-right:0.13cm">${applyResult.majorName}</td>
        </tr>
        <tr style="height:0.88cm">
            <td colspan="2">愿否专业（方向）调剂</td>
            <td colspan="10" style="text-align:left;padding-left:0.13cm;padding-right:0.13cm">愿（<span style="width:20px;text-align:center"><#if applyResult.isAllowMajor>√</#if></span>）<span style="width:10px"></span>否（<span style="width:20px;text-align:center"><#if !applyResult.isAllowMajor>√</#if></span>）</td>
        </tr>
        <tr style="height:15pt">
            <td style="padding-left:0.13cm;padding-right:0.13cm;border-left-width:1px" rowspan="6">本科期间获奖励情况</td>
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="padding-left:22pt;text-align:left;border-bottom-width:0px">奖励称号、等级（附复印件一份）</td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12"></td>
        </tr>
        <tr style="height:15pt">
            <td style="padding-left:0.13cm;padding-right:0.13cm;border-left-width:1px" rowspan="5">学术成果及科研情况</td>
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px;text-align:right;padding-right:0.13cm">（附复印一份）</td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12"></td>
        </tr>
        <tr style="height:15pt">
            <td style="padding-left:0.13cm;padding-right:0.13cm;border-left-width:1px" rowspan="7">申请人<br>承诺</td>
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:30pt">
            <td colspan="12" style="border-bottom-width:0px;padding-left:0.13cm;padding-right:0.13cm;text-align:justify;text-justify:inter-ideograph;text-indent:21pt">本人保证以上所填内容及所提交的全部申请材料均真实有效。如果有不真实或故意隐瞒的地方，我同意华东政法大学随时取消我的录取资格，由此造成的一切后果由本人自负。</td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px">申请人签名：<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:63pt"></span><span style="width:157.5pt"></span><span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>年<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>月<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>日</td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12"></td>
        </tr>
    </table>
    <div style='PAGE-BREAK-AFTER: always'>&nbsp;</div>
    <#--第二页-->
    <table class="listTable" align="center" style="text-align:center;font-size:10.5pt;table-layout:fixed;work-break:break-all;vertical-align:middle;border-top-width:0px;border-left-width:0px;border-right-width:0px" cellpadding="0" cellspacing="0">
        <tr style="height:0cm">
            <td style="${tdWidthes[1]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[2]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[3]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[4]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[5]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[6]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[7]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[8]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[9]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[10]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[11]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[12]}" style="border-left-width:0px;border-right-width:0px"></td>
            <td style="${tdWidthes[13]}" style="border-left-width:0px;border-right-width:0px"></td>
        </tr>
        <tr style="height:18pt">
            <td style="padding-left:0.13cm;padding-right:0.13cm;border-left-width:1px" rowspan="5">本人特别申明</td>
            <td colspan="12" style="border-bottom-width:0px;padding-left:0.13cm;text-align:left;font-size:12pt;font-weight:bold;text-indent:18pt">本人只愿意接受学术型推免资格（是<span style="border-width:1px;border-color:black;border-style:solid;width:15pt;text-align:center;text-indent:0pt"><#if applyResult.isAllowAcademic>√</#if></span><span style="width:5px"></span>/<span style="width:5px"></span>否<span style="border-width:1px;border-color:black;border-style:solid;width:15pt;text-align:center;text-indent:0pt"><#if !applyResult.isAllowAcademic>√</#if></span>）。</td>
        </tr>
        <tr style="height:18pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:18pt">
            <td colspan="12" style="border-bottom-width:0px;padding-left:0.13cm;text-align:left;font-size:12pt;font-weight:bold;text-indent:18pt">本人接受调剂为专业学位推免资格（是<span style="border-width:1px;border-color:black;border-style:solid;width:15pt;text-align:center;text-indent:0pt"><#if applyResult.isAllowDegree>√</#if></span><span style="width:5px"></span>/<span style="width:5px"></span>否<span style="border-width:1px;border-color:black;border-style:solid;width:15pt;text-align:center;text-indent:0pt"><#if !applyResult.isAllowDegree>√</#if></span>）。</td>
        </tr>
        <tr style="height:18pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:18pt">
            <td colspan="12" style="font-weight:bold"><span style="font-size:12pt">本人签名：</span><span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:63pt"></span><span style="width:157.5pt"></span><span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt;font-size:10pt"></span>年<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>月<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt;font-size:10pt"></span>日</td>
        </tr>
        <tr style="height:18pt">
            <td style="padding-left:0.13cm;padding-right:0.13cm;border-left-width:1px" rowspan="7">学院审核特别申明</td>
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:18pt">
            <td colspan="12" style="border-bottom-width:0px;font-weight:bold;font-size:12pt;text-indent:18pt;text-align:left">经本学院审核，推荐该生为 <span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:72pt"></span>（学术型/专业型）研究生。</td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px">院系负责人签字：<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:63pt"></span><span style="width:10.5pt"></span>学院盖章：<span style="width:84pt"></span><span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>年<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>月<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>日</td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12"></td>
        </tr>
        <tr style="height:15pt">
            <td style="padding-left:0.13cm;padding-right:0.13cm;border-left-width:1px" rowspan="9">推荐学院意见</td>
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px;text-indent:21pt;text-align:left">（说明申请人所填内容是否属实，以及本单位的推荐意见，可另附页说明）</td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px">院系负责人签字：<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:63pt"></span><span style="width:10.5pt"></span>学院盖章：<span style="width:84pt"></span><span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>年<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>月<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>日</td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12"></td>
        </tr>
        <tr style="height:15pt">
            <td style="padding-left:0.13cm;padding-right:0.13cm;border-left-width:1px" rowspan="9">学校教务部门审核意见</td>
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px">教务部门负责人签字：<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:52.5pt"></span>教务处公章：<span style="width:63pt"></span><span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>年<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>月<span style="border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;width:31.5pt"></span>日</td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12"></td>
        </tr>
        <tr style="height:15pt">
            <td style="padding-left:0.13cm;padding-right:0.13cm;border-left-width:1px" rowspan="5">备注</td>
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12" style="border-bottom-width:0px"></td>
        </tr>
        <tr style="height:15pt">
            <td colspan="12"></td>
        </tr>
    </table>
    <div style="height:15pt"></div>
    <table class="listTable" align="center" style="font-size:10.5pt;vertical-align:middle;border-width:0px" cellpadding="0" cellspacing="0">
        <tr style="height:0cm;border-width:0px">
            <#list tdWidthes as tdWidth>
                <#if tdWidth_index != 0>
            <td style="${tdWidth}" style="border-width:0px"></td>
                </#if>
            </#list>
        </tr>
        <tr style="border-width:0px">
            <td colspan="13" style="font-weight:bold;border-width:0px">本表一式二份，一份留教务处，一份留研究生教育院。</td>
        </tr>
    </table>
    <div style='PAGE-BREAK-AFTER: always'>&nbsp;</div>
    <#--第三页-->
    <div style="height:80px"></div>
    <table align="center" style="font-size:14pt;font-weight:bold;vertical-align:middle;table-layout:fixed;work-break:break-all;line-height:28pt" cellpadding="0" cellspacing="0">
        <tr>
            <#list tdWidthes as tdWidth>
                <#if tdWidth_index != 0>
            <td style="${tdWidth}" style="border-width:0px"></td>
                </#if>
            </#list>
        </tr>
        <tr>
            <td colspan="13" style="font-weight:bold;font-size:18pt;letter-spacing:18pt;text-align:center;line-height:36pt">承诺书</td>
        </tr>
        <tr style="height:36pt">
            <td colspan="13"></td>
        </tr>
        <tr>
            <td colspan="13" style="font-weight:bold;text-align:justify;text-justify:inter-ideograph;text-indent:31pt">本人系华东政法大学<span style="font-family:Times New Roman">${applyResult.updateAt?string("yyyy")}</span>年应届本科毕业的在校学生，现向学校申请推荐免试攻读硕士学位研究生。本人将遵守学校相关规定并承诺，被录取的推荐免试研究生不得参加当年硕士研究生全国统一入学考试，已获推免资格但放弃推免的学生，取消其当年至毕业时各类荣誉称号的评定资格。</td>
        </tr>
        <tr style="height:56pt">
            <td colspan="13"></td>
        </tr>
        <tr>
            <td colspan="13" style="padding-left:9.43cm">承诺人：</td>
        </tr>
        <tr>
            <td colspan="13" style="text-align:right;letter-spacing:21pt">年月日</td>
        </tr>
    </table>
    <div style='PAGE-BREAK-AFTER: always'>&nbsp;</div>
    <#--第四页-->
    <table align="center" style="font-size:14pt;vertical-align:middle;table-layout:fixed;work-break:break-all;line-height:28pt" cellpadding="0" cellspacing="0">
        <tr>
            <#list tdWidthes as tdWidth>
                <#if tdWidth_index != 0>
            <td style="${tdWidth}" style="border-width:0px"></td>
                </#if>
            </#list>
        </tr>
        <tr>
            <td colspan="13" style="font-weight:bold;font-size:18pt;letter-spacing:18pt;text-align:center;line-height:36pt">告知书</td>
        </tr>
        <tr style="height:36pt">
            <td colspan="13"></td>
        </tr>
        <tr>
            <td colspan="13"><table id="stdNameTable" style="font-weight:bold;font-size:14pt;table-layout:fixed;work-break:break-all" cellpadding="0" cellspacing="0"><tr><td style="width:84pt;border-bottom-width:1px;border-bottom-color:black;border-bottom-style:solid;text-align:center;height:14pt">${applyResult.student.name}</td><td style="width:200px;height:24pt">同学之家长：</td></tr></table></td>
        </tr>
        <tr>
            <td colspan="13" style="text-align:justify;text-justify:inter-ideograph;text-indent:28pt">贵子女已被我校推荐免试攻读硕士学位研究生。根据《华东政法大学推荐优秀应届本科毕业生免试攻读硕士学位研究生工作管理办法》第十九条的规定，“被录取的推荐免试研究生不得参加当年硕士研究生全国统一入学考试，已获推免资格但放弃推免的学生，取消其当年至毕业时各类荣誉称号的评定资格”。贵子女已向我校作出书面承诺，表示将遵守学校相关规定，如获得推荐免试攻读硕士学位研究生资格但放弃推免的学生，取消其当年至毕业时各类荣誉称号的评定资格。</td>
        </tr>
        <tr>
            <td colspan="13" style="text-align:justify;text-justify:inter-ideograph;text-indent:28pt">请您支持和配合学校的工作，敦促贵子女恪守承诺，遵守学校的相关规定，不放弃和浪费宝贵的推荐名额。</td>
        </tr>
        <tr>
            <td colspan="13" style="text-align:justify;text-justify:inter-ideograph;text-indent:28pt">特此告知。</td>
        </tr>
        <tr>
            <td colspan="13" style="text-align:right;font-weight:bold">${systemConfig.school.name}</td>
        </tr>
        <tr>
            <td colspan="13" style="text-indent:322pt;font-weight:bold">学院（系）</td>
        </tr>
        <tr>
            <td colspan="13" style="text-align:right;letter-spacing:21pt;font-weight:bold">年月日</td>
        </tr>
        <tr style="height:28pt">
            <td colspan="13"></td>
        </tr>
        <#--下面一行是绘制横线-->
        <tr>
            <td colspan="13" style="text-align:left"><hr style="color:black;width:406pt;height:1px"></td>
        </tr>
        <tr>
            <td colspan="13" style="font-weight:bold;font-size:14pt;text-align:center;line-height:42pt">家长意见</td>
        </tr>
        <tr>
            <td colspan="13" style="text-align:justify;text-justify:inter-ideograph;text-indent:28pt">我已知悉《华东政法大学推荐优秀应届本科毕业生免试攻读硕士学位研究生工作管理办法》和以上告知内容，并将敦促我子女恪守承诺，遵守学校的相关规定，不放弃和浪费推荐名额。</td>
        </tr>
        <tr style="height:36pt">
            <td colspan="13"></td>
        </tr>
        <tr>
            <td colspan="13" style="padding-left:8.43cm">家长签名：</td>
        </tr>
        <tr>
            <td colspan="13" style="padding-left:8.63cm;letter-spacing:21pt">年月日</td>
        </tr>
    </table>
    <OBJECT id="WebBrowser1" height="0" width="0" classid="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2" VIEWASTEXT></OBJECT> 
    <script>
        var oBar = new ToolBar("bar", "免试攻读硕士学位研究生申请表<span style=\"color:blue\">（推荐使用IE打印，使用前需要将ActiveX安全降到最低）</span>", null, true, true);
        oBar.addPrint();
        oBar.addClose();
        
        <#--单元格缩写字体填充-->
        function update(startRowIndex, startCellIndex, tableName) {
            var oTable = document.getElementById(tableName);
            for (var i = startRowIndex; i < 12; i++) {
                if (i >= oTable.rows[i].length) {
                    break;
                }
                for (var j = startCellIndex; j < oTable.rows[i].cells.length; j++) {
                    oTable.rows[i].cells[j].style.fontSize = oTable.style.fontSize;
                    var iHeight = oTable.rows[i].cells[j].scrollHeight;
                    autofs(oTable.rows[i].cells[j]);
                }
            }
            
        }
        
        function autofs(o){
            var fs = o.style.fontSize;
            fs = Number(fs.replace("pt",""));
            var sw = o.scrollWidth;
            var ow = o.offsetWidth;
            var sh = o.scrollHeight;
            var oh = o.offsetHeight;
            //alert(o.innerHTML + " : " + sh + ", " + oh + " , " + fs);
            if (sh > oh - 8 || sw > ow) {
                fs -= 0.1;
                o.style.fontSize = fs + "pt";
                autofs(o);
            }
        }
        
        update(1, 1, "exemptionReportTable");
        update(0, 0, "stdNameTable");
        
        
        var hkey_root, hkey_path, hkey_key
        hkey_root = "HKEY_CURRENT_USER"
        hkey_path = "\\Software\\Microsoft\\Internet Explorer\\PageSetup\\"
        // 设置 页眉 页脚 页边距
        function PagePrintSetup() {
            var RegWsh = new ActiveXObject("WScript.Shell");
            hkey_key = "header";//页
            RegWsh.RegWrite(hkey_root + hkey_path + hkey_key, "");
    
            hkey_key = "footer";
            RegWsh.RegWrite(hkey_root + hkey_path + hkey_key, "");
    
            hkey_key = "margin_top";//注册表中的0.75对应于网页的19.05
            RegWsh.RegWrite(hkey_root + hkey_path + hkey_key, 0.75 * 10 / 19.05 + "");
    
            hkey_key = "margin_bottom";
            RegWsh.RegWrite(hkey_root + hkey_path + hkey_key, 0.75 * 15 / 19.05 + "");
    
            hkey_key = "margin_left";
            RegWsh.RegWrite(hkey_root + hkey_path + hkey_key, 0.75 * 10 / 19.05 + "");
    
            hkey_key = "margin_right";
            RegWsh.RegWrite(hkey_root + hkey_path + hkey_key, 0.75 * 15 / 19.05 + "");
        }
        
         PagePrintSetup();
    </script>
<script>
</script>
</body>
<#include "/templates/foot.ftl"/>