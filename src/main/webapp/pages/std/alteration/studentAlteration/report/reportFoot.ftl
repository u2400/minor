<object id="factory" style="display:none" viewastext classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="css/smsx.cab#Version=6,2,433,14"></object>
<script>
 function window.onload(){
    try{
       if(typeof factory.printing != 'undefined'){
            factory.printing.header = ""; 
            factory.printing.footer = "";
            factory.printing.leftMargin = factory.printing.topMargin = factory.printing.rightMargin = factory.printing.bottomMargin = ${marginMM_Value?default(50)} * 0.039370078740157;
       }
    }catch(e){
    }
 }
</script>
