%% genrates plot Avergare Magnetisation per site Vs Temperature
close all; clc;
mkdir Average_magnetisation;
mkdir Energy_vs_cycles;
A = xlsread('input.xlsx'); %reading excel file for inputs
n_grid=A(1); %reading excel file for inputs
L=A(2); %reading excel file for inputs
J=A(3); %reading excel file for inputs
B=A(4); %reading excel file for inputs
Tmin=A(5); %reading excel file for inputs
Tinc=A(7); %reading excel file for inputs
Tmax=A(6); %reading excel file for inputs
% calling function from ising_over_temp.m to generate mapping of equilibrated arrangements and temp
[grideqm, Ts, len] = ising_over_temp(n_grid,J,L,Tmin,Tinc,Tmax);
%plot energy vs cycles for min Temperature to check if system is equilibrated properly
[grid,E,d] = equilibration(n_grid,Tmin,J,L);
plot(d, E, 'ro');
title('Plotted during equilibration run');
set(gcf,'Visible', 'off'); 
ylabel('Average Energy');
xlabel('cycles');
pbaspect([2 1 1]);
%print(gcf, '-depsc2', 'ising-energy_vs_cycle');
saveas(gcf,'Energy_vs_cycles/Energy_vs_cycles.jpg');
Mp=zeros(1,len);
%% below it is calculating average Mag for each Arrangement after production run
for h = 1:len+1
[gridpr,Ms] = production(n_grid,Ts(:,h),J,L,grideqm(:,:,h));
disp(h);
Mp(1,h)=abs(Ms);
end
% figure generation
figure(2);
plot(Ts, Mp, 'bo');
set(gcf,'Visible', 'off'); 
ylabel('Average magnetization per site');
xlabel('temperature');
pbaspect([2 1 1]);
%print(gcf, '-depsc2', 'ising-magnetization');
saveas(gcf,'Average_magnetisation/Avg.Mag_vs_Temp.jpg');
A=[Mp;Ts];
%creating text file
fid = fopen('Average_magnetisation\AvgMagnetisation_&_Temp.txt','w');
fprintf(fid,'%6s %12s\r\n','Avg_Mag','Temp');
fprintf(fid,'%6.2f %14f\r\n',A);
fclose(fid);
type('Average_magnetisation\AvgMagnetisation_&_Temp.txt');
disp('FINISHED!');