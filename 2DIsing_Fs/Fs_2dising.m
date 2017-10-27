mkdir Data;
clear all;
c=datestr(fix(clock));         	  %Date/Time
A = xlsread('input_Fs.xlsx');     %reading excel file for inputs                                                                          
J=A(4);
B=A(5);                                         
KT=A(6);
i=1;
j=1;
Pr=A(7);
len=A(8);
vector=A(1):A(3):A(2);

for P=1:Pr
for n_grid=A(1):A(3):A(2)
    disp('L=')
    disp(n_grid)
    [rho_min,rho_max] = pdf_2dising(n_grid,J,B,len,KT);
    Fs_1(j,i) = -log(rho_min*100)/(2*n_grid);
    Fs_2(j,i) = log(rho_max/rho_min)/(2*n_grid);
    i=i+1;
end
    i=1;
    j=j+1;
end

%Plot Generation
Fs_2_avg = mean(Fs_2,1);
xaxis=1./vector;
% plot(xaxis,Fs_1,'r*');
% xlim([0 0.3])
% hold on;
plot(xaxis,Fs_2_avg,'g-')
xlim([0 (1/A(1))+.05])
hold on;

%std in values of fs
e=std(Fs_2,0,1);
errorbar(xaxis,Fs_2_avg,e,'r.')
set(gcf,'Visible', 'off'); 
saveas(gcf,'Data\FsvsLinv.jpg');
hold off;


%Exporting Data
Text=[xaxis;Fs_2_avg;e];
fid = fopen('Data\Fs_vs_L.dat','a+');
fprintf(fid,'%s %s\r\n\r\n','Date/Time : ',c);
fprintf(fid,'%s %f\r\n','L(initial)=',A(1));
fprintf(fid,'%s %f\r\n','L(final)=',A(2));
fprintf(fid,'%s %f\r\n','L(increment)=',A(3));
fprintf(fid,'%s %f\r\n','B=',B);
fprintf(fid,'%s %f\r\n','J=',J);
fprintf(fid,'%s %f\r\n','T=',KT);
fprintf(fid,'%s %f\r\n','No.of Production run = ',Pr);
fprintf(fid,'%s %f\r\n','No.of steps in production run = ',len);
fprintf(fid,'%s\r\n','Data:');
fprintf(fid,'%6s %12s %12s\r\n\r\n','1/L','Fs/KbT','std');
fprintf(fid,'%6f %12f %12f\r\n',Text);
fprintf(fid,'%s\r\n\r\n\r\n\r\n','');
fclose(fid);
disp('Finished!');