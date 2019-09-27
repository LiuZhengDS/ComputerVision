% function sfm
% A demo of the SfM (Structure from Motion) that shows the 3D structure of the points in the space. 
% Either from the original given set of points or the tracked points.
% 
% INPUT
%   Set of point correspondences to be read from local file. 
%
% OUTPUT
%   An image showing the 3D points in their estimated 3D world position.
%       - Yellow dots are when using the given list of points.
%       - Pink dots are when using the tracked points from the LKtracker.
%   M: The transformation matrix size of 2nx3. Where n is the number of cameras i.e. images.
%   S: The estimated 3-dimensional locations of the points (3x#points).

function [M,S,p] = sfm(X)
    close all

    % Load initial set of points
    %X = importdata('model_house/measurement_matrix.txt');

    [rows, noPoints] = size(X);
    % Centering: subtract the centroid of the image points (removes translation)
    X = X - (mean(X,2));

    % Singular value decomposition
    % Remark: Please pay attention to using V or V'. Please check matlab function: "help svd".
    [U,W,V] = svd(X);

    % The matrix of measurements must have rank 3.
    % Keep only the corresponding top 3 rows/columns from the SVD decompositions.
    U = U(:,1:3);
    W = W(1:3,1:3);
    V = V(:,1:3);
    % Compute M and S: One possible decomposition is M = U W^{1/2} and S = W^{1/2} V'
    M = U*(W^(1/2));
    S = (W^(1/2))*V';
    save('M','M');

    % Eliminate the affine ambiguity
    % Orthographic: We need to impose that image axes (a1 and a2) are perpendicular and their scale is 1.
    % (a1: col vector, projection of x; a2: row vector, projection of y;,)
    % We define the starting value for L, L0 as: A1 L0 A1' = Id 
    A1 = M(1:2, :);
    L0 = pinv(A1' * A1);

    % We solve L by iterating through all images and finding L one which minimizes Ai*L*Ai' = Id, for all i.
    % LSQNONLIN solves non-linear least squares problems. Please check the Matlab documentation.
    L = lsqnonlin(@residuals, L0);

    % Recover C from L by Cholesky decomposition.
    [C,p] = chol(L,'lower');
    if p>0
        return;
    end
    % Update M and S with the corresponding C form: M = MC and S = C^{-1}S. 
    M = M*C;
    S = C\S;
    % Plot the obtained 3D coordinates:
%     plot3(S(1,:),S(2,:),S(3,:),'.y');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%% Repeat the same procedure for the Optical Flow tracked points %%%%%%%%%%%
    % Clear variables (U,W,V,M,S,A1,L0) which have been used in first part load tracked points
%     load('Xpoints')
%     load('Ypoints')
%     X2 = zeros(size(X));
%     X2(1:2:end,:)= pointsx;
%     X2(2:2:end,:)= pointsy;
% %     X2(1:101,:)= pointsx;
% %     X2(102:end,:)= pointsy;
    
    X2=X;
    % Centering the data
    [~,noPoints] = size(X2);
    X2 = X2 - (mean(X2,2));

    % Perform the Singular Value Decomposition
    [U,W,V] = svd(X2);
    % Impose the rank 3 constraint by keeping the top 3 columns/rows for the obtained matrices.
    U = U(:,1:3);
    W = W(1:3,1:3);
    V = V(:,1:3);

    % Define the matrices M and S from U, W, and V.
    M1 = U*(W^(1/2));
    S1 = (W^(1/2))*V';
    save('M1','M1');

    % Solve the affine ambiguity 
    A1 = M1(1:2, :);
    L0 = pinv(A1' * A1);
    L = lsqnonlin(@residuals,L0);

    % Recover C from L by Cholesky decomposition
    [C,p] = chol(L,'lower');

    % Update M and S with the values of C: M = MC, S = C^{-1}S
    M1 = M1*C;
    S1 = C\S1;

    % Plot the obtained 3D points as well.
%     hold on
%     plot3(S1(1,:),S1(2,:),S1(3,:),'.m');

end