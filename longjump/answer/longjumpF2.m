function output = longjumpF2(D,L,Fmax,g)

%-------------------------------------------------------------------%
%-------------------- Data Required by Problem ---------------------%
%-------------------------------------------------------------------%

% specify auxdata if not already done

auxdata.L = L;
auxdata.D = D;
auxdata.g = g;
auxdata.Fmax = Fmax;

%-------------------------------------------------------------------%
%------------------------- Variable Bounds -------------------------%
%-------------------------------------------------------------------%
% ----- PHASE 1 ----- %
i = 1;
bounds.phase(i).initialtime.lower = 0;              % scalar
bounds.phase(i).initialtime.upper = 0;              % scalar
bounds.phase(i).finaltime.lower = 0.01;                % scalar
bounds.phase(i).finaltime.upper = Inf;                % scalar

bounds.phase(i).initialstate.lower = [0 0 0 0];           % row vector, length = numstates
bounds.phase(i).initialstate.upper = [L L 0 0];           % row vector, length = numstates
bounds.phase(i).state.lower = [0 0 0 -Inf];                  % row vector, length = numstates
bounds.phase(i).state.upper = [L L Inf Inf];                  % row vector, length = numstates
bounds.phase(i).finalstate.lower = [0 0 0 -Inf];             % row vector, length = numstates
bounds.phase(i).finalstate.upper = [L L Inf Inf];             % row vector, length = numstates

bounds.phase(i).control.lower = 0;                % row vector, length = numstates
bounds.phase(i).control.upper = Fmax;                % row vector, length = numstates

bounds.phase(i).integral.lower = 0;
bounds.phase(i).integral.upper = Inf;

% ----- PHASE 2 ----- %
i = 2;
bounds.phase(i).initialtime.lower = 0;              % scalar
bounds.phase(i).initialtime.upper = 0;              % scalar
bounds.phase(i).finaltime.lower = 0.01;                % scalar
bounds.phase(i).finaltime.upper = Inf;                % scalar

bounds.phase(i).initialstate.lower = [-L 0 0 -Inf];           % row vector, length = numstates
bounds.phase(i).initialstate.upper = [+L L Inf Inf];           % row vector, length = numstates
bounds.phase(i).state.lower = [-L 0 0  -Inf];                  % row vector, length = numstates
bounds.phase(i).state.upper = [+L L Inf Inf];                  % row vector, length = numstates
bounds.phase(i).finalstate.lower = [-L 0 0 -Inf];             % row vector, length = numstates
bounds.phase(i).finalstate.upper = [+L L Inf Inf];             % row vector, length = numstates

bounds.phase(i).control.lower = 0;                % row vector, length = numstates
bounds.phase(i).control.upper = Fmax;                % row vector, length = numstates

bounds.phase(i).integral.lower = 0;
bounds.phase(i).integral.upper = Inf;

bounds.parameter.lower = 0;                      % row vector, length = numintegrals
bounds.parameter.upper = D;                      % row vector, length = numintegrals

% Endpoint constraints (if required)

bounds.eventgroup.lower = [0.01   0 0 0 0]; % row vector
bounds.eventgroup.upper = [Inf 0 0 0 0]; % row vector

% Path constraints (if required)

% ----- PHASE 1 ----- %
i = 1;
bounds.phase(i).path.lower = 0; % row vector, length = number of path constraints in phase
bounds.phase(i).path.upper = 0; % row vector, length = number of path constraints in phase
% ----- PHASE 2 ----- %
i = 1;
bounds.phase(i).path.lower = 0; % row vector, length = number of path constraints in phase
bounds.phase(i).path.upper = 0; % row vector, length = number of path constraints in phase
%-------------------------------------------------------------------------%
%---------------------------- Provide Guess ------------------------------%
%-------------------------------------------------------------------------%
% ----- PHASE 1 ----- %
i = 1;
guess.phase(i).time    = sort(rand(2,1));                % column vector, min length = 2
guess.phase(i).state   = [L L 0 0;L L 10 10].*rand(2,4);                % array, min numrows = 2, numcols = numstates
guess.phase(i).control = Fmax*rand(2,1);                % array, min numrows = 2, numcols = numcontrols
guess.phase(i).integral = rand;

% ----- PHASE 2 ----- %
i = 2;
guess.phase(i).time    = sort(rand(2,1));                % column vector, min length = 2
guess.phase(i).state   = [L*(2*sort(rand(2,1))-1) L*rand(2,1) 10*rand(2,2)];% array, min numrows = 2, numcols = numstates
guess.phase(i).control = Fmax*rand(2,1);                % array, min numrows = 2, numcols = numcontrols
guess.phase(i).integral = rand;

guess.parameter = D*rand;                    % row vector, numrows = numparams


%-------------------------------------------------------------------------%
%----------Provide Mesh Refinement Method and Initial Mesh ---------------%
%-------------------------------------------------------------------------%

% not required
setup.mesh.maxiterations = 5;


%-------------------------------------------------------------------%
%--------------------------- Problem Setup -------------------------%
%-------------------------------------------------------------------%
setup.name                        = 'longjumpF2';
setup.functions.continuous        = @Continuous;
setup.functions.endpoint          = @Endpoint;
setup.auxdata                     = auxdata; % not necessary
setup.bounds                      = bounds;
setup.guess                       = guess;
setup.nlp.solver                  = 'ipopt';

setup.derivatives.derivativelevel = 'first';


%-------------------------------------------------------------------%
%------------------- Solve Problem Using GPOPS2 --------------------%
%-------------------------------------------------------------------%
output = gpops2(setup);
end


function phaseout = Continuous(input)

% extract data
X1 = input.phase(1).state;
F = input.phase(1).control;
aux = input.auxdata;

x                 = X1(:,1);
y                 = X1(:,2);
u                 = X1(:,3);
v                 = X1(:,4);
l                 = sqrt(x.^2 + y.^2);
xdot              = u;
ydot              = v;
udot              = F.*x./l;
vdot              = F.*y./l - aux.g;

phaseout(1).dynamics = [xdot, ydot, udot, vdot];
phaseout(1).path = l.^2; % path constraints, matrix of size num collocation points X num path constraints
phaseout(1).integrand = F.^2;

X2 = input.phase(2).state;
F = input.phase(2).control;


x                 = X2(:,1);
y                 = X2(:,2);
u                 = X2(:,3);
v                 = X2(:,4);
l                 = sqrt(x.^2 + y.^2);
xdot              = u;
ydot              = v;
udot              = F.*x./l;
vdot              = F.*y./l - aux.g;

phaseout(2).dynamics = [xdot, ydot, udot, vdot];
phaseout(2).path = l.^2; % path constraints, matrix of size num collocation points X num path constraints
phaseout(2).integrand = F.^2;
end

function output = Endpoint(input)

aux = input.auxdata;
X1f = input.phase(1).finalstate;
X2i = input.phase(2).initialstate;
X2f = input.phase(2).finalstate;
d  = input.parameter;

x1f = X1f(1);
x2i = X2i(1);
y1f = X1f(2);
y2i = X2i(2);
u1f = X1f(3);
u2i = X2i(3);
v1f = X1f(4);
v2i = X2i(4);


T1flight = (x2i - x1f + d)/u1f;
endpt(1) = T1flight;
endpt(2) = u2i - u1f;
endpt(3) = v1f*T1flight - 1/2*aux.g*T1flight^2 + y1f - y2i;
endpt(4) = v1f - aux.g*T1flight - v2i;

x2f = X2f(1);
y2f = X2f(2);
u2f = X2f(3);
v2f = X2f(4);


T2flight = (v2f + sqrt(v2f^2 + 2*aux.g*y2f))/aux.g;
xf = u2f*T2flight + x2f + d;
endpt(5) = xf - aux.D;

output.eventgroup.event = endpt; % event constraints (row vector)
output.objective = sum([input.phase(:).integral]); % objective function (scalar)
end