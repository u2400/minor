<#include "/templates/head.ftl"/>
 <BODY LEFTMARGIN="0" TOPMARGIN="0">
  <table id="stdBar" width="100%"></table>
  <#assign courseTakes = courseTakes?sort_by(["student","code"])>
  <#include "../courseTakeSearch/courseTakeList.ftl"/>
  <script>
     var bar=new ToolBar('stdBar','排课冲突学生名单(${courseTakes?size})',null,true,false);
     bar.setMessage('<@getMessage/>');
     bar.addItem("强制保存","save()");
     bar.addItem("发送消息","sendMessage()","send.gif");
     bar.addItem("<@msg.message key="action.print"/>","print()");
     bar.addBack();
     function save(){
       var form =document.queryForm;
       form.action="ecuplManualArrange.do?method=saveActivities&detectCollision=0";
       if(confirm("确认强制保存操作吗?")){
         var paramsValue = "${RequestParameters['params']?default()}";
         var params_ = paramsValue.split("&");
         var params = "";
         for (var i = 0; i < params_.length; i++) {
            var matchResult = null;
            if (null != params_[i]) {
                matchResult = params_[i].match(new RegExp("task.arrangeInfo.isArrangeComplete", "gm"));
            }
            if (null != params_[i] && null == matchResult) {
                params += "&" + params_[i];
            }
         }
         alert(params);
         form['params'].value = params;
         
         form.submit();
       }
    }
    function sendMessage(){
       window.open("systemMessage.do?method=quickSend&receiptorIds=<#list courseTakes as take>${take.student.code}<#if take_has_next>,</#if></#list>&who=std");
    }
</script>
 </body>
<#include "/templates/foot.ftl"/>

