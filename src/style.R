nb_theme <- ggplot2::theme_light() +
  mdthemes::as_md_theme(
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5),
                   plot.caption = ggplot2::element_text(hjust = 0.5),
                   plot.subtitle = ggplot2::element_text(hjust = 0.5)))