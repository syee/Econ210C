var c wp b n q pi y f_1 f_2 A y_flex markup gap r;

varexo eps_a;

parameters gamma rho_a eps phi alpha chi beta phi_pi phi_y theta mu;

gamma = 1;
set_param_value('rho_a', rho_in_matlab);
eps = 10;
phi = 1;
alpha = 1/3;
chi = 1;
beta = 0.99;
phi_pi = 1.5;
phi_y = 0;
set_param_value('theta', theta_in_matlab);
mu = eps/(eps-1) - 1;



pi_ss = 1;
A_ss = 1;
q_ss = 1/beta;
markup_ss = 1+mu;
mc_ss = (eps-1)/eps;
wp_ss = mc_ss * A_ss;
n_ss= [1/chi * wp_ss * A_ss ^(-gamma)]^(1/(gamma+phi));
y_ss = A_ss * n_ss;
c_ss = y_ss;
gap_ss = 1;
f_1_ss = ((1+mu)*y_ss *wp_ss/A_ss)/(1-beta*theta);
f_2_ss = y_ss/(1-beta*theta);
b_ss = f_1_ss/f_2_ss;
y_flex_ss = y_ss;
r_ss = q_ss;

model;
f_2 = y + beta * theta * pi(+1)^(eps-1) * (c(+1)^(-gamma))/(c^(-gamma))*f_2(+1);
f_1 = (1+mu)*y *(wp)/A + beta * theta * pi(+1)^(eps) * (c(+1)^(-gamma))/(c^(-gamma))*f_1(+1);
b = f_1/f_2;
1 = theta * pi^(eps-1) + (1 - theta)* b^(1-eps);
1 = beta * (q * (1/pi(+1)) * (c(+1)^(-gamma))/(c^(-gamma)));
wp = chi* n^phi * c^(gamma);
A = A(-1)^(rho_a) * exp(eps_a);
y = A * n;
y = c;
r = q/pi(+1);
q = 1/beta * pi^phi_pi * (y/y_flex)^phi_y;
A^(1+phi) = chi*(1+mu)*(y_flex)^(gamma+phi);
markup = (y/n)/(wp);
//1 + mu = (y/n)/(wp);
//p_star = b * p;
gap = y/y_flex;
end;

initval;
q = q_ss;
r = r_ss;
pi = pi_ss;
A = A_ss;
wp = wp_ss;
n = n_ss;
y = y_ss;
y_flex = y_flex_ss;
c = c_ss;
b = b_ss;
markup = markup_ss;
gap = gap_ss;
f_1 = f_1_ss;
f_2 = f_2_ss;
end;

steady(solve_algo=0);

shocks;
var eps_a; stderr .1;
end;

stoch_simul(loglinear, nograph, order = 1) c gap y n pi markup q r;