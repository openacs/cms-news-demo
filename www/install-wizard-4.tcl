# install-wizard-3.tcl
#
# A web interface for installing the CMS News Site Demo
# Step 4: Grant permissions to demo users
#
# @author Michael Pih

set html ""

set db [template::get_db_handle]

# get the user id of a cm_admin
template::query cm_admin onevalue "
  select
    distinct user_id
  from
    users u, cm_modules m
  where 
    cms_permission.permission_p( 
 	content_item.get_root_folder, user_id, 'cm_admin') = 't'
  and
    cms_permission.permission_p(
	content_template.get_root_folder, user_id, 'cm_admin') = 't'
  and
    cms_permission.permission_p(
	module_id, user_id, 'cm_admin') = 't'
  and
    user_id = [User::getID]
" -db $db


template::release_db_handle

if { [template::util::is_nil cm_admin] } {
    template::forward install-wizard
    return
} else {
    set cm_admin_p t
}


# some default variables
set creation_ip [ns_conn peeraddr]
set user_id     $cm_admin





# grant permissions to demo users

set db [template::begin_db_transaction]

# some root folders
template::query sitemap onevalue "
  select content_item.get_root_folder from dual
" -db $db

template::query templates onevalue "
  select content_template.get_root_folder from dual
" -db $db

# some user ID's
template::query author onevalue "
  select user_id from users where screen_name = 'author'
" -db $db

template::query editor onevalue "
  select user_id from users where screen_name = 'editor'
" -db $db

template::query publisher onevalue "
  select user_id from users where screen_name = 'publisher'
" -db $db


# some folder/module ID's
template::query demo_articles onevalue "
  select content_item.get_id( '/demo_articles' ) from dual
" -db $db

template::query other_modules onelist "
  select module_id from cm_modules where key ^= 'sitemap'
" -db $db


# grant permissions
ns_ora dml $db "
  begin
  cms_permission.grant_permission (
      item_id      => :sitemap,
      holder_id    => :user_id,
      privilege    => 'cm_examine',
      recepient_id => :author,
      is_recursive => 't'
  );

  cms_permission.grant_permission (
      item_id      => :demo_articles,
      holder_id    => :user_id,
      privilege    => 'cm_write',
      recepient_id => :author,
      is_recursive => 't'
  );

  cms_permission.grant_permission (
      item_id      => :sitemap,
      holder_id    => :user_id,
      privilege    => 'cm_examine',
      recepient_id => :editor,
      is_recursive => 't'
  );

  cms_permission.grant_permission (
      item_id      => :demo_articles,
      holder_id    => :user_id,
      privilege    => 'cm_write',
      recepient_id => :editor,
      is_recursive => 't'
  );

  cms_permission.grant_permission (
      item_id      => :sitemap,
      holder_id    => :user_id,
      privilege    => 'cm_item_workflow',
      recepient_id => :publisher,
      is_recursive => 't'
  );

  cms_permission.grant_permission (
      item_id      => :sitemap,
      holder_id    => :user_id,
      privilege    => 'cm_relate',
      recepient_id => :publisher,
      is_recursive => 't'
  );

  end;"

append html "<li>Granted cm_examine to author on sitemap."
append html "<li>Granted cm_write to author on /demo_articles folder."
append html "<li>Granted cm_examine to editor on sitemap."
append html "<li>Granted cm_write to editor on /demo_articles folder."
append html "<li>Granted cm_item_relate, cm_item_workflow to publisher on sitemap."


foreach module_id $other_modules {
    ns_ora dml $db "
      begin
      cms_permission.grant_permission (
          item_id      => :module_id,
          holder_id    => :user_id,
          privilege    => 'cm_examine',
          recepient_id => :author,
          is_recursive => 't'
      );
      end;"
}

append html "<li>Granted cm_examine to author on all other modules."

foreach module_id $other_modules {
    ns_ora dml $db "
      begin
      cms_permission.grant_permission (
          item_id      => :module_id,
          holder_id    => :user_id,
          privilege    => 'cm_examine',
          recepient_id => :editor,
          is_recursive => 't'
      );
      end;"
}

append html "<li>Granted cm_examine to editor on all other modules."

foreach module_id $other_modules {
    ns_ora dml $db "
      begin
      cms_permission.grant_permission (
          item_id      => :module_id,
          holder_id    => :user_id,
          privilege    => 'cm_write',
          recepient_id => :publisher,
          is_recursive => 't'
      );
      end;"
}

append html "<li>Granted cm_write to publisher on all other modules."

template::end_db_transaction


