<html>
<head>
<title>@title@</title>
</head>

<table border=0 cellspacing=0 cellpadding=0 width=100%>

<!-- header -->

<tr bgcolor=#000066>
  <td>
    <table border=0 cellspacing=0 cellpadding=0 width=100%>
      <tr bgcolor=#000066>
        <td bgcolor=#ffffff align=left width=212><img src="@static_root@dnn-logo.gif" border=0></td>
        <td bgcolor=#000066 align=center width=100%>
          <font color=#ffffff><h3>Article: @title@</h3></font>
        </td>
      </tr>
    </table>
  </td>
  <td bgcolor=#000066 width=30>&nbsp;</td>
</tr>


<!-- nav and body -->

<tr>
  <td>
    <table border=0 cellspacing=0 cellpadding=20 width=100%>
      <tr>
        <td valign=top bgcolor=#000066>
          <font color=#ffffff>
	    <include src="article-list" 
              location="@location@" 
              title="@title@"
              article_link_color="#CCCCCC"
              location_color="#FFFFFF">
          </font>
        </td>
        <td bgcolor=#ffffff>
          <slave>
        </td>
      </tr>
    </table>
  </td>
  <td bgcolor=#000066 width=30>&nbsp;</td>
</tr>

<tr bgcolor=#000066 height=30>
  <td colspan=3>&nbsp;</td>
</tr>

</table>


</body>
</html>


