function [ perplexity, cost ] = calculatePerplexity(distances, numIterations, perplexities, epsilon )
% Calculates the average best perplexity over a set of trials.
% Arguments:
%           distances: the n x n distance matrix from which to calculate
%           the perplexity
%           numIterations: number of iterations
%           perplexities: the perplexities to explore
%           epsilon: parameter for t-SNE
% Returns:
%           perplexity: average best perplexity over the trials
%           cost: the average cost of the corresponding perplexity
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
costs = zeros(length(perplexities), numIterations);

for i=1:numIterations
    for pIndex=perplexities
        p = d2p((distances / range(distances(:))).^2, perplexities(pIndex), epsilon);        
        [tempP tempCost] = tsne_p(p, [], dimension);
        costs(i, pIndex) = tempCost;
    end
end

meanCosts = mean(costs,2);
[cost pIndex] = min(meanCosts);
perplexity = perplexities(pIndex);

end

