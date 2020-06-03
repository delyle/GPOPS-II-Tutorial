function output = minTime2Phase(u1,u2,W,H,h)

%-------------------------------------------------------------------%
%-------------------- Data Required by Problem ---------------------%
%-------------------------------------------------------------------%

% specify auxdata if not already done; not necessary for this problem

%-------------------------------------------------------------------%
%------------------------- Variable Bounds -------------------------%
%-------------------------------------------------------------------%
% ----- PHASE 1 ----- %
i = 1;
bounds.phase(i).initialtime.lower = ;              % scalar
bounds.phase(i).initialtime.upper = ;              % scalar
bounds.phase(i).finaltime.lower = ;                % scalar
bounds.phase(i).finaltime.upper = ;                % scalar

bounds.phase(i).initialstate.lower = ;          % row vector, length = numstates
bounds.phase(i).initialstate.upper = ;           % row vector, length = numstates
bounds.phase(i).state.lower = ;                  % row vector, length = numstates
bounds.phase(i).state.upper = ;                  % row vector, length = numstates
bounds.phase(i).finalstate.lower = ;             % row vector, length = numstates
bounds.phase(i).finalstate.upper = ;             % row vector, length = numstates

bounds.phase(i).control.lower = ;                % row vector, length = numstates
bounds.phase(i).control.upper = ;                % row vector, length = numstates

% ----- PHASE 2 ----- %
i = 2;
bounds.phase(i).initialtime.lower = ;              % scalar
bounds.phase(i).initialtime.upper = ;              % scalar
bounds.phase(i).finaltime.lower = ;                % scalar
bounds.phase(i).finaltime.upper = ;                % scalar

bounds.phase(i).initialstate.lower = ;           % row vector, length = numstates
bounds.phase(i).initialstate.upper = ;           % row vector, length = numstates
bounds.phase(i).state.lower = ;                  % row vector, length = numstates
bounds.phase(i).state.upper = ;                  % row vector, length = numstates
bounds.phase(i).finalstate.lower = ;             % row vector, length = numstates
bounds.phase(i).finalstate.upper = ;             % row vector, length = numstates

bounds.phase(i).control.lower = ;                % row vector, length = numstates
bounds.phase(i).control.upper = ;                % row vector, length = numstates

% Path constraints (if required)

% ----- PHASE 1 ----- %
i = 1;
bounds.phase(i).path.lower = ; % row vector, length = number of path constraints in phase
bounds.phase(i).path.upper = ; % row vector, length = number of path constraints in phase

% Endpoint constraints (if required)

bounds.eventgroup.lower = ; % row vector
bounds.eventgroup.upper = ; % row vector


%-------------------------------------------------------------------------%
%---------------------------- Provide Guess ------------------------------%
%-------------------------------------------------------------------------%

%%%% RANDOM GUESS %%%%
% ----- PHASE 1 ----- %
i = 1;
guess.phase(i).time    = [0;rand];                % column vector, min length = 2
guess.phase(i).state   = [0,0;rand*W,h];                % array, min numrows = 2, numcols = numstates
guess.phase(i).control = u1*rand(2,2);                % array, min numrows = 2, numcols = numcontrols


%-------------------------------------------------------------------------%
%----------Provide Mesh Refinement Method and Initial Mesh ---------------%
%-------------------------------------------------------------------------%

% not required

%-------------------------------------------------------------------%
%--------------------------- Problem Setup -------------------------%
%-------------------------------------------------------------------%
setup.name                        = 'SandWalk';
setup.functions.continuous        = @Continuous;
setup.functions.endpoint          = @Endpoint;
%setup.auxdata                     = auxdata; % not necessary
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

% ---- Phase 1 ---- %
t1 = input.phase(1).time;
X1 = input.phase(1).state;
U1 = input.phase(1).control;

xdot1 = ; % provide derivative

phaseout(1).dynamics = xdot1;

phaseout(1).path = ; % path constraints, matrix of size num collocation points X num path constraints

% ---- Phase 2 ---- %
t2 = input.phase(2).time;
X2 = input.phase(2).state;
U2 = input.phase(2).control;

xdot2 = ;

phaseout(2).dynamics = xdot2;

phaseout(2).path = ; % path constraints, matrix of size num collocation points X num path constraints
end

function output = Endpoint(input)
XF1 = ; % final state 1
XI2 = ; % initial state 2 
T1 = ; % final time 1
T2 = ; % final time 2

output.eventgroup.event = ; % event constraints (row vector)
output.objective = ; % objective function (scalar)
end