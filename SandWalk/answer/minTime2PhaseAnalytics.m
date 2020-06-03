function bestx = minTime2PhaseAnalytics(u1,u2,W,H,h,plotcost)

if nargin < 6
    plotcost = false;
end

x = linspace(0,W);
T = sqrt(x.^2 + h^2)/u1 + sqrt((W-x).^2 + (H-h)^2)/u2;

if plotcost
    plot(x,T)
end

[~,I] = min(T);
bestx = x(I);

