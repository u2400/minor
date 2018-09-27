

var textAreaId;
var widthPx;
var heightPx;
var editorStyle;

function initFCK(fckTextAreaId, fckWidth, fckHeight, fckStyle)  {
	textAreaId = fckTextAreaId == "" || null == fckTextAreaId ? "areaTextId" : fckTextAreaId;
	widthPx = fckWidth== "" || null == fckWidth ? "700px" : fckWidth;
	heightPx = fckHeight == "" || null == fckHeight ? "300px" : fckHeight;
	editorStyle = fckStyle == "" || null == fckStyle ? "Default" : fckStyle;
	window.onload = function() {
	 	var oEditor = new FCKeditor(textAreaId, widthPx, heightPx) ;
	 	oEditor.BasePath = 'scripts/fckeditor/';
	 	oEditor.ToolbarSet = editorStyle;
	 	oEditor.ReplaceTextarea() ;
	}
}


function copyIt(){
 	var oEditor = FCKeditorAPI.GetInstance(textAreaId);
 	oEditor.UpdateLinkedField();
 	window.clipboardData.setData("Text", document.getElementById(textAreaId).innerHTML);
}
