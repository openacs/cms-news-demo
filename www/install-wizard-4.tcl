# install-wizard-3.tcl
#
# A web interface for installing the CMS News Site Demo
# Step 4: Grant permissions to demo users
#
# @author Michael Pih

set html ""

# get the user id of a cm_admin
set cm_admin [db_string cm_admin "
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
" -default ""]

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

db_transaction {

# some root folders
db_1row sitemap "
  select content_item.get_root_folder as sitemap from dual
"

db_1row templates "
  select content_template.get_root_folder as templates from dual
"

# some user ID's
db_1row author "
  select user_id as author from users where screen_name = 'author'
"

db_1row editor "
  select user_id as editor from users where screen_name = 'editor'
"

db_1row publisher "
  select user_id as publisher from users where screen_name = 'publisher'
"

# some folder/module ID's
db_1row demo_articles "
  select content_item.get_id( '/demo_articles' ) as demo_articles from dual
"

set other_modules [db_list other_modules "
  select module_id from cm_modules where key ^= 'sitemap'
"]

# grant permissions
db_dml grant_perms "
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
    db_dml grant1 "
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
    db_dml grant2 "
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
    db_dml grant3 "
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

}

