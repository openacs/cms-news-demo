<master src="master-2">
<property name="title">@title@</property>

<table bgcolor="#FFFFCC" cellpadding=10 cellspacing=0 border=0>
<tr>
  <td colspan=2>
    <a href="index">DNN News</a> : @title@
  </td>
</tr>
<tr>
  <td valign=top width="65%">
    <b><font face="arial" size=5>@title@</font></b><br>
    &nbsp;&nbsp;&nbsp;&nbsp;<font size=-1>by</font> <i>@author@</i>
    <p>
    <content>
  </td>


  <td valign=top>
    <child tag="cr_demo_article-cr_demo_article_image" index=1 embed>
    <p>
    &nbsp;
    <p>
    

  <h4>Multimedia Links</h4>
  <if @links:rowcount@ gt 0>
    <multiple name="links">
      <child tag="cr_demo_article-cr_demo_link" index=@links.rownum@ embed>
      <br>
    </multiple>
  </if>

  </td>
</tr>
</table>





