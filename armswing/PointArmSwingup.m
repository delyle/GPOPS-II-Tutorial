function output = PointArmSwingup(g,l,Tmax,s)

%-------------------------------------------------------------------%
%-------------------- Data Required by Problem ---------------------%
%-------------------------------------------------------------------%

% specify auxdata if not already done
auxdata.l = l;
auxdata.g = g;
auxdata.Tmax = Tmax;
auxdata.s = s;

%-------------------------------------------------------------------%
%------------------------- Variable Bounds -------------------------%
%-------------------------------------------------------------------%
% ----- PHASE 1 ----- %
i = 1;
bounds.phase(i).initialtime.lower = ;              % scalar
bounds.phase(i).initialtime.upper = ;              % scalar
bounds.phase(i).finaltime.lower = ;                % scalar
bounds.phase(i).finaltime.upper = ;                % scalar

bounds.phase(i).initialstate.lower = [,];           % row vector, length = numstates
bounds.phase(i).initialstate.upper = [,];           % row vector, length = numstates
bounds.phase(i).state.lower = [,];                  % row vector, length = numstates
bounds.phase(i).state.upper = [,];                  % row vector, length = numstates
bounds.phase(i).finalstate.lower = [,];             % row vector, length = numstates
bounds.phase(i).finalstate.upper = [,];             % row vector, length = numstates

bounds.phase(i).control.lower = ;                % row vector, length = numstates
bounds.phase(i).control.upper = ;                % row vector, length = numstates

bounds.phase(i).integral.lower = ;                 % row vector, length = numintegrals
bounds.phase(i).integral.upper = ;                 % row vector, length = numintegrals

%-------------------------------------------------------------------------%
%---------------------------- Provide Guess ------------------------------%
%-------------------------------------------------------------------------%
% ----- PHASE 1 ----- %
% RANDOM GUESS
% i = 1;
% guess.phase(i).time    = sort(rand(2,1));                % column vector, min length = 2
% guess.phase(i).state   = 2*pi*(rand(2,2)-1/2);                % array, min numrows = 2, numcols = numstates
% guess.phase(i).control = rand(2,1);                % array, min numrows = 2, numcols = numcontrols
% guess.phase(i).integral = rand;               % scalar

% GIVEN GUESS
i = 1;
guess.phase(i).time    = ;                % column vector, min length = 2
guess.phase(i).state   = ;                % array, min numrows = 2, numcols = numstates
guess.phase(i).control = ;                % array, min numrows = 2, numcols = numcontrols
guess.phase(i).integral = ;               % scalar

%-------------------------------------------------------------------------%
%----------Provide Mesh Refinement Method and Initial Mesh ---------------%
%-------------------------------------------------------------------------%

setup.mesh.maxiterations = 4;

%-------------------------------------------------------------------%
%--------------------------- Problem Setup -------------------------%
%-------------------------------------------------------------------%
setup.name                        = 'PtSwingUp';
setup.functions.continuous        = @Continuous;
setup.functions.endpoint          = @Endpoint;
setup.auxdata                     = auxdata; % not necessary
setup.bounds                      = bounds;
setup.guess                       = guess;
setup.nlp.solver = 'ipopt';
setup.nlp.ipoptoptions.maxiterations = 1000;
setup.derivatives.derivativelevel = 'first';


%-------------------------------------------------------------------%
%------------------- Solve Problem Using GPOPS2 --------------------%
%-------------------------------------------------------------------%
output = gpops2(setup);
end


function phaseout = Continuous(input)
% extract data
X = input.phase(1).state; %[ theta, omega] (angle, angular speed)
U = input.phase(1).control; % torque / ml^2
auxdata = input.auxdata; % auxdata.g is gravity, auxdata.l is arm length

thetadot = ; % provide derivative
thetaddot = ;

phaseout.dynamics = [thetadot,thetaddot];
phaseout.integrand = ;
end

function output = Endpoint(input)
output.objective = ; % objective function (scalar)
end