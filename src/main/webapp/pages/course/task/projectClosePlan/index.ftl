<#include "/templates/head.ftl"/>
<BODY> 
    <table id="taskBar"></table>
    <table class="frameTable">
        <tr>
            <td valign="top" bgcolor="white">
                <iframe  src="#" id="teachTaskListFrame" name="teachTaskListFrame" scrolling="auto" marginwidth="0" marginheight="0" frameborder="0"  height="100%" width="100%"></iframe>
            </td>
        </tr>
    </table>
    <form name="taskForm" target="teachTaskListFrame" method="post" action="?method=index" onsubmit="return false;">
    </form>
	<script>
        function search(){
            var form = document.taskForm;
            taskForm.action = "?method=search";
            form.target="teachTaskListFrame";
            form.submit();
        }
        search();
	</script>
</body>
<#include "/templates/foot.ftl"/> 
  