function resetcolor
% this function just resets the color order on the current axis.
% it just simplifies two lines of code that I hate writing out
% every time

ax = gca;
ax.ColorOrderIndex = 1;
end