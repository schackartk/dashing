#!/usr/bin/env python3
"""
Author : Kenneth Schackart <schackartk1@gmail.com>
Date   : 2021-07-26
Purpose: Create heatmap from dashing data
"""

import argparse
import csv
import folium
import pandas as pd
from folium.plugins import HeatMap
from typing import NamedTuple, TextIO


class Args(NamedTuple):
    """ Command-line arguments """
    file: TextIO
    out: str



# --------------------------------------------------
def get_args() -> Args:
    """ Get command-line arguments """

    parser = argparse.ArgumentParser(
        description='Create a heatmap based on dashing location',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('file',
                        help='File containing locations in .csv',
                        metavar='FILE',
                        type=argparse.FileType('rt'),
                        default=None)

    parser.add_argument('-o',
                        '--out',
                        help='Output file name',
                        metavar='STR',
                        default='heatmap.html')

    args = parser.parse_args()

    return Args(args.file, args.out)


# --------------------------------------------------
def main() -> None:
    """ Make a jazz noise here """

    args = get_args()
    fh = args.file
    out_file = args.out

    locations = pd.read_csv(fh)

    locations['latitude'] = locations['latitude'].astype(float)
    locations['longitude'] = locations['longitude'].astype(float)

    heat_data = [[row['latitude'], row['longitude']] for _, row in locations.iterrows()]

    m = folium.Map(zoom_start = 10.5,
                   width = '100%',
                   height = '100%',
                   location = (locations['latitude'].mean(), locations['longitude'].mean()))

    HeatMap(data = heat_data, radius = 7, blur = 4, min_opacity = 0.2).add_to(m)

    m.save(out_file)


# --------------------------------------------------
if __name__ == '__main__':
    main()
