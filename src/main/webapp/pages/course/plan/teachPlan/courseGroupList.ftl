  <table id="courseGroupListBar"></table>
  <script>
    var bar = new ToolBar("courseGroupListBar", "课程组列表", null, true, true);
    bar.addItem("<@bean.message key="action.add"/>", "add()");
    bar.addItem("<@bean.message key="action.modify"/>", "edit()");
    bar.addItem("合并", "merge()");
    bar.addItem("<@bean.message key="action.delete"/>", "remove()");
  </script>
 
    <@table.table width="100%" align="center" style="text-align:center">
        <@table.thead>
            <@table.selectAllTd id="courseGroupId"/>
            <@table.td width="25%" name="entity.courseType"/>
            <@table.td width="10%" text="要求学时"/>
            <@table.td width="10%" text="要求学分"/>
            <@table.td text="学分分布" colspan=teachPlan.termsCount + 2/>
            <@table.td text="周课时分布" colspan=teachPlan.termsCount + 2/>
        </@>
        <#assign total_credit = 0/>
        <#assign total_creditHour = 0/>
        <#assign total_term_credit = {}/>
        <#assign total_term_weekHour = {}/>
       
        <#list 1..teachPlan.termsCount as i>
            <#assign total_term_credit = total_term_credit + {i:0}/>
            <#assign total_term_weekHour = total_term_weekHour + {i:0}/>
        </#list>
        <#assign perWidth = 2/>
        <@table.tbody datas = teachPlan.courseGroups?sort_by(["courseType","id"]);group>
            <@table.selectTd id="courseGroupId" value=group.id/>
            <td><#if group.parentCourseType?exists && group.parentCourseType.id != group.courseType.id><@i18nName group.parentCourseType/>/</#if><@i18nName group.courseType/></td>
            <td>${group.creditHour}</td>
            <td>${group.credit}</td>
            <#assign creditPerTerms = ""/>
            <#assign total_creditHour = total_creditHour + group.creditHour/>
            <#assign total_credit = total_credit + group.credit/>
            <td style="border-right-width: 0px" width="${perWidth}%"></td>
            <#assign i = 1/>
            <#list group.creditPerTerms[1..group.creditPerTerms?length - 2]?split(",") as credit>
                <#assign current_totle = total_term_credit[i?string]?if_exists/>
                <#assign total_term_credit = total_term_credit + {i:current_totle + credit?number}/>
                <#assign i = i + 1/>
                <td style="border-right-width: 0px; text-align: right" width="${perWidth}%">${credit}</td>
            </#list>
            <#if (i - 1 < teachPlan.termsCount)>
                <#list i..teachPlan.termsCount as k>
                <td style="border-right-width: 0px; text-align: right" width="${perWidth}%">0</td>
                </#list>
            </#if>
            <td width="${perWidth}%"></td>
            <td style="border-right-width: 0px" width="${perWidth}%"></td>
            <#assign i = 1/>
            <#list group.weekHourPerTerms[1..group.weekHourPerTerms?length - 2]?split(",") as weekHour>
                <#assign current_totle = total_term_weekHour[i?string]?if_exists/>
                <#assign total_term_weekHour = total_term_weekHour + {i:current_totle + weekHour?number}/>
                <#assign i = i + 1/>
                <td style="border-right-width: 0px; text-align: right" width="${perWidth}%">${weekHour}</td>
            </#list>
            <#if (i - 1 < teachPlan.termsCount)>
                <#list i..teachPlan.termsCount as k>
                <td style="border-right-width: 0px; text-align: right" width="${perWidth}%">0</td>
                </#list>
            </#if>
            <td width="${perWidth}%"></td>
        </@>
        <tr class="brightStyle" align="center">
           <td colspan="2"><@bean.message key="attr.cultivateScheme.allTotle"/></td>
           <td>${total_creditHour}</td>
           <td>${total_credit}</td>
           <td style="border-right-width: 0px; text-align: right"></td>
           <#list 1..teachPlan.termsCount as i><td style="border-right-width: 0px; text-align: right">${total_term_credit[i?string]}</td></#list>
           <td></td>
           <td style="border-right-width: 0px; text-align: right"></td>
           <#list 1..teachPlan.termsCount as i><td style="border-right-width: 0px; text-align: right">${total_term_weekHour[i?string]}</td></#list> 
           <td></td>
        </tr>
    </@>
  <form name="courseGroupForm" method="post" action="" onsubmit="return false;">
      <input type="hidden" name="teachPlan.id" value="${RequestParameters['teachPlan.id']}"/>
      <input type="hidden" name="courseGroup.id" value=""/>
      <input type="hidden" name="courseGroupIds" value=""/>
  </form>
  </table>

  <script>
     var form = document.courseGroupForm;
     
     function add(){
         form.action="courseGroup.do?method=add";
         form.submit();
     }
     
     function edit(){
         var courseGroupId = getSelectId("courseGroupId");
         if(isEmpty(courseGroupId) || isMultiId(courseGroupId)) {
            alert("请选择一个要修改的课程组。");
            return;
         }
         var url = "courseGroup.do?method=edit&teachPlan.id=${RequestParameters["teachPlan.id"]}&courseGroup.id=" + courseGroupId;
         MakeFull(url, "yes");
     }
     
     function merge() {
         var courseGroupIds = getSelectIds("courseGroupId");
         if(isEmpty(courseGroupIds) || !isMultiId(courseGroupIds)) {
            alert("请选择两个（以上）要修改的课程组。");
            return;
         }
         form.action = "courseGroup.do?method=mergeEdit";
         form["courseGroupIds"].value = courseGroupIds;
         form.submit();
     }
     
     function remove() {
        var courseGroupId = getSelectId("courseGroupId");
        if(isEmpty(courseGroupId) || isMultiId(courseGroupId)) {
            alert("请选择一个要修改的课程组。");
            return;
        }
        if (confirm("删除培养计划课程组，确认？")) {
	        form.action="courseGroup.do?method=removeGroup";
	        form["courseGroup.id"].value = courseGroupId;
	        form.submit();
        }
     }
  </script>