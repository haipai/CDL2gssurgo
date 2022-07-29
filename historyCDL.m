function [result] = historyCDL(basecdl,cdlfiles)
%% use Iowa as example
basecdl  = 'g:/data/cdl/CDL_2008_19.tif'; 
cdlfiles  = [{'g:/data/cdl/CDL_2001_19.tif'},{'g:/data/cdl/CDL_2002_19.tif'}, ... 
             {'g:/data/cdl/CDL_2003_19.tif'},{'g:/data/cdl/CDL_2004_19.tif'}, ... 
             {'g:/data/cdl/CDL_2005_19.tif'},{'g:/data/cdl/CDL_2006_19.tif'}, ... 
             {'g:/data/cdl/CDL_2007_19.tif'},{'g:/data/cdl/CDL_2008_19.tif'}, ... 
             {'g:/data/cdl/CDL_2009_19.tif'},{'g:/data/cdl/CDL_2010_19.tif'}, ... 
             {'g:/data/cdl/CDL_2011_19.tif'},{'g:/data/cdl/CDL_2012_19.tif'}, ... 
             {'g:/data/cdl/CDL_2013_19.tif'},{'g:/data/cdl/CDL_2014_19.tif'}, ... 
             {'g:/data/cdl/CDL_2015_19.tif'},{'g:/data/cdl/CDL_2016_19.tif'}, ... 
             {'g:/data/cdl/CDL_2017_19.tif'},{'g:/data/cdl/CDL_2018_19.tif'}, ... 
             {'g:/data/cdl/CDL_2019_19.tif'},{'g:/data/cdl/CDL_2020_19.tif'}, ... 
              ]; 
          
[cdl,~,~,ext1] = geotiffread(basecdl);
cellsize       = (ext1(2,1) - ext1(1,1))/size(cdl,2);  
% ext1 
ncols = size(cdl,2); 
nrows = size(cdl,1); 
numcells = ncols * nrows; 

result = uint8(zeros(numcells,length(cdlfiles))); 

for i = 1:length(cdlfiles) 
    fprintf('working on %s',char(cdlfiles(i)));
    
    [cdli,~,~,exti] = geotiffread(char(cdlfiles(i)));  
    cellsizei       = (exti(2,1) - exti(1,1))/size(cdli,2); 
    % col pos and row pos
    cellpos = int32(zeros(numcells,4));
    % xpos ypos
    cellpos(:,1) = ext1(1,1) -cellsize/2 + 30*repmat([1:ncols]',[nrows 1]); % cols: longitude values 
    cellpos(:,2) = ext1(1,2) -cellsize/2 + 30*ceil([1:numcells]'/ncols); % rows: latitude 
    cellpos(:,3) = (ceil((cellpos(:,1) - exti(1,1))/cellsizei)); % cols
    cellpos(:,4) = (ceil((exti(2,2) - cellpos(:,2))/cellsizei)); % rows 

    % designate cdl cells covered in soil map or not
    min_row = 1;
    min_col = 1;
    max_row = size(cdli,1);
    max_col = size(cdli,2);
    cellpos(cellpos(:,3)< min_col,3:4) = 0;
    cellpos(cellpos(:,4)< min_row,3:4) = 0;
    cellpos(cellpos(:,3)> max_col,3:4) = 0;
    cellpos(cellpos(:,4)> max_row,3:4) = 0;
    
    cellidx = sub2ind(size(cdli),cellpos(cellpos(:,3)>0,4),cellpos(cellpos(:,3)>0,3));
    result(cellpos(:,3)>0,i) = cdli(cellidx);
    fprintf(' .... done\n'); 
end

end 
