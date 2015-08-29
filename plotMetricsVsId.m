% Script for plotting landscape metrics against the BBOB function ID
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
colors = {'b', 'r', 'g', 'k'};
legendLabels = {'2D', '5D', '10D', '20D'};

axisFontSize = 18;
labelFontSize = 14;
legendFontSize = 14;

seeds = 1:30;
walks = 1:30;
bbob = 1:24;

dirName = 'data/';
dirNameSuffix = 'D/metrics/metrics.mat';
dirNameSave = 'figures/';

% Autocorrelation
f1 = figure;
hold on;
xlabel('Distance');
ylabel('Autocorrelation Function');
f2 = figure;
set(gca, 'FontSize', axisFontSize);
hold on;
xlabel('Problem ID', 'FontSize', labelFontSize);
ylabel('Correlation Length', 'FontSize', labelFontSize);
corrLengthM = zeros(length(dim), length(bbob));
corrLengthS = zeros(length(dim), length(bbob));
for i=1:length(dim)
    load([dirName, num2str(dim(i)), dirNameSuffix], 'autoCorrelation', 'timeSteps', 'nBins');
    autoCorrelation(isnan(autoCorrelation)) = 0;
    a = reshape(autoCorrelation(seeds, walks, bbob, :), length(seeds) * length(walks), length(bbob), nBins);
    
    figure(f1);
    
    ind = a~=0;
    corrLength = sum(a, 3) ./ sum(ind, 3);
    corrLength = corrLength(~isnan(corrLength(:, 1)), :);
    corrLengthM(i, :) = mean(corrLength, 1);
    corrLengthS(i, :) = std(corrLength,[], 1);
    figure(f2);
    errorbar(bbob, corrLengthM, corrLengthS, colors{i});
    t = reshape(timeSteps, length(seeds) * length(walks), length(bbob), nBins);
    plot(t, a, colors{i});
end
axis([0 25 -1 1]);
leg = legend(legendLabels{1:length(dim)});
set(leg, 'FontSize', legendFontSize);
% print(f2, [dirNameSave, 'compare_corr_length.eps'], '-depsc');
% saveas(f2, [dirNameSave, 'compare_corr_length.fig']);
clear 'autoCorrelation' 'timeSteps' 'nBins';

% Dispersion
f1 = figure;
set(gca, 'FontSize', axisFontSize);
hold on;
xlabel('Problem ID', 'FontSize', labelFontSize);
ylabel('Dispersion', 'FontSize', labelFontSize);
for i=1:length(dim)
    load([dirName, num2str(dim(i)), dirNameSuffix], 'disperse');
    normalisation = 10*sqrt(dim(i)); % Theoretically: min d = 0, max d = sqrt(10^2*dim)
    d = reshape(disperse(seeds, walks, bbob), length(seeds) * length(walks), length(bbob)) / normalisation;
    dM = mean(d);
    dS = std(d);
    range(dM)
    errorbar(bbob, dM, dS, colors{i});
end
axis([0 25 0 1]);
leg = legend(legendLabels{1:length(dim)});
set(leg, 'FontSize', legendFontSize);
% print(f1,[dirNameSave, 'compare_dispersion.eps'], '-depsc');
% saveas(f1,[dirNameSave, 'compare_dispersion.fig']);
clear 'disperse';

% FDC
f1 = figure;
set(gca, 'FontSize', axisFontSize);
hold on;
xlabel('Problem ID');
ylabel('FDC');
axis([0 25 -1 1]);
f2 = figure;
set(gca, 'FontSize', axisFontSize);
hold on;
xlabel('Problem ID', 'FontSize', labelFontSize);
ylabel('Estimated FDC', 'FontSize', labelFontSize);
axis([0 25 -1 1]);

for i=1:length(dim)
    load([dirName, num2str(dim(i)), dirNameSuffix], 'fdc', 'fdcEst');
    fdcTemp = reshape(fdc(seeds,walks,bbob), length(seeds) * length(walks), length(bbob));
    fdcM = mean(fdcTemp);
    fdcS = std(fdcTemp);
    fdcEstTemp = reshape(fdcEst(seeds, walks, bbob), length(seeds) * length(walks), length(bbob));
    fdcEstM = mean(fdcEstTemp);
    fdcEstS = std(fdcEstTemp);
    figure(f1);
    errorbar(bbob, fdcM, fdcS, colors{i});
    figure(f2);
    errorbar(bbob, fdcEstM, fdcEstS, colors{i});
end
figure(f1);
leg = legend(legendLabels{1:length(dim)});
set(leg, 'FontSize', legendFontSize);
print(f1,[dirNameSave, 'compare_fdc.eps'], '-depsc');
saveas(f1,[dirNameSave, 'compare_fdc.fig']);
figure(f2);
leg = legend(legendLabels{1:length(dim)});
set(leg, 'FontSize', legendFontSize);
print(f2,[dirNameSave, 'compare_fdc_est.eps'], '-depsc');
saveas(f2,[dirNameSave, 'compare_fdc_est.fig']);
clear 'fdc' 'fdcEst';

% Information Distance
f1 = figure;
set(gca, 'FontSize', axisFontSize);
hold on;
xlabel('Problem ID', 'FontSize', labelFontSize);
ylabel('Information Content', 'FontSize', labelFontSize);
f2 = figure;
set(gca, 'FontSize', axisFontSize);
hold on;
xlabel('Problem ID', 'FontSize', labelFontSize);
ylabel('Partial Information Content', 'FontSize', labelFontSize);
f3 = figure;
set(gca, 'FontSize', axisFontSize);
hold on;
xlabel('Problem ID', 'FontSize', labelFontSize);
ylabel('Information Stability', 'FontSize', labelFontSize);
for i=1:length(dim)
    load([dirName, num2str(dim(i)), dirNameSuffix], 'iContent', 'iContentPartial', 'iContentStability');
    ic = reshape(iContent(seeds, walks, bbob), length(seeds) * length(walks), length(bbob));
    ip = reshape(iContentPartial(seeds, walks, bbob), length(seeds) * length(walks), length(bbob));
    is = reshape(iContentStability(seeds, walks, bbob), length(seeds) * length(walks), length(bbob));
    icM = mean(ic);
    isM = mean(is);
    ipM = mean(ip);
    icS = std(ic);
    ipS = std(ip);
    isS = std(is);
    figure(f1);
    errorbar(bbob, icM, icS, colors{i});
    figure(f2);
    errorbar(bbob, ipM, ipS, colors{i});
    figure(f3);
    errorbar(bbob, isM, isS, colors{i});
end
figure(f1);
leg = legend(legendLabels{1:length(dim)});
axis([0 25 0 1]);
set(leg, 'FontSize', legendFontSize);
print(f1,[dirNameSave, 'compare_info_content.eps'], '-depsc');
saveas(f1,[dirNameSave, 'compare_info_content.fig']);
figure(f2);
leg = legend(legendLabels{1:length(dim)});
set(leg, 'FontSize', legendFontSize);
axis([0 25 0 1]);
print(f2,[dirNameSave, 'compare_info_content_partial.eps'], '-depsc');
saveas(f2,[dirNameSave, 'compare_info_content_partial.fig']);
figure(f3);
% axes('YScale', 'log');
leg = legend(legendLabels{1:length(dim)});
set(leg, 'FontSize', legendFontSize);
print(f3,[dirNameSave, 'compare_info_content_stability.eps'], '-depsc');
saveas(f3,[dirNameSave, 'compare_info_content_stability.fig']);
clear 'iContent' 'iContentPartial' 'iContentStability';

% Import the BBOB performance
precision = 1e-8;
data = importdata('H:\PhD\Python\BBOB ERT Calculator\ert.csv', ', ');
ert = data.data;
clear data;

% Length Scale
f1 = figure;
set(gca, 'FontSize', axisFontSize);
hold on;
for i=1:length(dim)
    ind = (ert(:,2) == dim(i)) & (ert(:,4) == precision) & (~isinf(ert(:,5)));
    ert = ert(ind, :);
    load([dirName, num2str(dim(i)), dirNameSuffix], 'rMedian');
    rH = reshape(rMedian(seeds, walks, bbob), length(seeds) * length(walks), length(bbob));
    rHM = mean(rH);
    rHS = std(rH);
    errorbar(rHM, rHS, colors{i});
end
xlabel('Problem ID', 'FontSize', labelFontSize);
ylabel('$median(r)$', 'FontSize', labelFontSize);
leg = legend(legendLabels{1:length(dim)});
set(leg, 'FontSize', legendFontSize);
% print(f1,[dirNameSave, 'compare_length_scale.eps'], '-depsc');
% saveas(f1,[dirNameSave, 'compare_length_scale.fig']);
clear 'rEntropy';