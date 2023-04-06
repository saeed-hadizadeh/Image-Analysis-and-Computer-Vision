clear all;
close all;
clc
FNT_SZ = 20;
img = imread('image.jpg');
figure(1); imshow(img); title('Original image')
%% convert rgb to grayscale and histogram equalization
img_gray=rgb2gray(img);
figure(2); imshow(img); title('Grayscale image')
img_gray_eq=histeq(img_gray);
figure(4);
subplot(2,1,1)
histogram(img_gray);title('Grayscale image histogram')
subplot(2,1,2)
histogram(img_gray_eq);title('Grayscale equalized image histogram')
%% canny edge detection
edgs = edge(img_gray_eq, 'canny',[.1 .2],15);% the first vector is the interval and the number is sigma
figure(4); imshow(edgs);title('Canny edge detection')
%% Sobel edge detection
edges_sobel=edge(img_gray_eq, 'sobel',0.04);
figure(5); imshow(edges_sobel);title('Sobel edge detection')
%% Prewitt edge detection
edges_prewitt=edge(img_gray_eq, 'prewitt',0.04);
figure(6); imshow(edges_prewitt);title('Prewitt edge detection')
%% Roberts edge detection
edges_roberts=edge(img_gray_eq, 'roberts',0.04);
figure(7); imshow(edges_roberts);title('Roberts edge detection')
%% Harris Corner detection
corners = detectHarrisFeatures(img_gray_eq,'MinQuality', 0.03);
figure(8);imshow(img); hold on;
plot(corners);hold off
%% Draw the fitted line segments
 [edgelist, labelededgeim] = edgelink(edgs, 100);
% % Fit line segments to the edgelists
     tol = 5;         % Line segments are fitted with maximum deviation from
% 		     % original edge of 5 pixels.
    seglist = lineseg(edgelist, tol);
% 
%     % Draw the fitted line segments stored in seglist in figure with
%     % a linewidth of 1 and random colours
figure(3);  drawedgelist(seglist, size(img), 1, 'rand', 3); %axis off

