function output = PointArmSwingupWork(g,l,Tmax,Umax,s)

%-------------------------------------------------------------------%
%-------------------- Data Required by Problem ---------------------%
%-------------------------------------------------------------------%

% specify auxdata if not already done
auxdata.l = l;
auxdata.g = g;
auxdata.Tmax = Tmax;
auxdata.Umax = Umax;
auxdata.s = s;

%-------------------------------------------------------------------%
%------------------------- Variable Bounds -------------------------%
%-------------------------------------------------------------------%
% ----- PHASE 1 ----- %
i = 1;
bounds.phase(i).initialtime.lower = 0;              % scalar
bounds.phase(i).initialtime.upper = 0;              % scalar
bounds.phase(i).finaltime.lower = 1e-6;                % scalar
bounds.phase(i).finaltime.upper = Tmax;                % scalar

bounds.phase(i).initialstate.lower = [0,0];           % row vector, length = numstates
bounds.phase(i).initialstate.upper = [0,0];           % row vector, length = numstates
bounds.phase(i).state.lower = [-pi,-Inf];                  % row vector, length = numstates
bounds.phase(i).state.upper = [pi,Inf];                  % row vector, length = numstates
bounds.phase(i).finalstate.lower = [pi,0];             % row vector, length = numstates
bounds.phase(i).finalstate.upper = [pi,0];             % row vector, length = numstates

bounds.phase(i).control.lower = -Umax;                % row vector, length = numstates
bounds.phase(i).control.upper = Umax;                % row vector, length = numstates

bounds.phase(i).integral.lower = 0;                 % row vector, length = numintegrals
bounds.phase(i).integral.upper = Inf;                 % row vector, length = numintegrals

%-------------------------------------------------------------------------%
%---------------------------- Provide Guess ------------------------------%
%-------------------------------------------------------------------------%
% ----- PHASE 1 ----- %
i = 1;
rng('shuffle')
guess.phase(i).time    = [0;rand];                % column vector, min length = 2
guess.phase(i).state   = 2*pi*(rand(2,2)-1/2);                % array, min numrows = 2, numcols = numstates
guess.phase(i).control = rand*[Umax;-Umax];                % array, min numrows = 2, numcols = numcontrols
guess.phase(i).integral = rand;               % scalar

%-------------------------------------------------------------------------%
%----------Provide Mesh Refinement Method and Initial Mesh ---------------%
%-------------------------------------------------------------------------%

setup.mesh.maxiterations = 4;
setup.mesh.maxerror = 1e-6;

%-------------------------------------------------------------------%
%--------------------------- Problem Setup -------------------------%
%-------------------------------------------------------------------%
setup.name                        = 'PtSwingUpWork';
setup.functions.continuous        = @Continuous;
setup.functions.endpoint          = @Endpoint;
setup.auxdata                     = auxdata; % not necessary
setup.bounds                      = bounds;
setup.guess                       = guess;
setup.nlp.solver = 'ipopt';
setup.nlp.ipoptoptions.tolerance = 1e-9;
setup.nlp.ipoptoptions.maxiterations = 1000;
%setup.nlp.snoptoptions.tolerance = 1e-10;
%setup.derivatives.supplier = 'adigator';
setup.derivatives.derivativelevel = 'first';


%-------------------------------------------------------------------%
%------------------- Solve Problem Using GPOPS2 --------------------%
%-------------------------------------------------------------------%
output = gpops2(setup);
end


function phaseout = Continuous(input)
% extract data
X = input.phase(1).state;
U = input.phase(1).control;
auxdata = input.auxdata;

thetadot = X(:,2); % provide derivative
thetaddot = U - auxdata.g*sin(X(:,1))/auxdata.l;

phaseout.dynamics = [thetadot,thetaddot];
x = U.*thetadot;
phaseout.integrand = x.*tanh(x/auxdata.s);
end

function output = Endpoint(input)
output.objective = input.phase.integral; % objective function (scalar)
end