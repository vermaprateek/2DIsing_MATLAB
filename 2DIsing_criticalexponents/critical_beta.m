mkdir Data;;
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


len_grid = floor((n_gridmax-n_gridmin)/n_gridinc);
for Pr=1:P
    i=1;
for n_grid=n_gridmin:n_gridinc:n_gridmax
    ln_ngrid(1,i)=log(n_grid);
    fprintf('%s %i\n','production run=',Pr);
%     pause(1);
    [grid] = equilibration(n_grid,T,J,B);
    [gridpr,Ms,Es,xs,Cs] = production(n_grid,T,J,L,grid,B);
fprintf('%s %i\n','Lattice size =',n_grid);
Mp(Pr,i)=-log(Ms)/log(n_grid);
gridcount(Pr,i) = n_grid;
i=i+1;
end
end

%Calculating average properties
Mp_avg=mean(Mp,1);
ln_ngrid_avg=mean(ln_ngrid,1);
e=std(Mp,0,1);

%plotting
figure(2);
plot(mean(gridcount,1), Mp_avg, 'b-');
hold on;

%errorbar showing std in production runs
errorbar(mean(gridcount,1),Mp_avg,e,'r.');

%plot properties
set(gcf,'Visible', 'off'); 
ylabel('\beta');
xlabel('Lattice size');
xlim([0 n_gridmax+50]);
saveas(gcf,'Data\beta_vs_latticesize.jpg');
hold off;

%Exporting Data
Text=[mean(gridcount,1);Mp_avg];
fid = fopen('Data\beta_vs_latticesize.dat','a+');
fprintf(fid,'%s %s\r\n\r\n','Date/Time : ',c);
fprintf(fid,'%s %f\r\n','B=',B);
fprintf(fid,'%s %f\r\n','J=',J);
fprintf(fid,'%s %f\r\n','T=',T);
fprintf(fid,'%s %f\r\n','Minimum lattice size for critical exponents = ',n_gridmin);
fprintf(fid,'%s %f\r\n','Maximum lattice size for critical exponents = ',n_gridmax);
fprintf(fid,'%s %f\r\n','Increment in LatticeSize = ',n_gridinc);
fprintf(fid,'%s %f\r\n','No.of Production run = ',P);
fprintf(fid,'%s %f\r\n','No.of steps in production run = ',L);
fprintf(fid,'%s\r\n','Data:');
fprintf(fid,'%6s %12s\r\n\r\n','Lattice Size','beta');
fprintf(fid,'%6u %19e\r\n',Text);
fprintf(fid,'%s\r\n\r\n\r\n\r\n','');
fclose(fid);
disp('Finished!');