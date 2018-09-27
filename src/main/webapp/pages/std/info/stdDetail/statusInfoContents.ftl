<#assign info=std.studentStatusInfo/>
<table class="infoTable">
   	<tr>
     	<td class="title" width="18%"><@msg.message key="std.examNumber"/>：</td>
     	<td width="32%">${(info.examNumber)?if_exists}</td>
     	<td class="title" width="18%">考生号：</td>
     	<td width="32%">${(info.examineeNumber)?if_exists}</td>
   	</tr>
   	<tr>
     	<td class="title"><@msg.message key="std.graduateSchool"/>：</td>
     	<td>${(info.graduateSchool)?if_exists}</td>
     	<td class="title"><@msg.message key="entity.enrollMode"/>：</td>
     	<td><#if info.enrollMode?exists><@i18nName info.enrollMode/><#else>&nbsp;</#if></td>
   	</tr>
   	<tr>
     	<td class="title"><@msg.message key="entity.educationMode"/>：</td>
     	<td><#if info.educationMode?exists><@i18nName info.educationMode/><#else>&nbsp;</#if></td>
     	<td class="title"><@msg.message key="std.educationBeforEnroll"/>：</td>
     	<td><#if info.educationBeforEnroll?exists><@i18nName info.educationBeforEnroll/><#else>&nbsp;</#if></td>
   	</tr>
   	<tr>
     	<td class="title"><@msg.message key="std.enrollDate"/>：</td>
     	<td>${(info.enrollDate)?if_exists}</td>
     	<td class="title"><@msg.message key="std.statusInfo.department"/>：</td>
     	<td><#if info.department?exists><@i18nName info.department/><#else>&nbsp;</#if></td>
   	</tr>
   	<tr>
     	<td class="title"><@msg.message key="std.statusInfo.speciality"/>：</td>
     	<td><#if info.speciality?exists><@i18nName info.speciality/><#else>&nbsp;</#if></td>
     	<td class="title"><@msg.message key="std.originalAddress"/>：</td>
     	<td>${(info.originalAddress)?if_exists}</td>
   	</tr>
   	<tr>
     	<td class="title"><@msg.message key="std.statusInfo.recommendedUnit"/>：</td>
     	<td>${(info.recommendOrganization)?if_exists}</td>
     	<td class="title"><@msg.message key="entity.leaveSchoolCause"/>：</td>
     	<td><#if info.leaveSchoolCause?exists><@i18nName info.leaveSchoolCause/><#else>&nbsp;</#if></td>
   	</tr>
   	<tr>
     	<td class="title"><@msg.message key="std.leaveDate"/>：</td>
     	<td>${(info.leaveDate)?if_exists}</td>
     	<td class="title"><@msg.message key="std.gotoWhere"/>：</td>
     	<td>${(info.gotoWhere)?if_exists}</td>
   	</tr>
   	<tr>
     	<td class="title"><@msg.message key="std.statusInfo.fareSources"/>：</td>
     	<td><#if info.feeOrigin?exists><@i18nName info.feeOrigin/><#else>&nbsp;</#if></td>
     	<td class="title"><@msg.message key="entity.studentState"/>：</td>
     	<td><#if std.state?exists><@i18nName std.state/><#else>&nbsp;</#if></td>
   	</tr>
</table>
