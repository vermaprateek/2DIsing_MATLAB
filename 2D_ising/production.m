% Production Run
function [gridpr,Ms,Es,xs,Cs] = production(n_grid,T,J,L,grid,B)
%allocating required memory to variables like Mag_avg,Energy_ang at the beginning to run the code faster
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
% Calculate the number of neighbors of each cell
spin = grid(nrow,ncol);
neighbors = grid(nrow,neighleft) + grid(nrow,neighright) + grid(neighup,ncol) + grid(neighdown,ncol);
% Calculate the change in energy of flipping a spin
oldE = -J * (spin * neighbors);
DeltaE = -2*oldE;
beta=1/T;
expect_E = expect_E + oldE*exp(-beta*oldE)/2;
expect_E2 = expect_E2 + oldE^2*exp(-beta*oldE)/4;
expect_M = expect_M + spin*exp(-beta*oldE);
expect_M2 = expect_M2 + (spin)^2*exp(-beta*oldE);
pnorm = pnorm + exp(-beta*oldE);
end
end
if DeltaE < 0
grid(ncol,nrow) = -grid(ncol,nrow);
else
p = exp(-DeltaE/T);
if rand(1) <= p
grid(ncol,nrow) = -grid(ncol,nrow);
end
end
% Sum up our variables of interest
Mag_avg(1,i)= expect_M/pnorm; % storing values of M with each step in an array
%E = -0.25 * sum(DeltaE(:));
C(1,i) = (beta/T)*(expect_E2/pnorm - (expect_E/pnorm)^2);
Chi(1,i) = beta*(expect_M2/pnorm - (expect_M/pnorm)^2);
Energy_avg(1,i) = expect_E/pnorm; % storing values of E with each step in an array
%Zero everything so we start with entirely new averages on the next pass through
expect_E = 0;
expect_E2 = 0;
expect_M = 0;
expect_M2 = 0;
pnorm = 0;
end
gridpr = grid; % final arrangement after production run stored to gridpr
Ms=mean(Mag_avg,2); % Ms is a scalar with average of all the elements in array Mag_avg;
Es=mean(Energy_avg,2); % Es is a scalar with average of all the elements in array Energy_avg;
xs=mean(Chi,2);
Cs=mean(C,2);
end