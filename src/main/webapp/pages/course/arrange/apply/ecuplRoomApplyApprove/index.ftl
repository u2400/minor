<#include "/templates/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="scripts/validator.js"></script>
<BODY LEFTMARGIN="0" TOPMARGIN="0" >
<table id="bar"></table>
<table width="100%" class="frameTable" height="90%">
	<tr>
		<form method="post" action="" name="searchRoomApplyApproveForm" target="contentFrame" onsubmit="return false;">
		<td class="frameTable_view" style="width:168px;">
			<#include "searchTable.ftl"/>
		</td>
            <input type="hidden" name="adminRole"/>
            <input type="hidden" name="toPageNo" value=""/>
            <input type="hidden" name="toPageSize" value=""/>
		</form>
		<td valign="top">
	     	<iframe name="contentFrame" id="contentFrame" src="#" width="100%" style="height:100%" frameborder="0" scrolling="no"></iframe>
		</td>
	</tr>
</table>
 	<script>
        var bar=  new ToolBar("bar","教室审核",null,true,true);
        bar.addItem("查看空闲教室", "lookFreeApply()");
        <#--
        bar.addItem("价目表设定","roomPriceCatalogue()");
        -->
 		var form = document.searchRoomApplyApproveForm;
 		
 		function initData() {
            for (var i = 0; i < form["classroom.id"].options.length; i++) {
                var optionObj = form["classroom.id"].options[i];
                if (getStringLength(optionObj.text) > 10) {
                    optionObj.title = optionObj.text;
                }
            }
 		}
 		
 		initData();
 		
 		document.getElementById("searchRoom").onclick();
	    function search() {
	    	if (form["applyTime.dateBegin"].value.length!=form["applyTime.dateEnd"].value.length) {
	    		alert("日期区间需要填写完整！");
	    		return;
	    	}
	    	if (form["applyTime.timeEnd"].value.length!=form["applyTime.timeEnd"].value.length) {
	    		alert("时间区间填写不完整或格式错误！");
	    		return;
	    	}
	    	if(form['applyTime.timeBegin'].value!=""&&!isShortTime(form['applyTime.timeBegin'].value)){
	    	    alert("开始时间填写不完整或格式错误！");
	    		return;
	    	}
	    	if(form['applyTime.timeEnd'].value!=""&&!isShortTime(form['applyTime.timeEnd'].value)){
	    	    alert("结束时间填写不完整或格式错误！");
	    		return;
	    	}
            if(form['applyTime.dateBegin'].value>form['applyTime.dateEnd'].value){
               alert("起始结束日期不对");return;
            }
            if(""!=form['applyTime.timeBegin'].value&&form['applyTime.timeBegin'].value>=form['applyTime.timeEnd'].value){
               alert("起始结束时间不对");return;
            }
            form.action = "ecuplRoomApplyApprove.do?method=search";
            form.target = "contentFrame";
		    form.submit();
	    }
	    
	    function roomPriceCatalogue(){
	       form.action = "roomPriceCatalogue.do?method=index";
	       form.target = "_blank";
	       form.submit();
	    }
        
        function lookFreeApply() {
           form.action = "ecuplRoomApplyApprove.do?method=freeRoomHome";
	       form.target = "contentFrame";
	       form.submit();
        }
 	</script>
</body>
<#include "/templates/foot.ftl"/>