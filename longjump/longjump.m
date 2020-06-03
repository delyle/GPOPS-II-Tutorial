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
bounds.phase(i).initialtime.lower = ;              % scalar
bounds.phase(i).initialtime.upper = ;              % scalar
bounds.phase(i).finaltime.lower = ;                % scalar
bounds.phase(i).finaltime.upper = ;                % scalar

xmin = 0;
bounds.phase(i).initialstate.lower = [xmin 0 0 0];           % row vector, length = numstates
bounds.phase(i).initialstate.upper = [Lmax Lmax 0 0];           % row vector, length = numstates
bounds.phase(i).state.lower = [xmin 0 0 -Inf];                  % row vector, length = numstates
bounds.phase(i).state.upper = [Lmax Lmax Inf Inf];                  % row vector, length = numstates
bounds.phase(i).finalstate.lower = [xmin 0 0 -Inf];             % row vector, length = numstates
bounds.phase(i).finalstate.upper = [Lmax Lmax Inf Inf];             % row vector, length = numstates

bounds.phase(i).control.lower = 0;                % row vector, length = numstates
bounds.phase(i).control.upper = Fmax;                % row vector, length = numstates

% Path constraints (if required)

% ----- PHASE 1 ----- %
i = 1;
bounds.phase(i).path.lower = Lmin^2; % row vector, length = number of path constraints in phase
bounds.phase(i).path.upper = Lmax^2; % row vector, length = number of path constraints in phase


%%%% ^^^^^^PUT ALL CONTINUOUS TIME BOUNDS UP HERE!^^^^^^ %%%%

% Phase independent
bounds.parameter.lower = ;                      % row vector, length = numintegrals
bounds.parameter.upper = ;                      % row vector, length = numintegrals

% Endpoint constraints. You'll need one inequality constraint, and three
% equality constraints!

bounds.eventgroup.lower = [0.01,0,0,0]; % row vector 
bounds.eventgroup.upper = [Inf,0,0,0]; % row vector

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
F1 = input.phase(1).control;
aux = input.auxdata;
g = aux.g;



phaseout(1).dynamics = ;
phaseout(1).path = ; % path constraints, matrix of size num collocation points X num path constraints



end

function output = Endpoint(input)


% we'll do this part together
aux = input.auxdata;
X1f = input.phase(1).finalstate;
X2i = input.phase(2).initialstate;
X2f = input.phase(2).finalstate;
d  = input.parameter;

% Fill out the rest of the function with the appropriate endpoint
% conditions and objective function

x1f = X1f(1);
x2i = X2i(1);
y1f = X1f(2); % vertical position at end of phase 1 
y2i = X2i(2); % vertical position at start of phase 2
u1f = X1f(3); % horizontal velocity at end of phase 1
u2i = X2i(3); % horizontal velocity at start of phase 2
v1f = X1f(4); % vertical velocity at end of phase 1
v2i = X2i(4); % vertical velocity at start of phase 2
T1flight = (x2i - x1f + d)/u1f; % flight time after phase 1
yland = v1f*T1flight - 1/2*aux.g*T1flight^2 + y1f; % landing height after first ballistic phase
vland = v1f - aux.g*T1flight; % vertical landing velocity after first ballistic phase


endpt(1) = T1flight; 
endpt(2) = ;
endpt(3) = ;
endpt(4) = ;

x2f = X2f(1); % horizontal position at end of phase 2
y2f = X2f(2); % vertical position at end of phase 2
u2f = X2f(3); % horizontal speed at end of phase 2
v2f = X2f(4); % vertical speed at end of phase 2
T2flight = (v2f + sqrt(v2f^2 + 2*aux.g*y2f))/aux.g; %flight time after phase 2


output.eventgroup.event = endpt; % event constraints (row vector)
output.objective = ; % objective function (scalar)

end