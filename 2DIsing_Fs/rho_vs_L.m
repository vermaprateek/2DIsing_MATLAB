clear all;
A = xlsread('input.xlsx');     %reading excel file for inputs                                                                        
J=A(3);
B=A(4);                                         
len=A(9);
for KT=2.25:0.05:2.35
i=1;
L=4:1:12;
for n_grid=4:1:12
    disp('L=')
    disp(n_grid)
    [rho_min,rho_max] = pdf_2dising(n_grid,J,B,len,KT);
    rhomin(1,i) = rho_min*100;
    rhomax(1,i) = rho_max*100;
    Fs_1(1,i) = -log(rho_min)/(2*n_grid);
    Fs_2(1,i) = log(rho_max/rho_min)/(2*n_grid);
    i=i+1;
end
xaxis=1./L;
plot(L,rhomin,'*')
axis([0 14 .001 1])
hold on
end
hold off;

