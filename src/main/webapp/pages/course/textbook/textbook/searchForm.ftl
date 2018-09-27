  <table class="searchTable"  onkeypress="DWRUtil.onReturn(event, search)">
    <tr>
      <td colspan="2" class="infoTitle" align="left" valign="bottom">
       <img src="images/action/info.gif" align="top"/>
          <B><@msg.message key="textbook.search"/></B>
      </td>
    </tr>
    <tr>
      <td colspan="2" style="font-size:0px">
          <img src="images/action/keyline.gif" height="2" width="100%" align="top"/>
      </td>
    </tr>
    <tr>
      <td>书号:</td>
      <td><input type="text" name="textbook.code" style="width:100px;"/></td>
    </tr>
    <tr>
      <td>教材名称:</td>
      <td id="name"><input type="text" name="textbook.name" maxlength="20" style="width:100px;"/></td>
    </tr>
    <tr>
      <td><@msg.message key="textbook.author"/>:</td>
      <td id="auth"><input type="text" name="textbook.auth" maxlength="20" style="width:100px;"/></td>
    </tr>
    <tr>
      <td><@msg.message key="entity.press"/>:</td>
      <td id="press.id"><input type="text" name="textbook.press.name" maxlength="20" style="width:100px;"/></td>
    </tr>
    <tr align="center">
      <td colspan="2">
    	  <button onclick="search();"><@msg.message key="action.query"/></button>
      </td>
    </tr>
  </table>