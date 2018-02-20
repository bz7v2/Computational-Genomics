clear all; clc;
%% location of the data: filename and group
fileName = 'e1.h5';
location = '/Genotypes';
%% extract data by linename
info = h5info(fileName, location);
lines = numel(info.Groups) - 1;
cells = struct2cell(info.Groups);
names = cells(1, :);
positions = numel(h5read(fileName, strcat(names{lines}, '/calls')));
% some names appear to be stored in another cell if they are too long
for i = 1:lines
    if (~isempty(cells{2, i}))
        names{i} = cells{2, i}.Name;
    end
end
data = zeros(lines, positions);
for idx = 1:lines
    data(idx, :) = (h5read(fileName, strcat(names{idx}, '/calls')))';
end
%% N = -1, A = 0, T = 51, C = 17, G = 34
intersections = zeros(1, positions);
for i = 1:positions
    for j = 1:lines
        if (data(j, i) ~= -1) 
            intersections(i) = intersections(i) + 1;
        end
    end
end
%% the set of genomic positions having two or more SNPs (“intersecting SNPs”)
sites = find(intersections ~= 0);
%% the names of the lines and their non-N variants at each position 
%% currently this part takes too long to calculate
% nonNs = cell(1, positions);
% for i = 1:positions
%     nonNs{i} = strings(1, intersections(i));
%     count = 1;
%     for j = 1:lines
%         if (data(j, i) ~= -1) 
%             nonNs{i}(count) = erase(names(j), strcat(location, '/'));
%             count = count + 1;
%         end
%     end
% end
%% print intersections
% fileID = fopen('intersections.txt','w');
% output = strings(lines, positions);
% strings(:, :) = '-';
% for i = 1:positions
%     count = 1;
%     for j = 1:lines
%         if (data(j, i) ~= -1) 
%             output(count, i) = erase(names(i), strcat(location, '/'));
%             count = count + 1;
%         end
%     end
% end
% fclose(fileID);
%% the number of lines at each intersecting SNP and their distribution of intersecting SNP positions across the genome 
bar(intersections(1:10000)');
title('Number of intersections at each location');
ylabel('Number of intersections');
xlabel('Coordinate');
set(gcf,'color','white');
set(gca,'FontSize',14);