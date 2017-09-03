clear all;close all,clc;
mkdir Average_Susceptibility;
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
Mp=zeros(1,len);
x=zeros(1,len);
for h = 1:len+1
[gridpr,Ms,Ms_2] = production(n_grid,Ts(:,h),J,L,grideqm(:,:,h));
disp(h);
x(1,h) = (Ms_2-(Ms.^2))*(1/Ts(:,h));
end
% figure generation
figure(1);
plot(Ts, x, 'bo');
set(gcf,'Visible', 'off'); 
ylabel('Average Susceptibility');
xlabel('Temperature');
pbaspect([2 1 1]);
%print(gcf, '-depsc2', 'ising-chi');
saveas(gcf,'Average_Susceptibility/Avg.Susceptibility_vs_Temp.jpg');
A=[x;Ts];
%creating text file
fid = fopen('Average_Susceptibility\AvgSusceptibility_&_Temp.txt','w');
fprintf(fid,'%6s %12s\r\n','Avg_Chi','Temp');
fprintf(fid,'%6.2f %14f\r\n',A);
fclose(fid);
type('Average_Susceptibility\AvgSusceptibility_&_Temp.txt');
disp('FINISHED!');