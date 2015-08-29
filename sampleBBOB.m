% Script for sampling the BBOB functions.
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

dim = 20;
dirName = ['data/',num2str(dim),'D/'];

nSamples = 1000 * dim^2;
bounds = [-5,5];
precision = 10^(-3);

% Get points that will be common to all problems
bbob_i = 1:24;
walks = 1:30;
seeds = 25:30;
fhs = benchmarks('handles');

save([dirName, 'settings.mat'], 'dim', 'nSamples', 'seeds','bounds', 'bbob_i', 'precision');

x = zeros(length(walks), nSamples, dim);
for j=1:length(walks)
    RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', seeds(j))); % So we can reproduce
    initPoint = rand(1, dim) * range(bounds) + bounds(1);
    x(j,:,:) = randomLevyWalk(initPoint, nSamples, precision, bounds);
    save([dirName, 'x.mat'], 'x', '-v7.3');
end
disp('Walks are finished.');

for k=1:length(seeds)
    f = zeros(length(walks), length(bbob_i), nSamples);
    
    for j=1:length(walks)
        x_temp = reshape(x(j,:,:),nSamples,dim)';
        
        for i=1:length(bbob_i)
            func = fhs{bbob_i(i)};
            f(walks(j),bbob_i(i),:) = func(x_temp, [], seeds(k));
        end
    end
    
    save([dirName, 'f_seed_', num2str(seeds(k)), '.mat'], 'f', '-v7.3');
    disp(['Finished seed ', num2str(seeds(k))]);
end