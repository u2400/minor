  <table class="searchTable"  onkeypress="DWRUtil.onReturn(event, search)">
    <tr>
      <td colspan="2" class="infoTitle" align="left" valign="bottom">
       <img src="images/action/info.gif" align="top"/>
          <B>奖项查询</B>
      </td>
    </tr>
    <tr>
      <td colspan="2" style="font-size:0px">
          <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
      </td>
    </tr>
    <tr>
      <td>名称:</td>
      <td><input type="text" name="subject.name" style="width:100px;"/></td>
    </tr>
    <tr align="center">
      <td colspan="2">
    	  <button onclick="search();"><@msg.message key="action.query"/></button>
      </td>
    </tr>
  </table>