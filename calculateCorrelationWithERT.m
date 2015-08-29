% Script for calculating the correlation between each metric and the best ERT.
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

seeds = 1:30;
walks = 1:30;
bbob = 1:24;

dim = [2, 5, 10, 20];

dirName = 'data/';
dirNameSuffix = 'D/metrics/metrics.mat';

% Import the BBOB performance
precision = 1e-5;
data = importdata([dirName, 'ert.csv'], ',');
ert = data.data;
clear data;

rhos = zeros(length(dim), 3);
pVals = zeros(length(dim), 3);

for d=1:length(dim)
    load([dirName, num2str(dim(d)), dirNameSuffix]);

    % Let feature be whatever feature you're interested in
%     feature = disperse / (10 * sqrt(dim(d)));
%     feature = rEntropy;
%     feature = fdc;
%     feature = fdcEst;
%     feature = iContent;
    autoCorrelation(isnan(autoCorrelation)) = 0;
    a = reshape(autoCorrelation(seeds, walks, bbob, :), length(seeds) * length(walks), length(bbob), nBins);
    ind = a~=0;
    corrLength = sum(a, 3) ./ sum(ind, 3);
    feature = corrLength(~isnan(corrLength(:, 1)), :);

    ind = (ert(:, 2) == dim(d)) & (ert(:, 4) == precision) & (~isinf(ert(:, 5)));
    ertDim = ert(ind, :);
    ertBest = zeros(1, length(bbob));
    for i=1:length(bbob)
        ertBest(i) = min(ertDim(ertDim(:, 1) == bbob(i), 5));
    end
    ertBest = repmat(ertBest, length(seeds) * length(walks), 1);
    feature = reshape(feature, length(seeds) * length(walks) * length(bbob), 1);
    ertBest = reshape(ertBest, length(seeds) * length(walks) * length(bbob), 1);

    [r p] = corr(feature, ertBest, 'type', 'Pearson');
    rhos(d, 1) = round(r * 10^4) / 10^4;
    pVals(d, 1) = round(p * 10^4) / 10^4;
    [r p] = corr(feature, ertBest, 'type', 'Spearman');
    rhos(d, 2) = round(r * 10^4) / 10^4;
    pVals(d, 2) = round(p * 10^4) / 10^4;
    [r p] = corr(feature, ertBest, 'type', 'Kendall');
    rhos(d, 3) = round(r * 10^4) / 10^4;
    pVals(d, 3) = round(p * 10^4) / 10^4;
end
