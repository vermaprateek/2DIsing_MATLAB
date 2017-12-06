%%%%%%%%%%%%% PRODUCTION %%%%%%%%%%%%%%%%

function [gridpr,Si,Sj,SiSj] = production(n_grid,T,J,L,grid,B,r)

Mmean=zeros(1,L);
Si = zeros(1,L);
Sj = zeros(1,L);
SiSj = zeros(1,L);

for iter = 1 : L
    % Pick a random spin

row = randi(n_grid,1);
col = randi(n_grid,1);
    
    % Find its nearest neighbors
    above = mod(row - 1 - 1, size(grid,1)) + 1;
    below = mod(row + 1 - 1, size(grid,1)) + 1;
    left  = mod(col - 1 - 1, size(grid,2)) + 1;
    right = mod(col + 1 - 1, size(grid,2)) + 1;
    
    neighbors = [grid(above,col);grid(row,left);grid(row,right);grid(below,col)];
    
    % Calculate energy change if this spin is flipped
    dE = 2 * (J * grid(row, col) * sum(neighbors)-(grid.*B));
    
    % Spin flip condition
    if dE <= 0
        grid(row, col) = - grid(row, col);
    else
        prob = exp(-dE / T);          % Boltzmann probability of flipping
        if rand(1) <= prob
        grid(row, col) = - grid(row, col);
        end
    end

%Calulating spin-spin correlation
icorr = n_grid/2;
jcorr = n_grid/2;
Sn_corr = grid(mod(icorr-r,n_grid),jcorr) + grid(mod(icorr+r,n_grid),jcorr)+grid(icorr,mod(jcorr-r,n_grid))+...
    grid(icorr,mod(jcorr+r,n_grid));
Si(1,iter) = grid(icorr,jcorr);
Sj(1,iter) = Sn_corr/4;
SiSj(1,iter) = (grid(icorr,jcorr)*Sn_corr)/4;

Mmean(1,iter) = sum(grid(:))/numel(n_grid);   
end

Ms=mean(Mmean);
gridpr = grid;
end
