var c w p i n m q U_c U_m;

varexo eps;

parameters chi alpha psi phi beta gamma rho_m nu theta k_m ;

gamma = 1;
rho_m = .93;
psi = 1;
phi = 1;
alpha = 1/3;
chi = 1;
beta = 0.99;
set_param_value('nu', nu_in_matlab);
k_m = 3;
theta = (k_m ^ nu * (1-beta) / (1 + k_m ^ nu * (1-beta)));

q_ss = 1/beta;
Z = (1-theta)*((1-theta)+theta*((1-theta)*(1/theta)*(1-beta))^((nu-1)*(1/nu)))^((nu-gamma)*(1/(1-nu)));
c_ss = ((1-alpha)*Z*(1/chi))^((1-alpha)*1/(phi+alpha+gamma*(1-alpha)));
m_p_ss = (((1-theta)/theta)*(1-beta))^(-1/nu)*c_ss;
U_c_ss = Z*c_ss^(-gamma);
U_m_ss = theta*(m_p_ss)^(-nu) * (((1-theta)*c_ss^(1-nu)+theta * ((((1-theta)/theta)*c_ss^(-nu)*(1-beta))^(-1/nu))^(1-nu)))^((nu - gamma)/(1-nu));
p_ss = 1;
m_ss = m_p_ss/p_ss;
n_ss = c_ss^(1/(1-alpha));
i_ss = log(q_ss);
w_p_ss = (1-alpha)*n_ss^(-alpha);
w_ss = w_p_ss/p_ss;

model;
c=n^(1-alpha);
U_c = (1-theta)*c^(-nu) * (((1-theta)*c^(1-nu)+theta * (m/p)^(1-nu))^((nu - gamma)/(1-nu)));
U_m = theta*(m/p)^(-nu) * (((1-theta)*c^(1-nu)+theta * (m/p)^(1-nu))^((nu - gamma)/(1-nu)));
1 = beta * q * U_c(+1) / U_c * p/(p(+1));
w/p = chi * n^phi / U_c;
U_m = U_c - beta* U_c(+1)*p/p(+1);
w/p = (1-alpha)*n^(-alpha);
m = (m(-1)^rho_m)*exp(eps);
i = log(q);
end;

initval;
c = c_ss;
i = i_ss;
m = m_ss;
q = q_ss;
n = n_ss;
w = w_ss;
U_c = U_c_ss;
U_m = U_m_ss;
p = 1;
end;

steady(solve_algo=0);

shocks;
var eps; stderr 1;
end;

stoch_simul(loglinear, order = 1) c w p i m n ;