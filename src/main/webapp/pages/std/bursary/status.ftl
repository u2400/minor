
<#macro status apply>
<#if !apply.submited>未提交<#else>
      	    <#if apply.approved??>
      	      <#if apply.approved>学校审核通过<#else>学校审核不通过</#if>
      	    <#else>
      	      <#if apply.collegeApproved??>
      	        <#if apply.collegeApproved>院系审核通过,等待学校审核<#else>院系审核不通过</#if>
      	      <#else>
      	        <#if apply.instructorApproved??>
      	          <#if apply.instructorApproved>辅导员审核通过<#else>辅导员审核不通过</#if>
      	        <#else>
      	        等待辅导员审核
      	        </#if>
      	      </#if>
      	    </#if>
      	  </#if>
</#macro>