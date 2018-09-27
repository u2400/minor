<#include "/templates/head.ftl"/>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
<table id="myBar" width="100%"></table>
  <table class="frameTable" height="85%">
    <tr>
     <td class="frameTable_content">
	     <iframe src="bursarySetting.do?method=search" id="settingListFrame" name="settingListFrame" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" height="100%" width="100%"></iframe>
     </td>
  </tr>
</table>
<script>
  var bar = new ToolBar("myBar","助学金开关设置",null,true,true);
  bar.addItem("奖项维护","awardSetting()");
  bar.addHelp("<@msg.message key="action.help"/>");
  function awardSetting(){
      self.location='bursaryAward.do';
  }
</script>
</body>
<#include "/templates/foot.ftl"/>