        var HKEY_Root,HKEY_Path,HKEY_Key;
        HKEY_Root="HKEY_CURRENT_USER";
        HKEY_Path="\\Software\\Microsoft\\Internet Explorer\\PageSetup\\";
        // 设置网页打印的页眉页脚为空
        function PageSetup_Null() {
            try {
                var Wsh=new ActiveXObject("WScript.Shell");
                HKEY_Key="header";
                Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"");
                HKEY_Key="footer";
                Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"");
                HKEY_Key="margin_bottom";
                Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0.19685");
                HKEY_Key="margin_left";
                Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0.23667");
                HKEY_Key="margin_right";
                Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0.23667");
                HKEY_Key="margin_top";
                Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0.19685");
            } catch(e) {
                //alert(e);
            }
        }
        //设置网页打印的页眉页脚为默认值
        function PageSetup_Default() {
            try {
                var Wsh=new ActiveXObject("WScript.Shell");
                HKEY_Key="header";
                Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"&w&b 页码,&p/&P");
                HKEY_Key="footer";
                Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"&u&b&d");
            } catch(e) {
                ;
            }
        }

        
    function window.onload(){
       try{
           if(typeof factory.printing != 'undefined'){ 
             factory.printing.header = ""; 
             factory.printing.footer = "";
             
                 // -- advanced features
                //factory.printing.SetMarginMeasure(2); // measure margins in inches
                //factory.printing.printer = "HP DeskJet 870C";
                factory.printing.paperSize = "A3";//只能A3，因为此项是收费的。
                //factory.printing.paperSource = "Manual feed";
                //factory.printing.collate = true;
                //factory.printing.copies = 2;
                //factory.printing.SetPageRange(false, 1, 3); // need pages from 1 to 3
               
                // -- basic features
                //factory.printing.header = "This is MeadCo";
                //factory.printing.footer = "Printing by ScriptX";
                //factory.printing.portrait = true;
                factory.printing.leftMargin = 10.0;
                factory.printing.topMargin = 10.0;
                factory.printing.rightMargin = 10.0;
                factory.printing.bottomMargin = 10.0;
           }
       }catch(e){
           
       }
    }