function output = longjump(D,Lmin,Lmax,Fmax,g)

%-------------------------------------------------------------------%
%-------------------- Data Required by Problem ---------------------%
%-------------------------------------------------------------------%

% specify auxdata if not already done

auxdata.Lmax = Lmax;
auxdata.D = D;
auxdata.g = g;
auxdata.Fmax = Fmax;
auxdata.Lmin = Lmin;
%-------------------------------------------------------------------%
%------------------------- Variable Bounds -------------------------%
%-------------------------------------------------------------------%
% ----- PHASE 1 ----- %
i = 1;
bounds.phase(i).initialtime.lower = 0;              % scalar
bounds.phase(i).initialtime.upper = 0;              % scalar
bounds.phase(i).finaltime.lower = 0.01;                % scalar
bounds.phase(i).finaltime.upper = Inf;                % scalar

xmin = 0;
bounds.phase(i).initialstate.lower = [xmin 0 0 0];           % row vector, length = numstates
bounds.phase(i).initialstate.upper = [Lmax Lmax 0 0];           % row vector, length = numstates
bounds.phase(i).state.lower = [xmin 0 0 -Inf];                  % row vector, length = numstates
bounds.phase(i).state.upper = [Lmax Lmax Inf Inf];                  % row vector, length = numstates
bounds.phase(i).finalstate.lower = [xmin 0 0 -Inf];             % row vector, length = numstates
bounds.phase(i).finalstate.upper = [Lmax Lmax Inf Inf];             % row vector, length = numstates

bounds.phase(i).control.lower = 0;                % row vector, length = numstates
bounds.phase(i).control.upper = Fmax;                % row vector, length = numstates


% ----- PHASE 2 ----- %
i = 2;
bounds.phase(i).initialtime.lower = 0;              % scalar
bounds.phase(i).initialtime.upper = 0;              % scalar
bounds.phase(i).finaltime.lower = 0.01;                % scalar
bounds.phase(i).finaltime.upper = Inf;                % scalar

bounds.phase(i).initialstate.lower = [-Lmax 0 0 -Inf];           % row vector, length = numstates
bounds.phase(i).initialstate.upper = [ Lmax Lmax Inf Inf];           % row vector, length = numstates
bounds.phase(i).state.lower = [-Lmax 0 0  -Inf];                  % row vector, length = numstates
bounds.phase(i).state.upper = [ Lmax Lmax Inf Inf];                  % row vector, length = numstates
bounds.phase(i).finalstate.lower = [-Lmax 0 0 -Inf];             % row vector, length = numstates
bounds.phase(i).finalstate.upper = [ Lmax Lmax Inf Inf];             % row vector, length = numstates

bounds.phase(i).control.lower = 0;                % row vector, length = numstates
bounds.phase(i).control.upper = Fmax;                % row vector, length = numstates


bounds.parameter.lower = 0;                      % row vector, length = numintegrals
bounds.parameter.upper = D;                      % row vector, length = numintegrals

% Endpoint constraints (if required)

bounds.eventgroup.lower = [0.01   0 0 0]; % row vector
bounds.eventgroup.upper = [Inf 0 0 0]; % row vector

% Path constraints (if required)

% ----- PHASE 1 ----- %
i = 1;
bounds.phase(i).path.lower = Lmin^2; % row vector, length = number of path constraints in phase
bounds.phase(i).path.upper = Lmax^2; % row vector, length = number of path constraints in phase
% ----- PHASE 2 ----- %
i = 2;
bounds.phase(i).path.lower = Lmin^2; % row vector, length = number of path constraints in phase
bounds.phase(i).path.upper = Lmax^2; % row vector, length = number of path constraints in phase
%-------------------------------------------------------------------------%
%---------------------------- Provide Guess ------------------------------%
%-------------------------------------------------------------------------%
%%% RANDOM GUESS %%%
% ----- PHASE 1 ----- %
i = 1;
rng('shuffle')
guess.phase(i).time    = sort(rand(2,1));                % column vector, min length = 2
guess.phase(i).state   = [Lmax Lmax 0 0;Lmax Lmax 10 10].*rand(2,4);                % array, min numrows = 2, numcols = numstates
guess.phase(i).control = Fmax*rand(2,1);                % array, min numrows = 2, numcols = numcontrols

% ----- PHASE 2 ----- %
i = 2;
guess.phase(i).time    = sort(rand(2,1));                % column vector, min length = 2
guess.phase(i).state   = [Lmax*(2*sort(rand(2,1))-1) Lmax*rand(2,1) 10*rand(2,2)];% array, min numrows = 2, numcols = numstates
guess.phase(i).control = Fmax*rand(2,1);                % array, min numrows = 2, numcols = numcontrols

guess.parameter = D*rand;                    % row vector, numrows = numparams


% %%% DECENT GUESS %%%
% % ----- PHASE 1 ----- %
% i = 1;
% guess.phase(i).time    = [0;1];                % column vector, min length = 2
% guess.phase(i).state   = [0.1*Lmax 0.9*Lmax 0 0; sqrt(1/2)*[Lmax Lmax] 1 1];                % array, min numrows = 2, numcols = numstates
% guess.phase(i).control = [1; Fmax];                % array, min numrows = 2, numcols = numcontrols
% 
% % ----- PHASE 2 ----- %
% i = 2;
% guess.phase(i).time    = [0;1];                % column vector, min length = 2
% guess.phase(i).state   = [sqrt(1/2)*[-Lmax Lmax] 1 -1; sqrt(1/2)*[Lmax Lmax] 1 1];                % array, min numrows = 2, numcols = numstates
% guess.phase(i).control = [Fmax; Fmax];                % array, min numrows = 2, numcols = numcontrols
% 
% guess.parameter = D/2;                    % row vector, numrows = numparams
% 
% 
% 




%-------------------------------------------------------------------------%
%----------Provide Mesh Refinement Method and Initial Mesh ---------------%
%-------------------------------------------------------------------------%

% not required
setup.mesh.maxiterations = 5;


%-------------------------------------------------------------------%
%--------------------------- Problem Setup -------------------------%
%-------------------------------------------------------------------%
setup.name                        = 'LongJump';
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

output.eventgroup.event = endpt; % event constraints (row vector)
output.objective = -xf; % objective function (scalar)

end