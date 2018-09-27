<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <#function stringLeft string length>
        <#if string?default("") == "" || !length?exists || !length?is_number>
            <#return ""/>
        </#if>
        <#return string[0..(string?length lt length)?string(string?length - 1, length - 1)?number]>
    </#function>
    <table style="width:151.7mm" align="center" cellspacing="0" cellpadding="0">
        <tr valign="top">
            <td>
                <#list signUpStds as signUpStd>
                <table align="center" style="text-align:center;font-size:15pt;font-weight:bold" cellpading="0" cellspacing="0">
                    <tr style="height:30pt">
                        <td>上海松江大学园区</td>
                    </tr>
                    <tr style="height:30pt">
                        <td>学生修读辅修专业学士学位申请表</td>
                    </tr>
                </table>
                <table class="listTable" style="width:151.7mm;font-size:10.5pt;text-align:center;vertical-align:middle;border-left-width:0px;border-top-width:0px;border-right-width:0px;word-break:break-all" align="center" cellpadding="0" cellspacing="0">
                    <tr style="height:0pt">
                        <td style="width:12.4mm;border-left-width:0px;border-top-width:0px;border-right-width:0px"></td>
                        <td style="width:16.8mm;border-left-width:0px;border-top-width:0px;border-right-width:0px"></td>
                        <td style="width:25mm;border-left-width:0px;border-top-width:0px;border-right-width:0px"></td>
                        <td style="width:11.1mm;border-left-width:0px;border-top-width:0px;border-right-width:0px"></td>
                        <td style="width:13.9mm;border-left-width:0px;border-top-width:0px;border-right-width:0px"></td>
                        <td style="width:8.3mm;border-left-width:0px;border-top-width:0px;border-right-width:0px"></td>
                        <td style="width:17.2mm;border-left-width:0px;border-top-width:0px;border-right-width:0px"></td>
                        <td style="width:8.2mm;border-left-width:0px;border-top-width:0px;border-right-width:0px"></td>
                        <td style="width:13.6mm;border-left-width:0px;border-top-width:0px;border-right-width:0px"></td>
                        <td style="width:25.1mm;border-left-width:0px;border-top-width:0px;border-right-width:0px"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="border-left-width:1px" colspan="2">姓名</td>
                        <td>${signUpStd.std.name}</td>
                        <td colspan="2">性别</td>
                        <td colspan="2">${signUpStd.std.gender.name}</td>
                        <td colspan="2">学号</td>
                        <td>${signUpStd.std.code}</td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="border-left-width:1px" colspan="2">所在学校</td>
                        <td colspan="5"><@i18nName systemConfig.school/></td>
                        <td colspan="2">主修专业</td>
                        <td>${(signUpStd.std.firstMajor.name)?if_exists}</td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="border-left-width:1px" colspan="2">通讯地址、邮编</td>
                        <#assign homeAddress_postCode = (signUpStd.std.basicInfo.homeAddress + "　")?default("") + (signUpStd.std.basicInfo.postCode)?default("")/>
                        <td colspan="2"<#if (homeAddress_postCode?length)?default(0) gt 9> style="font-size:7pt"</#if>>${(homeAddress_postCode)?if_exists}</td>
                        <td colspan="2">固定电话</td>
                        <td colspan="2"<#if (signUpStd.std.basicInfo.phone?length)?default(0) gt 16> style="font-size:7pt"</#if>>${(signUpStd.std.basicInfo.phone)?if_exists}</td>
                        <td>手机</td>
                        <td<#if (signUpStd.std.basicInfo.mobile?length)?default(0) gt 12> style="font-size:7pt"</#if>>${(signUpStd.std.basicInfo.mobile)?if_exists}</td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="border-left-width:1px" colspan="2">拟修读学校</td>
                        <#assign firstWishes = (signUpStd.getRecord(1).specialitySetting.speciality.name)?default("")?split(" ")/>
                        <td colspan="3"<#if (firstWishes[0]?length)?default(0) gt 12> style="font-size:7pt"</#if>>${stringLeft(firstWishes[0]?default(""), 30)}</td>
                        <td colspan="2">身份证号码</td>
                        <td colspan="3">${(signUpStd.std.basicInfo.idCard)?if_exists}</td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="border-left-width:1px" colspan="3">拟申请专业（可填报两个志愿）</td>
                        <td style="text-align:left;padding-left:5px" colspan="4"<#if ("1、" + firstWishes[1])?default("1、" + firstWishes[0])?length gt 12> style="font-size:7pt"</#if>>1、${stringLeft(firstWishes[1]?default(firstWishes[0]), 30)}</td>
                        <#assign secondWishes = (signUpStd.getRecord(2).specialitySetting.speciality.name)?default("")?split(" ")/>
                        <td style="text-align:left;padding-left:5px" colspan="3"<#if ("2、" + secondWishes[1])?default("1、" + secondWishes[0])?length gt 12> style="font-size:7pt"</#if>>2、${stringLeft(secondWishes[1]?default(secondWishes[0]), 30)}</td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="border-left-width:1px;direction:inherit;writing-mode:tb-rl" rowspan="8">主修专业学习情况</td>
                        <td style="text-align:left;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-right-width:0px;border-bottom-width:0px" colspan="3"></td>
                        <td style="border-width:0px" colspan="5">学院负责人签字（盖章）：</td>
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr style="height:21pt;font-size:9pt">
                        <td style="border-top-width:0px;border-right-width:0px" colspan="7">（注：要求如实填写学生的学习绩点及重修情况，可附成绩单）</td>
                        <td style="text-align:left;border-top-width:0px" colspan="2"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="border-left-width:1px;direction:inherit;writing-mode:tb-rl" rowspan="8">所在学校教务处审核意见</td>
                        <td style="text-align:left;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-right-width:0px;border-bottom-width:0px" colspan="3"></td>
                        <td style="border-width:0px" colspan="5">教务处负责人（盖章）：</td>
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px"></td>
                    </tr>
                    <tr style="height:21pt;font-size:9pt">
                        <td style="border-top-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="border-left-width:1px;direction:inherit;writing-mode:tb-rl" rowspan="8">主办学校教务处审核意见</td>
                        <td style="text-align:left;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-bottom-width:0px" colspan="9"></td>
                    </tr>
                    <tr style="height:21pt">
                        <td style="text-align:left;border-top-width:0px;border-right-width:0px" colspan="3"></td>
                        <td style="border-width:0px" colspan="5">教务处负责人（盖章）：</td>
                        <td style="text-align:left;border-top-width:0px"></td>
                    </tr>
                </table>
                <table align="center" style="font-size:10.5pt;width:151.7mm" cellpading="0" cellspacing="0">
                    <tr style="height:15pt">
                        <td>说明：此表请打印或用黑色水笔填写，由主办学校存档保管。</td>
                    </tr>
                    <tr style="height:15pt;text-align:right;letter-spacing:31.5">
                        <td>年月日</td>
                    </tr>
                </table>
                <div style='page-break-after: always'><br style="height:0; line-height:0"/></div>
                <table align="center" style="font-size:18pt;font-family:仿宋_GB2312;text-align:center" cellpadding="0" cellspacing="0">
                    <tr style="height:30pt">
                        <td>上海松江大学园区高校</td>
                    </tr>
                    <tr style="height:30pt">
                        <td>辅修专业学士学位告知书</td>
                    </tr>
                </table>
                <table width="100%" style="text-align:justify;text-justify:inter-ideograph;font-size:12pt;line-height:16pt;text-indent:24pt;font-family:仿宋_GB2312;width:164mm" cellpadding="0" cellspacing="0">
                    <tr style="height:24pt">
                        <td></td>
                    </tr>
                    <tr>
                        <td>经上海市学位委员会（沪学位办[2005]8号）批准，松江大学园区自2005年10月起，开展松江大学园区高校授予辅修专业学士学位证书试点工作。现将有关情况告知如下：</td>
                    </tr>
                    <tr>
                        <td>一、举办辅修专业学士学位教育工作目的</td>
                    </tr>
                    <tr>
                        <td>进一步完善各校学生的知识结构，提升各校学生的就业竞争力，实现知识复合，加速社会需要的学科交叉高层次专门人才的培养。</td>
                    </tr>
                    <tr>
                        <td>二、报名条件</td>
                    </tr>
                    <tr>
                        <td>松江大学园区各校的在籍本科学生，在学有余力的条件下，均可根据自身意愿及各校的招生要求，报名修读松江大学园区各校开设的与学生本人主修专业学科门类不同的辅修专业。</td>
                    </tr>
                    <tr>
                        <td>三、证书授予办法</td>
                    </tr>
                    <tr>
                        <td>1、详见《上海松江大学园区辅修专业学士学位管理办法》。</td>
                    </tr>
                    <tr>
                        <td>2、学生本人主修专业与辅修专业属相同学科门类，则不能取得辅修专业学士学位证书。修满到或超过辅修证书所规定学分者，由辅修主办学校颁发辅修证书。</td>
                    </tr>
                    <tr>
                        <td>四、招生学校及专业</td>
                    </tr>
                    <tr>
                        <td>详见松江大学园区各年度招生计划。</td>
                    </tr>
                    <tr>
                        <td>五、收费办法</td>
                    </tr>
                    <tr>
                        <td>1、辅修专业学士学位教育实行按学分收费，收费标准由各主办学校制定，一般不高于主办学校该专业的学分收费标准。</td>
                    </tr>
                    <tr>
                        <td>2、修读费用由主办学校按学期收取，学生中途终止辅修专业学士学位专业学习，不退还所交费用。</td>
                    </tr>
                    <tr>
                        <td>六、报名办法</td>
                    </tr>
                    <tr>
                        <td>具备修读辅修专业学士学位专业条件的学生，可到所在学校教务处领取并填写《上海市松江大学园区学生修读辅修专业学士学位申请表》，教务处审核通过后，统一报主办学校审核和录取。</td>
                    </tr>
                    <tr style="height:16pt">
                        <td></td>
                    </tr>
                    <tr>
                        <td>说明：《上海松江大学园区辅修专业学士学位管理办法》和《上海松江大学园区辅修专业学士学位学籍管理办法》请查看教务处网站。</td>
                    </tr>
                    <tr style="height:16pt">
                        <td></td>
                    </tr>
                    <tr>
                        <td style="font-family:宋体">以上内容我已阅读并知晓，我愿意参加松江大学园区辅修专业学士学位教育的学习。</td>
                    </tr>
                    <tr style="height:32pt">
                        <td></td>
                    </tr>
                </table>
                <table style="text-align:justify;text-justify:inter-ideograph;font-size:12pt;line-height:16pt;width:100%;font-family:仿宋_GB2312" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="width:${12 * 20}pt;text-indent:24pt">修读学生所在学校：<span style="border-bottom-width:1px;border-bottom-style:solid;width:96pt;text-align:center;text-indent:0pt"><@i18nName systemConfig.school/></span></td>
                        <td>修读学生学号：<span style="border-bottom-width:1px;border-bottom-style:solid;width:96pt;text-align:center">${signUpStd.std.code}</span></td>
                    </tr>
                    <tr style="height:16pt">
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td style="text-indent:24pt">修读学生签名：<span style="border-bottom-width:1px;border-bottom-style:solid;width:96pt"></span></td>
                        <td style="text-align:center;letter-spacing:36pt">年月日</td>
                    </tr>
                </table>
                    <#if signUpStd_has_next>
                <div style='page-break-after: always'><br style="height:0; line-height:0"/></div>
                    </#if>
                </#list>
            </td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "辅修学士学位申请表", null, true, true);
        bar.addPrint();
        bar.addClose();
    </script>
</body>
<object id="factory" style="display:none" viewastext classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="css/smsx.cab#Version=6,2,433,14"></object>
<script>
 function window.onload(){
    try{
       if(typeof factory.printing != 'undefined'){
            factory.printing.header = ""; 
            factory.printing.footer = "";
            factory.printing.leftMargin = factory.printing.topMargin = factory.printing.rightMargin = factory.printing.bottomMargin = 12.7 * 0.039370078740157;
       }
    }catch(e){
    }
 }
</script>
<#include "/templates/foot.ftl"/>