# procs to publish audio and video mime types


namespace eval cms_news {}

# Util procedure to fetch the URL of the cms-news-demo package static page root
proc cms_news::get_static_content_root {} {
    set package_id [apm_package_id_from_key "cms-news-demo"]
    set static_root [ad_parameter -package_id $package_id StaticPageRoot \
	    "cms-news-demo" ""]
    return $static_root
}


set package_id [apm_package_id_from_key "cms-news-demo"]
set static_root [ad_parameter -package_id $package_id StaticPageRoot \
	"cms-news-demo" ""]



namespace eval publish {
    variable item_id_stack
    variable main_item_id
    variable main_revision_id
    
    variable revision_html


    namespace eval handle {}
}


# Publish the audio file to the filesystem and create an <a href> tag
proc publish::handle::audio { item_id args } {

  template::util::get_opts $args

  if { [template::util::is_nil opts(revision_id)] } {
    set revision_id [item::get_live_revision $item_id]
  } else {
    set revision_id $opts(revision_id)
  }
  
  # If the embed tag is true, return the html. Otherwise,
  # just write the file to the filesystem
  if { [info exists opts(embed)] } {

    set file_url [publish::write_content $revision_id \
       -item_id $item_id -get_url]

    # If write_content aborted, give up
    if { [template::util::is_nil file_url] } {
      return ""
    }

    # Try to use the registered template for the file
    if { ![info exists opts(no_merge)] } {
      set code "publish::merge_with_template $item_id $args"
      set html [eval $code]
      if { ![template::util::is_nil html] } {
        return $html
      }
    }

    # Merging failed, output a straight <img> tag

    template::query audio_info onerow "
      select caption, type from cr_demo_links where link_id = :revision_id
    " -cache "audio_info $revision_id"
  
    template::util::array_to_vars audio_info

    # Concatenate all the extra html arguments into a string
    if { [info exists opts(html)] } {
     set extra_html [publish::html_args $opts(html)]
    } else {
     set extra_html ""
    }


    if { ![template::util::is_nil type] \
	    && ![template::util::is_nil caption] } {

	switch -exact -- $type {
	    audio { 
		set link "<img src=\"/cms-demo/static/audio.gif\" border=0 alt=\"Listen\">"
	    }
	    video {
		set link "<img src=\"/cms-demo/static/video.gif\" border=0 alt=\"Watch\">"
	    }
	    default {
		set link ""
	    }
	}

	set html "<a href=\"$file_url\">$link</a> 
	          <a href=\"$file_url\">$caption</a>"
    }

    append html $extra_html
    return $html
  } else {
    ns_log Warning \
      "publish::handle_audio: No embed specified for audio, aborting"
    return ""
  }

}



# Publish the video file to the filesystem and create an <a href> tag
proc publish::handle::video { item_id args } {
    return [eval publish::handle::audio $item_id $args]
}
