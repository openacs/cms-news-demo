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

      Creating folders and templates for the CMS News Demo...
      <ul>
      <if @demo_folders_p@ eq t>
        <li>Folders and templates for the CMS News Site Demo have
          already been created.
      </if>
      <else>
        <!-- results of creating folders and templates -->
        @html;noquote@
      </else>
      </ul>
      <p>

      Publishing templates to the file system...
      <ul>
      <if @published_templates_p@ eq t>
	<li>News Demo templates have already been published to the filesystem.
      </if>
      <else>
        <!-- results of publishing templates -->
        @html2@
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