Wrap text data in a portable shell script allowing easy (re)-analysis

- Well suited to tabular or relational data with multiple categories.
- An easy way to share both data and analysis (Reproducible Research).
- Easier than continually re-learning how to do simple analytic tasks.
- Very portable, written entire in bash with two optional dependencies.
  1. R for statistical analysis
  2. gnuplot for graphical display of data

Usage:

1. Run the data-wrapper on your file of tab-separated data passing in
   names for each column of the data.

     data-wrapper DATAFILE [COLUMNS]

2. This will result in the creation of an executable file named
   DATAFILE-viewer.  This file holds all of your data wrapped in a
   bash script which provides numerous views into the data.  For more
   information pass "-h" to this resulting script.
