function minTime2PhasePlot(GPOPSoutput,u1,u2,W,H,h,animate)

if nargin < 6
    animate = false;
end

o = GPOPSoutput;
X1r = o.result.solution.phase(1).state;
X2r = o.result.solution.phase(2).state;
X1 = o.result.interpsolution.phase(1).state;
X2 = o.result.interpsolution.phase(2).state;

close all;
plot(X1r(:,1),X1r(:,2),'o');
hold on
plot(X2r(:,1),X2r(:,2),'o');
hold on
plot([0 W],[h h],'k-')

% Get best solution

bestx = minTime2PhaseAnalytics(u1,u2,W,H,h);
resetcolor
plot([0,bestx],[0,h],'--')
plot([bestx,W],[h,H],'--')

n = 20;
if animate
   t1 = o.result.interpsolution.phase(1).time;
   t2 = o.result.interpsolution.phase(2).time;
   T1 = t1(end);
   T2 = t2(end);
   t1i = linspace(0, T1,round(T1*n))';
   t2i = linspace(0, T2,round(T2*n))';
   X1i = interp1(t1,X1(:,1:2),t1i);
   X2i = interp1(t2,X2(:,1:2),t2i);
   for i = 1:length(t1i)
      lh = plot(X1i(i,1),X1i(i,2),'ko','markersize',10,'markerfacecolor','k');
      drawnow
      pause(1/n)
      delete(lh)
   end
   for i = 2:length(t2i)
      lh = plot(X2i(i,1),X2i(i,2),'ko','markersize',10,'markerfacecolor','k');
      drawnow
      pause(1/n)
      delete(lh)
   end
    
end