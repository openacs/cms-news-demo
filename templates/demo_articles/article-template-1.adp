<master src="master-1">
<property name=title>@title;noquote@</property>

<table cellspacing=0 height=100%>
 <tr bgcolor=#ffffff>
   <td width="65%">
     <content>
   </td>
   <td>&nbsp;</td>
   <td valign=top bgcolor=#eeeeee>
     <child tag="cr_demo_article-cr_demo_article_image" index=1 embed>
     <p>
     <if @links:rowcount@ gt 0>
    <multiple name="links">
      <child tag="cr_demo_article-cr_demo_link" index=@links.rownum@ embed>
      <br>
    </multiple>
  </if>
   </td>
 </tr>
</table>





