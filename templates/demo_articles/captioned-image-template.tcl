content::get_content
template::util::array_to_vars content


if { ![template::util::is_nil width] && $width < 150 } {
    set width 150
}