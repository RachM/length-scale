function [x] = randomLevyWalk(xInitial, numSteps, minStepSize, bounds)
%Conducts a random Levy walk
%
%Syntax: randomWalk(xInitial, numSteps, minStepSize, bounds, fn)
%
%Example:
%       randomWalk(rand(1,1), 10, 0.1, [0,1], @(x)(x.^2))
%
%Note:
%       If using Levy-distributed steps, the function stblrnd.m must be
%       in the same directory as this function. stblrnd.m generates random 
%       numbers form the Levy alpha-stable distribution. It is originally
%       described at:
%       http://math.bu.edu/people/mveillet/html/alphastablepub.html
%
%Inputs: 
%        xInitial: 1xDIMENSION point in the search space to start the walk
%        from
%        numSteps: the number of steps to walk (in total)
%        minStepSize: the minimum step size of each step (steps may be
%        larger)
%        bounds: 1x2 vector, where bounds(1) is the minimum and bounds(2)
%        is the maximum. Bounds are the same in each dimension
%
%Outputs:
%        x: matrix of points visited. Rows are points, columns are the
%        dimensions of the point.
%
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

dimension = size(xInitial, 2);

x = zeros(numSteps, dimension);
x(1,:) = xInitial;

pointOk = 0; % Flag used to check that points are within the bounds
stepSize = minStepSize; % stepSize may change throughout the walk

for i = 2:numSteps
    while ~pointOk
        % Generate point on unit hypersphere and scale by step size
        % NOTE: if you do not want to do a Levy walk, and would prefer to
        % do a fixed-step sized walk, then simply uncomment the line below
        % and comment-out the Levy-distributed step.
        % stepSize = minStepSize; % Fixed step size
        stepSize = stblrnd(0.5, 1, minStepSize, 0); % Levy-distributed step
        proposedPoint = x(i-1, :) + stepSize * hypershpere_point(dimension); % New point

        % Check bounds
        lower = max(proposedPoint < bounds(1));
        upper = max(proposedPoint > bounds(2));
        if (lower == 0 && upper == 0)
            pointOk = 1; % Bounds are ok, so point is ok
        end
    end
        
    x(i,:) = proposedPoint;
    
    pointOk = 0; % On next iteration point may not be ok;
end

end

function [ vector ] = hypershpere_point( dimensions )
%--------------------------------------------------------------------------
%Returns a point on the edge of a unit hypersphere
%
%Syntax: hypershpere_point(dimensions)
%
%Example:
%       x = hypershpere_point(2)
%
%Note:
%       It is explained at:
%       http://mathworld.wolfram.com/HyperspherePointPicking.html
%
%Inputs: 
%        dimensions: the dimensionality of the point
%
%Outputs:
%        vector: the point
%
%Original Author: Rachael Morgan (r.morgan4@uq.edu.au)
%--------------------------------------------------------------------------
vector = randn(1, dimensions); % N Gaussians mean = 0, sigma = 1
scalar = sqrt(sum(vector .^ 2)); % Normalisation scalar
vector = vector / scalar; % Unit vector

end
