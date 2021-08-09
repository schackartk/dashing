# Code Structure

![Directed Acyclic Graph of Snakemake Pipeline](snakemake_dag.svg)

Here is a tree of the code used in this project. Tests are located in `tests/` at the root of this repository

```
src/              
    ├── clean_locations.R       # Clean Takeout data and filter by dash time
    ├── config.R                # File with paths to data, etc.
    ├── dash_dashboard.Rmd      # Flex dashboard
    ├── dash_heatmap.py         # Python script to make heatmap.html
    ├── graph_tweaking.Rmd      # Playing with new plots for dashboard
    ├── helpers.R               # Small functions for dashboard
    ├── location_tweaking.Rmd   # Trying to incoporate Takeout location data to dashboard
    ├── Snakefile               # Snakemake pipeline
    └── style.R                 # Theme for dashboard 

```
