mkdir Critical_exponents;
clear all;
A = xlsread('input.xlsx'); %reading excel file for inputs
n_grid=A(1); %reading excel file for inputs
L=A(2); %reading excel file for inputs
J=A(3); %reading excel file for inputs
B=A(4); %reading excel file for inputs
P=A(8);
Tmin=2.2; %reading excel file for inputs
Tinc=0; %reading excel file for inputs
Tmax=2.2; %reading excel file for inputs
n_gridmin=A(9);
n_gridmax=A(10);
n_gridinc=A(11);
% Mp=zeros(1,len);
% x=zeros(1,len);
% C=zeros(1,len);
% Ep=zeros(1,len);


len_grid = floor((n_gridmax-n_gridmin)/n_gridinc);
for Pr=1:P
    i=1;
for n_grid=n_gridmin:n_gridinc:n_gridmax
    ln_ngrid(1,i)=log(n_grid);
    fprintf('%s %i\n','production run=',Pr);
%     pause(1);
    [grid,E,d] = equilibration(n_grid,Tmin,J,L);
    [gridpr,Ms,Es,xs,Cs] = production(n_grid,Tmin,J,L,grid);
fprintf('%s %i\n','Lattice size =',n_grid);
Mp(Pr,i)=-log(Ms)/log(n_grid);
%Ep(Pr,i)=Es;
%ln_x(Pr,i) = -log(xs)/log(n_grid);
%C(Pr,i) = Cs;
gridcount(Pr,i) = n_grid;
i=i+1;
end
end
Mp_avg=mean(Mp,1);
%ln_x_avg=mean(ln_x,1);
%C_avg=mean(C,1);
%Ep_avg=mean(Ep,1);
ln_ngrid_avg=mean(ln_ngrid,1);
% figure(2);
% plot(gridcount, Mp_avg, 'bo');
e=std(Mp,0,1);
%plot(gridcount, Mp_avg, 'bo');
% hold on;
errorbar(mean(gridcount,1),Mp_avg, e);
% set(gcf,'Visible', 'off'); 
ylabel('\beta');
xlabel('Lattice size');
pbaspect([2 1 1]);
saveas(gcf,'Critical_exponents/beta_vs_latticesize_errorbar.jpg');