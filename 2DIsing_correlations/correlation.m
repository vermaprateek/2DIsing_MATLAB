clear all;
c=datestr(fix(clock));
A = xlsread('input_phasetransition.xlsx');    %reading excel file for inputs
n_grid=A(1);                        
L=A(8);                             
J=A(3);                             
B=A(4);                             
P=A(9);
Tmin=A(5);                          
Tinc=A(7);                          
Tmax=A(6);                          

[grideqm, Ts, len] = ising_over_temp(n_grid,J,L,Tmin,Tinc,Tmax);

%preallocating for speed
corr = zeros(len,n_grid/2-1);
v= zeros(1,n_grid/2-1);

%calculating average properties of the model for each temperature step
for h = 1:len
for r=1:(n_grid/2-1)
[gridpr,Si,Sj,SiSj] = production(n_grid,Ts(1,h),J,L,grideqm{h},B,r);
Si_avg = sum(Si)/L;
SiSj_avg = sum(SiSj)/L;
Sj_avg = sum(Sj)/L;
corr(h,r) = (SiSj_avg - (Si_avg*Sj_avg));
v(1,r) = r;
disp(h);
end
end


%figure generation
figure(1);
for h=1:len
plot(v,corr(h,:),'o-');
hold on;
legendInfo{h} = ['T = ' num2str(Ts(1,h))];
end
legend(legendInfo);
hold off;

%Exporting Data
corr = transpose(corr);
corr=reshape(corr,1,[]);
v(numel(corr)) = 0;
Text=[v;corr];
fid = fopen('Data/correlation.dat','a+');
fprintf(fid,'%s %s\r\n\r\n','Date/Time : ',c);
fprintf(fid,'%s %f\r\n','B=',B);
fprintf(fid,'%s %f\r\n','J=',J);
fprintf(fid,'%s %f\r\n','Lattice Size=',n_grid);
fprintf(fid,'%s %f\r\n','Minimum temperature = ',Tmin);
fprintf(fid,'%s %f\r\n','Maximum temperature = ',Tmax);
fprintf(fid,'%s %f\r\n','Increment in temperature = ',Tinc);
fprintf(fid,'%s %f\r\n','No.of Production run = ',P);
fprintf(fid,'%s %f\r\n','No.of steps in production run = ',L);
fprintf(fid,'%s\r\n','Data:');
fprintf(fid,'%6s %12s\r\n\r\n','r (distance)','Correlation function');
fprintf(fid,'%6u %19e\r\n',Text);
fprintf(fid,'%s\r\n\r\n\r\n\r\n','');
fclose(fid);

disp('FINISHED!');
