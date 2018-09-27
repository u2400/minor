<#include "/templates/head.ftl"/>
<BODY> 
    <table id="courseInTaskBar"></table>
    <table class="frameTable_title">
        <tr>
            <td style="width:50px"><font color="blue"><@bean.message key="action.advancedQuery"/></font></td>
            <td class="infoTitle"><@msg.message key="course.arrangeState"/>:</td>
          <form name="courseInTaskForm" method="post" action="" onsubmit="return false;">
             <td>
                <select name="task.arrangeInfo.isArrangeComplete" style="width:100px" onchange="search()">
                   <option value=""><@bean.message key="common.all"/></option>
                   <option value="1"><@msg.message key="course.beenArranged"/></option>
                   <option value="0"><@msg.message key="course.noArrange"/></option>
                </select>
             </td>
            <td>|</td>
            <input type="hidden" name="task.calendar.id" value="${calendar.id}" />
            <#include "/pages/course/calendar.ftl"/>
        </tr>
    </table>
    <table class="frameTable">
        <tr>
            <td valign="top" width="19%" class="frameTable_view">
                <#include "../teachTaskSearchForm.ftl"/>
            </td>
          </form>
            <td valign="top" bgcolor="white">
                <iframe src="#" id="coursesInTaskFrame" name="coursesInTaskFrame" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"  height="100%" width="100%"></iframe>
            </td>
        </tr>
    </table>
    <script>
        var bar=new ToolBar("courseInTaskBar","教学任务课程档案",null,true,true);
        bar.addBlankItem();
        
        var form = document.courseInTaskForm;
        search();
        function search(){
            courseInTaskForm.action = "?method=search";
            form.target="coursesInTaskFrame";
            form.submit();
        }
    </script>
</body>
<#include "/templates/foot.ftl"/> 
