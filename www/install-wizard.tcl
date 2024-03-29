# install-wizard.tcl
#
# A web interface for installing the CMS News Site Demo
# @author Michael Pih



# check if the news demo data model has been installed
#  by checking if the cr_demo_article, cr_demo_article_image, and cr_demo_link
#   content types exist

db_1row news_demo_content_types "
  select
    count(1) news_demo_content_types
  from
    acs_object_types
  where
    object_type in ('cr_demo_article','cr_demo_article_image', 'cr_demo_link')
"


if { $news_demo_content_types != 3 } {
    template::release_db_handle
    set data_model_p f
    return
} else {
    set data_model_p t
}




# check if a cm_admin user exists -- a user who has the 'cm_admin' privilege
#   on the CMS root folders and CMS modules

db_1row cm_admin "
  select
    distinct user_id cm_admin
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
"

if { [template::util::is_nil cm_admin] } {
    set cm_admin_p f
    return
} else {
    set cm_admin_p t
}





# if the data model has been installed and an admin user exists,
#   create buttons to go to the next step
form create install
element create install submit \
	-datatype text \
	-widget   submit \
	-label    "Continue >>"


if { [form is_valid install] } {

    template::forward install-wizard-2

}

