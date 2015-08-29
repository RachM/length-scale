% Script for calculating landscape metrics of the BBOB problems
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

dim = 20; % Set this to whatever you want
nBins = 100; % Number of bins in autocorrelation function
dispersionPrecision = 0.05; % Select best 5%
dirName = ['data/', num2str(dim), 'D/'];
load([dirName, 'walks/settings.mat']);
nSamples = 1000 * dim^2;
nKernel = 1000;
walks = 1:30;
fhs = benchmarks('handles');

load([dirName, 'walks/x.mat']);

save([dirName,'metrics/metric_settings.mat'], 'nBins', 'dispersionPrecision', 'nSamples', 'nKernel');

autoCorrelation = zeros(length(seeds), length(walks), length(bbob_i), nBins);
timeSteps = zeros(length(seeds), length(walks), length(bbob_i), nBins);
fdc = zeros(length(seeds), length(walks), length(bbob_i));
fdcEst = zeros(length(seeds), length(walks), length(bbob_i));
disperse = zeros(length(seeds), length(walks), length(bbob_i));
iContent = zeros(length(seeds), length(walks), length(bbob_i));
iContentPartial = zeros(length(seeds), length(walks), length(bbob_i));
iContentStability = zeros(length(seeds), length(walks), length(bbob_i));
rMax = zeros(length(seeds), length(walks), length(bbob_i));
rMin = zeros(length(seeds), length(walks), length(bbob_i));
rMean = zeros(length(seeds), length(walks), length(bbob_i));
rMedian = zeros(length(seeds), length(walks), length(bbob_i));
rMode = zeros(length(seeds), length(walks), length(bbob_i));
rVar = zeros(length(seeds), length(walks), length(bbob_i));
rEntropy = zeros(length(seeds), length(walks), length(bbob_i));
rBandwidth = zeros(length(seeds), length(walks), length(bbob_i));
rKernelF = zeros(length(seeds), length(walks), length(bbob_i), nKernel);
rKernelX = zeros(length(seeds), length(walks), length(bbob_i), nKernel);

for k=1:length(seeds)
    load([dirName, 'walks/f_seed_', num2str(seeds(k)), '.mat']);
    
    for j=1:length(walks)
        x_temp = reshape(x(j,:,:), nSamples, dim);
        
        for i=1:length(bbob_i)
            f_temp = reshape(f(walks(j), bbob_i(i), :), nSamples, 1);
            
            disperse(k,j,i) = dispersion(x_temp, f_temp, dispersionPrecision * nSamples); % Dispersion
            
            func = fhs{bbob_i(i)};
            [temp, xG] = func('xopt', dim);
            xG = xG';
            [temp, indXG] = min(f_temp);
            clear temp;
            
            % Calc metrics
            [a, t] = autocorrelation(x_temp, f_temp, nBins);
            autoCorrelation(k,j,i,:) = padarray(a, [0, nBins - length(autoCorrelation)], 'post');
            timeSteps(k,j,i,:) = padarray(t, [0, nBins - length(timeSteps)], 'post');
            clear a t;
            
            [iC, iP, iS] = informationContent(f_temp);
            iContent(k,j,i) = iC;
            iContentPartial(k,j,i) = iP;
            iContentStability(k,j,i) = iS;   
            clear iC iP iS;
            
            fdc(k,j,i) = fitnessDistanceCorrelation(x_temp, f_temp, xG); % Fitness distance correlation
            fdcEst(k,j,i) = fitnessDistanceCorrelation(x_temp, f_temp, x_temp(indXG,:)); % Fitness distance correlation
            
            rStats = length_scale(x_temp, f_temp, nKernel); % Length scale statistics

            rMax(k,j,i) = rStats.max;
            rMin(k,j,i) = rStats.min;
            rMean(k,j,i) = rStats.mean;
            rMedian(k,j,i) = rStats.median;
            rMode(k,j,i) = rStats.mode;
            rVar(k,j,i) = rStats.var;
            rEntropy(k,j,i) = rStats.entropy;
            rBandwidth(k,j,i) = rStats.kerenelB;
            rKernelF(k,j,i,:) = rStats.kernelF;
            rKernelX(k,j,i,:) = rStats.kernelX;
            clear rStats;
        end

        % Try and save all of the data
        save([dirName, 'metrics/metrics.mat'], 'iContent', 'iContentPartial', ...
            'iContentStability', 'autoCorrelation', 'timeSteps', 'fdc', ...
            'fdcEst', 'disperse', 'nBins', 'dispersionPrecision',...
            'rBandwidth', 'rEntropy', 'rKernelF', 'rKernelX', 'rMax' ,'rMin', ...
            'rMedian', 'rMean', 'rMode', 'rVar');
        disp(['Walk ', num2str(walks(j))]);
    end

    disp(['Finished seed ', num2str(seeds(k))]);
end
