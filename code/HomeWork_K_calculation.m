%% compute calibration matrix K
v2=c1_center;
v3=c2_center;
A=[v1(1)*v3(1)+v1(2)*v3(2)      v1(1)*v3(3)+v3(1)*v1(3)              v1(2)*v3(3)+v3(2)*v1(3)              v1(3)*v3(3);
   H(1)^2+H(2)^2-H(4)^2-H(5)^2  2*H(1)*H(3)-2*H(4)*H(6)  2*H(2)*H(3)-2*H(5)*H(6)  H(3)^2-H(6)^2;
   v1(1)*v2(1)+v1(2)*v2(2)      v1(1)*v2(3)+v2(1)*v1(3)              v1(2)*v2(3)+v2(2)*v1(3)              v1(3)*v2(3)];

B=null(A);
w=[B(1) 0 B(2);
    0   B(1) B(3);
    B(2) B(3) B(4)];


K=inv(chol(w));
K=K./K(9) 
%% comptute roto-translation matrix
Q=inv(K)*H;
i_pi=Q(:,1);
j_pi=Q(:,2);
O_pi=Q(:,3);
k_pi=cross(i_pi,j_pi);
R_t=[i_pi j_pi k_pi O_pi;
     0     0    0     1]

%% comptute cone axis direction in camera reference
c1_3d=R_t*[c1_center(1);c1_center(2);0;c1_center(3)]; % compute c1 center in camera reference
c2_3d=R_t*[c2_center(1);c2_center(2);0;c2_center(3)]; % compute c1 center in camera reference
c1_3d=c1_3d./c1_3d(4)
c2_3d=c2_3d./c2_3d(4)
figure(1);
scatter3(c1_3d(1),c1_3d(2),c1_3d(3),'filled')
text(c1_3d(1),c1_3d(2),c1_3d(3),'C1_center')
hold on
scatter3(c2_3d(1),c2_3d(2),c2_3d(3),'filled')
text(c2_3d(1),c2_3d(2),c2_3d(3),'C2_center')
scatter3(0,0,0,'r')
text(0,0,0,'camera')
plot3([c1_3d(1) c2_3d(1)],[c1_3d(2) c2_3d(2)],[c1_3d(3) c2_3d(3)],'color','b','LineWidth',2)
xlabel('X');ylabel("Y");zlabel("Z")

%% semi_aperture angle
lac=hcross(a,c);
lbd=hcross(b,d);

V=hcross(lac,lbd); % cone vertex
V_3d=R_t*[V(1);V(2);0;V(3)]; % cone vertex in 3D
a_3d=R_t*[a(1);a(2);0;a(3)]; % point a in 3D
V_3d=V_3d./V_3d(4);
a_3d=a_3d./a_3d(4);


V_3dc=V_3d(1:3,:); % cone certex V in cartesian coordinates
a_3dc=a_3d(1:3,:); % point a in cartesian coordinates
c2_3dc=c2_3d(1:3,:); % c2 center in cartesian coordinates


vec_V_3dc_a_3dc=a_3dc-V_3dc; % build 3D vectors 
vec_V_3dc_c2_3dc=c2_3dc-V_3dc; % build 3D vectors
A=vec_V_3dc_a_3dc;
B=vec_V_3dc_c2_3dc;
cos_theta=(dot(A,B)/(norm(A)*norm(B)));
alpha=rad2deg(acos(cos_theta)) % semi aperture angle