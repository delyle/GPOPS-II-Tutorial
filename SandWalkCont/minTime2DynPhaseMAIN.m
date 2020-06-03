u1 = 2;
u2 = 1;
W = 3;
H = 2;
h = 1;



GPOPSoutput =minTime2DynPhase(u1,u2,W,H,h);

T1 = GPOPSoutput.result.solution.phase(1).time(end);
T2 = GPOPSoutput.result.solution.phase(2).time(end);
disp(['T1 is ', num2str(T1)])
disp(['T2 is ', num2str(T2)])
objective = GPOPSoutput.result.objective;
disp(['Total time is ', num2str(objective)])
%%
minTime2PhasePlot(GPOPSoutput,u1,u2,W,H,h,true)

%% Iterations with random seeds; save result with minimum cost

u1 = 1;
u2 = 1;
W = 3;
h = 1;
H = 2;
Topt = 1e6;
tic
for i = 1:25
   GPOPSoutput =minTime2PhasePath(u1,u2,W,H,h);
   T = GPOPSoutput.result.objective;
   if T < Topt
       Topt = T;
       GPOPSoutputBest = GPOPSoutput;
   end
end
toc
minTime2PhasePlot(GPOPSoutputBest,u1,u2,W,H,h)
T1 = GPOPSoutputBest.result.solution.phase(1).time(end);
T2 = GPOPSoutputBest.result.solution.phase(2).time(end);
disp(['T1 is ', num2str(T1)])
disp(['T2 is ', num2str(T2)])
objective = GPOPSoutputBest.result.objective;
disp(['Total time is ', num2str(objective)])
