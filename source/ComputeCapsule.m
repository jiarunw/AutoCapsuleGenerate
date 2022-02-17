% Input: 
% X: [N-by-1 double] point cloud data
% Return:
% R: [Scalar double] Radius of the capsule
% OR: [Scalar double] Distance between the capsule center and the right hand side capsule sphere center
% OL: [Scalar double] Distance between the capsule center and the left hand side capsule sphere center
% theta: [3-by-1 double] Directional unit vector of the capsule's center line
% Oh: [3-by-1 double] Center of the capsule
% OR_vec: xyz coordinate of the right hand side capsule sphere center
% OL_vec: xyz coordinate of the left hand side capsule sphere center 
function [R, OR, OL, theta, Oh, OR_vec, OL_vec] = ComputeCapsule(X)
    O = mean(X, 1); % Point Cloud center
    [U, S, V] = svd(X - O);
    [M, I] = max(max(S));
    theta = V(:, I)';
    
    OX = X - O;
    [N, ~] = size(OX);
    Theta = sum(repmat(theta, N, 1) .* OX, 2);
    r = sqrt(sum(cross(repmat(theta, N, 1), OX, 2).^2, 2));
    R = max(max(r));
    OR = max(Theta - sqrt(R^2 - r.^2));
    OL = min(Theta + sqrt(R^2 - r.^2));
    OL_vec = O + OL * theta;
    OR_vec = O + OR * theta;  
    Oh = O + 0.5 * (OR + OL) * theta;
end