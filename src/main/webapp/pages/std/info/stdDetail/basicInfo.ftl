<#include "/templates/head.ftl"/>
<body>
	<table id="myBar" width="100%" ></table>
	<#include "basicInfoContents.ftl"/>
	<script>
	    var bar =new ToolBar("myBar","<@msg.message key="std.baseInfo.title"/>",null,true,true);
	    bar.setMessage('<@getMessage/>');
	    bar.addItem("<@msg.message key="action.edit"/>","edit()");    
	    
	    function edit(){
	       self.location="stdDetail.do?method=editApply";
	    }
	</script>
</body>
<#include "/templates/foot.ftl"/>