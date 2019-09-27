% function F = computeF(A,T1,T2)
% Compute and denormalize F 
% Input: 
%   -matrix A, normalization matrix T1 and T2
% Output: 
%   -Fundameantal matrix F
function F = computeF(A,T1,T2)

    % Solution for Af=0 using SVD
    [U,S,V] = svd(A);
    f = reshape(V(:,end),[3,3]);
    F = f';
    % Resolve the rank 2 constraint: det(F) =0 using SVD
    [U1,S1,V1] = svd(F);
    S1(end, end) = 0;
    F = U1*S1*V1'; 
    % De-normalize F
    % F= T'_2 F T_1
    F = T2'*F*T1;
    % One more step: make sure that the norm of output_F is 1 (To deal with the scale invariance)
    F= F/norm(F);
    
end
