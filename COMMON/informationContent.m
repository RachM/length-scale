function [ h, m, s ] = informationContent( f )
% Calculates the information content, the partial information content and
% information stability
% Taken from V. K. Vassilev, T. C. Fogarty, and J. F. Miller. Information 
% characteristics and the structure of landscapes. Evolutionary Computation, 8:31–60, 2000. 267
%
% Arguments:
%           f: fitness values of the points visited
% Returns:
%           h: information content
%           m: partial information content
%           s: information stability
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

epsilon = 0; % precision: f1 = f2 if (f1 - f2) < epsilon

% First, we will go through the data and work out transitions
fLength = length(f);

t1 = ((f(2:fLength) - f(1:fLength-1)) > epsilon) * 1.0;
t2 = ((f(2:fLength) - f(1:fLength-1)) < -1*epsilon) * -1.0;

transitions = t1 + t2;

% Count the types of transitions
tLength = fLength - 1;
n = tLength-1;

n01 = sum((transitions(1:tLength-1) == 0) & (transitions(2:tLength) == 1)) / n;
n10 = sum((transitions(1:tLength-1) == 1) & (transitions(2:tLength) == 0)) / n;
n02 = sum((transitions(1:tLength-1) == 0) & (transitions(2:tLength) == -1)) / n;
n20 = sum((transitions(1:tLength-1) == -1) & (transitions(2:tLength) == 0)) / n;
n12 = sum((transitions(1:tLength-1) == 1) & (transitions(2:tLength) == -1)) / n;
n21 = sum((transitions(1:tLength-1) == -1) & (transitions(2:tLength) == 1)) / n;

h = 0;

% Calculate entropy of the types of transitions
if (n10 ~= 0)
    h = h + n10*(log(n10)/log(6));
end
if (n01 ~= 0)
    h = h + n01*(log(n01)/log(6));
end
if (n02 ~= 0)
    h = h + n02*(log(n02)/log(6));
end
if (n20 ~= 0)
    h = h + n20*(log(n20)/log(6));
end
if (n12 ~= 0)
    h = h + n12*(log(n12)/log(6));
end
if (n21 ~= 0)
    h = h + n21*(log(n21)/log(6));
end

% Information content
h = h * -1;

% Partial info content
slopeTransitions = transitions(transitions~=0);
stLength = length(slopeTransitions);
slopeTransitionsTransitions = slopeTransitions(1:stLength-1) - slopeTransitions(2:stLength);
mu = sum(slopeTransitionsTransitions~=0);
m = mu / n;

% Number of local optima
% n = floor(mu/2);

% Information stability
s = max(abs(f(1:length(f)-1) - f(2:length(f))));

end