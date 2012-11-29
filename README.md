Data Wrapper
------------

Wrap text data in a portable shell script allowing easy (re)-analysis.

- Well suited to tabular or relational data with multiple categories.
- An easy way to share both data and analysis (Reproducible Research).
- Easier than continually re-learning how to do simple analytic tasks.
- Very portable, written entire in bash with two optional dependencies.
  1. `R` for statistical analysis
  2. `gnuplot` for graphical display of data

Installation
------------

Download the script using this link
"[data-wrapper](https://raw.github.com/eschulte/data-wrapper/master/data-wrapper))"
and place it in your PATH.

Usage
-----

1. Run `data-wrapper` on your file of tab-separated data passing in a
   name for each column.

        data-wrapper DATAFILE [COLUMN NAMES]

2. This will result in the creation of an executable file named
   `DATAFILE-viewer`.  This file holds all of your data wrapped in a
   script which provides numerous views into the data.  For more
   information on usage and available outputs and analysis call
   `DATAFILE-viewer -h`.

