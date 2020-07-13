close all, clear all, clc
%% Initialize the system

syms g mp mc L d1 d2;


A = [0  0                   1           0;
     0  0                   0           1;
     0  g*mp/mc             -d1/mc      -d2/(L*mc);
     0  g*(mc*mp)/(L*mc)    -d1/(L*mc)  -d2*(mc+mp)/(L^2*mc*mp)];

B = [0;
     0;
     1/mc;
     1/(L*mc)];
  
 A_hat = double(subs(A, [mc mp g L d1 d2], [1.5 0.5 9.82 1 .01 .01]));
 B_hat = double(subs(B, [mc L], [1.5 1]));
 
 x0 = [0;
       5*pi/180;
       0;
       0];
 %% output
 C = [1 0 0 0];     % q_1 as output
 %C = [0 1 0 0];     % q_2 as output
 %C = [0 0 1 0];     % q_1_dot as output
 %C = [0 0 0 1];     % q_2_dot as output
 
 D = 0;
 
 %% build the System
 sysFull = ss(A_hat, B_hat, C, D);
 sc = ctrb(sysFull);    % Steubarkeit
 so = obsv(sysFull);    % Beobachtbarkeit
 rank(sc);
 rank(so);
 %rlocus(sysFull);        % a pos. eigwert --> kein P-Regler dises Sys. regeln kann
                         % in diesem Fall --> 1. ZD.     2. PI, PD, PID

%% controller
des_pole = [-3;
            -3;
            -3;
            -3];
        
k = acker(A_hat, B_hat, des_pole);        

Q = eye(4);
R = .5;
k_lqr = lqr(A_hat, B_hat, Q, R);

%% discretize
Ts = .1;
sys_d = c2d(sysFull, Ts);
[A_d, B_d, C_d, D_d] = ssdata(sys_d);

des_pole_d = [.3;
              .3;
              .3;
              .3]*1.5;
          
k_d = acker(A_d, B_d, des_pole_d);
[k_lqr_d, ~, ~] = dlqr(A_d, B_d, Q, R);


obs_des_pole_d = des_pole_d * 0.5;
l = acker(A_d', C_d', obs_des_pole_d);


