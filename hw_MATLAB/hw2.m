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
    data(idx, :) = (h5read(fileName, strcat(names{idx}, '/calls')));
end
% N = -1, A = 0, T = 51, C = 17, G = 34, R = 2/32, Y = 19/49, S = 33/18, W = 3/48,  
% K = 35/50,  M = 16/1, 0 = 53/37/21/80/81/82/83, + -
map = containers.Map([-1, 0, 51, 17, 34, 2, 19, 33, 3, 35, 16, 53, 85, 5, 49, 32, 18, 37, 50, 21, 1, 48, 80, 81, 82, 83],...
{'N' 'A' 'T' 'C' 'G' 'R' 'Y' 'S' 'W' 'K' 'M' '0' '-', '0', 'Y', 'R', 'S', '0', 'K', '0', 'M', 'W', '0', '0', '0', '0'});
% for i = 5:lines
%     for j = 1:cols
%         if (~isKey(map, data(i, j))) 
%             i
%             j
%         end
%     end
% end

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
nonNlocus = zeros(lines, cols);
count = 1;
for i = 1:lines
    count = 1;
    for j = 1:cols
        if (data(i, j) ~= -1) 
            nonNlocus(i, count) = j;
            count = count + 1;
        end
    end
end
% print the nonNlocus
fileID = fopen('intersections.txt','w');
for i = 1:lines
    fprintf(fileID,'%s:\r',erase(names{i}, strcat(location, '/')));
    for j = 1:cols
        if (nonNlocus(i, j) ~= 0) 
            fprintf(fileID,'%d ',nonNlocus(i, j));
            %fprintf(fileID,'(%s)\r',map(data(i, nonNlocus(i, j))));
            %fprintf(fileID,'\r');
        else
            break;
        end
    end
    fprintf(fileID,'\n');
end
fclose(fileID);
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
