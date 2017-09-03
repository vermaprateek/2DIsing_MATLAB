function [ output_args ] = ising_over_grid( input_args )
%ISING_OVER_GRID Summary of this function goes here
%   Detailed explanation goes here
len = floor((Gmax-Gmin)/Ginc);%returns the number of cycles to loop over temperatures
%allocating required memory to variables like gridqm,Ts at the beginning to run the code faster
grideqm= cell(1,len);
Ts=zeros(1,len);
i=1;
% The temperature loop
disp('equilibration started!');
fprintf('%s %i\n','Number of steps =',L);
for T=Tmin:Tinc:Tmax
[grid,E,d] = equilibration(n_grid, T, J, L);%calling the equilibration function present in the file equilibration.m
%storing equilibrated arrangements with temperature mapped in an array
grideqm{i}= grid;
Ts(1,i) = T;
i=i+1;
end
disp('equilibration finished!');
len = length(Ts);
end

end

