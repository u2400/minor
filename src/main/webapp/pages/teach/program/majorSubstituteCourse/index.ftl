<#include "/templates/head.ftl"/>
<body>
    <table id="majorSubstitutionCourseBar"></table>
    <#if (stdTypeList?first.id)?exists>
    <table class="frameTable" width="100%">
        <tr>
            <td width="18%" class="frameTable_view"><#include "searchForm.ftl"/></td>
            <td valign="top">
                <iframe src="#" id="planListFrame" name="planListFrame" marginwidth="0" marginheight="0" scrolling="no" frameborder="0"  height="100%" width="100%"></iframe>
            </td>
        </tr>
    </table>
    </form>
    <script>
        var bar=new ToolBar("majorSubstitutionCourseBar","专业替代课程管理",null,true,true);
        bar.setMessage('<@getMessage/>');
        bar.addBlankItem();
        searchTeachPlan();
    </script>  
     <#else>
   <center><h1><font color="red">请先配置“<a href="studentType.do" target="studentType_window">学生类别</a>”。</font></h1></center>
   <script>
    var bar=new ToolBar("majorSubstitutionCourseBar","专业替代课程管理",null,true,true);
    bar.addBlankItem();
   </script>
   </#if>
</body>
<#include "/templates/foot.ftl"/>