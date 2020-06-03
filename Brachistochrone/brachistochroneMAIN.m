%% Once you have coded brachistochroneGPOPS, run this section. 
% Do the blue points align with the red line?

B = [2,-1];

GPOPSoutput = brachistochroneGPOPS(B);

close all
brachistochronePlot(GPOPSoutput)

% Once you get a good solution, play around with values of B

%% With a fully-functional GPOPS function, try optimizing this point
B = [2,+1];

GPOPSoutput = brachistochroneGPOPS(B);
close all
brachistochronePlot(GPOPSoutput)

% What happens? Note the GPOPS / IPOPT output