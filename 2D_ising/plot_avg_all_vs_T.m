clc;
mkdir Average_magnetisation;
mkdir Average_Susceptibility;
mkdir Average_Heatcapacity;
mkdir Average_Energy;
mkdir Energy_vs_cycles;
clc;
A = xlsread('input.xlsx'); %reading excel file for inputs
n_grid=A(1); %reading excel file for inputs
L=A(2); %reading excel file for inputs
J=A(3); %reading excel file for inputs
B=A(4); %reading excel file for inputs
P=A(8);
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
x=zeros(1,len);
C=zeros(1,len);
Ep=zeros(1,len);
%below it is calculating average Mag for each Arrangement after production run
for Pr=1:P
    fprintf('%s %i\n','production run=',Pr);
    pause(1);
for h = 1:len
[gridpr,Ms,Es,xs,Cs] = production(n_grid,Ts(1,h),J,L,grideqm{h});
disp(h);
Mp(Pr,h)=(Ms);
Ep(Pr,h)=Es;
x(Pr,h) = xs;
C(Pr,h) = Cs;
end
end
Mp_avg=mean(Mp,1);
x_avg=mean(x,1);
C_avg=mean(C,1);
Ep_avg=mean(Ep,1);
% figure generation
figure(2);
plot(Ts, Mp_avg, 'bo');
set(gcf,'Visible', 'off'); 
ylabel('Average magnetization per site');
xlabel('temperature');
pbaspect([2 1 1]);
%print(gcf, '-depsc2', 'ising-magnetization');
saveas(gcf,'Average_magnetisation/Avg.Mag_vs_Temp.jpg');
A=[Mp_avg;Ts];
%creating text file
fid = fopen('Average_magnetisation\AvgMagnetisation_&_Temp.txt','w');
fprintf(fid,'%6s %12s\r\n','Avg_Mag','Temp');
fprintf(fid,'%6.2f %14f\r\n',A);
fclose(fid);
%type('Average_magnetisation\AvgMagnetisation_&_Temp.txt');
fid = fopen('Average_magnetisation\AvgMagnetisation_&_Temp (per production run).txt','w');
for i=1:P
    A=[Mp(i,:);Ts];
    fprintf(fid,'%6s %i\r\n','production Run = ',i);
    fprintf(fid,'%6s %12s\r\n','Avg_Mag','Temp');
    fprintf(fid,'%6.2f %14f\r\n',A);
    fprintf(fid,'%s\r\n\r\n','');
end
fclose(fid);


figure(3);
plot(Ts, x_avg, 'bo');
set(gcf,'Visible', 'off'); 
ylabel('Average Susceptibility');
xlabel('Temperature');
pbaspect([2 1 1]);
%print(gcf, '-depsc2', 'ising-chi');
saveas(gcf,'Average_Susceptibility/Avg.Susceptibility_vs_Temp.jpg');
B=[x_avg;Ts];
%creating text file
fid = fopen('Average_Susceptibility\AvgSusceptibility_&_Temp.txt','w');
fprintf(fid,'%6s %12s\r\n','Avg_Chi','Temp');
fprintf(fid,'%6.2f %14f\r\n',B);
fclose(fid);
%type('Average_Susceptibility\AvgSusceptibility_&_Temp.txt');
fid = fopen('Average_Susceptibility\AvgSusceptibility_&_Temp (per production run).txt','w');
for i=1:P
    B=[x(i,:);Ts];
    fprintf(fid,'%6s %i\r\n','production Run = ',i);
    fprintf(fid,'%6s %12s\r\n','Avg_Chi','Temp');
    fprintf(fid,'%6.2f %14f\r\n',B);
    fprintf(fid,'%s\r\n\r\n','');
end
fclose(fid);


figure(4);
plot(Ts, C_avg, 'bo');
set(gcf,'Visible', 'off'); 
ylabel('Average Heatcapacity');
xlabel('Temperature');
pbaspect([2 1 1]);
%print(gcf, '-depsc2', 'ising-C');
saveas(gcf,'Average_Heatcapacity/Avg.Heatcapacity_vs_Temp.jpg');
D=[C_avg;Ts];
%creating text file
fid = fopen('Average_Heatcapacity\Average_Heatcapacity_&_Temp.txt','w');
fprintf(fid,'%6s %12s\r\n','Avg_C','Temp');
fprintf(fid,'%6.2f %14f\r\n',D);
fclose(fid);
%type('Average_Heatcapacity\Average_Heatcapacity_&_Temp.txt');
fid = fopen('Average_Heatcapacity\Average_Heatcapacity_&_Temp (per production run).txt','w');
for i=1:P
    D=[C(i,:);Ts];
    fprintf(fid,'%6s %i\r\n','production Run = ',i);
    fprintf(fid,'%6s %12s\r\n','Avg_C','Temp');
    fprintf(fid,'%6.2f %14f\r\n',D);
    fprintf(fid,'%s\r\n\r\n','');
end
fclose(fid);


figure(5);
plot(Ts, Ep_avg, 'bo');
set(gcf,'Visible', 'off'); 
ylabel('Average ernergy');
xlabel('temperature');
pbaspect([2 1 1]);
%print(gcf, '-depsc2', 'ising-energy');
saveas(gcf,'Average_Energy/Avg.Energy_vs_Temp.jpg');
F=[Ep_avg;Ts];
%creating text file
fid = fopen('Average_Energy\AvgEnergy_&_Temp.txt','w');
fprintf(fid,'%6s %12s\r\n','Avg_Energy','Temp');
fprintf(fid,'%6.2f %14f\r\n',F);
fclose(fid);
%type('Average_Energy\AvgEnergy_&_Temp.txt');
fid = fopen('Average_Energy\AvgEnergy_&_Temp(per production run).txt','w');
for i=1:P
    F=[Ep(i,:);Ts];
    fprintf(fid,'%6s %i\r\n','production Run = ',i);
    fprintf(fid,'%6s %12s\r\n','Avg_E','Temp');
    fprintf(fid,'%6.2f %14f\r\n',F);
    fprintf(fid,'%s\r\n\r\n','');
end
fclose(fid);

disp('FINISHED!');
