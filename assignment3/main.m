%%
%Steven Yee
%Macro C PS 3
%4/26/20

%%
%Problem 2
clearvars

% Option 1: Write different files for different parameters
%Runs the dynare linear file
nu_in_matlab = 0.25;
dynare yeeStevenDynareMacroCHW3 noclearall
irfs_rho025 = oo_.irfs;

nu_in_matlab = 0.5
dynare yeeStevenDynareMacroCHW3 noclearall
irfs_rho05 = oo_.irfs;

nu_in_matlab = 2;
dynare yeeStevenDynareMacroCHW3 noclearall
irfs_rho2 = oo_.irfs;

nu_in_matlab = 4;
dynare yeeStevenDynareMacroCHW3 noclearall
irfs_rho4 = oo_.irfs;

nu_in_matlab = 0.9999999;
dynare yeeStevenDynareMacroCHW3 noclearall
irfs_rho1 = oo_.irfs;

figure
subplot(2,2,1)
hold on
plot(irfs_rho025.c_eps)
plot(irfs_rho05.c_eps)
plot(irfs_rho1.c_eps)
plot(irfs_rho2.c_eps)
plot(irfs_rho4.c_eps)
title('IRF Consumption')
legend('nu=0.25', 'nu=0.5', 'nu=1', 'nu=2', 'nu=4' ,'Location', 'SouthOutside','Orientation','horizontal','Box','off')
hold off

subplot(2,2,2)
hold on
plot(irfs_rho025.i_eps)
plot(irfs_rho05.i_eps)
plot(irfs_rho1.i_eps)
plot(irfs_rho2.i_eps)
plot(irfs_rho4.i_eps)
title('IRF Interest Rate')
legend('nu=0.25', 'nu=0.5', 'nu=1', 'nu=2', 'nu=4' ,'Location', 'SouthOutside','Orientation','horizontal','Box','off')
hold off

subplot(2,2,3)
hold on
plot(irfs_rho025.p_eps)
plot(irfs_rho05.p_eps)
plot(irfs_rho1.p_eps)
plot(irfs_rho2.p_eps)
plot(irfs_rho4.p_eps)
title('IRF Price')
legend('nu=0.25', 'nu=0.5', 'nu=1', 'nu=2', 'nu=4' ,'Location', 'SouthOutside','Orientation','horizontal','Box','off')
hold off
saveas(gcf,'macroPS3graphs.png')

%%
%Problem 3

gm = linspace(0.001,20,1000)
a = 0;
b = 1/3;
r = 1;
i = r + gm;
lnY = 1;
ln_mp = a - b*i + lnY;
S = exp(ln_mp + log(gm));
figure;
hold on
plot(gm, S)
% title('Real Seniorage vs. gm: r = 1')

gm = linspace(0.001,20,1000)
a = 0;
b = 1/3;
r = 2;
i = r + gm;
lnY = 1;
ln_mp = a - b*i + lnY;
S = exp(ln_mp + log(gm));
plot(gm, S)
% title('Real Seniorage vs. gm: r = 2')

gm = linspace(0.001,20,1000)
a = 0;
b = 1/3;
r = 3;
i = r + gm;
lnY = 1;
ln_mp = a - b*i + lnY;
S = exp(ln_mp + log(gm));
plot(gm, S)
% title('Real Seniorage vs. gm: r = 3')

gm = linspace(0.001,20,1000)
a = 0;
b = 1/3;
r = 4;
i = r + gm;
lnY = 1;
ln_mp = a - b*i + lnY;
S = exp(ln_mp + log(gm));
plot(gm, S)
title('Real Seniorage vs. gm')
legend('r = 1', 'r =2', 'r = 3', 'r = 4', 'Location', 'SouthOutside','Orientation','horizontal','Box','off')
hold off
saveas(gcf,'macroCPS3seniorage.png')











