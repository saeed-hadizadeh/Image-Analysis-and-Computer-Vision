close all
clear all
clc
img = imread('image.jpg');
load('C1.mat')
load('C2.mat')
load('a.mat')
load('b.mat')
load('c.mat')
load('d.mat')

[a1 b1 c1 d1 e1 f1] = deal(C1(1),C1(2)*2,C1(5),C1(3)*2,C1(6)*2,C1(9));
[a2 b2 c2 d2 e2 f2] = deal(C2(1),C2(2)*2,C2(5),C2(3)*2,C2(6)*2,C2(9));
%% intersect ellipses
syms 'x';
syms 'y';

eq1 = a1*x^2 + b1*x*y + c1*y^2 + d1*x + e1*y + f1;
eq2 = a2*x^2 + b2*x*y + c2*y^2 + d2*x + e2*y + f2;

eqns = [eq1 ==0, eq2 ==0];
S = solve(eqns, [x,y]);
%% solutions
s1 = [double(S.x(1));double(S.y(1));1];
s2 = [double(S.x(2));double(S.y(2));1];
s3 = [double(S.x(3));double(S.y(3));1];
s4 = [double(S.x(4));double(S.y(4));1];
%% 
II = s3;
JJ = s4;
horizon=hcross(II,JJ); %compute the horizon
imDCCP = II*JJ' + JJ*II'; % image of coinc dual to circular points
imDCCP = imDCCP./norm(imDCCP);
%% draw vanishing line
openfig('1111.fig')
hold on
hline(horizon);
%% compute the rectifying homography
[U,D,V] = svd(imDCCP);
D(3,3) = 1;
A = U*sqrt(D);
H_R=inv(A); % shape reconstruction homography
H=inv(H_R); % inverse of shape reconstruction homography
%% compute image projection of cone axis a
horizon=horizon./horizon(3);
c1_center=inv(C1)*horizon; %compute center of c1
c2_center=inv(C2)*horizon; %compute center of c2
lc1c2=hcross(c1_center,c2_center); % compute cone axis a
c1_center=c1_center./c1_center(3);
c2_center=c2_center./c2_center(3);
plot([c1_center(1), c2_center( 1)], [c1_center(2), c2_center(2)], 'b');
scatter(c1_center(1),c1_center(2),'filled',MarkerFaceColor='b')
scatter(c2_center(1),c2_center(2),'filled',MarkerFaceColor='b')
text(c1_center(1), c1_center(2), 'c1', 'FontSize', 20, 'Color', 'r')
text(c2_center(1), c2_center(2), 'c2', 'FontSize', 20, 'Color', 'r')
%% visualize vanishing point

lab=hcross(a,b); 
lcd=hcross(c,d);
v1=hcross(lab,lcd); % compute vanishing point V1
plot([a(1), v1( 1)], [a(2), v1(2)], 'b');
plot([d(1), v1(1)], [d(2), v1(2)], 'b');
text(v1(1), v1(2), 'v1', 'FontSize', 20, 'Color', 'r')
text(c1_center(1), c1_center(2), 'c1', 'FontSize', 20, 'Color', 'r')
text(c2_center(1), c2_center(2), 'c2', 'FontSize', 20, 'Color', 'r')
hold off
v1'*horizon
h1=H(:,1);
h2=H(:,2);
h3=H(:,3);