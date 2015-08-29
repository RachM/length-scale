function h = plotShaded(x, f, statAcross)
% Plots the average distribution, with shading of 1 standard deviation.
%
% Input:
%    - x: nDistributions x nPoints matrix of x values
%    - f: nDistributions x nPoints matrix of probability values
%    - statAcross: the dimension to calculate the mean across (generally is 2)
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
    [row col] = size(x);
    
    gray = 220;
    %colors = {[0 175 0]/255, [220 0 0]/255, [0 0 220]/255, [0 0 0]/255};
    colors = {[0 0 0]/255, [0 0 0]/255, [0 0 0]/255, [0 0 0]/255};
    lines = {'-', '--', ':', '-.'};
    lineWidth = 2;

    fontSize = 24;

    h = figure;
    hold on;
    xlabel('r', 'FontSize', fontSize);
    ylabel('p(r)', 'FontSize', fontSize)

    fMean = reshape(mean(f, statAcross), row, col);
    fStd = reshape(std(f, [], statAcross), row, col);
    
    for i=1:row
        plot(x(i, :), fMean(i, :), 'Color', colors{i}, 'LineStyle', lines{i}, 'LineWidth', lineWidth);
    end
    
    for i=1:row    
        y1 = fMean(i, :) - fStd(i, :);
        y2 = fMean(i, :) + fStd(i, :);

        xShade=[x(i, :),fliplr(x(i, :))];

        yShade=[y1,fliplr(y2)];

        fill(xShade,yShade, [gray gray gray]/255, 'LineStyle', 'none');
    end
    
    for i=1:row
        plot(x(i, :), fMean(i, :), 'Color', colors{i}, 'LineStyle', lines{i}, 'LineWidth', lineWidth);
    end
end

