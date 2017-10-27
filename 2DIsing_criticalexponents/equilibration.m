%%%%%%%%%%% Equilibration Run %%%%%%%%%%%%%

function [grid,E,d] = equilibration(n_grid,T,J,L,B)

grid = (rand(n_grid) > 0.5)*2 - 1;%generates random arrangement

for i=1:L
randcol = randi(n_grid,1);
randrow = randi(n_grid,1);
spin = grid(randrow,randcol);

%Periodic Boundary Conditions
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

%neighbors of each site
neighbors = grid(randrow,neighleft) + grid(randrow,neighright) + grid(neighup,randcol) + grid(neighdown,randcol);

%change in energy by a spin flip
oldE = -J * (spin * neighbors);
DeltaE = -2*oldE;

%Decide which transitions will occur
if DeltaE < 0
grid(randcol,randrow) = -grid(randcol,randrow);
else
p = exp(-DeltaE/T);
if rand(1) <= p
grid(randcol,randrow) = -grid(randcol,randrow);
end
end

% Sum up properties of interest
E(i) = -0.25 * sum(DeltaE(:));
d(i) = i+1;
end
end