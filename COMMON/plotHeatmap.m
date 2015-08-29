function plotHeatmap(distances, axisLabel, varargin)
% Plots a heatmap of the distances provided.
%
% Input:
%    - distances: n x n matrix of distances to plot
%    - axisLabel: labelling of the axis
%    - varargin: optional values of the axis (i.e. something other than 0:n)
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

    fontSize = 16;
    totalProblems = size(distances, 1);
    axisValues = 1:totalProblems;
    if (numel(varargin) > 0)
        axisValues = varargin{1};
    end

    % Make upper triangle Inf
    ind = eye(totalProblems);
    ind = logical(ind);
    ind = ind | logical(triu(ones(totalProblems)));
    distances(ind) = Inf;

    figure;
    imagesc(axisValues,axisValues,distances);
    colormap('gray');
    xlabel(axisLabel, 'FontSize', fontSize);
    ylabel(axisLabel, 'FontSize', fontSize);
    colorbar;
    box(gca, 'off');

end