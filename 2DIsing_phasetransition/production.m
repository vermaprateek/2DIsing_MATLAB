%%%%%%%%%%%%% PRODUCTION %%%%%%%%%%%%%%%%

function [gridpr,Ms,Es,xs,Cs] = production(n_grid,T,J,L,grid,B)
Mmean=zeros(1,L);
Emean=zeros(1,L);
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
    
%calculating magnetisation per spin
Mmean(1,iter) = mean(grid(:))/numel(n_grid);

%calculating energy per spin
sumOfNeighbors = ...
      circshift(grid, [ 0  1]) ...
    + circshift(grid, [ 0 -1]) ...
    + circshift(grid, [ 1  0]) ...
    + circshift(grid, [-1  0]);
Em = - J * grid .* sumOfNeighbors;
E  = 0.5 * sum(Em(:));
Emean(1,iter) = E / numel(grid);



end

gridpr = grid; % final arrangement after production run stored to gridpr
Ms=mean(Mmean);% Ms is a scalar with average of all the elements in array Mag_avg;
Es=mean(Emean); % Es is a scalar with average of all the elements in array Energy_avg;
xs=(mean(Mmean.^2)-mean(Mmean)^2)/T;
Cs=(mean(Emean.^2)-mean(Emean)^2)/T^2;
end