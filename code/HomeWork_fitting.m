clear all;
close all;
clc
FNT_SZ = 20;
img = imread('image.jpg');
%% convert rgb to grayscale and histogram equalization
img_gray=rgb2gray(img);
img_gray_eq=histeq(img_gray);

  %% get points for c1 conic
figure(1); imshow(img_gray_eq); title('equalized image')
pause
hold on
[x, y] = getpts();
% save points in the homogeneous cooridnate. It is enough to set to 1 the third component
c = [x(1); y(1); 1]; % consider first point of coinc c1 as point c
d = [x(5); y(5); 1]; % consider first point of coinc c1 as point d
A=[x.^2 x.*y y.^2 x y ones(size(x))];% fit conic to five points
N = null(A);
cc = N(:, 1);
%% 
[a1 b1 c1 d1 e1 f1] = deal(cc(1),cc(2),cc(3),cc(4),cc(5),cc(6));
% here is the matrix of the conic: off-diagonal elements must be divided
% by two
C1=[a1 b1/2 d1/2; b1/2 c1 e1/2; d1/2 e1/2 f1]
% from line 27 to 40 we draw the conic c1
im=zeros(4000,3000);
for i=1:4000
    for j=1:3000
        im(i,j)=[j i 1]*C1*[j i 1]'; % this is an algebraic error
    end
end
if im(1,1)<0 
    im=im*-1;    
end 
imc1=im<0;
B = bwboundaries(imc1,'noholes');
ellipse1.x = B{1}(:,2);
ellipse1.y = B{1}(:,1);
plot(ellipse1.x, ellipse1.y, 'r', 'LineWidth', 2);
%% get points for c2 conic
figure(1)
pause
  [x, y] = getpts();
% save points in the homogeneous cooridnate. It is enough to set to 1 the third component
a = [x(1); y(1); 1];% consider first point of coinc c2 as point a
b = [x(5); y(5); 1]; % consider first point of coinc c2 as point b
A=[x.^2 x.*y y.^2 x y ones(size(x))];% fit conic to five points
N = null(A);
cc = N(:, 1);
%% 
[a2 b2 c2 d2 e2 f2] = deal(cc(1),cc(2),cc(3),cc(4),cc(5),cc(6));
% here is the matrix of the conic: off-diagonal elements must be divided
% by two
C2=[a2 b2/2 d2/2; b2/2 c2 e2/2; d2/2 e2/2 f2]
% from line 56 to 72 we draw the conic c2
im=zeros(4000,3000);
for i=1:4000
    for j=1:3000
        im(i,j)=[j i 1]*C2*[j i 1]'; % this is an algebraic error
    end
end
if im(1,1)<0 
    im=im*-1;    
end    
imc2=im<0;
B = bwboundaries(imc2,'noholes');
ellipse1.x = B{1}(:,2);
ellipse1.y = B{1}(:,1);
figure(1)
hold on
plot(ellipse1.x, ellipse1.y, 'r', 'LineWidth', 2);
%% visualize lines l1 and l2 (contour lines)
text(a(1), a(2), 'a', 'FontSize', FNT_SZ, 'Color', 'r')
text(b(1), b(2), 'b', 'FontSize', FNT_SZ, 'Color', 'r')
text(c(1), c(2), 'c', 'FontSize', FNT_SZ, 'Color', 'r')
text(d(1), d(2), 'd', 'FontSize', FNT_SZ, 'Color', 'r')
l1=hcross(a,c); % compute contour lines
l2=hcross(b,d); % compute contour lines
plot([a(1), c(1)],[a(2), c(2)], 'LineWidth', 1,'Color', 'r')
plot([b(1), d(1)],[b(2), d(2)], 'LineWidth', 1,'Color', 'r')

hold off
