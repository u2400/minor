<#include "/templates/head.ftl"/>
<body>
    <table id="bar" width="100%"></table>
    <table style="text-align:right">
        <tr>
            <td width="50px"></td>
            <td>当前找到了设有等级学生 <span style="color:red">${students?size}</span> 名(按条件查询)</td>
        </tr>
        <tr>
            <td style="text-align:center">×</td>
            <td>找到对应可分配（设有等级、已排课）的教学任务 <span style="color:red">${allTasks?size}</span> 条(按条件查询)</td>
        </tr>
        <tr>
            <td colspan="2"><hr></td>
        </tr>
        <tr>
            <td></td>
            <td>总共产生 <span style="color:red">${students?size * allTasks?size}</span> 条上课名单（含上课冲突和人满情况）</td>
        </tr>
        <tr>
            <td style="text-align:center">×</td>
            <td><span style="color:red">2</span> 次初始化</td>
        </tr>
        <tr>
            <td colspan="2"><hr></td>
        </tr>
        <tr>
            <td></td>
            <td>总进度 <span style="color:red">${students?size * allTasks?size * 2}</span></td>
        </tr>
    </table>
    <br>
    <table>
        <tr>
            <td width="45px">说明：</td>
            <td style="font-weight:bold;color:red">1. 操作的时间就停止其它任何的操作，“过程”由系统自动进行，否则将出错中断生产异常。</td>
        </tr>
        <tr>
            <td></td>
            <td>2. “过程”结束后，由系统判断情况，将有以下 4 种情况：</td>
        </tr>
        <tr>
            <td></td>
            <td>1) 结束后没有“上课冲突”和“人满”情况，系统将提示“保存成功”并返回“已分配学生名单列表”页面；</td>
        </tr>
        <tr>
            <td></td>
            <td>2) 如果从头到尾没有一条教学任务被分配进去，又没有“上课冲突”和“人满”情况，将认为全部学生已经分配完了；</td>
        </tr>
        <tr>
            <td></td>
            <td>3) 如果有一部分学生分配进了一部分的教学任务，则将保存已分配成功的记录，收集没有分配成功的记录将跳转输出显示这样“情况”；</td>
        </tr>
        <tr>
            <td></td>
            <td>4) 如果统统没有一个被分配成功，收集完这些“情况”后直接跳转输出。</td>
        </tr>
        <tr>
            <td></td>
            <td>3. <span  style="font-weight:bold;color:red">凡转跳到“情况”的页面，系统提供“导出”功能，把这些“情况”导出，一旦离开这个页面，这些信息将丢失。</span>这“情况”页面，只有在初始化的“过程”在第3、4种情况才会出现。</td>
        </tr>
    </table>
    <form method="post" action="" name="actionForm" onsubmit="return false;">
        <input type="hidden" name="calendarId" value="${calendar.id}"/>
        <input type="hidden" name="params" value="${RequestParameters["params"]}"/>
        <#assign filterKeys = ["method", "params"]/>
        <#list RequestParameters?keys as key>
            <#if !filterKeys?seq_contains(key)>
        <input type="hidden" name="${key}" value="${RequestParameters[key]?if_exists}"/>
            </#if>
        </#list>
    </form>
    <script>
        var bar = new ToolBar("bar", "初始化学生确认", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addItem("开始初始化", "init()");
        bar.addItem("放弃返回", "backSearch()", "backward.gif");
        
        var form = document.actionForm;
        
        function init() {
            if (confirm("确定要开始初始化学生名单吗？")) {
                form.action = "courseTakeInEnglish.do?method=init";
                form.target = "_self";
                form.submit();
            }
        }
        
        function backSearch() {
            try {
                parent.search();
            } catch (e) {
                window.close();
            }
        }
        
        window.onunload = function() {
            parent.document.getElementById("pageIframe").style.height = "100%";
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>