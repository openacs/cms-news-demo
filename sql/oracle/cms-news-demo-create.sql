-- Data model for the news site demo
-- Author: Simon Huynh (shuynh@arsdigita.com)
-- Author: Michael Pih (pihman@arsdigita.com)


begin

  /* Insert audio and video MIME types */
  dbms_output.put_line('Inserting audio and video MIME types...');

  insert into cr_mime_types (
    label, mime_type, file_extension
  ) values (
    'Wave Audio File','audio/x-wav','wav'
  );

  insert into cr_mime_types (
    label, mime_type, file_extension
  ) values (
    'Basic Audio File','audio/basic','au'
  );

  insert into cr_mime_types (
    label, mime_type, file_extension
  ) values (
    'Aiff Audio File','audio/aiff','aif'
  );

  insert into cr_mime_types (
    label, mime_type, file_extension
  ) values (
    'AVI Video','video/x-msvideo','avi'
  );

  insert into cr_mime_types (
    label, mime_type, file_extension
  ) values (
    'QuickTime Video','video/quicktime','qt'
  );

  insert into cr_mime_types (
    label, mime_type, file_extension
  ) values (
    'Mpeg Video','video/mpeg','mpg'
  );

  insert into cr_mime_types (
    label, mime_type, file_extension
  ) values (
    'ADP Text', 'text/adp', 'adp'
  );

  -- register text/adp mime type to templates
  content_type.register_mime_type(
      content_type => 'content_template',
      mime_type    => 'text/adp'
  );

end;
/
show errors


/* Data model for cr_demo_articles */

create table cr_demo_articles (
  cr_demo_article_id integer
		     constraint cr_demo_articles_id_fk
		     references cr_revisions
		     constraint cr_demo_articles_id_pk
		     primary key,
  location	     varchar(500),
  author	     varchar(500),
  type		     varchar(500)
);


declare 
  attr_id integer;
begin
  dbms_output.put_line('Creating cr_demo_article content type...');

  content_type.create_type (
      content_type  => 'cr_demo_article',
      supertype	    => 'content_revision',
      pretty_name   => 'Article',
      pretty_plural => 'Articles',
      table_name    => 'cr_demo_articles',
      id_column	    => 'cr_demo_article_id'
  );

  attr_id := content_type.create_attribute (
      content_type   => 'cr_demo_article',
      attribute_name => 'location',
      datatype       => 'text',
      pretty_name    => 'Location',
      pretty_plural  => 'Locations'
  );


  cm_form_widget.register_attribute_widget (
      content_type   => 'cr_demo_article',
      attribute_name => 'location',
      widget         => 'select',
      is_required    => 't'
  );

  cm_form_widget.set_attribute_param_value (
      content_type   => 'cr_demo_article',
      attribute_name => 'location',
      param          => 'options',
      value          => '{Berkeley Berkeley} {Boston Boston} {{Los Angeles} {Los Angeles}} {Munich Munich} {Tokyo Tokyo}',
      param_type     => 'onevalue',
      param_source   => 'literal'
  );

  attr_id := content_type.create_attribute (
      content_type   => 'cr_demo_article',
      attribute_name => 'author',
      datatype       => 'text',
      pretty_name    => 'Author',
      pretty_plural  => 'Authors'
  );

  cm_form_widget.register_attribute_widget(
      content_type   => 'cr_demo_article',
      attribute_name => 'author',
      widget         => 'text',
      is_required    => 't'
  );

  cm_form_widget.set_attribute_param_value (
      content_type   => 'cr_demo_article',
      attribute_name => 'author',
      param          => 'maxlength',
      param_type     => 'onevalue',
      param_source   => 'literal',
      value	     => '50'
  );

  attr_id := content_type.create_attribute (
      content_type   => 'cr_demo_article',
      attribute_name => 'type',
      datatype       => 'keyword',
      pretty_name    => 'Type',
      pretty_plural  => 'Types'
  );

  cm_form_widget.register_attribute_widget(
      content_type   => 'cr_demo_article',
      attribute_name => 'type',
      widget         => 'select',
      is_required    => 't'
  );

  cm_form_widget.set_attribute_param_value (
      content_type   => 'cr_demo_article',
      attribute_name => 'type',
      param          => 'options',
      value          => '{News news} {Sports sports} {Features features} {Editorial editorial} {Column column}',
      param_type     => 'onevalue',
      param_source   => 'literal'
  );

  content_type.register_mime_type(
      content_type => 'cr_demo_article',
      mime_type	 => 'text/plain'
  );

  content_type.register_mime_type(
      content_type => 'cr_demo_article',
      mime_type	 => 'text/html'
  );

  content_type.register_mime_type(
      content_type => 'cr_demo_article',
      mime_type	 => 'text/rtf'
  );

end;
/
show errors



/* Data model for cr_demo_article_images */

create table cr_demo_article_images (
  article_image_id integer
		   constraint cr_demo_article_images_id_fk
		   references images
		   constraint cr_demo_article_images_id_pk
		   primary key,
  caption	   varchar(4000)
);

declare 
  attr_id integer;
begin
  dbms_output.put_line('Creating cr_demo_article_image content type...');

  content_type.create_type (
      content_type  => 'cr_demo_article_image',
      supertype     => 'image',
      pretty_name   => 'Captioned Image',
      pretty_plural => 'Captioned Images',
      table_name    => 'cr_demo_article_images',
      id_column     => 'article_image_id'
  );

  attr_id := content_type.create_attribute (
      content_type   => 'cr_demo_article_image',
      attribute_name => 'caption',
      datatype       => 'text',
      pretty_name    => 'Caption',
      pretty_plural  => 'Captions'
  );

  cm_form_widget.register_attribute_widget(
      content_type   => 'cr_demo_article_image',
      attribute_name => 'caption',
      widget         => 'text',
      is_required    => 't'
  );

  content_type.register_mime_type(
      content_type => 'cr_demo_article_image',
      mime_type	   => 'image/jpeg'
  );

  content_type.register_mime_type(
      content_type => 'cr_demo_article_image',
      mime_type	   => 'image/gif'
  );

end;
/
show errors



/* Data model for cr_demo_links */

create table cr_demo_links (
  link_id    integer
	     constraint cr_demo_links_id_fk
	     references cr_revisions
	     constraint cr_demo_links_pk
	     primary key,
  type	     varchar(500),
  ref_tag    varchar(1000),
  caption    varchar(4000)
);

declare
  attr_id integer;
begin
  dbms_output.put_line('Creating cr_demo_links content type...');

  content_type.create_type (
      content_type   => 'cr_demo_link',
      supertype      => 'content_revision',
      pretty_name    => 'Multimedia Link',
      pretty_plural  => 'Multimedia Links',
      table_name     => 'cr_demo_links',
      id_column      => 'link_id'
  );

  attr_id := content_type.create_attribute (
      content_type   => 'cr_demo_link',
      attribute_name => 'type',
      datatype       => 'keyword',
      pretty_name    => 'Type',
      pretty_plural  => 'Types'
  );

  cm_form_widget.register_attribute_widget(
      content_type   => 'cr_demo_link',
      attribute_name => 'type',
      widget         => 'select',
      is_required    => 't'
  );

  cm_form_widget.set_attribute_param_value (
      content_type   => 'cr_demo_link',
      attribute_name => 'type',
      param          => 'options',
      value          => '{Audio audio} {Video video}',
      param_type     => 'onevalue',
      param_source   => 'literal'
  );

  attr_id := content_type.create_attribute (
      content_type   => 'cr_demo_link',
      attribute_name => 'caption',
      datatype       => 'text',
      pretty_name    => 'Caption',
      pretty_plural  => 'Captions'
  );

  cm_form_widget.register_attribute_widget(
      content_type   => 'cr_demo_link',
      attribute_name => 'caption',
      widget         => 'textarea',
      is_required    => 't'
  );

  content_type.register_mime_type(
      content_type => 'cr_demo_link',
      mime_type    => 'audio/x-wav'
  );

  content_type.register_mime_type(
      content_type => 'cr_demo_link',
      mime_type    => 'audio/aiff'
  );

  content_type.register_mime_type(
      content_type => 'cr_demo_link',
      mime_type    => 'audio/basic'
  );

  content_type.register_mime_type(
      content_type => 'cr_demo_link',
      mime_type    => 'video/x-msvideo'
  );

  content_type.register_mime_type(
      content_type => 'cr_demo_link',
      mime_type    => 'video/quicktime'
  );

  content_type.register_mime_type(
      content_type => 'cr_demo_link',
      mime_type    => 'video/mpeg'
  );

end;
/
show errors




/* Registering relationship types for cr_demo_article */

begin
  dbms_output.put_line('Registering relationship types to cr_demo_article...');


  content_type.register_child_type (
      parent_type  => 'cr_demo_article',
      child_type   => 'cr_demo_article_image',
      relation_tag => 'demo_article_image',
      min_n        => 0
  );

  content_type.register_child_type (
      parent_type  => 'cr_demo_article',
      child_type   => 'cr_demo_link',
      relation_tag => 'demo_article_mm_link',
      min_n        => 0
  );

end;
/
show errors
