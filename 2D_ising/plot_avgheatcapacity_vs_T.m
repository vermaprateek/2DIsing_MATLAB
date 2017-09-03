clear all;close all,clc;
mkdir Average_Heatcapacity;
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
C=zeros(1,len);
for h = 1:len+1
[gridpr,Ms,Ms_2,Es,Es_2] = production(n_grid,Ts(:,h),J,L,grideqm(:,:,h));
disp(h);
C(1,h) = (Es_2-(Es.^2))*(1/(Ts(:,h).^2));
end
% figure generation
figure(1);
plot(Ts, C, 'bo');
set(gcf,'Visible', 'off'); 
ylabel('Average Heatcapacity');
xlabel('Temperature');
pbaspect([2 1 1]);
%print(gcf, '-depsc2', 'ising-C');
saveas(gcf,'Average_Heatcapacity/Avg.Heatcapacity_vs_Temp.jpg');
A=[C;Ts];
%creating text file
fid = fopen('Average_Heatcapacity\Average_Heatcapacity_&_Temp.txt','w');
fprintf(fid,'%6s %12s\r\n','Avg_Chi','Temp');
fprintf(fid,'%6.2f %14f\r\n',A);
fclose(fid);
type('Average_Heatcapacity\Average_Heatcapacity_&_Temp.txt');
disp('FINISHED!');