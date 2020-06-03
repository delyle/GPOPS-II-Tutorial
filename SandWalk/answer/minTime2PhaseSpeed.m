function output = minTime2PhaseSpeed(u1,u2,W,H,h)

%-------------------------------------------------------------------%
%-------------------- Data Required by Problem ---------------------%
%-------------------------------------------------------------------%

% specify auxdata if not already done

%-------------------------------------------------------------------%
%------------------------- Variable Bounds -------------------------%
%-------------------------------------------------------------------%
% ----- PHASE 1 ----- %
i = 1;
bounds.phase(i).initialtime.lower = 0;              % scalar
bounds.phase(i).initialtime.upper = 0;              % scalar
bounds.phase(i).finaltime.lower = 1e-6;                % scalar
bounds.phase(i).finaltime.upper = Inf;                % scalar

bounds.phase(i).initialstate.lower = [0,0];           % row vector, length = numstates
bounds.phase(i).initialstate.upper = [0,0];           % row vector, length = numstates
bounds.phase(i).state.lower = [0,0];                  % row vector, length = numstates
bounds.phase(i).state.upper = [W,h];                  % row vector, length = numstates
bounds.phase(i).finalstate.lower = [0,h];             % row vector, length = numstates
bounds.phase(i).finalstate.upper = [W,h];             % row vector, length = numstates

bounds.phase(i).control.lower = [0,0];                % row vector, length = numstates
bounds.phase(i).control.upper = [u1,pi/2];                % row vector, length = numstates

% ----- PHASE 2 ----- %
i = 2;
bounds.phase(i).initialtime.lower = 0;              % scalar
bounds.phase(i).initialtime.upper = 0;              % scalar
bounds.phase(i).finaltime.lower = 1e-6;                % scalar
bounds.phase(i).finaltime.upper = Inf;                % scalar

bounds.phase(i).initialstate.lower = [0,h];           % row vector, length = numstates
bounds.phase(i).initialstate.upper = [W,h];           % row vector, length = numstates
bounds.phase(i).state.lower = [0,h];                  % row vector, length = numstates
bounds.phase(i).state.upper = [W,H];                  % row vector, length = numstates
bounds.phase(i).finalstate.lower = [W,H];             % row vector, length = numstates
bounds.phase(i).finalstate.upper = [W,H];             % row vector, length = numstates

bounds.phase(i).control.lower = [0,0];                % row vector, length = numstates
bounds.phase(i).control.upper = [u2,pi/2];                % row vector, length = numstates

%bounds.phase(i).integral.lower = ;                 % row vector, length = numintegrals
%bounds.phase(i).integral.upper = ;                 % row vector, length = numintegrals

%bounds.parameter.lower = ;                      % row vector, length = numintegrals
%bounds.parameter.upper = ;                      % row vector, length = numintegrals

% Endpoint constraints (if required)

bounds.eventgroup.lower = [0]; % row vector
bounds.eventgroup.upper = [0]; % row vector

% Path constraints (if required)

% % ----- PHASE 1 ----- %
% i = 1;
% bounds.phase(i).path.lower = [0]; % row vector, length = number of path constraints in phase
% bounds.phase(i).path.upper = [u1^2]; % row vector, length = number of path constraints in phase
% 
% % ----- PHASE 2 ----- %
% i = 2;
% bounds.phase(i).path.lower = [0]; % row vector, length = number of path constraints in phase
% bounds.phase(i).path.upper = [u2^2]; % row vector, length = number of path constraints in phase
%-------------------------------------------------------------------------%
%---------------------------- Provide Guess ------------------------------%
%-------------------------------------------------------------------------%

% %%%% PROBLEMATIC GUESS %%%%
% % ----- PHASE 1 ----- %
% i = 1;
% guess.phase(i).time    = [0;1];                % column vector, min length = 2
% guess.phase(i).state   = [0,0;W/2,h];                % array, min numrows = 2, numcols = numstates
% guess.phase(i).control = [u1,u1;u1,u1];                % array, min numrows = 2, numcols = numcontrols
% %guess.phase(i).integral = [];               % scalar
% 
% % ----- Phase 2 ----- %
% i = 2;
% guess.phase(i).time    = [0;1];                % column vector, min length = 2
% guess.phase(i).state   = [W/2,h;W,H];                % array, min numrows = 2, numcols = numstates
% guess.phase(i).control = [u2,u2;u2,u2];                % array, min numrows = 2, numcols = numcontrols

%%%% RANDOM GUESS %%%%
% ----- PHASE 1 ----- %
i = 1;
guess.phase(i).time    = [0;rand];                % column vector, min length = 2
guess.phase(i).state   = [0,0;rand*W,h];                % array, min numrows = 2, numcols = numstates
guess.phase(i).control = [u1*rand(2,1),2*pi*rand(2,1)];                % array, min numrows = 2, numcols = numcontrols
%guess.phase(i).integral = [];               % scalar

% ----- Phase 2 ----- %
i = 2;
guess.phase(i).time    = [0;rand];                % column vector, min length = 2
guess.phase(i).state   = [rand*W,h;W,H];                % array, min numrows = 2, numcols = numstates
guess.phase(i).control = [u2*rand(2,1),2*pi*rand(2,1)];                % array, min numrows = 2, numcols = numcontrols



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
%setup.auxdata                     = auxdata; % not necessary
setup.bounds                      = bounds;
setup.guess                       = guess;
setup.nlp.solver = 'ipopt';
setup.derivatives.derivativelevel = 'first';
%setup.displaylevel = 0;

%-------------------------------------------------------------------%
%------------------- Solve Problem Using GPOPS2 --------------------%
%-------------------------------------------------------------------%
output = gpops2(setup);
end


function phaseout = Continuous(input)

% extract data
%t = input.phase(1).time;
%X = input.phase(1).state;
U1 = input.phase(1).control;
%P = input.phase(1).parameter;

xdot1 = U1(:,1)*[1 1].*[cos(U1(:,2)),sin(U1(:,2))]; % provide derivative

phaseout(1).dynamics = xdot1;

U2 = input.phase(2).control;

xdot2 = U2(:,1)*[1 1].*[cos(U2(:,2)),sin(U2(:,2))]; % provide derivative
phaseout(2).dynamics = xdot2;

%phaseout.integrand = ; 
% phaseout(1).path = sum(U1.^2,2); % path constraints, matrix of size num collocation points X num path constraints
% phaseout(2).path = sum(U2.^2,2); % path constraints, matrix of size num collocation points X num path constraints
end

function output = Endpoint(input)
XF1 = input.phase(1).finalstate;
XI2 = input.phase(2).initialstate;
T1 = input.phase(1).finaltime;
T2 = input.phase(2).finaltime;

output.eventgroup.event = XF1(1) - XI2(1); % event constraints (row vector)
output.objective = T1 + T2; % objective function (scalar)
end