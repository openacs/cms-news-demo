<html>
<head>
  <title>CMS News Site Demo Installation Wizard</title>
</head>
<body>

  <h2>CMS News Site Demo Installation Wizard</h2>

  <formtemplate id="install">

  <table cellspacing=0 cellpadding=4 border=0>
  <tr bgcolor="#6699CC"><td>
  <table cellspacing=0 cellpadding=8 border=0 width="100%">
  <tr bgcolor="#99CCFF"><td>

    Registering basic users for the CMS News Demo...
    <ul>
    <if @demo_users_p@ eq t>
      <li>Demo users have already been created.
    </if>
    <else>
      <!-- results of creating demo users -->
      @html@
    </else>
    </ul>
    <p>

  </td></tr>
  <tr bgcolor="#99CCFF"><td align=center>
    <formwidget id="submit">
  </td></tr>
  </table>
  </td></tr>
  </table>

  </formtemplate>

</body>
</html>