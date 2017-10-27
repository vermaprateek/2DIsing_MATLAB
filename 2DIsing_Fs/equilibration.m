function [grid] = equilibration(n_grid, KT, J, B)

%%%%%%%The Metropolis algorithm%%%%%%%%%%%

grid = sign(0.5 - rand(n_grid,n_grid));			%Generating Random state

numIters = 2^8 * numel(grid);       			%Number of steps for equilibration

for iter = 1 : numIters
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
        prob = exp(-dE / KT);          % Boltzmann probability of flipping
        if rand(1) <= prob
        grid(row, col) = - grid(row, col);
        end
    end 
end