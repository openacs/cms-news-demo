<html>
  <style>

     .blue { background-color: #99CCFF }
     .large { font-size: large }

     body { 
       font-family: Helvetica,sans-serif;
       background-color: white
     }
     td { 
       font-family: Helvetica,sans-serif;
     }
     th { 
       font-family: Helvetica,sans-serif;
       text-align: left;
     }

     A:link, A:visited, A:active { text-decoration: none }

  </style>
  <head><title>@content.title@</title></head>
<body>

<table width=100% border=0 cellpadding=20>
  <tr>
    <td bgcolor="#99ccff" width=100>
      <b><font size="+5">DNN</font><br>Demo News Network</b>
    </td>
    <td bgcolor="#FFFFCC"><b>@content.title@</b></td>
  </tr>
</table>
<br>


<multiple name="folders">
  <if @folders.rownum@ lt @folders:rowcount@>
    <a href="@folders.url@">@folders.title@</a> : 
  </if>
  <else>
    @folders.title@
  </else>
</multiple>

<hr>

<blockquote>

@content.text@

<slave>

</blockquote>

<hr>

<em>Copyright &copy; 2000 Demo News Network. All Rights Reserved.</em>

</body>
</html>
