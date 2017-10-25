
%%%%%%%%%%%%%%% probability density of states for 2D Ising %%%%%%%%%%%%%%%%%%%%
clear all;
c=datestr(fix(clock));
A = xlsread('input.xlsx');     %reading excel file for inputs
n_grid=A(1);                                                                             
J=A(3);
B=A(4);                                         
len=A(2);
grideqm= cell(1,len);
Ts=zeros(1,len);
num_plusone=zeros(1,len);
M=zeros(1,len);
KT=A(5);
[grid] = equilibration(n_grid, KT, J, B);


for iter = 1 : len
      if mod(iter,1000000)==0
      disp(iter);
      end

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
plot(out(:,1),y,'o-')
Text=[y.';out(:,1).'];
fid = fopen('Data\Probability_Distribution.dat','a+');
fprintf(fid,'%s %s\r\n\r\n','Date/Time : ',c);
fprintf(fid,'%s %f\r\n','L=',n_grid);
fprintf(fid,'%s %f\r\n','B=',B);
fprintf(fid,'%s %f\r\n','No.of steps for equilibrium=',2^8*(n_grid^2));
fprintf(fid,'%s %f\r\n','J=',J);
%fprintf(fid,'%s %f\r\n','T(max)=',Tmax);
%fprintf(fid,'%s %f\r\n','T(min)=',Tmin);
fprintf(fid,'%s %f\r\n','T=',KT);
%fprintf(fid,'%s %f\r\n','No.of Production run = ',P);
fprintf(fid,'%s %f\r\n','No.of steps in production run = ',len);
fprintf(fid,'%s\r\n','Data:');
fprintf(fid,'%6s %12s\r\n','ln(p)','<m>');
fprintf(fid,'%6f %12f\r\n',Text);
fprintf(fid,'%s\r\n\r\n\r\n\r\n','');
fclose(fid);
disp('Finished!');