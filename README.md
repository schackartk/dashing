This repository contains analyses of data obtained as a Dasher. It is also available on GitHib.io [here](https://schackartk.github.io/dashing/).

## [Dashboard](https://schackartk.github.io/dashing/pages/dashboard.html)

This dashboard is a [flexdashboard](https://pkgs.rstudio.com/flexdashboard/) made using R. Unfortunately, Doordash does not provide an API for fetching Dasher data. So, I got the data from the Dasher app, and recorded it by hand in an excel spreadsheet.

## [Location Heatmap](https://schackartk.github.io/dashing/pages/heatmap.html)

This heatmap was created in Python using the [folium](http://python-visualization.github.io/folium/) package. Location data is recorded from my smartphone using Google location tracking in Maps. Data are downloaded from [Google Takeout](https://takeout.google.com/). Preprocessing of location data is done in R, with the help of a small custom R package I created for this purpose called [takeout](https://github.com/schackartk/takeout). The data shown in the heatmap are locations that were logged only during dashes.

## [Animated Dashes](https://schackartk.github.io/dashing/pages/animation.html)

This animation is was made using [gganimate](https://gganimate.com/) with the same location data as described above. All dashes are aligned by time of day, so you can see where I was during each dash given the time of day.

## About this Project

### Reproducibility

Sadly, much of this project is not easily reusable for others. The most annoying part is having to record the data manually to an excel workbook. I have provided a README.md in `data/` that explains how the data are organized. By following this template, you may be able to get the code to work for you.

Additionally, I have not gone through great efforts in this project to remove hard-coded paths, etc. I intended it originally for myself, but wanted to share my code along with the results anyway. If you are viewing this as Github Pages, the original repository can be found on [Github](https://github.com/schackartk/dashing/)

### Authorship

This project was developed by Kenneth Schackart (schackartk1@gmail.com).
