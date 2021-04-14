header_blue <- "#62d0f5"
sub_blue <- "#9fe4f5"
header_green <- "#62f576"
sub_green <- "#9ff5ab"
header_red <- "#f56262"
sub_red <- "#f59f9f"

nb_theme <- theme_light() +
  as_md_theme(theme(
    plot.title = element_text(hjust = 0.5),
    plot.caption = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)))