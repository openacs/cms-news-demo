content::get_content
template::util::array_to_vars content

template::query links links multirow "
  select
    relation_tag
  from
    cr_child_rels
  where
    relation_tag = 'cr_demo_article-cr_demo_link'
  and
    parent_id = :item_id
  order by
    order_n
"
