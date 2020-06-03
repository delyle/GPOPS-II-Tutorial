function output = gpopstemplate(auxdata)

%-------------------------------------------------------------------%
%-------------------- Data Required by Problem ---------------------%
%-------------------------------------------------------------------%

% specify auxdata if not already done

%-------------------------------------------------------------------%
%------------------------- Variable Bounds -------------------------%
%-------------------------------------------------------------------%
% ----- PHASE 1 ----- %
i = 1;
bounds.phase(i).initialtime.lower = ;              % scalar
bounds.phase(i).initialtime.upper = ;              % scalar
bounds.phase(i).finaltime.lower = ;                % scalar
bounds.phase(i).finaltime.upper = ;                % scalar

bounds.phase(i).initialstate.lower = [];           % row vector, length = numstates
bounds.phase(i).initialstate.upper = [];           % row vector, length = numstates
bounds.phase(i).state.lower = [];                  % row vector, length = numstates
bounds.phase(i).state.upper = [];                  % row vector, length = numstates
bounds.phase(i).finalstate.lower = [];             % row vector, length = numstates
bounds.phase(i).finalstate.upper = [];             % row vector, length = numstates

bounds.phase(i).control.lower = [];                % row vector, length = numstates
bounds.phase(i).control.upper = [];                % row vector, length = numstates

bounds.phase(i).integral.lower = ;                 % row vector, length = numintegrals
bounds.phase(i).integral.upper = ;                 % row vector, length = numintegrals

bounds.parameter.lower = ;                      % row vector, length = numintegrals
bounds.parameter.upper = ;                      % row vector, length = numintegrals

% Endpoint constraints (if required)

bounds.eventgroup.lower = []; % row vector
bounds.eventgroup.upper = []; % row vector

% Path constraints (if required)

% ----- PHASE 1 ----- %
i = 1;
bounds.phase(i).path.lower = []; % row vector, length = number of path constraints in phase
bounds.phase(i).path.upper = []; % row vector, length = number of path constraints in phase
%-------------------------------------------------------------------------%
%---------------------------- Provide Guess ------------------------------%
%-------------------------------------------------------------------------%
% ----- PHASE 1 ----- %
i = 1;
guess.phase(i).time    = [];                % column vector, min length = 2
guess.phase(i).state   = [];                % array, min numrows = 2, numcols = numstates
guess.phase(i).control = [];                % array, min numrows = 2, numcols = numcontrols
guess.phase(i).integral = [];               % scalar

guess.parameter = [];                    % row vector, numrows = numparams


%-------------------------------------------------------------------------%
%----------Provide Mesh Refinement Method and Initial Mesh ---------------%
%-------------------------------------------------------------------------%

% not required

%-------------------------------------------------------------------%
%--------------------------- Problem Setup -------------------------%
%-------------------------------------------------------------------%
setup.name                        = 'providename';
setup.functions.continuous        = @Continuous;
setup.functions.endpoint          = @Endpoint;
setup.auxdata                     = auxdata; % not necessary
setup.bounds                      = bounds;
setup.guess                       = guess;

setup.derivatives.derivativelevel = 'first';


%-------------------------------------------------------------------%
%------------------- Solve Problem Using GPOPS2 --------------------%
%-------------------------------------------------------------------%
output = gpops2(setup);
end


function phaseout = Continuous(input)

% extract data
t = input.phase(1).time;
X = input.phase(1).state;
U = input.phase(1).control;
P = input.phase(1).parameter;

xdot = ; % provide derivative

phaseout.dynamics = xdot;
phaseout.integrand = ; 
phaseout.path = ; % path constraints, matrix of size num collocation points X num path constraints
end

function output = Endpoint(input)

output.eventgroup.event = ; % event constraints (row vector)
output.objective = ; % objective function (scalar)
end