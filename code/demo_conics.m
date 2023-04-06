% Playing with conic sections in homogeneous coordinates
% Preparation
% First, we create an empty image and display it (will be our "canvas")
clear all
clc
figure(1)
im=zeros(500,500);
imshow(im, []);
hold on;

% Data input: enter five points (then enter)
disp('click 5 points, then enter');
[x, y]=getpts;
scatter(x,y,100,'filled');

% x and y are now column vectors.
x
y

% Estimation of conic parameters
% using the technique shown in "Multiple View Geometry", page 9. this is equivalent to requiring that the conic passes trhough all the six points
A=[x.^2 x.*y y.^2 x y ones(size(x))]

% A is 5x6: we find the parameter vector (containing [a b c d e f]) as the
% right null space of A.
% This returns a vector N such that A*N=0.  Note that this expresses the
% fact that the conic passes through all the points we inserted.
N = null(A);
% alternatively you can use the svd
[~,~,V] = svd(A);
N = V(:,end);

% Let's assign the values to variables and build the 3x3 conic matrix (which is symmetrical)
cc = N(:, 1);
% change the name of variables
[a b c d e f] = deal(cc(1),cc(2),cc(3),cc(4),cc(5),cc(6));
% here is the matrix of the conic: off-diagonal elements must be divided
% by two
C=[a b/2 d/2; b/2 c e/2; d/2 e/2 f]

% Remark: since the right null space has dimension one,
% when the points are taken in general position
% the system admits an infinite number of solutions
% however, these can be expressed as lambda * n, where n
% lambda \in R and n = null(A).
% thus, they all corresponds to the same conic.

% Draw the conic
% We pick every pixel, and compute the incidence relation.
im=zeros(500,500);
for i=1:500
    for j=1:500
        im(i,j)=[j i 1]*C*[j i 1]'; % this is an algebraic error
    end
end
figure(2); imshow(im); title('Algebraic error');

% Let's draw black for pixels less than zero, white for pixels greater than 0.
figure(1)
imshow(im > 0);
scatter(x,y, 100, 'filled');

% What happen when A is not full rank?
% Instead of taking 5 points take just 4 N contains in each column a generator of the null space
N = null(A(1 : 4, :));

% then, any vector living in the null space give rise to a conic
% passing throguh those 4 points. Since the nullspace has dimension two
% we can find two conic passing through the four points

% Let's assign the values to variables and build the 3x3 conic matrix (which is symmetrical) Let's start with a first solution, the first vector of the nullspace
cc = N(:, 1);
% cc = N(:, 1) + N(:, 2); % another example, any linear combination is fine
[a, b, c, d, e, f]=deal(cc(1),cc(2),cc(3),cc(4),cc(5),cc(6));
% here is the matrix of the conic
C1_four =[a b/2 d/2; b/2 c e/2; d/2 e/2 f]
% Let's consider a second solution, the second  vector of the nullspace
cc = N(:, 2);
% cc = N(:, 1) + 2*N(:, 2); % another example, any linear combination is fine
[a, b, c, d, e, f]=deal(cc(1),cc(2),cc(3),cc(4),cc(5),cc(6));
% here is the matrix of the conic
C2_four =[a b/2 d/2; b/2 c e/2; d/2 e/2 f]

% Draw the conic
% We pick every pixel, and compute the incidence relation.
im_four=zeros(500,500);
for i=1:500
    for j=1:500
        im_four1(i,j)=[j i 1]*C1_four*[j i 1]';
        im_four2(i,j)=[j i 1]*C2_four*[j i 1]';
    end
end

figure(3)
subplot(1,2,1)
imshow(im_four1>0);
hold on;
scatter(x(1 : 4), y(1 : 4), 100, 'filled','cyan');
scatter(x(5), y(5), 100, 'filled','red');
title('1st nullspace col ')
subplot(1,2,2)
imshow(im_four2>0);
hold on
scatter(x(1 : 4), y(1 : 4), 100, 'filled','cyan');
scatter(x(5), y(5), 100, 'filled','red');
title('2n nullspace col ')
hold off

% Any linear combination of N1 and N2 is a solution
% we can draw a pencil of conics
for lambda = [10, 200, 3000, 100000]

    cc = 1*N(:,1)+ lambda*N(:,2);
    [a, b, c, d, e, f]=deal(cc(1),cc(2),cc(3),cc(4),cc(5),cc(6));
    C3_four =[a b/2 d/2; b/2 c e/2; d/2 e/2 f];
    % We pick every pixel, and compute the incidence relation.
    im_four=zeros(500,500);
    for i=1:500
        for j=1:500
            im_four3(i,j)=[j i 1]*C3_four*[j i 1]';
        end
    end
    figure(4)
    imshow(im_four3>0);
    hold on;
    scatter(x(1 : 4), y(1 : 4), 100, 'filled','cyan');
    scatter(x(5), y(5), 100, 'filled','red');
    title('linear combination of nullspace cols ')
    pause;
end

% Tangent lines
% Let's draw the tangents to our points: the tangent line in homogeneous coordinates is l the line tangent to C at the line x is defined as l = C*x
% this is the line tangent to the first point
l1 = C * [x(1); y(1); 1];
% here I compute all the tangent lines simultaneously
% stacking all the vectors in the columns of the matrix l
l=C*[x y ones(size(x))]'

% in order to draw it we find its angle, then plot a line of length 200 around it. In order to write less lines of code, I'm doing a bit of hacks with matrices and vectors here: theta will be a column vector of angles, and with a single plot command I'll plot all the lines. Check out the documentation of plot to understand what's happening.
theta=atan2(-l(1,:),l(2,:));
theta = theta';
figure(1), hold on
plot([x-cos(theta)*100 x+cos(theta)*100]',...
    [y-sin(theta)*100 y+sin(theta)*100]','b-','LineWidth',5);
