g = 10;
D = 5;
Lmin = 2/3;
Lmax = 1;
Fmax = 5*g;

GPOPSoutput = longjump(D,Lmin,Lmax,Fmax,g);

close all
plotLongjump(GPOPSoutput,true,true)

%%
t1 = GPOPSoutput.result.interpsolution.phase(1).time;
t2 = GPOPSoutput.result.interpsolution.phase(2).time;
F1 = GPOPSoutput.result.interpsolution.phase(1).control;
F2 = GPOPSoutput.result.interpsolution.phase(2).control;

figure;
subplot(2,1,1)
plot(t1,F1)
subplot(2,1,2)
plot(t2,F2)
