%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Debeloped by Luis Miranda Santafe. Master Thesis. January-May 2017      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function will create a folder in the same directory where the
% function is running to store the results. The folder will be called as
% the current date. If the folder is already created it will do nothing (so
% you don't delete all the results already stored in there)
function folder = createDirectoryForResults()


m = month(datetime('today'));
today = date;

todaySplited = strsplit(today,'-');

folder = strcat(int2str(m),'-',todaySplited{1},'-',todaySplited{3});

if (7 ~= exist(folder,'dir'))
    mkdir(folder)
end