# List latest live press releases

# Get the folder

set query "
  select
    r.title, initcap(to_char(r.publish_date, 'MONTH DD, YYYY')) publish_date, 
    r.description, i.name
  from
    cr_revisions r, cr_items i, acs_objects o
  where
    o.context_id = content_item.get_id('/demo_articles')
  and
    o.object_id = i.item_id
  and
    i.live_revision = r.revision_id
  and
    i.publish_status = 'live'
  and
    i.name ^= 'index'
  order by
    publish_date"

query items items multirow $query
