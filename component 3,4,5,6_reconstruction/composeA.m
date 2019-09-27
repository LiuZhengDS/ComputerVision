% function A = composeA(x1, x2)
% Compose matrix A, given matched points (X1,X2) from two images
% Input: 
%   -normalized points: X1 and X2 
% Output: 
%   -matrix A
function A = composeA(X1, X2)
    A = [];
    x1x = X1(1,:)';
    x1y = X1(2,:)';
    x2x = X2(1,:)';
    x2y = X2(2,:)';
    A = [x1x.*x2x x1x.*x2y x1x x1y.*x2x x1y.*x2y x1y x2x x2y ones(size(x1x,1),1)];
end
