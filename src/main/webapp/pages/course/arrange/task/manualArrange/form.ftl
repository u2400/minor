<#include "/templates/head.ftl"/>
    <table id="bar" width="100%"></table>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="switch.id" value="${arrangeSwitch.id}"/>
        <table class="formTable" width="60%" align="center">
            <tr>
                <td class="darkColumn" colspan="2" style="font-weight:bold;text-align:center">状态详细设置</td>
            </tr>
            <tr>
                <td class="title" width="30%">学年学期：</td>
                <td>${arrangeSwitch.calendar.year}学年${arrangeSwitch.calendar.term}学期</td>
            </tr>
            <tr>
                <td class="title">是否显示上课地点：</td>
                <td>
                    <select name="switch.isArrangeAddress" style="width:200px">
                        <option value="1">是</option>
                        <option value="0" selected>否</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="title">是否发布排课结果：</td>
                <td>
                    <select name="switch.isPublished" style="width:200px">
                        <option value="1">是</option>
                        <option value="0" selected>否</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="darkColumn" colspan="2" style="text-align:center"><button onclick="save()">提交</button></td>
            </tr>
        </table>
        <input type="hidden" name="params" value="${RequestParameters["params"]?if_exists}">
    </form>
    <script>
        var bar = new ToolBar("bar", "详细设置", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addBack();
        
        var form = document.actionForm;
        
        function initData() {
	     <#if arrangeSwitch.isArrangeAddress?? >
	         form["switch.isArrangeAddress"].value = "${arrangeSwitch.isArrangeAddress?string("1", "0")}";
	    <#else>
		form["switch.isArrangeAddress"].value = "0";
	    </#if>
	 <#if arrangeSwitch.isPublished?? >
            form["switch.isPublished"].value = "${arrangeSwitch.isPublished?string("1", "0")}";
	    <#else>
		form["switch.isPublished"].value = "0";
	    </#if>
        }
        
        function save() {
            if (confirm("确定要提交吗？")) {
                form.action = "courseArrangeSwitch.do?method=save";
                form.target = "_self";
                form.submit();
            }
        }
        
        initData();
    </script>
<#include "/templates/foot.ftl"/>