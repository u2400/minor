   <div style="display: block;" class="tab-page" id="tabPage3">
   <h2 class="tab"><a href="#">语言等级统计(${languageAbilitys?size})</a></h2>     
   <script type="text/javascript">tp1.addTabPage( document.getElementById( "tabPage3" ) );</script>
   <table width="100%" align="center" class="listTable">
    <tr align="center" class="darkColumn">
      <td width="2%"align="center" >
        <input type="radio" onClick="toggleCheckBox(document.getElementsByName('adminClassId'),event);">
      </td>
      <td width="5%">序号</td>
      <td width="9%">语言等级代码</td>
      <td width="9%">语言等级名称</td>
      <td width="15%">人数</td>
    </tr>
    <#list languageAbilitys?sort_by("id") as languageAbility>
	  <#if languageAbility_index%2==1 ><#assign class="grayStyle" ></#if>
	  <#if languageAbility_index%2==0 ><#assign class="brightStyle" ></#if>
     <tr class="${class}" onmouseover="swapOverTR(this,this.className)" 
       onmouseout="swapOutTR(this)" align="center"
       onclick="onRowChange(event)">
      <td  class="select">
         <input type="radio" name="languageAbilityId" value="${languageAbility.id?if_exists}">
      </td>
      <td>${languageAbility_index+1}</td>
      <td>${languageAbility.code?if_exists}</td>
       <td>${languageAbility.name?if_exists}</td>
      <td>${(langMap.get(languageAbility.id))?if_exists}</td>
    </tr>
    </#list>
  </table>
  </div>