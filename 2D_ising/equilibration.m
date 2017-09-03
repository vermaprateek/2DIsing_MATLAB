%Equilibration Run
%Evolve the system for a fixed number of steps
function [grid,E,d] = equilibration(n_grid,T,J,L,B)
grid=ones(n_grid,n_grid);
%grid = (rand(n_grid) > 0.5)*2 - 1;%generates random arrangement
for i=1:L
randcol = randi(n_grid,1);
randrow = randi(n_grid,1);
spin = grid(randrow,randcol);
if randcol == 1
neighleft = n_grid;
else
neighleft = randcol - 1;
end
if randcol == n_grid
neighright = 1;
else
neighright = randcol + 1;
end
if randrow == 1
neighup = n_grid;
else
neighup = randrow - 1;
end
if randrow == n_grid
neighdown = 1;
else
neighdown = randrow + 1;
end
% Calculate the number of neighbors of each cell
neighbors = grid(randrow,neighleft) + grid(randrow,neighright) + grid(neighup,randcol) + grid(neighdown,randcol);
% Calculate the change in energy of flipping a spin
oldE = -J * (spin * neighbors);
DeltaE = -2*oldE;
% Decide which transitions will occur
if DeltaE < 0
grid(randcol,randrow) = -grid(randcol,randrow);
else
p = exp(-DeltaE/T);
if rand(1) <= p
grid(randcol,randrow) = -grid(randcol,randrow);
end
end
% Sum up our variables of interest
E(i) = -0.25 * sum(DeltaE(:));
d(i) = i+1;
%Display the current state of the system (optional)
%image((grid+1)*128);
%xlabel(sprintf('T = %0.2f, M = %0.2f, E = %0.2f', T, M/N^2, E/N^2));
%set(gca,'YTickLabel',[],'XTickLabel',[]);
%axis square; colormap bone; drawnow;
end

end