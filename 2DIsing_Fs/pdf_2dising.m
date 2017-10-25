
%%%%%%%%%%%%%%% probability density of states for 2D Ising %%%%%%%%%%%%%%%%%%%%

function[rho_min,rho_max]=pdf_2dising(n_grid,J,B,len,KT)
Ts=zeros(1,len);
M=zeros(1,len);
[grid] = equilibration(n_grid, KT, J, B);

for iter = 1 : len
%      if mod(iter,1000000)==0
%     disp(iter);
%      end
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
    dE = 2 * (J * grid(row, col) * sum(neighbors)- grid.*B);
    
    % Spin flip condition
    if dE <= 0
        grid(row, col) = - grid(row, col);
    else
        prob = exp(-dE / KT);  % Boltzmann probability of flipping
        if rand(1) <= prob
        grid(row, col) = - grid(row, col);
        end
    end 
    M(1,iter) = sum(sum(grid))/(numel(grid));
    Ts(1,iter) = KT;
end
a=unique(M);
a=transpose(a);
out = [a,histc(M(:),a)];
y=(out(:,2)/len);
%plot(out(:,1),y,'o-');
% rho_min=min(y);
rho_min=y(ceil(end/2));
rho_max=max(y);
%end
