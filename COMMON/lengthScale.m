function [ stats ] = lengthScale( x, f, nKernel )
% Calculates the length scales and related measures from a sample of data.
% For more information, see 'Length Scale for Characterising Continuous
% Optimization Problems'
% Arguments:
%           x: n x dim search points visited (rows are points, cols are dimension)
%           f: n x 1 vector of fitness values of the points visited
%           nKernel: number of points in the kernel density estimate for
%           the length scale distribution (p(r)).
% Returns:
%           stats: struct containing:
%               mean: mean of length scales
%               median: median of length scales
%               var: variance of length scales
%               mode: mode of length scales
%               max: maximum length scale
%               min: minimum length scale
%               kernelF: probability density estimates for p(r)
%               kernelX: r's for which p(r) is defined over
%               kernelB: bandwidth calculated for kernel desntiy estimate
%               entropy: entropy of p(r)
% 
% Copyright (C) 2014 Rachael Morgan (rachael.morgan8@gmail.com)
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

ind1 = randperm(length(f));
ind2 = [ind1(2:end), ind1(1)];
r = (abs(f(ind1) - f(ind2)) ./ sqrt(sum((x(ind1,:) - x(ind2,:)).^2, 2)))';
clear ind1 ind2;
        
bandwidth = fast_univariate_bandwidth_estimate_STEPI(length(r), r, 10^(-3));
[pi xi] = ksdensity(r, 'width', bandwidth, 'npoints', nKernel);

stats = struct();

stats.mean = mean(r);
stats.median = median(r);
stats.var = var(r);
stats.mode = mode(r);
stats.max = max(r);
stats.min = min(r);
stats.kernelF = pi;
stats.kernelX = xi;
stats.kerenelB = bandwidth;

pi = pi(pi ~= 0);
xiInc = xi(2) - xi(1);
stats.entropy = -xiInc * sum(pi .* log2(pi));

end
