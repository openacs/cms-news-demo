
<if @articles:rowcount@ gt 0>
  <font size=-1>Published articles by location:</font>
  <p>

  <table cellspacing=0 cellpadding=2 border=0 width="100%">
  <multiple name="articles">

    <tr><th align=left>
      <img src="@static_root@/small-ball.gif" border=0>
      <if @location_color@ not nil>
         <font size=-1 color="@location_color@">@articles.location@</font>
      </if>
      <else>
         <font size=-1>@articles.location@</font>
      </else>
    </th></tr>


    <group column="location">
      <tr><th align=left>
        &nbsp;&nbsp;&nbsp;&nbsp;    
       <img src="@static_root@/triangle-right.gif" border=0>
        <a href="@articles.url@?location=@articles.encoded_location@">
          <if @article_link_color@ not nil>
            <font size=-1 color="@article_link_color@">
              @articles.title@</font></a>
          </if>
          <else>
            <font size=-1>@articles.title@</font></a>
          </else>
        
      </td></tr>
    </group>

  </multiple>
  </table>

</if>

</font>
