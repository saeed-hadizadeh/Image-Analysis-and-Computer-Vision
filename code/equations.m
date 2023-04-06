syms 'x1';
syms 'y1';
syms 'x2';
syms 'y2';


eq1 = a1*x1^2 + b1*x1*y1 + c1*y1^2 + d1*x1 + e1*y1 + f1;
eq2 = a1*x2^2 + b1*x2*y2 + c1*y2^2 + d1*x2 + e1*y2 + f1;
eq3 = a2*x1^2 + b2*x1*y1 + c2*y1^2 + d2*x1 + e2*y1 + f2;
eq4 = a2*x2^2 + b2*x2*y2 + c2*y2^2 + d2*x2 + e2*y2 + f2;


eqns = [eq1 ==0, eq2 ==0,eq3==0,eq4==0];
S = solve(eqns, [x1,y1,x2,y2]);