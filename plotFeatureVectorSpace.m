% Script for plotting the visualisations, heatmaps and dendrograms of
% the landscape feature feature vector.
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
colors = {'b', 'r', 'g', 'k'};
legendLabels = {'2D', '5D', '10D', '20D'};

seeds = 1:30;
walks = 1:30;
bbob = 1:24;
maxIt = 5000;

dirName = 'data/';
dirNameSuffix = 'D/metrics/metrics.mat';

load([dirName, num2str(dim), dirNameSuffix]);

nMetrics = 7;
features = zeros(length(bbob), nMetrics);
autoCorrelation(isnan(autoCorrelation)) = 0;
a = reshape(autoCorrelation(seeds, walks, bbob, :), length(seeds) * length(walks), length(bbob), nBins);
ind = a~=0;
corrLength = sum(a, 3) ./ sum(ind, 3);
corrLength = corrLength(~isnan(corrLength(:, 1)), :);
corrLengthM = mean(corrLength, 1);

features(:,1) = mean(corrLength, 1);
features(:,2) = mean(mean(disperse, 1), 2) / (10 * sqrt(dim)); % Normalise
features(:,3) = (mean(mean(fdc, 1), 2) + 1) / 2;
features(:,4) = (mean(mean(fdcEst, 1), 2) + 1) / 2;
features(:,5) = mean(mean(iContent, 1), 2);
features(:,6) = mean(mean(iContentPartial, 1), 2);
features(:,7) = mean(mean(iContentStability, 1), 2) ./ max(iContentStability(:));

distances = squareform(pdist(features));

% t-SNE
dimension = 2;
epsilon = 1e-5;
[perplexity, cost] = calculatePerplexity(distances, 1000, 1:0.5:50, epsilon);
% perplexity = 5;
p = d2p(distances.^2, perplexity, epsilon);
[points cost] = tsne_p(p, [], dimension);

% Clustering
z = linkage(squareform(distances), 'average');
clust = cluster(z, 'maxclust', 5);
figure;
fontSize = 12;
set(gca,'FontSize',fontSize);
[h, t] = dendrogram(z, 'colorthreshold', 0.5 * max(z(:, 3)));
set(h, 'LineWidth', 1.5);
xlabel('Problem ID', 'FontSize', 18);
ylabel('Distance', 'FontSize', 18);

% Plot the space
mSize = 12;
figure;
fontSize = 14;
set(gca,'FontSize', fontSize);
hold on;
for i=1:length(bbob)
    plot(points(i, 1), points(i, 2), '.k', 'MarkerSize', mSize);
    text(points(i, 1), points(i, 2), ['  ', num2str(bbob(i))], 'FontSize', fontSize);
end