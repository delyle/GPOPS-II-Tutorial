function GPOPSoutput = brachistochroneGPOPS(B)

%---------------------------------------------------%
% Classical Brachistochrone Problem:                %
%---------------------------------------------------%
% The problem solved here is given as follows:      %
%   Minimize t_f                                    %
% subject to the dynamic constraints                %
%    dx/dt = v*sin(u)                               %
%    dy/dt = -v*cos(u)                              %
%    dv/dt = g*cos(u)                               %
% and the boundary conditions                       %
%    x(0) = 0, y(0) = 0, v(0) = 0                   %
%    x(t_f) = B(1), y(t_f) = B(2) < 0, v(t_f) = FREE%
%---------------------------------------------------%

auxdata.g = 10;
t0 = 0;
tfmin = 0; tfmax = ;
x0 = ; y0 = ; v0 = ;
xf = ; yf = ;
xmin = ; xmax = ;
ymin = ; ymax = ;
vmin = ; vmax = ;
umin = ; umax = ;


%-------------------------------------------------------------------------%
%----------------------- Setup for Problem Bounds ------------------------%
%-------------------------------------------------------------------------%
bounds.phase.initialtime.lower = t0; 
bounds.phase.initialtime.upper = t0;
bounds.phase.finaltime.lower = tfmin; 
bounds.phase.finaltime.upper = tfmax;
bounds.phase.initialstate.lower = [x0,y0,v0]; 
bounds.phase.initialstate.upper = [x0,y0,v0]; 
bounds.phase.state.lower = [xmin,ymin,vmin]; 
bounds.phase.state.upper = [xmax,ymax,vmax]; 
bounds.phase.finalstate.lower = [xf,yf,vmin]; 
bounds.phase.finalstate.upper = [xf,yf,vmax]; 
bounds.phase.control.lower = umin; 
bounds.phase.control.upper = umax;

%-------------------------------------------------------------------------%
%---------------------- Provide Guess of Solution ------------------------%
%-------------------------------------------------------------------------%
guess.phase.time    = [t0; 10]; % column vector!
guess.phase.state   = [[x0; xf],[y0; yf],[v0; v0]]; % #rows = # time points; # cols = # states
guess.phase.control = [pi/4; pi/4]; % #rows = # time points; # cols = # controls

%-------------------------------------------------------------------------%
%----------Provide Mesh Refinement Method and Initial Mesh ---------------%
%-------------------------------------------------------------------------%
mesh.method       = 'hp-PattersonRao';
mesh.tolerance    = 1e-7;
mesh.maxiterations = 2;
mesh.colpointsmin = 5;
mesh.colpointsmax = 10;

%-------------------------------------------------------------------------%
%------------- Assemble Information into Problem Structure ---------------%        
%-------------------------------------------------------------------------%
setup.name                        = 'Brachistochrone-Problem';
setup.functions.continuous        = @Continuous;
setup.functions.endpoint          = @Endpoint;
setup.auxdata                     = auxdata;
setup.bounds                      = bounds;
setup.guess                       = guess;
setup.mesh                        = mesh; 
setup.nlp.solver                  = 'ipopt';
setup.nlp.ipoptoptions.tolerance  = 10^-7;
setup.nlp.ipoptoptions.linear_solver = 'ma57'; % the default 'mumps' will have issues here
setup.derivatives.supplier        = 'sparseCD';
setup.derivatives.level           = 'first';
setup.method                      = 'RPM-Differentiation';

%-------------------------------------------------------------------------%
%------------------------- Solve Problem Using GPOP2 ---------------------%
%-------------------------------------------------------------------------%
 
GPOPSoutput = gpops2(setup);

end

function phaseout = Continuous(input)
%---------------------------------------------------%
% Classical Brachistochrone Problem:                %
%---------------------------------------------------%
% Dynamic constraints                %
%    dx/dt = v*sin(u)                               %
%    dy/dt = -v*cos(u)                              %
%    dv/dt = g*cos(u)                               %
%---------------------------------------------------%


g                 = input.auxdata.g;

t                 = input.phase.time;
x                 = input.phase.state(:,1);
y                 = input.phase.state(:,2);
v                 = input.phase.state(:,3);
u                 = input.phase.control;
xdot              = ;
ydot              = ;
vdot              = ;
phaseout.dynamics = [xdot, ydot, vdot]; % Matrix, size is equal to size of state matrix
end

function output = Endpoint(input)
% minimize t_f

output.objective = ;

end
