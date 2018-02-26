clear all; clc;
%% location of the data: filename and group
fileName = 'g2f_2014_zeagbsv27.raw.h5';
location = '/Genotypes';
%% extract data by linename
info = h5info(fileName, location);
lines = numel(info.Groups) - 1;
cells = struct2cell(info.Groups);
names = cells(1, :);
cols = numel(h5read(fileName, strcat(names{lines}, '/calls')));
% some names appear to be stored in another cell if they are too long
for i = 1:lines
    if (~isempty(cells{2, i}))
        names{i} = cells{2, i}.Name;
    end
end
data = zeros(lines, cols);
for idx = 1:lines
    data(idx, :) = (h5read(fileName, strcat(names{idx}, '/calls')))';
end
%% N = -1, A = 0, T = 51, C = 17, G = 34
intersections = zeros(1, cols);
for i = 1:cols
    for j = 1:lines
        if (data(j, i) ~= -1) 
            intersections(i) = intersections(i) + 1;
        end
    end
end
%% the set of genomic positions having two or more SNPs (“intersecting SNPs”)
sites = find(intersections ~= 0);
%% the names of the lines and their non-N variants at each position 
%% print intersections, file size > 1G
% fileID = fopen('intersections.txt','w');
% for i = 1:cols
%     fprintf(fileID,'%d\r',i);
%     for j = 1:lines
%         if (data(j, i) ~= -1) 
%             fprintf(fileID,'%s\r',erase(names{j}, strcat(location, '/')));
%         end
%     end
%     fprintf(fileID,'\n');
% end
% fclose(fileID);
%% the number of lines at each intersecting SNP and their distribution of intersecting SNP positions across the genome 
bar(intersections(1:10000)');
title('Number of intersections at each location');
ylabel('Number of intersections');
xlabel('Coordinate');
set(gcf,'color','white');
set(gca,'FontSize',14);
