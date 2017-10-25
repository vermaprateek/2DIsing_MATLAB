mkdir Data;
clear all;
c=datestr(fix(clock));
A = xlsread('input.xlsx'); %reading excel file for inputs
J=A(1); 
B=A(2);
T=A(3); 
P=A(4);
L=A(5);
n_gridmin=A(6);
n_gridmax=A(7);
n_gridinc=A(8);
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
    fprintf('%s %i\n','Lattice size=',n_grid);
%     pause(1);
    [grid] = equilibration(n_grid,T,J,B);
    [gridpr,Ms,Es,xs,Cs] = production(n_grid,T,J,L,grid,B);
% disp(h);
Mp(Pr,i)=log(Ms);
Ep(Pr,i)=Es;
ln_x(Pr,i) = -log(xs)/log(n_grid);
C(Pr,i) = Cs;
gridcount(Pr,i) = n_grid;
i=i+1;
end
end
Mp_avg=mean(Mp,1);
ln_x_avg=mean(ln_x,1);
C_avg=mean(C,1);
Ep_avg=mean(Ep,1);
ln_ngrid_avg=mean(ln_ngrid,1);
figure(2);
e=std(ln_x);
plot(mean(gridcount,1), ln_x_avg, 'bo');
%hold on;
%errorbar(mean(gridcount,1),ln_x_avg, e);
% set(gcf,'Visible', 'off'); 
ylabel('\gamma/');
xlabel('Lattice size');
pbaspect([2 1 1]);
saveas(gcf,'Data\gamma_vs_Lattice size.jpg');

%Exporting Data
Text=[mean(gridcount,1);ln_x_avg];
fid = fopen('Data\gamma_vs_latticesize.dat','a+');
fprintf(fid,'%s %s\r\n\r\n','Date/Time : ',c);
%fprintf(fid,'%s %f\r\n','L=',n_grid);
fprintf(fid,'%s %f\r\n','B=',B);
%fprintf(fid,'%s %f\r\n','No.of steps for equilibrium=',2^8*(n_grid^2));
fprintf(fid,'%s %f\r\n','J=',J);
fprintf(fid,'%s %f\r\n','T=',T);
% fprintf(fid,'%s %f\r\n','T(max)=',Tmax);
% fprintf(fid,'%s %f\r\n','T(min)=',T);
% fprintf(fid,'%s %f\r\n','Increment in T=',Tinc);
fprintf(fid,'%s %f\r\n','Minimum lattice size for critical exponents = ',n_gridmin);
fprintf(fid,'%s %f\r\n','Maximum lattice size for critical exponents = ',n_gridmax);
fprintf(fid,'%s %f\r\n','Increment in LatticeSize = ',n_gridinc);
fprintf(fid,'%s %f\r\n','No.of Production run = ',P);
fprintf(fid,'%s %f\r\n','No.of steps in production run = ',L);
fprintf(fid,'%s\r\n','Data:');
fprintf(fid,'%6s %12s\r\n\r\n','Lattice Size','gamma');
fprintf(fid,'%6u %19e\r\n',Text);
fprintf(fid,'%s\r\n\r\n\r\n\r\n','');
fclose(fid);