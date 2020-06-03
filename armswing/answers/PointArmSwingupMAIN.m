% Write a GPOPS function to solve the swing-up problem
% Solve the problem and use the following inputs

l = 1;
g = 10;
Tmax = 3; % Maximum time to run the simulation
GPOPSoutput = PointArmSwingup(g,l,Tmax);
PointArmSwingupPlot(GPOPSoutput,30) % Second term is frame rate

%% With a fully functional solver, remove the upper bound on time

l = 1;
g = 10;
Tmax = Inf; % Maximum time to run the simulation
GPOPSoutput = PointArmSwingup(g,l,Tmax);
PointArmSwingupPlot(GPOPSoutput,5) % Frame rate lower; we're running the animation at 6x normal speed

% What happens? Why do you think this occurs?

%% We are going to do the same problem, but this time minimizing absolute work
% Copy your working PointArmSwingup function, and rename it to PointArmSwingupWork
% Add two more inputs, Umax and s, to the function definition.

l = 1;
g = 10;
Tmax = 3;
Umax = 20;
s = 1; % Smoothing term
GPOPSoutput = PointArmSwingupWork(g,l,Tmax,Umax,s);
PointArmSwingupPlot(GPOPSoutput,30)

% Next, use abs(F.*thetadot) as your objective.
% What happens? Does SNOPT or GPOPS converge?

% Why do you think this might be? How can you solve the problem?
% What happens if you increase Umax?

