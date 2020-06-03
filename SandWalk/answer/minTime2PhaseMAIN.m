% Solve the Sand-Walk problem by modifying minTime2Phase.m

u1 = 4;
u2 = 2;
W = 4;
H = 3;
h = 2;

GPOPSoutput =minTime2Phase(u1,u2,W,H,h);
minTime2PhasePlot(GPOPSoutput,u1,u2,W,H,h,true)