/**为视图中的选择增加选中效果**/
 var selectedFontColor="blue";
 var selectedFontStyle="italic";
 var selectedFontBackgroundColor="#e9f2f8";
 var rowStartIndex = 0;
 function setSelectedRow(table,ele){
     //alert(selectedFontBackgroundColor);
     var rows = table.tBodies[0].rows;
     //alert(rows.length);
     if (rows.length <= 1 + rowStartIndex) {
     	rows = table.rows;
     }
     // 确定选中的是第几列
     var index=getSelectedIndex(ele);
     for(var i=rowStartIndex;i<rows.length;i++){
//    	 alert(i + "," + index + "," + rows[i].cells.length + " : " + ele.innerHTML + ", " + rows[i].cells[index].innerHTML);
         // 如果该行没有那么多单元格,适合于那些表格下方有其他信息行的情况（如pageBar）
         if(rows[i].cells.length<=index) {
            continue;
         }
         if(ele==rows[i].cells[index]){
             ele.style.fontStyle=selectedFontStyle;
             ele.style.color=selectedFontColor;
             ele.style.backgroundColor=selectedFontBackgroundColor;
         } else {
             rows[i].cells[index].style.fontStyle="";
             rows[i].cells[index].style.color="";
             rows[i].cells[index].style.backgroundColor="";
         }
     }
 }
 
 function clearSelected(tables,ele){
     // 确定选中的是第几列
     var index=getSelectedIndex(ele);
     for(var i=rowStartIndex;i<tables.length;i++){
         clearSelectedForTable(tables[i],index);
	 }
 }

 function clearSelectedForTable(table,index){
    var rows = table.tBodies[0].rows;
	 for(var j=1;j<rows.length;j++){
         rows[j].cells[index].style.fontStyle="";
         rows[j].cells[index].style.color="";
         rows[j].cells[index].style.backgroundColor="";
     }
 }
 // 确定选中的是第几列
 function getSelectedIndex(td){
     var colIndex=-1;
     var childs = td.parentNode.childNodes;
     for(var index=0;index <childs.length;index++){
        if(childs[index].tagName=="TD"){
          colIndex++;
          if(childs[index]==td) {
              break;
          }
        }
     }
     return colIndex;
 }
