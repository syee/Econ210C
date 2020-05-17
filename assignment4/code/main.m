%%
%Steven Yee
%Macro C PS 4
%5/17/20

%%
clearvars

% Option 1: Write different files for different parameters
%Runs the dynare linear file
theta_in_matlab = .75;
rho_in_matlab = 0;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho0 = oo_.irfs;

rho_in_matlab = 0.25;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho25 = oo_.irfs;

rho_in_matlab = .5;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho5 = oo_.irfs;

rho_in_matlab = 0.75;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho75 = oo_.irfs;

rho_in_matlab = 0.9;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho9 = oo_.irfs;

rho_in_matlab = 0.99;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho99 = oo_.irfs;

rho_in_matlab = 1;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho1 = oo_.irfs;

figure;
subplot(2,2,1)
hold on
plot(irfs_rho0.c_eps_a)
plot(irfs_rho25.c_eps_a)
plot(irfs_rho5.c_eps_a)
plot(irfs_rho75.c_eps_a)
plot(irfs_rho9.c_eps_a)
plot(irfs_rho99.c_eps_a)
plot(irfs_rho1.c_eps_a)
legend off
hold off
title('Consumption IRF, $\theta$ = .75','interpreter','latex')

subplot(2,2,2)
hold on
plot(irfs_rho0.gap_eps_a)
plot(irfs_rho25.gap_eps_a)
plot(irfs_rho5.gap_eps_a)
plot(irfs_rho75.gap_eps_a)
plot(irfs_rho9.gap_eps_a)
plot(irfs_rho99.gap_eps_a)
plot(irfs_rho1.gap_eps_a)
legend off
hold off
title('Output Gap IRF, $\theta$ = .75','interpreter','latex')

subplot(2,2,3)
hold on
plot(irfs_rho0.y_eps_a)
plot(irfs_rho25.y_eps_a)
plot(irfs_rho5.y_eps_a)
plot(irfs_rho75.y_eps_a)
plot(irfs_rho9.y_eps_a)
plot(irfs_rho99.y_eps_a)
plot(irfs_rho1.y_eps_a)
legend off
hold off
title('Output IRF, $\theta$ = .75','interpreter','latex')

subplot(2,2,4)
hold on
plot(irfs_rho0.n_eps_a)
plot(irfs_rho25.n_eps_a)
plot(irfs_rho5.n_eps_a)
plot(irfs_rho75.n_eps_a)
plot(irfs_rho9.n_eps_a)
plot(irfs_rho99.n_eps_a)
plot(irfs_rho1.n_eps_a)
legend('$\rho=0$','$\rho=0.25$', '$\rho=0.5$', '$\rho=0.75$', '$\rho=0.9$', '$\rho=0.99$' , '$\rho=1$' ,'Location', 'SouthOutside','Orientation','horizontal', 'Box', 'off', 'FontSize',14, 'interpreter','latex')
hold off
title('Employment IRF, $\theta$ = .75','interpreter','latex')
saveas(gcf,'KeynesIRF1.png')

figure;
subplot(2,2,1)
hold on
plot(irfs_rho0.pi_eps_a)
plot(irfs_rho25.pi_eps_a)
plot(irfs_rho5.pi_eps_a)
plot(irfs_rho75.pi_eps_a)
plot(irfs_rho9.pi_eps_a)
plot(irfs_rho99.pi_eps_a)
plot(irfs_rho1.pi_eps_a)
legend off
hold off
title('Inlation IRF, $\theta$ = .75','interpreter','latex')

subplot(2,2,2)
hold on
plot(irfs_rho0.markup_eps_a)
plot(irfs_rho25.markup_eps_a)
plot(irfs_rho5.markup_eps_a)
plot(irfs_rho75.markup_eps_a)
plot(irfs_rho9.markup_eps_a)
plot(irfs_rho99.markup_eps_a)
plot(irfs_rho1.markup_eps_a)
legend off
hold off
title('Markup IRF, $\theta$ = .75','interpreter','latex')

subplot(2,2,3)
hold on
plot(irfs_rho0.q_eps_a)
plot(irfs_rho25.q_eps_a)
plot(irfs_rho5.q_eps_a)
plot(irfs_rho75.q_eps_a)
plot(irfs_rho9.q_eps_a)
plot(irfs_rho99.q_eps_a)
plot(irfs_rho1.q_eps_a)
legend off
hold off
title('Nominal Interest Rate IRF, $\theta$ = .75','interpreter','latex')

subplot(2,2,4)
hold on
plot(irfs_rho0.r_eps_a)
plot(irfs_rho25.r_eps_a)
plot(irfs_rho5.r_eps_a)
plot(irfs_rho75.r_eps_a)
plot(irfs_rho9.r_eps_a)
plot(irfs_rho99.r_eps_a)
plot(irfs_rho1.r_eps_a)
legend('$\rho=0$','$\rho=0.25$', '$\rho=0.5$', '$\rho=0.75$', '$\rho=0.9$', '$\rho=0.99$' , '$\rho=1$' ,'Location', 'SouthOutside','Orientation','horizontal', 'Box', 'off','FontSize',14, 'interpreter','latex')
hold off
title('Real Interest Rate IRF, $\theta$ = .75','interpreter','latex')

%%
theta_in_matlab = 0;
rho_in_matlab = 0;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho0 = oo_.irfs;

rho_in_matlab = 0.25;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho25 = oo_.irfs;

rho_in_matlab = .5;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho5 = oo_.irfs;

rho_in_matlab = 0.75;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho75 = oo_.irfs;

rho_in_matlab = 0.9;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho9 = oo_.irfs;

rho_in_matlab = 0.99;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho99 = oo_.irfs;

rho_in_matlab = 1;
dynare yeeStevenDynareMacroCHW4 noclearall
irfs_rho1 = oo_.irfs;

figure;
subplot(2,2,1)
hold on
plot(irfs_rho0.c_eps_a)
plot(irfs_rho25.c_eps_a)
plot(irfs_rho5.c_eps_a)
plot(irfs_rho75.c_eps_a)
plot(irfs_rho9.c_eps_a)
plot(irfs_rho99.c_eps_a)
plot(irfs_rho1.c_eps_a)
legend off
hold off
title('Consumption IRF, $\theta$ = 0','interpreter','latex')

subplot(2,2,2)
hold on
plot(irfs_rho0.gap_eps_a)
plot(irfs_rho25.gap_eps_a)
plot(irfs_rho5.gap_eps_a)
plot(irfs_rho75.gap_eps_a)
plot(irfs_rho9.gap_eps_a)
plot(irfs_rho99.gap_eps_a)
plot(irfs_rho1.gap_eps_a)
ylim([0 .1])
legend off
hold off
title('Output Gap IRF, $\theta$ = 0','interpreter','latex')

subplot(2,2,3)
hold on
plot(irfs_rho0.y_eps_a)
plot(irfs_rho25.y_eps_a)
plot(irfs_rho5.y_eps_a)
plot(irfs_rho75.y_eps_a)
plot(irfs_rho9.y_eps_a)
plot(irfs_rho99.y_eps_a)
plot(irfs_rho1.y_eps_a)
legend off
hold off
title('Output IRF, $\theta$ = 0','interpreter','latex')

subplot(2,2,4)
hold on
plot(irfs_rho0.n_eps_a)
plot(irfs_rho25.n_eps_a)
plot(irfs_rho5.n_eps_a)
plot(irfs_rho75.n_eps_a)
plot(irfs_rho9.n_eps_a)
plot(irfs_rho99.n_eps_a)
plot(irfs_rho1.n_eps_a)
ylim([0 .1])
legend('$\rho=0$','$\rho=0.25$', '$\rho=0.5$', '$\rho=0.75$', '$\rho=0.9$', '$\rho=0.99$' , '$\rho=1$' ,'Location', 'SouthOutside','Orientation','horizontal', 'Box', 'off','FontSize',14, 'interpreter','latex')
hold off
title('Employment IRF, $\theta$ = 0','interpreter','latex')
saveas(gcf,'KeynesIRF1_flex.png')

figure;
subplot(2,2,1)
hold on
plot(irfs_rho0.pi_eps_a)
plot(irfs_rho25.pi_eps_a)
plot(irfs_rho5.pi_eps_a)
plot(irfs_rho75.pi_eps_a)
plot(irfs_rho9.pi_eps_a)
plot(irfs_rho99.pi_eps_a)
plot(irfs_rho1.pi_eps_a)
legend off
hold off
title('Inlation IRF, $\theta$ = 0','interpreter','latex')

subplot(2,2,2)
hold on
plot(irfs_rho0.markup_eps_a)
plot(irfs_rho25.markup_eps_a)
plot(irfs_rho5.markup_eps_a)
plot(irfs_rho75.markup_eps_a)
plot(irfs_rho9.markup_eps_a)
plot(irfs_rho99.markup_eps_a)
plot(irfs_rho1.markup_eps_a)
ylim([-.08 0])
legend off
hold off
title('Markup IRF, $\theta$ = 0','interpreter','latex')

subplot(2,2,3)
hold on
plot(irfs_rho0.q_eps_a)
plot(irfs_rho25.q_eps_a)
plot(irfs_rho5.q_eps_a)
plot(irfs_rho75.q_eps_a)
plot(irfs_rho9.q_eps_a)
plot(irfs_rho99.q_eps_a)
plot(irfs_rho1.q_eps_a)
legend off
hold off
title('Nominal Interest Rate IRF, $\theta$ = 0','interpreter','latex')

subplot(2,2,4)
hold on
plot(irfs_rho0.r_eps_a)
plot(irfs_rho25.r_eps_a)
plot(irfs_rho5.r_eps_a)
plot(irfs_rho75.r_eps_a)
plot(irfs_rho9.r_eps_a)
plot(irfs_rho99.r_eps_a)
plot(irfs_rho1.r_eps_a)
legend('$\rho=0$','$\rho=0.25$', '$\rho=0.5$', '$\rho=0.75$', '$\rho=0.9$', '$\rho=0.99$' , '$\rho=1$' ,'Location', 'SouthOutside','Orientation','horizontal', 'Box', 'off','FontSize',14, 'interpreter','latex')
hold off
title('Real Interest Rate IRF, $\theta$ = 0','interpreter','latex')

