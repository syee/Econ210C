//These are levels of Y's. Not Y hats
var y k n c i w r A;

//exogenous variables
varexo eps;

// Need to declear parameters used in the model
// Parameters used only in initval block doesn't need to be declared here. (You may if you want)
parameters delta alpha rho beta gamma theta;

delta = 0.025;
alpha = 2/3;
rho = 0.979;
beta = 0.984;
theta = 3.48;
gamma = 1.004;
eta = 1;

k_n_ss = ((1-alpha)/[(gamma/beta) - (1-delta)])^(1/alpha);
y_n_ss = (k_n_ss)^(1-alpha);
c_n_ss = y_n_ss + (1-delta)*k_n_ss - gamma*k_n_ss;
n_ss = 1/[1 + (1/[(alpha/theta)*(1/c_n_ss)*y_n_ss])];
r_ss = (gamma/beta) - (1 - delta);
w_ss = alpha * (k_n_ss^(1-alpha));

k_ss = k_n_ss * n_ss;
y_ss = y_n_ss * n_ss;
c_ss = c_n_ss * n_ss;
i_ss = y_ss - c_ss;

//Write the non linearized model here
model;
gamma/c = beta*(1 - delta + r(+1))/c(+1);
theta * c / (1-n) = w; 
r = (1-alpha) * y/k(-1);
w = alpha * (y/n);
y = c + i;
y = A*(k(-1))^(1-alpha)*n^(alpha);
k = (1 - delta)*k(-1)+i;
A = A(-1)^rho * exp(eps);
end;

initval;
r = r_ss;
i = i_ss;
k = k_ss;
y = y_ss;
n = n_ss;
c = c_ss;
w = w_ss;
A = 1;
end;

//to find actual steady state values
steady(solve_algo=0);

shocks;
var eps; stderr 0.07;
end;

stoch_simul(loglinear, order = 1) c y n i k r w A;