%% this is the main file used for Q1 and Q2 of the final CV project.
%(for compress the size, I did not upload the whole dataset directory)
clc
clear all
img1 = imread('model_castle/8ADT8586.JPG');   % comment to select one of two datasets
img2 = imread('model_castle/8ADT8587.JPG');

img1 = imread('TeddyBearPNG/obj02_001.png');
img2 = imread('TeddyBearPNG/obj02_002.png');

%% Question 1: find matches
%%%%%%%%%%% use the toolbox function vl_ubcmatch to find match %%%%%%%%%%%
im1 = single(rgb2gray((img1)));
im2 = single(rgb2gray((img2)));
[frames1, desc1]=vl_sift(im1);
[frames2, desc2]=vl_sift(im2);
[matches] = vl_ubcmatch(desc1, desc2);

% select 50 matches to visualize, too many will give a messy view
numm=300;     
pts1 = frames1(:,matches(1,1:numm));    
pts2 = frames2(:,matches(2,1:numm));      

% first show the matches without RANSAC
figure; imshow([img1, img2]);          
line([pts1(1,:);size(im1,2)+pts2(1,:)],[pts1(2,:);pts2(2,:)]);

% scatter plot the interesting points
hold on; 
scatter(pts1(1,:),pts1(2,:),'y');
scatter(pts2(1,:)+size(im1,2),pts2(2,:),'g');
hold off;
title('VL-ubcmathes of Image 1 and 2 without RANSAC uses');

%%%%%%%%%%%% use self-coded harris detection to find matches %%%%%%%%%%%%%%
[ma1,ma2] = findMatches(img1, img2, 0.9);

%% Question 2: applying the RANSAC for the best matches
% Get X,Y coordinates of matched features from each image
X1 = ma1(1:2,:);
X2 = ma2(1:2,:);

% Estimate Fundamental Matrix using the 8-point algorithm
disp('Estimating F');
[F inliers] = estimateFundamentalMatrix(X1,X2);

% Display Fundamental matrix
disp('F =');
disp(F);

% Show the images with inliers matched points
figure;
imshow([img1,img2],'InitialMagnification', 'fit');
title('Images with matched points'); hold on;

scatter(X1(1,inliers),X1(2,inliers), 'y');
scatter(size(img1,2)+X2(1,inliers),X2(2,inliers) ,'r');
line([X1(1,inliers);size(img1,2)+X2(1,inliers)], [X1(2,inliers);X2(2,inliers)], 'Color', 'g');
