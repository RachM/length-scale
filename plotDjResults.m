% Script for plotting the J-divergence visualisations, heatmaps and dendrograms
% 
% Copyright (C) 2015 Rachael Morgan (rachael.morgan8@gmail.com)
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
addpath(genpath('../COMMON'));
clc;
clear all;

dim = 20;
dirName = ['data/', num2str(dim), 'D/metrics/'];

load([dirName, 'kl.mat']);

seeds = 1:30;
walks = 1:30;
bbob_i = 1:24;

distances = reshape(mean(reshape(...
    mean(kl(seeds, walks, bbob_i, bbob_i), 1), length(walks), length(bbob_i), length(bbob_i)), 1), ...
    length(bbob_i), length(bbob_i));
distances = distances + distances';

% t-SNE
dimension = 2;
epsilon = 1e-5;
d = max(distances ./ sum(distances(:)), realmin);
[perplexity, cost] = calculatePerplexity(d, 1000, 1:0.5:50, epsilon);
% perplexity = 5;
p = d2p(d, perplexity, epsilon);
[points cost] = tsne_p(p, [], dimension);

% Clustering
z = linkage(squareform(distances), 'average');
clust = cluster(z, 'maxclust', 5);
figure;
fontSize = 12;
set(gca, 'FontSize', fontSize);
[h, t] = dendrogram(z);
set(h, 'LineWidth', 1);
xlabel('Problem ID', 'FontSize', 18);
ylabel('D_J', 'FontSize', 18);
set(gca, 'FontSize', 14)

mSize = 12;
mType = {'o', 's', 'p', 'x', '.'};
figure;
fontSize = 14;
set(gca, 'FontSize', fontSize);
hold on;
for i=1:length(bbob_i)
    plot(points(i, 1), points(i, 2), '.k', 'MarkerSize', mSize);
    text(points(i, 1), points(i, 2), ['  ', num2str(bbob_i(i))], 'FontSize', fontSize);
end

% Heatmap
ind = eye(length(bbob_i));
ind = logical(ind);
ind = ind | logical(triu(ones(length(bbob_i))));
distancesTemp = distances;
distancesTemp(ind) = Inf;
figure;
imagesc(1:24, 1:24, distancesTemp);
colormap('gray');