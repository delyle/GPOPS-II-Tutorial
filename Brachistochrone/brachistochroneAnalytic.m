function [x, y] = brachistochroneAnalytic(A,B)

% Computes the brachistochrone connecting point A and B in the x-y plane
% Must have A(2) > B(2)
%
% Example:
%
% A = [0 1];
% B = [2 0];
% 
% [x, y] = brachistochrone(A,B);
% close all
% plot(x,y) 

x1 = B(1); x2 = A(1);
y1 = B(2); y2 = A(2);

if y1 >= y2
    error('must have A(2) > B(2)')
end

fun = @(t) (t - sin(t))./(cos(t) - 1) - (x1 - x2)./(y1 - y2);

tend = fzero(fun,1);

R = (x1 - x2)./(tend - sin(tend));
t = linspace(0,tend);

x = x2 + R*(t-sin(t));
y = y2 + R*(cos(t) - 1);
