function plotLongjump(GPOPSoutput,animate,saveanimation)

if nargin < 3
    saveanimation = false;
    if nargin <2
        animate = false;
    end
end

o = GPOPSoutput;
t1 = o.result.interpsolution.phase(1).time;
X1 = o.result.interpsolution.phase(1).state;
F1 = o.result.interpsolution.phase(1).control;
t2 = o.result.interpsolution.phase(2).time;
X2 = o.result.interpsolution.phase(2).state;
F2 = o.result.interpsolution.phase(2).control;
d = o.result.interpsolution.parameter;
aux = o.result.setup.auxdata;

figure('position',[276   406   917   420])

plot(X1(:,1),X1(:,2))
hold on
plot(X2(:,1)+d,X2(:,2))

X1f = X1(end,:);
X2i = X2(1,:);
X2f = X2(end,:);

x1f = X1f(1);
x2i = X2i(1);
y1f = X1f(2);
y2i = X2i(2);
u1f = X1f(3);
u2i = X2i(3);
v1f = X1f(4);
v2i = X2i(4);


T1flight = (x2i - x1f +d)/u1f;
endpt(1) = u2i - u1f;
endpt(2) = v1f*T1flight - 1/2*aux.g*T1flight^2 + y1f - y2i;
endpt(3) = v1f - aux.g*T1flight - v2i;

x2f = X2f(1);
y2f = X2f(2);
u2f = X2f(3);
v2f = X2f(4);


T2flight = (v2f + sqrt(v2f^2 + 2*aux.g*y2f))/aux.g;
xf = u2f*T2flight + x2f + d;

t1flight = linspace(0, T1flight,11);
x1flight = t1flight*u1f + x1f;
y1flight = y1f+v1f*t1flight - 1/2*aux.g*t1flight.^2;
plot(x1flight,y1flight,'k--')

t2flight = linspace(0,T2flight,11);
x2flight = t2flight*u2f + x2f + d;
y2flight = t2flight*v2f + y2f - 1/2*aux.g*t2flight.^2;
plot(x2flight,y2flight,'k--')

axis equal
xl = xlim;
xlim([0 xl(2)])
xl = xlim;

yl = ylim;

patch([0 xl(2)*[1 1] 0],[0 0 [1 1]*yl(1)],-2*ones(1,4),'facecolor',ones(1,3)*145/255,'edgecolor','none')
patch([aux.D xl(2)*[1 1] aux.D],[0 0 [1 1]*yl(1)],-2*ones(1,4),'facecolor',[255, 218, 127]/255,'edgecolor','none')

plot([0 d],[0 0],'rs')
plot([0 xl(2)],[0 0],'k-')

xlim(xl);
ylim(yl);

T1 = t1(end);
T2 = t2(end);
t1i = 0:0.1:T1;
t2i = 0:0.1:T2;
i1 = find_closest(t1i,t1);
i2 = find_closest(t2i,t2);

for i = 1:length(i1)
    plot([0 X1(i1(i),1)],[0 X1(i1(i),2)],'-','color',[0    0.4470    0.7410])
end
for i = 1:length(i2)
    plot([0 X2(i2(i),1)]+d,[0 X2(i2(i),2)],'-','color',[0.8500    0.3250    0.0980])
end






if animate
    FR = 30; % Frame rate
    figure('position',[291     1   917   420])
    patch([0 xl(2)*[1 1] 0],[0 0 [1 1]*yl(1)],-2*ones(1,4),'facecolor',ones(1,3)*145/255,'edgecolor','none')
    patch([aux.D xl(2)*[1 1] aux.D],[0 0 [1 1]*yl(1)],-2*ones(1,4),'facecolor',[255, 218, 127]/255,'edgecolor','none')
    hold on
    
    t1i = (0:1/FR:T1)';
    Trem = T1 - t1i(end);
    t1fli = (1/FR-Trem:1/FR:T1flight)';
    x1flight = t1fli*u1f + x1f;
    y1flight = y1f+v1f*t1fli - 1/2*aux.g*t1fli.^2;
    F1flight = zeros(size(t1fli));
    Trem = T1flight - t1fli(end);
    t2i = (1/FR-Trem:1/FR:T2)';
    Trem = T2 - t2i(end);
    t2fli = (1/FR-Trem:1/FR:T2flight)';
    x2flight = t2fli*u2f + x2f;
    y2flight = y2f+v2f*t2fli - 1/2*aux.g*t2fli.^2;
    F2flight = zeros(size(t2fli));
    
    % Add time vectors together (both query vectors and solution ones)
    ti = [t1i;t1fli+T1;t2i+T1+T1flight;t2fli+T1+T1flight+T2];
    t = [t1;t1fli+T1;t2(2:end)+T1+T1flight;t2fli+T1+T1flight+T2];
    
    % Combine solution states and forces with flight states and forces
    x = [X1(:,1);x1flight;X2(2:end,1)+d;x2flight+d];
    y = [X1(:,2);y1flight;X2(2:end,2);y2flight];
    F = [F1;F1flight;F2(2:end);F2flight];
    
    % Use query time to interpolate combined state and force vectors.
    xi = interp1(t,x,ti);
    yi = interp1(t,y,ti);
    Fi = interp1(t,F,ti);
    
    % Create a file if saving the animation
    if saveanimation
        filename = 'longjump.gif';
    end
    
    % Cycle through this new combined state to generate animation.
    for i = 1:length(ti)
        if i > 1
            delete(lh)
        end
        lh(1) = plot(xi(i),yi(i),'bo','markersize',10,'markerfacecolor','b');
        % Use magnitude of force vector to modify width of leg lines.
        if ti(i) <= T1 + T1flight
            footx = 0;
            lcolor = [0    0.4470    0.7410];
        else
            footx = d;
            lcolor = [0.8500    0.3250    0.0980];
        end
        alpha = Fi(i)/aux.Fmax;
        lwidth = 4*alpha+ 0.01;
        lh(2) = patchline([footx xi(i)],[0 yi(i)],'edgecolor',lcolor,'linewidth',lwidth,'edgealpha',alpha);
        xlim(xl)
        ylim(yl)
        drawnow
        if saveanimation
            % Get an image of the plot
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            if i == 1
                imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',1/FR);
            else
                imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',1/FR);
            end
        else
            pause(1/FR)
        end
        
    end
    
    %Be sure
    % to record transition to second stance phase, and have forces acting
    % through footfall location!
    
    
    
end

