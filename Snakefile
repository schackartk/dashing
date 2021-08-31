rule all:
    input:
        "src/dash_dashboard.html"

rule wrangle_dashes:
    input:
        "data/raw_data.xlsx"
    output:
        "data/wrangled_data.Rdata"
    shell:
        "Rscript --vanilla src/dash_wrangling.R"

rule wrangle_locations:
    input:
        "data/wrangled_data.Rdata",
        "data/Takeout/Location History/Location History.json"
    output:
        "data/dash_locations.csv"
    shell:
        "Rscript --vanilla src/clean_locations.R"

rule heatmap:
    input:
        "data/dash_locations.csv"
    output:
        "src/heatmap.html"
    shell:
        "python3 src/dash_heatmap.py -o {output} {input}"
        
rule animation:
    input:
        "data/dash_locations.csv"
    output:
        "src/animation.gif"
    shell:
        "Rscript --vanilla src/animated_map.R"

rule dashboard:
    input:
        "data/wrangled_data.Rdata",
        "src/heatmap.html"
        "src/animation.gif"
    output:
        "src/dash_dashboard.html"
    shell:
        "Rscript -e \"rmarkdown::render('src/dash_dashboard.Rmd')\""
