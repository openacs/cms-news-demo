# @datasource multirow articles
# @column location
# @column name
# @column title 
# @onevalue location the user clicked location


request create
request set_param title    -datatype text -value ""
request set_param location -datatype text -optional

if { ![template::util::is_nil location] } {
    set where_clause "where location in '$location'"
} else {
    set where_clause ""
}


template::query articles articles multirow "
  select
    live_revision, location, title, name
  from
    cr_items i, cr_demo_articles a, cr_revisions r
  where
    i.live_revision = r.revision_id
  and
    r.item_id = i.item_id
  and
    r.revision_id = a.cr_demo_article_id
  and
    i.publish_status = 'live'
  order by
    location, title, name"


lappend articles:columns encoded_location

set rowcount [multirow size articles]

for {set i 1} {$i <= $rowcount } {incr i} {
    set articles:[set i](encoded_location) [ns_urlencode [multirow get articles $i location]]
}


set static_root [cms_news::get_static_content_root]
