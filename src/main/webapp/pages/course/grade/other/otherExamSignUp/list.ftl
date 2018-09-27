<#include "/templates/head.ftl"/>
 <BODY LEFTMARGIN="0" TOPMARGIN="0" >
  <table id="gradeListBar" width="100%"> </table>
  <@table.table id="listTable" sortable="true" width="100%">
    <@table.thead>
      <@table.selectAllTd id="otherExamSignUpId"/>
      <@table.sortTd name="attr.stdNo" id="signUp.std.code"/>
      <@table.sortTd name="attr.personName" id="signUp.std.name"/>
      <@table.sortTd text="学生类别" id="signUp.std.type.name"/>
      <@table.sortTd text="考试类别" id="signUp.category.name"/>
      <@table.sortTd text="报名时间" id="signUp.signUpAt"/>
      <@table.sortTd text="学年学期" id="signUp.calendar.start"/>
    </@>
    <@table.tbody datas=otherExamSignUps;signup>
      <@table.selectTd id="otherExamSignUpId" value=signup.id />
      <td>${signup.std.code}</td>
      <td><@i18nName signup.std/></td>
      <td><@i18nName signup.std.type/></td>
      <td><@i18nName signup.category/></td>
      <td>${signup.signUpAt?string("yyyy-MM-dd")}</td>
      <td>${signup.calendar.year} ${signup.calendar.term}</td>
    </@>
  </@>
  <@htm.actionForm name="actionForm" action="otherExamSignUp.do" entity="otherExamSignUp" onsubmit="return false;">
    <input type="hidden" name="keys" value="std.code,std.name,std.basicInfo.idCard,std.basicInfo.gender.name,std.basicInfo.nation.name,workPlace,job,std.basicInfo.birthday,std.studentStatusInfo.examineeNumber,std.department.name,std.type.name,calendar.year,calendar.term,category.name,signUpAt,std.firstMajor.name,std.firstMajorClass.name"/>
    <input type="hidden" name="titles" value="学号,姓名,身份证号,性别,民族,工作单位,职业,出生年月,考生学号,所在院系,学生类别,学年度,学期,考试类别,报名时间,专业,班级"/>
  </@>
  <script>
    var bar = new ToolBar("gradeListBar","报名查询结果",null,true,true);
    bar.setMessage('<@getMessage/>');
    bar.addItem("<@msg.message key="action.new"/>", "add()");
    bar.addItem("<@msg.message key="action.delete"/>", "remove()");
    bar.addItem("<@msg.message key="action.export"/>","exportData()");
    bar.addPrint("<@msg.message key="action.print"/>");

    function exportData(){
       exportList();
    }
  </script>
 </body>
<#include "/templates/foot.ftl"/>
