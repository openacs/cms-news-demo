# install-wizard-2.tcl
#
# A web interface for installing the CMS News Site Demo
# Step 2: Create demo folders and templates
#
# @author Michael Pih



# check if the news demo folders have been created
#  by checking if the demo_articles folder exists under the
#  templates root and the sitemap root

set db [template::get_db_handle]

template::query demo_folders onevalue "
  select
    count(1)
  from
    cr_items
  where
    ( parent_id = content_item.get_root_folder
      or
      parent_id = content_template.get_root_folder )
  and
    name = 'demo_articles'
  and
    content_type = 'content_folder'
" -db $db

if { $demo_folders != 2 } {
    set demo_folders_p f
} else {
    set demo_folders_p t
}



# check if templates have been published by counting the number
#   of live templates in the /demo_articles folder under the
#   templates mount point

template::query published_templates onevalue "
  select
    count(1)
  from
    cr_items
  where
    publish_status = 'live'
  and
    live_revision is not null
  and
    content_type = 'content_template'
  and
    parent_id = ( select 
                    item_id
                  from
                    cr_items
                  where
                    parent_id = content_template.get_root_folder
                  and
                    name = 'demo_articles'
                  and
                    content_type = 'content_folder' )
" -db $db

if { $published_templates < 8 } {
    set published_templates_p f
} else {
    set published_templates_p t
}



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



# create the demo folders and templates
if { $demo_folders != 2 } {

    # create folders and templates
    
    set html ""
    
    set db [template::begin_db_transaction]

    # some root folders
    template::query sitemap onevalue "
      select content_item.get_root_folder from dual
    " -db $db

    template::query templates onevalue "
      select content_template.get_root_folder from dual
    " -db $db


    # create demo_articles folder
    ns_ora exec_plsql_bind $db "
      begin
      :folder_id := content_folder.new (
          name          => 'demo_articles',
          label         => 'Demo Articles',
          description   => 'Articles for publication',
          creation_user => :user_id,
          creation_ip   => :creation_ip,
          parent_id     => :sitemap
      );
      end;
    " folder_id

    append html "<li>Created /demo_articles folder under the sitemap."

    # register content types to demo_articles folder
    ns_ora dml $db "
      begin
      delete from cr_folder_type_map
        where folder_id = :folder_id;

      content_folder.register_content_type(
          folder_id    => :folder_id,
          content_type => 'cr_demo_article'
      );

      content_folder.register_content_type(
          folder_id    => :folder_id,
          content_type => 'content_revision'
      );
      end;"

    append html "<li>Registered content types to /demo_articles."

    # create article index
    ns_ora exec_plsql_bind $db "
      begin
      :item_id := content_item.new (
          name          => 'index',
          parent_id     => :folder_id,
          content_type  => 'content_revision',
          title         => 'Article Index',
          text          => 'All curent articles',
          is_live       => 't',
          creation_user => :user_id,
          creation_ip   => :creation_ip
      );
      end;
    " item_id

    append html "<li>Created /demo_articles/index content item."

    # create demo templates folder and templates
    ns_ora exec_plsql_bind $db "
      begin
      :folder_id := content_folder.new (
          name          => 'demo_articles',
          label         => 'Demo Article Templates',
          description   => 'Templates for demo articles and links',
          creation_user => :user_id,
          creation_ip   => :creation_ip,
          parent_id     => :templates
      );
      end;
    " folder_id

    append html "<li>Created /demo_articles folder under the templates mount point."

    # register content type to the folder
    ns_ora dml $db "
      begin
      content_folder.register_content_type (
          folder_id    => :folder_id,
          content_type => 'content_template'
      );
      end;"

    append html "<li>Registered templates to the /demo_articles folder."

    # create index template
    ns_ora exec_plsql_bind $db "
      begin
      :template_id := content_template.new (
          name          => 'index',
          parent_id     => :folder_id,
          creation_user => :user_id,
          creation_ip   => :creation_ip
      );
      end;
    " template_id

    # make the index template an adp file
    ns_ora dml $db "
      update cr_revisions
        set mime_type = 'text/adp'
        where item_id = :template_id"

    append html "<li>Created /demo_articles/index template for articles index page."

    # register template index template to content_revision and index page
    ns_ora dml $db "
      begin
      content_type.register_template (
          content_type => 'content_revision',
          template_id  => :template_id,
          use_context  => 'public',
          is_default   => 'f'
      );

      content_item.register_template (
          item_id     => :item_id,
          template_id => :template_id,
          use_context => 'public'
      );
      end;"

    append html "<li>Registered the index page template to /demo_articles/index."


    # create more templates
    ns_ora exec_plsql_bind $db "
      begin
      :template_id := content_template.new (
          name          => 'master-1',
          parent_id     => :folder_id,
          creation_user => :user_id,
          creation_ip   => :creation_ip
      );
      end;
    " template_id

    append html "<li>Created /demo_articles/master-1 master template."

    ns_ora exec_plsql_bind $db "
      begin
      :template_id := content_template.new (
          name          => 'article-template-1',
          parent_id     => :folder_id,
          creation_user => :user_id,
          creation_ip   => :creation_ip
      );
      end;
    " template_id

    append html "<li>Created /demo_articles/article-template-1 article template."

    # register template to articles
    ns_ora dml $db "
      begin
      content_type.register_template (
          content_type => 'cr_demo_article',
          template_id  => :template_id,
          use_context  => 'public',
          is_default   => 't'
      );
      end;"

    append html "<li>Registered the article template as the default for articles."

    # more article templates
    ns_ora exec_plsql_bind $db "
      begin
      :template_id := content_template.new (
          name          => 'master-2',
          parent_id     => :folder_id,
          creation_user => :user_id,
          creation_ip   => :creation_ip
      );
      end;
    " template_id

    append html "<li>Createed /demo_articles/master-2 master template."

    ns_ora exec_plsql_bind $db "
      begin
      :template_id := content_template.new (
          name          => 'article-template-2',
          parent_id     => :folder_id,
          creation_user => :user_id,
          creation_ip   => :creation_ip
      );
      end;
    " template_id

    append html "<li>Created /demo_articles/article-template-2 article template."

    ns_ora dml $db "
      begin
      content_type.register_template (
          content_type => 'cr_demo_article',
          template_id  => :template_id,
          use_context  => 'public',
          is_default   => 'f'
      );
      end;"

    append html "<li>Registered the 2nd article template to articles."

    # article list template
    ns_ora exec_plsql_bind $db "
      begin
      :template_id := content_template.new (
          name          => 'article-list',
          parent_id     => :folder_id,
          creation_user => :user_id,
          creation_ip   => :creation_ip
      );
      end;
    " template_id

    append html "<li>Created /demo_articles/article-list template for listing articles."

    # multimedia link template
    ns_ora exec_plsql_bind $db "
      begin
      :template_id := content_template.new (
          name          => 'article-link-template',
          parent_id     => :folder_id,
          creation_user => :user_id,
          creation_ip   => :creation_ip
      );
      end;
    " template_id

    append html "<li>Created /demo_articles/article-link-template."


    ns_ora dml $db "
      begin
      content_type.register_template (
          content_type => 'cr_demo_link',
          template_id  => :template_id,
          use_context  => 'public',
          is_default   => 't'
      );
      end;"

    append html "<li>Registered /demo_articles/article-link-template 
    to the cr_demo_link content type."

    # captioned image template
    ns_ora exec_plsql_bind $db "
      begin
      :template_id := content_template.new (
          name          => 'captioned-image-template',
          parent_id     => :folder_id,
          creation_user => :user_id,
          creation_ip   => :creation_ip
      );
      end;
    " template_id

    append html "<li>Created /demo_articles/captioned-image-template."

    ns_ora dml $db "
      begin
      content_type.register_template (
          content_type => 'cr_demo_article_image',
          template_id  => :template_id,
          use_context  => 'public',
          is_default   => 't'
      );
      end;"

    append html "<li>Registered /demo_articles/captioned-image-template 
      to the cr_demo_article_image content type."

    # master template
    ns_ora exec_plsql_bind $db "
      begin
      :template_id := content_template.new (
          name          => 'master',
          parent_id     => :templates,
          creation_user => :user_id,
          creation_ip   => :creation_ip
      );
      end;
    " template_id

    append html "<li>Created /master, the demo master template."

    template::end_db_transaction
}



set published_templates 0


# publish templates to the file system

set html2 ""

if { $published_templates < 8 } {

    # the phyiscal (destination) location where the templates will be published
    set template_root [content::get_template_root]

    # the physical location where the cms-news-demo package resides
    set package_key  [apm_package_key_from_id [ad_conn package_id]]
    set package_root [acs_package_root_dir $package_key]

    set demo_templates_list { 
	/master 
	/demo_articles/captioned-image-template 
	/demo_articles/index 
	/demo_articles/article-list 
	/demo_articles/article-link-template
	/demo_articles/master-1
	/demo_articles/master-2 
	/demo_articles/article-template-1 
	/demo_articles/article-template-2
    }

    # upload and publish each template

    foreach template $demo_templates_list {

	set revision_id  [content::get_object_id]
	set tmpfile "$package_root/templates$template.adp"
	
	set db [template::begin_db_transaction]

	template::query template_id onevalue "
	  select 
            content_item.get_id( :template, content_template.get_root_folder )
	  from 
            dual
	" -db $db
    
	# upload the template

	# this is safe because none of the templates exceeds the max size
	set adp_text [template::util::read_file $tmpfile]

	template::query index_template onevalue "
	  select
	    item_id
	  from
	    cr_items
          where
	    item_id = content_item.get_id( '/demo_articles/index', 
	      content_template.get_root_folder )
	" -db $db

	if { $template_id == $index_template } {
	    set mime_type "text/adp"
	} else {
	    set mime_type "text/html"
	}

	ns_ora exec_plsql_bind $db "
	  begin
          :revision_id := content_revision.new (
              revision_id   => :revision_id,
              item_id       => :template_id,
              title         => 'News Demo Template',
              mime_type     => :mime_type,
              text          => :adp_text,
              creation_user => :user_id,
              creation_ip   => :creation_ip
          );
          end;
	" revision_id

	ns_ora dml $db "
	  update cr_items 
            set live_revision = :revision_id,
            publish_status = 'live'
            where item_id = :template_id"

	template::end_db_transaction

	# publish the template to the file system and set the live revision
	set text [content::get_content_value $revision_id]
	set path "$template_root$template"
	
	util::write_file $path.adp $text
	
	append html2 "<li>Published $path.adp."
    }

    ##############################
    # copy the datasources (tcl files) to the template root

    set datasource_list {
	/master
	/demo_articles/captioned-image-template
	/demo_articles/article-link-template
	/demo_articles/article-list
	/demo_articles/article-template-1
	/demo_articles/article-template-2
	/demo_articles/master-1
	/demo_articles/master-2
	/demo_articles/index
    }

    foreach datasource $datasource_list {
	set tmpfile "$package_root/templates$datasource.tcl"
	set tcl_text [template::util::read_file $tmpfile]
	set path "$template_root$datasource"
	util::write_file $path.tcl $tcl_text
	append html2 "<li>Wrote $path.tcl.<br>"
    }


    # copy the index.tcl datasource to the publish root(s)
    set tmpfile "$package_root/templates/demo_articles/index.tcl"
    set tcl_text [template::util::read_file $tmpfile]

    publish::write_multiple_files "/demo_articles/index.tcl" $tcl_text
    append html2 "<li>Copied $path.tcl.<br>"

    # publish the index item
    template::query revision_id onevalue "
      select
        live_revision
      from
        cr_items
      where
        item_id = content_item.get_id('/demo_articles/index')"

    publish::publish_revision $revision_id
    append html2 "<li>Published /demo_articles/index.<br>"

}








# create buttons to go to the next step
form create install
element create install submit \
	-datatype text \
	-widget   submit \
	-label    "Continue >>"

if { [form is_valid install] } {

    template::forward install-wizard-3

}

