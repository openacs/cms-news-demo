<html>
<head>
  <title>CMS News Site Demo Installation Wizard</title>
</head>
<body>

  <h2>CMS News Site Demo Installation Wizard</h2>


  <if @data_model_p@ eq f>
    <ul>
    <li>The CMS News Demo data model has not been properly loaded.
    Please load the data model and return here when finished.
    </ul>
  </if>
  <else>


  <if @cm_admin_p@ eq f>
    <ul>
    <li>You are not a CMS Administrator.  The CMS News Demo installation 
    requires an existing CMS administrator.
    </ul>
  </if>

  <if @data_model_p@ eq t and @cm_admin_p@ eq t>
    <formtemplate id="install">
      <table cellspacing=0 cellpadding=4 border=0>
      <tr bgcolor="#6699CC"><td>
      <table cellspacing=0 cellpadding=8 border=0 width=100%>
      <tr bgcolor="#99CCFF"><td>

        CMS News Demo prerequisites check...
        <ul>
          <li>The CMS News Demo data model has been loaded.
          <li>You are a CMS administrator.
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
  </if>

  </else>



</body>
</html>