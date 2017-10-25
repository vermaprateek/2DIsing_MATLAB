%%%%%%%%%%%%% EQUILIBRATION %%%%%%%%%%%%%

function [grid,E,d] = equilibration(n_grid, T, J, B)

%%%%%%% The Metropolis algorithm %%%%%%%%%%%

%grid = (rand(n_grid) > 0.5)*2 - 1;  %Generating Random state 
grid=ones(n_grid);
numIters = 2^8 * numel(grid);       %Number of steps for equilibration

%preallocating for speed
E=zeros(1,numIters);
d=zeros(1,numIters);

for iter = 1 : numIters
    % Pick a random spin

row = randi(n_grid,1);
col = randi(n_grid,1);
    
    % Find its nearest neighbors
    above = mod(row - 1 - 1, size(grid,1)) + 1;
    below = mod(row + 1 - 1, size(grid,1)) + 1;
    left  = mod(col - 1 - 1, size(grid,2)) + 1;
    right = mod(col + 1 - 1, size(grid,2)) + 1;
    
    neighbors = [grid(above,col);grid(row,left);...
                 grid(row,right);grid(below,col)];
    
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
    
% %calculating energy 
% sumOfNeighbors = ...
%       circshift(grid, [ 0  1]) ...
%     + circshift(grid, [ 0 -1]) ...
%     + circshift(grid, [ 1  0]) ...
%     + circshift(grid, [-1  0]);
% Em = - J * grid .* sumOfNeighbors;
% E(1,iter)  = 0.5 * sum(Em(:));
% d(1,iter) = iter;
end
end