mkdir Data;
clear all;
c=datestr(fix(clock));
A = xlsread('input.xlsx'); 		%reading excel file for inputs
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
    fprintf('%s %i\n','Lattice size=',n_grid);
    [grid] = equilibration(n_grid,T,J,B);
    [gridpr,Ms,Es,xs,Cs] = production(n_grid,T,J,L,grid,B);
	Mp(Pr,i)=log(Ms);
	Ep(Pr,i)=Es;
	ln_x(Pr,i) = -log(xs)/log(n_grid);
	C(Pr,i) = Cs;
	gridcount(Pr,i) = n_grid;
	i=i+1;
end
end

%Calculating average properties	
ln_x_avg=mean(ln_x,1);
ln_ngrid_avg=mean(ln_ngrid,1);
e=std(ln_x,0,1);

%plot generation
figure(2);
plot(mean(gridcount,1), ln_x_avg, 'b-');
hold on;

%errorbar showing std in production runs
errorbar(mean(gridcount,1),ln_x_avg,e,'r.');

%plot properties
set(gcf,'Visible', 'off'); 
ylabel('\gamma');
xlabel('Lattice size');
xlim([0 n_gridmax+50]);
saveas(gcf,'Data\gamma_vs_latticesize.jpg');
hold off;

%Exporting Data
Text=[mean(gridcount,1);ln_x_avg];
fid = fopen('Data\gamma_vs_latticesize.dat','a+');
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
fprintf(fid,'%6s %12s\r\n\r\n','Lattice Size','gamma');
fprintf(fid,'%6u %19e\r\n',Text);
fprintf(fid,'%s\r\n\r\n\r\n\r\n','');
fclose(fid);