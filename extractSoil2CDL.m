function [result] = extractSoil2CDL(cdlfile,soilfile)
%cdlfile  = 'g:/data/cdl/CDL_2008_19.tif'; 
%soilfile = strcat('e:/soil/','MapunitRaster_IA.tif'); 
[cdl,~,~,ext1] = geotiffread(cdlfile);
% ext1 
ncols = size(cdl,2); 
nrows = size(cdl,1); 

% read soil tif
[soil,~,~,soilext] = geotiffread(soilfile); 

% col pos and row pos
numcells = size(cdl,1) * size(cdl,2); 
cellpos = int32(zeros(numcells,4));
% xpos ypos
cellpos(:,1) = ext1(1,1) -15 + 30*repmat([1:ncols]',[nrows 1]); % cols: longitude values 
cellpos(:,2) = ext1(1,2) -15 + 30*ceil([1:numcells]'/ncols); % rows: latitude 
cellpos(:,3) = (ceil((cellpos(:,1) - soilext(1,1))/10)); % cols
cellpos(:,4) = (ceil((soilext(2,2) - cellpos(:,2))/10)); % rows 

% designate cdl cells covered in soil map or not 
min_soil_row = 1;
min_soil_col = 1; 
max_soil_row = size(soil,1); 
max_soil_col = size(soil,2); 
cellpos(cellpos(:,3)< min_soil_col,3:4) = 0; 
cellpos(cellpos(:,4)< min_soil_row,3:4) = 0;
cellpos(cellpos(:,3)> max_soil_col,3:4) = 0; 
cellpos(cellpos(:,4)> max_soil_row,3:4) = 0;

cellidx = sub2ind(size(soil),cellpos(cellpos(:,3)>0,4),cellpos(cellpos(:,3)>0,3));
result  = int32(-9*ones(numcells,1));
result(cellpos(:,3)>0) = soil(cellidx); 
end 

