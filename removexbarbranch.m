function [B_list] = removexbarbranch(B, xbar, n_nus)
% Create a partition of sets, such that one integer point (xbar) is removed and
%   Input:
%       B: (3xN)-cell array
%           B(1,nu): A^nu (m_nu x n_nu) Matrix
%           B(2,nu): b^nu (m_nu x 1) Vector
%           B(3,nu): bnd^nu (n_nu x 2) Matrix
%       xbar (n x 1) Vector
%       n_nus (N x 1) Vector
%   Output
%       B_list: (1x2n)-cell array with each cell containing a (3xN) cell
%       array of same type like B

B_list = cell(1,2*sum(n_nus));
k = 1;
for nu=1:size(n_nus,1)
 for i=1:n_nus(nu,1)
     B_new1 = B;
     B_new2 = B;
     ind = getFullIndex(nu,i,n_nus);
     B_new1{3,nu}(i,1) = xbar(ind)+1;
     B_new2{3,nu}(i,2) = xbar(ind)-1;
     B{3,nu}(i,1) = xbar(ind);
     B{3,nu}(i,2) = xbar(ind);
     B_list(1,k) = {B_new1};
     B_list(1,k+1) = {B_new2};
     k = k+2;
 end
end
assert(all(size(B_list)==[1,2*sum(n_nus)]),"B_list in removexbarbranch wrong");
end

