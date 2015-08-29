% Script for plotting landscape metrics against the best ERT.
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
clear all;
clc;

colors = {'b', 'r', [0 0.7 0], 'k'};
legendLabels = {'2D', '5D', '10D', '20D'};

seeds = 1:30;
walks = 1:30;
bbob = 1:24;
maxIt = 5000;

dim = [2, 5, 10, 20];

dirName = 'data/';
dirNameSuffix = 'D/metrics/metrics.mat';

% Import the BBOB performance
precision = 1e-8;
data = importdata([dirName,'ert.csv'], ',');
ert = data.data;
clear data;

figure;
fontSize = 14;
hold on;
mSize = 12;
mType = {'o', 's', 'p', 'x', '.'};

for d=1:length(dim)
    load([dirName, num2str(dim(d)), dirNameSuffix]);

    % NOTE: choose whichever feature you like
    feature = disperse / (10 * sqrt(dim(d)));
%     feature = rMedian;
%     feature = iContent;

    ind = (ert(:, 2) == dim(d)) & (ert(:, 4) == precision) & (~isinf(ert(:, 5)));
    ertDim = ert(ind, :);
    ertBest = zeros(1, length(bbob));
    for i=1:length(bbob)
        ertBest(i) = min(ertDim(ertDim(:, 1) == bbob(i), 5));
    end
    % Normalise the ERTs so that we can scale the sizes
    % ertBest = (ertBest - min(ertBest)) / (max(ertBest) - min(ertBest));

    meanFeature = mean(reshape(feature, length(walks) * length(seeds), length(bbob)), 1);
    plot(meanFeature(1), ertBest(1), mType{d}, 'Color', colors{d});
end

legend(legendLabels);

for d=1:length(dim)
    load([dirName, num2str(dim(d)), dirNameSuffix]);

    % NOTE: choose whichever feature you like
    feature = disperse / (10 * sqrt(dim(d)));
%     feature = rMedian;
%     feature = iContent;

    ind = (ert(:,2) == dim(d)) & (ert(:,4) == precision) & (~isinf(ert(:,5)));
    ertDim = ert(ind,:);
    ertBest = zeros(1, length(bbob));
    for i=1:length(bbob)
        ertBest(i) = min(ertDim(ertDim(:,1) == bbob(i), 5));
    end
    % Normalise the ERTs so that we can scale the sizes
    % ertBest = (ertBest - min(ertBest)) / (max(ertBest) - min(ertBest));

    meanFeature = mean(reshape(feature, length(walks) * length(seeds), length(bbob)), 1);
%     stdFeature = std(reshape(feature,length(walks)*length(seeds),length(bbob)));
    plot(meanFeature,ertBest, mType{d}, 'Color', colors{d});
    for fn=1:length(bbob)
%         stdBar = [meanFeature(fn) - stdFeature(fn), meanFeature(fn) + stdFeature(fn)];
%         plot(stdBar, [ertBest(fn), ertBest(fn)], ':', 'Color', colors{d});
        text(meanFeature(fn), ertBest(fn), [' ',num2str(bbob(fn))], 'FontSize', 12);
    end
end
ylabel('Best ERT', 'FontSize', 18)
xlabel('Length Scale Median', 'FontSize', 18)
set(gca, 'FontSize', fontSize);
%axis([0 0.7 0 10^8])
set(gca, 'YScale', 'log');