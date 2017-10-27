%%%%%%%%%%%%%%%% Production Run %%%%%%%%%%%%%%%%%%%%%

function [gridpr,Ms,Es,xs,Cs] = production(n_grid,T,J,L,grid,B)

Mag_avg = zeros(1,L);
Energy_avg = zeros(1,L);
expect_E = 0;
expect_E2 = 0;
expect_M = 0;
expect_M2 = 0;
pnorm = 0;

for i=1:50
for nrow=1:n_grid
for ncol=1:n_grid

%Periodic Boundary conditions
if ncol == 1
neighleft = n_grid;
else
neighleft = ncol - 1;
end
if ncol == n_grid
neighright = 1;
else
neighright = ncol + 1;
end
if nrow == 1
neighup = n_grid;
else
neighup = nrow - 1;
end
if nrow == n_grid
neighdown = 1;
else
neighdown = nrow + 1;
end

%number of neighbors of each cell
spin = grid(nrow,ncol);
neighbors = grid(nrow,neighleft) + grid(nrow,neighright)...
 + grid(neighup,ncol) + grid(neighdown,ncol);

%change in energy by spin flip
oldE = -J * (spin * neighbors);
DeltaE = -2*oldE;
beta=1/T;

%Mean of Properties
expect_E = expect_E + oldE*exp(-beta*oldE)/2;
expect_E2 = expect_E2 + oldE^2*exp(-beta*oldE)/4;
expect_M = expect_M + spin*exp(-beta*oldE);
expect_M2 = expect_M2 + (spin)^2*exp(-beta*oldE);
pnorm = pnorm + exp(-beta*oldE);
end
end

%Checking the acceptance probability
if DeltaE < 0
grid(ncol,nrow) = -grid(ncol,nrow);
else
p = exp(-DeltaE/T);
if rand(1) <= p
grid(ncol,nrow) = -grid(ncol,nrow);
end
end

% Summing up variables of interest
Mag_avg(1,i)= expect_M/pnorm; 
C(1,i) = (beta/T)*(expect_E2/pnorm - (expect_E/pnorm)^2);
Chi(1,i) = beta*(expect_M2/pnorm - (expect_M/pnorm)^2);
Energy_avg(1,i) = expect_E/pnorm; 

%Zero everything so next step starts with new averages on the next pass through
expect_E = 0;
expect_E2 = 0;
expect_M = 0;
expect_M2 = 0;
pnorm = 0;
end

%mean of properties
gridpr = grid; 
Ms=mean(Mag_avg,2); 
Es=mean(Energy_avg,2); 
xs=mean(Chi,2);
Cs=mean(C,2);
end