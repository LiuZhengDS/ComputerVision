% function A = composeA(x1, x2)
% Compose matrix A, given matched points (X1,X2) from two images
% Input: 
%   -normalized points: X1 and X2 
% Output: 
%   -matrix A
function A = composeA(x1, x2)
  x=x1(1,:)';
  y=x1(2,:)';
  xp=x2(1,:)';
  yp=x2(2,:)';
  
  A = [x.*xp, x.*yp, x, y.*xp, y.*yp, y, xp, yp, ones(size(x,1),1)];
end
