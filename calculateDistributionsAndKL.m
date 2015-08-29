% Script for calculating the length scale distributions and KL divergence.
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
dirName = ['data/', num2str(dim), 'D/'];
load([dirName, 'walks/settings.mat']);

nSamples = 1000 * dim^2;
nKernel = 1000;
walks = 1:30;
seeds = 1:30;
fhs = benchmarks('handles');
load([dirName, 'metrics/metrics.mat'], 'rBandwidth', 'rKernelX');

kl = zeros(length(seeds), length(walks), length(bbob_i), length(bbob_i));
load([dirName, 'metrics/kl.mat']);

for j=1:length(walks)
    load([dirName, 'walks/x.mat']);
    x_temp = reshape(x(walks(j),:,:),nSamples,dim);
    clear x;
    
    for k=1:length(seeds)
        load([dirName, 'walks/f_seed_',num2str(seeds(k)),'.mat']);
        
        for i=1:length(bbob_i)-1
            f1_temp = reshape(f(walks(j), bbob_i(i), :), nSamples, 1);
			xKernel1 = reshape(rKernelX(seeds(k), walks(j), bbob_i(i), :), 1, nKernel);
			
			ind1 = randperm(length(f1_temp));
			ind2 = [ind1(2:end),ind1(1)];
			r1 = (abs(f1_temp(ind1) - f1_temp(ind2)) ./ sqrt(sum((x_temp(ind1,:) - x_temp(ind2,:)).^2,2)))';
			clear ind1 ind2;
            
            for m=i+1:length(bbob_i)
				xKernel2 = reshape(rKernelX(seeds(k), walks(j), bbob_i(m), :), 1, nKernel);
				xKernel = union(xKernel1, xKernel2);
                clear xKernel2;
                
                f2_temp = reshape(f(walks(j), bbob_i(m), :), nSamples, 1);
				
				ind1 = randperm(length(f2_temp));
				ind2 = [ind1(2:end),ind1(1)];
				r2 = (abs(f2_temp(ind1) - f2_temp(ind2)) ./ sqrt(sum((x_temp(ind1,:) - x_temp(ind2,:)).^2,2)))';
				clear ind1 ind2 f2_temp;
				
				p1 = ksdensity(r1, xKernel, 'width', rBandwidth(seeds(k), walks(j), bbob_i(i)));
				p2 = ksdensity(r2, xKernel, 'width', rBandwidth(seeds(k), walks(j), bbob_i(m)));
				clear r2;
				
				kl1 = p1 ./ p2;
				ind = kl1~=0 & ~isinf(kl1) & ~isnan(kl1);
				xKernelTemp = xKernel(ind);
				inc = xKernelTemp(2:end) - xKernelTemp(1:end-1);
				kl1 = p1(ind) .* log2(kl1(ind));
				kl1 = sum(((kl1(2:end) + kl1(1:end-1)) / 2) .* inc);
				
				kl2 = p2 ./ p1;
				ind = kl2~=0 & ~isinf(kl2) & ~isnan(kl2);
				xKernelTemp = xKernel(ind);
				inc = xKernelTemp(2:end) - xKernelTemp(1:end-1);
				kl2 = p2(ind) .* log2(kl2(ind));
				kl2 = sum(((kl2(2:end) + kl2(1:end-1)) / 2) .* inc);
				
				kl(seeds(k), walks(j), bbob_i(i), bbob_i(m)) = kl1;
				kl(seeds(k), walks(j), bbob_i(m), bbob_i(i)) = kl2;
            end
        end
		save([dirName,'/metrics/kl.mat'], 'kl', '-v7.3');
        disp(['Seed: ', num2str(seeds(k))]);
    end
    disp(['Finished walk: ', num2str(walks(j))]);
end