function brachistochronePlot(GPOPSoutput)

o = GPOPSoutput;

X = o.result.solution.phase.state;

figure('color','w');
plot(X(:,1),X(:,2),'bo')
A = X(1,[1,2]);
B = X(end,[1,2]);
[x,y] = brachistochroneAnalytic(A,B);
hold on
plot(x,y,'r--')
xlabel('x')
ylabel('y')
legend('GPOPS solution','Analytic solution')

