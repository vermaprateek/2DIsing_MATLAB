function [grideqm, Ts, len] = ising_over_temp(n_grid,J,L,Tmin,Tinc,Tmax,B)
len = floor((Tmax-Tmin)/Tinc);		%number of cycles to loop over temperature							
grideqm= cell(1,len);
Ts=zeros(1,len);
i=1;

% The temperature loop
disp('equilibration started!');
fprintf('%s %i\n','Number of steps =',L);


for T=Tmin:Tinc:Tmax
[grid,E,d] = equilibration(n_grid, T, J, L);

%storing equilibrated arrangements with temperature mapped in an array
grideqm{i}= grid;
Ts(1,i) = T;
i=i+1;
end


disp('equilibration finished!');
len = length(Ts);
end
