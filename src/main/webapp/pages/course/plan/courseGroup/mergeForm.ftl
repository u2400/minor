<#include "/templates/head.ftl"/>
<body>
    <table id="bar"></table>
    <#assign mergeMap = {}/>
    <#assign courseGroupIds = RequestParameters["courseGroupIds"]?split(",")/>
    <#list courseGroupIds as courseGroupId>
        <#assign mergeMap = mergeMap + {courseGroupId?string:courseGroupId}/>
    </#list>
    <@table.table width="100%" align="center" style="text-align:center">
        <@table.thead>
            <@table.td width="35%" name="entity.courseType"/>
            <@table.td text="要求学时"/>
            <@table.td text="要求学分"/>
            <@table.td text="学分分布" colspan=plan.termsCount + 2/>
            <@table.td text="周课时分布" colspan=plan.termsCount + 2/>
        </@>
        <#assign courseGroupMap = {}/>
        <#list plan.courseGroups?sort_by(["courseType","id"]) as group>
            <#assign courseTypeValue><#if group.parentCourseType?exists && group.parentCourseType.id != group.courseType.id><@i18nName group.parentCourseType/>/</#if><@i18nName group.courseType/></#assign>
            <#assign credits = group.creditPerTerms?split(",")/>
            <#assign weekHours = group.weekHourPerTerms?split(",")/>
            <#assign courseGroupMap = courseGroupMap + {group.id?string:{"this",group, "courseTypeValue":courseTypeValue, "credits":credits, "weekHours":weekHours}}/>
        </#list>
        
        <#assign perWidth = 2/>
        <#assign mergeSum = {}/>
        <#assign row = 0/> 
        <#list courseGroupMap?keys as key>
            <#if mergeMap?keys?seq_contains(key)>
        <tr class="${(row % 2 == 0)?string("brightStyle", "grayStyle")}" align="center" onmouseover="swapOverTR(this,this.className)"onmouseout="swapOutTR(this)" onclick="onRowChange(event)">
                <#assign k = 0/>
            <td>${courseGroupMap[key].courseTypeValue}</td>
                <#if mergeSum["_2"]?exists>
                    <#assign mergeSum = mergeSum + {"_2":mergeSum["_2"]?number + courseGroupMap[key].this.creditHour?number}>
                <#else>
                    <#assign mergeSum = mergeSum + {"_2":courseGroupMap[key].this.creditHour?number}/>
                </#if>
            <td>${courseGroupMap[key].this.creditHour}</td>
                <#if mergeSum["_1"]?exists>
                    <#assign mergeSum = mergeSum + {"_1":mergeSum["_1"]?number + courseGroupMap[key].this.credit?number}>
                <#else>
                    <#assign mergeSum = mergeSum + {"_1":courseGroupMap[key].this.credit?number}/>
                </#if>
            <td>${courseGroupMap[key].this.credit}</td>
            <td style="border-right-width: 0px" width="${perWidth}%"></td>
                <#list 1..courseGroupMap[key].credits?size - 2 as i>
                    <#assign k = k + 1/>
                    <#if mergeSum[k?string]?exists>
                        <#assign mergeSum = mergeSum + {k?string:(mergeSum[k?string]?number + courseGroupMap[key].credits[i]?number)}/>
                    <#else>
                        <#assign mergeSum = mergeSum + {k?string:courseGroupMap[key].credits[i]?number}/>
                    </#if>
            <td style="border-right-width: 0px; text-align: right" width="${perWidth}%">${courseGroupMap[key].credits[i]}</td>
                </#list>
                <#if ((courseGroupMap[key].credits?size - 2 ) < plan.termsCount)>
                    <#list (courseGroupMap[key].credits?size - 2)..plan.termsCount as i>
            <td style="border-right-width: 0px; text-align: right" width="${perWidth}%">-</td>
                    </#list>
                </#if>
            <td width="${perWidth}%"></td>
            <td style="border-right-width: 0px" width="${perWidth}%"></td>
                <#list 1..courseGroupMap[key].weekHours?size - 2 as i>
                    <#assign k = k + 1/>
                    <#if mergeSum[k?string]?exists>
                        <#assign mergeSum = mergeSum + {k?string:(mergeSum[k?string]?number + courseGroupMap[key].weekHours[i]?number)}/>
                    <#else>
                        <#assign mergeSum = mergeSum + {k?string:courseGroupMap[key].weekHours[i]?number}/>
                    </#if>
            <td style="border-right-width: 0px; text-align: right" width="${perWidth}%">${courseGroupMap[key].weekHours[i]}</td>
                </#list>
                <#if ((courseGroupMap[key].weekHours?size - 2 ) < plan.termsCount)>
                    <#list (courseGroupMap[key].weekHours?size - 2)..plan.termsCount as i>
            <td style="border-right-width: 0px; text-align: right" width="${perWidth}%">0</td>
                    </#list>
                </#if>
            <td width="${perWidth}%"></td>
        </tr>
                <#assign row = row + 1/> 
            </#if>
        </#list>
        <form method="post" action="" name="actionForm" onsubmit="return false;">
            <input type="hidden" name="courseGroupIds" value="${RequestParameters["courseGroupIds"]}"/>
            <input type="hidden" name="planId" value="${plan.id}"/>
            <input type="hidden" name="params" value="&teachPlan.id=${plan.id}"/>
        <tr class="brightStyle" align="center">
           <td>合并到：<select name="mergeToId" style="width:150px" onchange="mergeTo()"><#list courseGroupMap?keys as key><option value="${courseGroupMap[key?string].this.courseType.id}">${courseGroupMap[key?string].courseTypeValue}</option></#list></select>　小计：</td>
           <td id="_2">${(mergeMap?keys?seq_contains(courseGroupMap?keys?first))?string(mergeSum["_2"]?number, (mergeSum["_2"]?number + courseGroupMap[courseGroupMap?keys?first?string].this.creditHour)?number)}</td>
           <td id="_1">${(mergeMap?keys?seq_contains(courseGroupMap?keys?first))?string(mergeSum["_1"]?number, (mergeSum["_1"]?number + courseGroupMap[courseGroupMap?keys?first?string].this.credit)?number)}</td>
           <td style="border-right-width: 0px; text-align: right"></td>
           <#list 1..courseGroupMap[courseGroupMap?keys?first].credits?size - 2 as i>
           <td style="border-right-width: 0px; text-align: right" id="${i}">${(mergeMap?keys?seq_contains(courseGroupMap?keys?first))?string(mergeSum[i?string]?number, mergeSum[i?string]?number + courseGroupMap[courseGroupMap?keys?first?string].credits[i]?number)}</td>
           </#list>
           <td></td>
           <td style="border-right-width: 0px; text-align: right"></td>
           <#list (courseGroupMap[courseGroupMap?keys?first].credits?size - 2) + 1..(courseGroupMap[courseGroupMap?keys?first].credits?size - 2) + (courseGroupMap[courseGroupMap?keys?first].weekHours?size - 2) as i>
           <td style="border-right-width: 0px; text-align: right" id="${i}">${(mergeMap?keys?seq_contains(courseGroupMap?keys?first))?string(mergeSum[i?string]?float, mergeSum[i?string]?number + courseGroupMap[courseGroupMap?keys?first?string].weekHours[i - (courseGroupMap[courseGroupMap?keys?first].credits?size - 2)]?number)}</td>
           </#list>
           <td></td>
        </tr>
    </@>
    <br>
    <p align="center"><button style="width:60px;height:25px;font-size:11pt" onclick="merge()">合并</button></p>
        </form>
    <script>
        var bar = new ToolBar("bar", "课程组合并", null, true, true);
        bar.setMessage('<@getMessage/>');
        bar.addBackOrClose("<@msg.message key="action.back"/>", "<@msg.message key="action.close"/>");
        
        var form = document.actionForm;
        
        function mergeTo() {
            <#list courseGroupMap?keys as key>if (form["mergeToId"].value == ${courseGroupMap[key?string].this.courseType.id}) {
                <#if mergeMap?keys?seq_contains(key)>
                $("_2").innerHTML = "${mergeSum["_2"]?number}"
                $("_1").innerHTML = "${mergeSum["_1"]?number}"
                    <#list 1..(courseGroupMap[key].credits?size - 2) + (courseGroupMap[key].weekHours?size - 2) as i>
                $("${i}").innerHTML = "${mergeSum[i?string]}";
                    </#list>
                <#else>
                $("_2").innerHTML = "${mergeSum["_2"]?number + courseGroupMap[key?string].this.creditHour}"
                $("_1").innerHTML = "${mergeSum["_1"]?number + courseGroupMap[key?string].this.credit}"
                    <#list 1..(courseGroupMap[key].credits?size - 2) as i>
                $("${i}").innerHTML = "${mergeSum[i?string]?number + courseGroupMap[key?string].credits[i]?number}";
                    </#list>
                    <#list (courseGroupMap[key].credits?size - 2) + 1..(courseGroupMap[key].credits?size - 2) + (courseGroupMap[key].weekHours?size - 2) as i>
                $("${i}").innerHTML = "${mergeSum[i?string]?number + courseGroupMap[key?string].weekHours[i - (courseGroupMap[key].credits?size - 2)]?number}";
                    </#list>
                </#if>
            }<#if key_has_next> else </#if></#list>
        }
        
        mergeTo();
        
        function merge() {
            if (confirm("确认要如此合并吗？\n\n合并后，部分课程组将会有删除的操作，要继续吗？")) {
                form.action = "courseGroup.do?method=merge";
            <#list mergeSum?keys as key>
                addInput(form, "V${key}", $("${key}").innerHTML, "hidden");
            </#list>
                form.submit();
            }
        }
    </script>
</body>
<#include "/templates/foot.ftl"/>