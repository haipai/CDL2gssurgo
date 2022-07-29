# CDL2gssurgo
Match each CDL raster cell to one gssurgo cell

# Introduction 
This repository includes R and Matlab scripts to match each state CDL raster cell to one raster cell in state gssurgo. 
CDL: http://nassgeodata.gmu.edu/CropScape/
gSSURGO: https://www.nrcs.usda.gov/wps/portal/nrcs/detail/soils/survey/geo/?cid=nrcs142p2_053628


# Methodology 
CDL, gSSURGO are all in raster format, essentially a huge 2-dimension matrix with column and row index as spatial units, like degrees, meters. The idea to overlap soil information from gSSURGO to CDL is to assign mapkey information which is used in gSSURGO database to link all kind of soil attributes. The quick method I used here is to use MATLAB builtin matrix index function of sub2ind(matrix size, row number vector, column number vector).  See details in the link https://www.mathworks.com/help/matlab/ref/sub2ind.html for the function. 

For example, each CDL cell will have a pair of information about the cell's latitude and longtitude information, let use degree as the unit say (lata,lona). CDL would tell you the crop information at this cell, say corn in 2020. And you want to know what is the soil information at this point. For gSSURGO map, it is also a raster file and a huge matrix actually. The (lata, lona) information can help you to figure out the exact cell in the huge soil matrix, say (rowA,colB). Then you can find out the mapkey value at the CDL cell. For tens of millions these row and column pairs, I found out the index based retrieving is a little bit faster.

For CDL, the spatial resolution and extent is not consistent cross years. For example, the spatial resolution is 56 meter, while in other years, the resolution is 30 meter. If you want to summarize the crop rotation pattern at each CDL cell, it is best to resample 56 meter CDL to 30 meter CDL as other years. If you want to match soil information to each year's CDL, no such resampling procedure is needed. 

Here, I just include one R script to download CDL date set, and one Matlab script to match soil mapkey to 2020 Iowa CDL. The downloaded state gSSURGO database is an ArcGIS geodatabase, to be used directly by MATLAB, the raster feature needs to be exported as a geo-tiff data file. With matched mapkey, you can futher connect mapkey with a set of soil attributes for your analysis. 


# Scripts 

Download_CDL.r: download state CDL 
extractSoil2CDL.m: match mapkey to each CDL cell. the result is a vector with the length of num of rows in CDL times num of cols in CDL. If the CDL is located outside of the extent of soil area, the value is set to -9. The size of the result is in the range of several hundred MB to several GB depending on the size of the state. The projection of both CDL and gSSURGO needs to be the same projection system, if the projection system is different, re-project one of them to align the coordinates. Apparently, the projection is the same for current versions of CDL and gSSURGO raster files. 



