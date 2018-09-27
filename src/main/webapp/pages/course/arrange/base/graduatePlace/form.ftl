<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/My97DatePicker/WdatePicker.js"></script>
<script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<body>
    <table id="bar" width="100%"></table>
    <#assign mustBeFull><span style="color:red;font-weight:bold">*</span></#assign>
    <table class="formTable" width="100%">
        <tr>
            <td class="darkColumn" colspan="4" style="text-align:center;font-weight:bold">毕业实习基地基础信息</td>
        </tr>
        <form method="post" action="" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="place.id" value="${(place.id)?if_exists}"/>
            <input type="hidden" name="params" value="${RequestParameters["params"]}"/>
        <tr>
            <td id="f_name" class="title" style="width:15%">单位名称${mustBeFull}：</td>
            <td style="width:35%"><input type="text" name="place.name" value="${(place.name?html)?if_exists}" maxlength="100" style="width:200px">(100个字符)</td>
            <td id="f_corporation_id" class="title" style="width:15%">单位类型${mustBeFull}：</td>
            <td>
                <select name="place.corporation.id" style="width:200px">
                    <option value="" selected>...</option>
                    <#list corporations as corporation>
                    <option value="${corporation.id}">${corporation.name}</option>
                    </#list>
                </select>
            </td>
        </tr>
        <tr>
            <td id="f_address_info" class="title">单位所在地${mustBeFull}：</td>
            <td colspan="3"><input type="text" name="place.addressInfo" value="${(place.addressInfo?html)?if_exists}" maxlength="250" style="width:500px"/>(250个字符)</td>
        </tr>
        <tr>
            <td class="title">是否校内：</td>
            <td><input id="inSchool" type="radio" name="place.isInSchool" value="1" checked><lable for="inSchool">校内</label><input id="outSchool" type="radio" name="place.isInSchool" value="0"><lable for="outSchool">校外</label></td>
            <td id="f_assign_on" class="title">签约日期${mustBeFull}：</td>
            <td><input type="text" name="place.assignOn" value="${(place.assignOn?string("yyyy-MM-dd"))?if_exists}" maxlength="10" style="width:200px" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'});" readOnly/></td>
        </tr>
        <tr>
            <td id="f_status" class="title">合作协议状态${mustBeFull}：</td>
            <td>
                <select name="place.status" style="width:200px">
                    <option value="" selected>...</option>
                    <option value="1">有效期内</option>
                    <option value="2">无效期内</option>
                    <option value="3">已过期</option>
                </select>
            </td>
            <td id="f_contact_person" class="title">联系人${mustBeFull}：</td>
            <td><input type="text" name="place.contactPerson" value="${(place.contactPerson)?if_exists}" maxlength="100" style="width:200px"/>(100个字符)</td>
        </tr>
        <tr>
            <td id="f_contact_info" class="title">联系方式${mustBeFull}：</td>
            <td colspan="3"><input type="text" name="place.contactInfo" value="${(place.contactInfo?html)?if_exists}" maxlength="250" style="width:500px"/>(联系电话＋email，250个字符)</td>
        </tr>
        <tr>
            <td id="f_department_id" class="title">所属部门${mustBeFull}：</td>
            <td>
                <@htm.i18nSelect datas=departmentList selected=(place.department.id?string)?default("") name="place.department.id" style="width:200px">
                    <option value="" selected>...</option>
                </@>（分管院系）
            </td>
            <td id="f_plan_std_count" class="title">接收实习生人数${mustBeFull}：</td>
            <td><input type="text" name="place.planStdCount" value="${(place.planStdCount)?if_exists}" maxlength="10" style="width:200px"/></td>
        </tr>
        <tr>
            <td id="f_remark" class="title">备注：</td>
            <td colspan="3"><textarea name="place.remark" style="width:500px;height:50px">${(place.remark?html)?if_exists}</textarea>(250个字符)</td>
        </tr>
        <tr>
            <td class="darkColumn" colspan="4" style="text-align:center"><button onclick="save()">保存</button>&nbsp;<button onclick="this.form.reset();initData();">重置</button></td>
        </tr>
        </form>
    </table>
    <script>
        parent.document.getElementById('pageIframe').style.height = '600px';
        
        var bar = new ToolBar("bar", "基础信息维护", null, true, true);
        bar.addBack();
        
        var form = document.actionForm;
        
        function initData() {
            form["place.corporation.id"].value = "${(place.corporation.id)?if_exists}";
            <#if (place.isInSchool)?default(true)>
            document.getElementById("inSchool").checked = true;
            <#else>
            document.getElementById("outSchool").checked = true;
            </#if>
            form["place.status"].value = "${(place.status)?if_exists}";
            form["place.department.id"].value = "${(place.department.id)?if_exists}";
        }
        
        function save() {
            var a_fields = {
                "place.name":{"l":"单位名称", "r":true, "t":"f_name"},
                "place.corporation.id":{"l":"单位类型", "r":true, "t":"f_corporation_id"},
                "place.addressInfo":{"l":"单位所在地", "r":true, "t":"f_address_info"},
                "place.assignOn":{"l":"签约日期", "r":true, "t":"f_assign_on"},
                "place.status":{"l":"合作协议状态", "r":true, "t":"f_status"},
                "place.contactPerson":{"l":"联系人", "r":true, "t":"f_contact_person"},
                "place.contactInfo":{"l":"联系方式", "r":true, "t":"f_contact_info"},
                "place.department.id":{"l":"所属部门", "r":true, "t":"f_department_id"},
                "place.planStdCount":{"l":"接收实习生人数", "r":true, "t":"f_plan_std_count", "f":"positiveInteger"},
                "place.remark":{"l":"备注", "r":false, "t":"f_remark", "mx":250}
            };
            var v = new validator(form, a_fields, null);
            if (v.exec()) {
                form.action = "${actionName?default("graduatePlace.do")}?method=save";
                form.target = "_self";
                form.submit();
            }
        }
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
        
        initData();
    </script>
</body>
<#include "/templates/foot.ftl"/>