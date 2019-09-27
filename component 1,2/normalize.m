% Function [Xout, T] = normalize( X )
% Normalize all the points in each image
% Input
%     -X: a matriX with 2D inhomogeneous X in each column.
% Output: 
%     -Xout: a matriX with (2+1)D homogeneous X in each column;
%     -matrix T: normalization matrix

function [Xout, T] = normalize( X )

    % Compute Xmean: normalize all X in each image to have 0-mean
    XYmean = mean(X,2);

    % Compute d: scale all X so that the average distance to the mean is sqrt(2).
    % Check the lab file for details.
    %d = (1/size(X,2))*sqrt((X-Xmean').^2),2);
    temp1=(X-XYmean).^2;
    temp2=sum(temp1);
    d = mean(sqrt(temp2));

    % Compose matrix T
    T = [sqrt(2)/d 0 -XYmean(1)*sqrt(2)/d; 0 sqrt(2)/d -XYmean(2)*sqrt(2)/d; 0 0 1 ];

    % Compute Xout using X^ = TX with one extra dimension (We are using homogenous coordinates)
    Xout = T * [X(1:2,:); ones(1,size(X,2))];

end
