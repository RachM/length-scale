% Script for plotting the length scale distributions across dimensionality.
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

dim = [2, 5, 10, 20];
bbob_i = 20;
seeds = 1:30;
walks = 1:30;
colors = {[0 175 0] / 255, [220 0 0] / 255, [0 0 220] / 255, [0 0 0] / 255};
lines = {'-', '--', ':', '-.'};
lineWidth = 2;

fontSize = 24;
legendFontSize = 18;

figure;
hold on;
xlabel('r', 'FontSize', fontSize);
ylabel('p(r)', 'FontSize', fontSize)

xLength = 100;
x = zeros(length(dim), xLength);
pMean = zeros(length(dim), xLength);
pStd = zeros(length(dim), xLength);
for i=1:length(dim)
    dirName = ['data/', num2str(dim(i)), 'D/metrics/'];
    load([dirName, 'metrics.mat'], 'rKernelX', 'rKernelF');
    load([dirName, 'metric_settings.mat'], 'nSamples', 'nKernel');
    
    x_temp = reshape(rKernelX(seeds, walks, bbob_i, :), length(seeds) * length(walks) * nKernel, 1);
    p_temp = reshape(rKernelF(seeds, walks, bbob_i, :), length(seeds) * length(walks) * nKernel, 1);
    
    x(i, :) = linspace(min(x_temp), max(x_temp), xLength);
    
    for j=2:length(x)
        if (j == length(x))
           ind = (x_temp <= x(i, j)) & (x_temp >= x(i, j-1)); 
        else
           ind = (x_temp < x(i, j)) & (x_temp >= x(i, j-1));
        end
        pMean(i, j) = mean(p_temp(ind));
        pStd(i, j) = std(p_temp(ind));
    end
end

for i=1:length(dim)
    plot(x(i, :), pMean(i, :), 'Color', colors{i}, 'LineStyle', lines{i}, 'LineWidth', lineWidth);
end
handle = legend('2D', '5D', '10D', '20D');
set(handle, 'FontSize', legendFontSize);

gray = 220;
for i=1:length(dim)
    y1 = pMean(i, :) - pStd(i, :);
    y2 = pMean(i, :) + pStd(i, :);
    xShade=[x(i, :),fliplr(x(i, :))];
    yShade=[y1, fliplr(y2)];
    fill(xShade, yShade, [gray gray gray]/255, 'LineStyle', 'none');
end

for i=1:length(dim)
    plot(x(i, :), pMean(i, :), 'Color', colors{i}, 'LineStyle', lines{i}, 'LineWidth', lineWidth);
end

% axis([-1 20 0 0.5]) % F5
% axis([-0.5e4 8e4 0 2.8e-4]) % F20