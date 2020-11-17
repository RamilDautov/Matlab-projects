close all


l1 = 0.75; %m
l2 = 1.25; %m
l3 = 1.10; %m

F0 = 100; %N

q_0 = [0 pi/3 -pi/4 -0.407*pi]';
F_0 = [0 0.29 -0.96]';

l0_C = l_C(q_0);
l0_S = l_S(q_0);


cov_k_0 = (1/F0^2)*[1/a_11(q_0)                            0                                                      0; 
                      0               a_33(q_0)/(a_22(q_0)*a_33(q_0)-a_23(q_0)^2)                a_23(q_0)/(a_22(q_0)*a_33(q_0)-a_23(q_0)^2);
                      0               a_23(q_0)/(a_22(q_0)*a_33(q_0)-a_23(q_0)^2)                a_22(q_0)/(a_22(q_0)*a_33(q_0)-a_23(q_0)^2)];
                  
                  
                  
         

% Optimal test configuration                  
q = fminunc(@calc_O, q_0);

cov_k = (1/F0^2)*[1/a_11(q)                            0                                                      0; 
                      0               a_33(q_0)/(a_22(q)*a_33(q)-a_23(q)^2)                a_23(q_0)/(a_22(q)*a_33(q)-a_23(q)^2);
                      0               a_23(q_0)/(a_22(q)*a_33(q)-a_23(q)^2)                a_22(q_0)/(a_22(q)*a_33(q)-a_23(q)^2)];

                  
                  

% cov_k_0
% q
% cov_k

% Functions

function x = l_C(q)
l2 = 1.25; %m
l3 = 1.10; %m

x = l2*cos(q(2))+l3*cos(q(2)+q(3));
end

function x = l_S(q)
l2 = 1.25; %m
l3 = 1.10; %m

x = l2*sin(q(2))+l3*sin(q(2)+q(3));
end

function x = a_11(q)

x = (l_C(q)^4)*(cos(q(4)))^2;

end

function x = a_22(q)
l2 = 1.25; %m
l3 = 1.10; %m

x = (l_C(q)^2)*(l2^2 + l3^2 + 2*l2*l3*cos(q(3)))*(sin(q(4)))^2;

end

function x = a_33(q)
l2 = 1.25; %m
l3 = 1.10; %m

x = (l3^4)*(cos(q(2) + q(3))^2)*(sin(q(4)))^2;

end

function x = a_23(q)
l2 = 1.25; %m
l3 = 1.10; %m

x = (l3^2)*l_C(q)*cos(q(2) + q(3))*(l3 + l2*cos(q(3)))*(sin(q(4)))^2;

end


%Objective

function o = calc_O(q)
q_0 = [0 pi/3 -pi/4]';
F_0 = [0 0.29 -0.96]';

l2 = 1.25; %m
l3 = 1.10; %m

d1 = (l_C(q_0)^4)*(F_0(1)*sin(q_0(1)) + F_0(2)*cos(q_0(1)))^2;
d2 = (l3^2)*(F_0(1)*l3*sin(q_0(2)+q_0(3))*cos(q_0(1)) + F_0(2)*l3*sin(q_0(2)+q_0(3))*sin(q_0(1)) - F_0(3)*l3*cos(q_0(2)+q_0(3)))^2;
d3 = ((F_0(1)*l_S(q_0)*cos(q_0(1)) + F_0(2)*l_S(q_0)*sin(q_0(1)) - F_0(3)*l_C(q_0))^2)*(l2^2 + l3^2 + 2*l2*l2*cos(q_0(3)));
d4 = l3*(l3 + l2*cos(q_0(3)))*(F_0(1)*l_S(q_0)*cos(q_0(1)) + F_0(2)*l_S(q_0)*sin(q_0(1)) - F_0(3)*l_C(q_0))*...
    (F_0(1)*l3*sin(q_0(2)+q_0(3))*cos(q_0(1)) + F_0(2)*l3*sin(q_0(2)+q_0(3))*sin(q_0(1)) - F_0(3)*l3*cos(q_0(2) - q_0(3)));

%Objective function
o = (d1/a_11(q)) + (d2*a_22(q) + d3*a_33(q) + 2*d4*a_23(q))/(a_22(q)*a_33(q) - a_23(q)^2);

end
