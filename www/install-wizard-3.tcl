# install-wizard-3.tcl
#
# A web interface for installing the CMS News Site Demo
# Step 3: Register Demo Users
#
# @author Michael Pih



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


# check if author, editor, and publisher users have been created
template::query demo_users onevalue "
  select
    count(1)
  from
    users
  where
    screen_name in ('author','editor','publisher')
" -db $db

if { $demo_users < 3 } {
    set demo_users_p f
} else {
    set demo_users_p t
}


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






# register demo users if not already registered: 
#   author, editor, publisher

set html ""

if { $demo_users < 3 } {

    set db [template::begin_db_transaction]

    set demo_user_list \
	    { {Author author} {Editor editor} {Publisher publisher} }

    foreach demo_user $demo_user_list {
	set name        [lindex $demo_user 0]
	set screen_name [lindex $demo_user 1]
	
	# check if the user exists already
	template::query user_exists_p onevalue "
	  select
            count(1)
          from
            users
	  where
            screen_name = :screen_name
	" -db $db

	# if the user doesn't exists, create the user
	if { $user_exists_p == 0 } {

	    append html "<li>Creating $name... "

	    set password $screen_name
	    set email "${screen_name}@host.com"
	    
	    set user_id [ad_user_new $email $name $name $password "" ""]

	    ns_ora dml $db "
	    update users
              set screen_name = :screen_name
              where user_id = :user_id"

	    append html "created.<br>"

	} else {
	    append html "<li>$name already exists.<br>"
	}
    }

    template::end_db_transaction
}



# create buttons to go to the next step
form create install
element create install submit \
	-datatype text \
	-widget   submit \
	-label    "Continue >>"

if { [form is_valid install] } {

    template::forward install-wizard-4

}