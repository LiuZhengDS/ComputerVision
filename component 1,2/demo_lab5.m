% Compute Fundamental Matrix F using the normalized Eight-Point Algorithm
close all; clear all; tic;

% Read images
disp('Reading images');
img1 = imread('TeddyBearPNG/obj02_001.png');
img2 = imread('TeddyBearPNG/obj02_002.png');

img1 = imread('model_castle/8ADT8586.JPG');
img2 = imread('model_castle/8ADT8587.JPG');
% Load Features and Descriptors (provided by TAs)
% you can also extract those features using the Harris/Hessian Affine 
% implementation which can be downloaded from http://www.robots.ox.ac.uk/~vgg/research/affine/detectors.html.
[feat1,desc1,~,~] = loadFeatures('TeddyBearPNG/obj02_001.png.haraff.sift');
[feat2,desc2,~,~] = loadFeatures('TeddyBearPNG/obj02_002.png.haraff.sift');

% Using vl_ubcmatch to match descriptors
disp('Matching Descriptors');
[matches, ~] = vl_ubcmatch(desc1,desc2);
disp(strcat( int2str(size(matches,2)), ' matches found'));

% Get X,Y coordinates of matched features
X1 = feat1(1:2,matches(1,:));
X2 = feat2(1:2,matches(2,:));
%%
% Estimate Fundamental Matrix using the 8-point algorithm
disp('Estimating F');
[F inliers] = estimateFundamentalMatrix(X1,X2);

% Display Fundamental matrix
disp('F =');
disp(F);
%%
% Show the images with inliers matched points
figure(1);
imshow([img1,img2],'InitialMagnification', 'fit');
title('Images with matched points'); hold on;

scatter(X1(1,inliers),X1(2,inliers), 'y');
scatter(size(img1,2)+X2(1,inliers),X2(2,inliers) ,'r');
line([X1(1,inliers);size(img1,2)+X2(1,inliers)], [X1(2,inliers);X2(2,inliers)], 'Color', 'g');

% outliers = setdiff(1:size(matches,2),inliers);
% line([X1(1,outliers);size(img1,2)+X2(1,outliers)], [X1(2,outliers);X2(2,outliers)], 'Color', 'r');
%%
figure(2);
% Visualize epipolar lines
subplot(1,2,1);
imshow(img1,'InitialMagnification', 'fit');
title('Epipolar line for the yellow point of right image'); hold on;
subplot(1,2,2);
imshow(img2,'InitialMagnification', 'fit');
title('Epipolar line for the yellow point of left image'); hold on;

% Take random points and visualize
a  = 1;
b  = size(matches,2);
rL = floor(a + (b-a).*rand(1,1));
rR = floor(a + (b-a).*rand(1,1));
pointL = [X1(:,rL);1];
pointR = [X2(:,rR);1];

subplot(1,2,1);
scatter(pointL(1),pointL(2),15,'y');
subplot(1,2,2);
scatter(pointR(1),pointR(2),15,'y');

% If the obtained line has coordinates (u1, u2, u3) then we can plot it over the image (X,Y) with:
% Y = -(u1 * X + u3)/u2
epiR = F * pointL;
plot(-(epiR(1)*(1:size(img2,2))+epiR(3))./epiR(2), 'r')

epiL = F' * pointR;
subplot(1,2,1);
plot(-(epiL(1)*(1:size(img1,2))+epiL(3))./epiL(2), 'r')






