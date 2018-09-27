<#include "/templates/head.ftl"/>
<script lanuage="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<body>
    <table id="bar" width="100%"></table>
    <table width="100%" cellpadding="0" cellspacing="0">
        <form method="post" action="" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="student.id" value="${student.id}"/>
        <tr>
            <td>
                <table class="infoTable" width="100%">
                    <tr>
                        <td class="title" style="width:10%">学号</td>
                        <td width="15%">${student.code}</td>
                        <td class="title" style="width:10%">姓名</td>
                        <td width="15%">${student.name}</td>
                        <td class="title" style="width:10%">年级</td>
                        <td width="15%">${student.enrollYear}</td>
                        <td class="title" style="width:10%">学制</td>
                        <td>${(student.schoolingLength)?if_exists}</td>
                    </tr>
                    <tr>
                        <td class="title">性别</td>
                        <td>${(student.basicInfo.gender.name)?if_exists}</td>
                        <td class="title">国籍</td>
                        <td>${(student.basicInfo.country.name)?if_exists}</td>
                        <td class="title">民族</td>
                        <td>${(student.basicInfo.nation.name)?if_exists}</td>
                        <td class="title">是否毕业</td>
                        <td>${(student.degreeInfo.graduateOn)?exists?string("是", "否")}</td>
                    </tr>
                    <tr>
                        <td class="title">院系</td>
                        <td colspan="3">${student.department.name}</td>
                        <td class="title">班级</td>
                        <td colspan="3"><#list student.adminClasses?if_exists as adminClass>${adminClass.name}(${adminClass.code})<#if adminClass_has_next>, </#if></#list></td>
                    </tr>
                    <tr>
                        <td class="title">专业</td>
                        <td colspan="3">${student.firstMajor.name}</td>
                        <td class="title">专业方向</td>
                        <td colspan="3">${(student.firstAspect.name)?if_exists}</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr height="20px">
            <td></td>
        </tr>
        <tr>
            <td>
                <table class="formTable" width="100%">
                    <tr>
                        <td class="darkColumn" style="text-align:center;font-weight:bold" colspan="4">学生英语等级维护项</td>
                    </tr>
                    <tr>
                        <td id="f_languageAbilityId" class="title" width="20%">语种能力：</td>
                        <td width="30%">
                            <@htm.i18nSelect datas=languageAbilities?sort_by("name") selected=(student.languageAbility.id?string)?default("") name="student.languageAbility.id" style="width:200px">
                                <option value="">...</option>
                            </@>
                        </td>
                        <td id="f_scoreInLanguage" class="title" width="20%">语种成绩：</td>
                        <td><input type="text" name="student.scoreInLanguage" value="${(student.scoreInLanguage)?if_exists}" maxlength="5" style="width:200px"/></td>
                    </tr>
                    <tr>
                        <td class="darkColumn" style="text-align:center" colspan="4"><button onclick="save()">保存</button></td>
                    </tr>
                </table>
            </td>
        </tr>
            <input type="hidden" name="params" value="${RequestParameters["params"]?if_exists}"/>
        </form>
    </table>
    <script>
        var bar = new ToolBar("bar", "学生英语等级维护", null, true, true);
        bar.addBack();
        
        var form = document.actionForm;
        
        function save() {
            var a_fields = {
                'student.scoreInLanguage':{'l':'语种成绩', 'r':false, 't':'f_scoreInLanguage', 'f':'unsignedReal'}
            };
            var v = new validator(form, a_fields, null);
            if (v.exec()) {
                form.action = "studentAbilityQuery.do?method=save";
                form.target = "_self";
                form.submit();
            }
        }
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>