# @datasource articles multirow
# @column location
# @column name
# @column title 
# @onevalue location the user clicked location

# @onevalue current_url

set current_url [ns_conn url]

request create
request set_param title    -datatype text -value ""
request set_param location -datatype text -optional

request set_param location_color     -datatype text
request set_param article_link_color -datatype text


template::query articles articles multirow "
  select
    live_revision, location, title, name,
    content_item.get_path( i.item_id ) as url
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
    location, title, name
" -eval {

  set row(encoded_location) [ns_urlencode $row(location)]
}


set static_root [cms_news::get_static_content_root]
