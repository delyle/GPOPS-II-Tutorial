function PointArmSwingupPlot(GPOPSoutput,FR)

if nargin < 2
    FR = 30;
end

t = GPOPSoutput.result.interpsolution.phase.time;
X = GPOPSoutput.result.interpsolution.phase.state;
U = GPOPSoutput.result.interpsolution.phase.control;
auxdata = GPOPSoutput.result.setup.auxdata;
l = auxdata.l;

close all
plot(t,X)
yyaxis right
plot(t,U)

legend({'$\theta$','$\dot\theta$','Applied Torque'},'interpreter','latex')

pause(1)

ti = linspace(0,t(end),t(end)*FR);

figure;
plot(0,0,'ks')
hold on
axis equal

Xi = interp1(t,X,ti);
for i = 1:length(ti)
    if i > 1
        delete(lh1)
        delete(lh2)
    end
    lh1 = plot([0 l*sin(Xi(i,1))],[0 -l*cos(Xi(i,1))],'b-');
    lh2 = plot(l*sin(Xi(i,1)),-l*cos(Xi(i,1)),'bo');
    xlim(l*1.25*[-1, 1])
    ylim(l*1.25*[-1, 1])
    xlabel('x/l')
    ylabel('y/l')
    drawnow
    pause(1/FR)
end
