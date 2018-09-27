    <#--数字与汉字转换-->
    <#assign numberCharMap = {
        "1":"一",
        "2":"二",
        "3":"三",
        "4":"四",
        "5":"五",
        "6":"六",
        "7":"七",
        "8":"八",
        "9":"九",
        "0":"〇",
        "11":"十",
        "12":"百",
        "13":"千",
        "14":"万",
        "15":"十万"
    }/>
    <#--isNumbers：true－数字；false－实数-->
    <#function to_chineseNumber text, isNumbers>
        <#if !text?exists || text?default("") == "">
            <#return ""/>
        </#if>
        <#attempt>
            <#local numberValue = text?number/>
        <#recover>
            <#return ""/>
        </#attempt>
        <#local result = ""/>
        <#if isNumbers>
            <#list 0..text?length - 1 as i>
                <#local result = result + numberCharMap[text[i..i]?string]?default(text[i..i]?string)/>
            </#list>
        <#else>
            <#local kZero = 0/>
            <#list 0..text?length - 1 as i>
                <#local iText = text[i..i]?string/>
                <#if i gt 0>
                    <#if iText == "0">
                        <#local kZero = i/>
                    <#else>
                        <#if kZero != 0>
                            <#local kZero = 0/>
                            <#local result = result + "零"/>
                        </#if>
                        <#local result = result + numberCharMap[iText]/>
                        <#if i != text?length - 1>
                            <#local result = result + numberCharMap[(text?length - i - 1 + 10)?string]/>
                        </#if>
                    </#if>
                <#else>
                    <#if text?length != 2 || iText != "1">
                        <#local result = result + numberCharMap[iText]/>
                    </#if>
                    <#if i != text?length - 1>
                        <#local result = result + numberCharMap[(text?length - i - 1 + 10)?string]/>
                    </#if>
                </#if>
            </#list>
        </#if>
        <#return result/>
    </#function>
    <#--第二个字符串与第一个字符串非重复的拼接-->
    <#function endWithReplaceString string1, string2>
        <#if !string1?exists || string1 == "">
            <#return ""/>
        </#if>
        <#if string1?length - string2?length lte 0>
            <#return string1 + string2/>
        </#if>
        <#if string1?index_of(string2) != -1> <#return string1/> </#if>
        <#return string1+string2/>
        <#--<#return string1[0..string1?length - string2?length - 1] + string1?substring(string1?length - string2?length)?replace(string2, "") + string2/>-->
    </#function>
    <#--根据变动的时间段，计算出学期、学年的长度-->
    <#function semesterDuration alteration>
        <#if (alteration.alterEndOn)?exists>
            <#local count = thisObj.getSemesterCount(alteration.std.type, alteration.alterBeginOn, alteration.alterEndOn?if_exists)/>
            <#if count % 2 == 0>
                <#return numberCharMap[(count / 2)?int?string] + "学年"/>
            <#else>
                <#return numberCharMap[count?string] + "学期"/>
            </#if>
        <#else>
            <#return "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"/>
        </#if>
    </#function>

    <#function getAddMonthDate date, monthIncrease>
        <#if date?exists && date?is_date && monthIncrease?exists && monthIncrease?is_number>
            <#local year = date?string("yyyy")?number/>
            <#local month = date?string("M")?number/>
            <#local day = date?string("d")?number/>
            <#if month + monthIncrease gt 12>
                <#return (year + ((month + monthIncrease) / 12)?int) + (((month + monthIncrease) % 12)?int)?string("00") + day?string("00")/>
            <#else>
                <#return year + (month + monthIncrease)?string("00") + day?string("00")/>
            </#if>
        <#else>
            <#return "－－－－年－月－日"/>
        </#if>
    </#function>
    