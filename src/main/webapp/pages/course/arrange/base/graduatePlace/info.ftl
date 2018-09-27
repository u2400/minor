<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/My97DatePicker/WdatePicker.js"></script>
<script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<body>
    <table id="bar" width="100%"></table>
    <#assign statusMap = {"1":"有效期内", "2":"无效期内", "3":"已过期"}/>
    <table class="infoTable" width="100%">
        <tr>
            <td class="title" style="width:15%">序号：</td>
            <td style="width:35%">${place.id}</td>
            <td class="title" style="width:15%">单位名称：</td>
            <td>${place.name?html}</td>
        </tr>
        <tr>
            <td class="title">单位所在地：</td>
            <td colspan="3">${place.addressInfo?html}</td>
        </tr>
        <tr>
            <td class="title">单位类型：</td>
            <td>${place.corporation.name?html}</td>
            <td class="title">是否校内：</td>
            <td>${place.isInSchool?string("校内", "校外")}</td>
        </tr>
        <tr>
            <td class="title">签约日期：</td>
            <td>${place.assignOn?string("yyyy-MM-dd")}</td>
            <td class="title">合作协议状态：</td>
            <td>${statusMap[place.status?string]?if_exists}</td>
        </tr>
        <tr>
            <td class="title">联系人：</td>
            <td>${place.contactPerson?html}</td>
            <td class="title">所属部门（分管院系）：</td>
            <td>${place.department.name?html}</td>
        </tr>
        <tr>
            <td class="title">联系方式：</td>
            <td colspan="3">${place.contactInfo?html}</td>
        </tr>
        <tr>
            <td class="title">接收实习生人数：</td>
            <td>${place.planStdCount}</td>
            <td class="title">是否确认：</td>
            <td>${place.enabled?string("是", "否")}</td>
        </tr>
        <tr>
            <td class="title">维护人帐号：</td>
            <td>${place.operatorBy.name}</td>
            <td class="title">维护人姓名：</td>
            <td>${place.operatorBy.userName}</td>
        </tr>
        <tr>
            <td class="title">创建时间：</td>
            <td>${place.createdAt?string("yyyy-MM-dd HH:mm:ss")}</td>
            <td class="title">修改时间：</td>
            <td>${place.updatedAt?string("yyyy-MM-dd HH:mm:ss")}</td>
        </tr>
        <tr>
            <td class="title">备注：</td>
            <td colspan="3">${(place.remark?html?replace("\r\n", "<br>"))?if_exists}</td>
        </tr>
    </table>
    <script>
        var bar = new ToolBar("bar", "基础信息查看", null, true, true);
        bar.addBack();
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>