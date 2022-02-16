Readme.txt
==========

Creation Date: 01/02/2016
Revision Date: 13/08/2018

ZIP PACKAGE
------------

This zip package contains:

- An ArcGIS GRID Raster for Major Vegetation Subgroups - Australia wide - EXTANT (The Value Attribute Table includes the following attributes: VALUE (MVS Number), MVS_NAME, and SORT_ORDER). See metadata for details.
- Relevant layer files for this raster


NVIS 5.1 MVS RASTER SYMBOLOGY
-----------------------------

This GRID Raster has an applied colormap based on the standard NVIS MVS legend colour scheme. However, this colormap provides only MVS Number values when displaying the Symbology in ArcGIS.

To enable full MVS Descriptions to appear in the legend (sorted by NAME or NUMBER), the included layer files will need to be imported via ArcGIS Symbology and the relevant field (see below) chosen from the list of attributes.

- mvs5_1e_by_name.lyr (use VALUE)
- mvs5_1e_by_number.lyr (use VALUE)
