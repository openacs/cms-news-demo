set current_url [ns_conn url]

request create
request set_param title -value ""
request set_param location -optional -datatype text

set static_root [cms_news::get_static_content_root]
