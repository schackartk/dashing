header_blue <- "#62d0f5"
sub_blue <- "#9fe4f5"
header_green <- "#62f576"
sub_green <- "#9ff5ab"
header_red <- "#f56262"
sub_red <- "#f59f9f"

nb_theme <- ggplot2::theme_light() +
  mdthemes::as_md_theme(
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5),
                   plot.caption = ggplot2::element_text(hjust = 0.5),
                   plot.subtitle = ggplot2::element_text(hjust = 0.5)))