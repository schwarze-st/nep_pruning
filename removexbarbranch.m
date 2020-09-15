function [B_list] = removexbarbranch(B, xbar, n_nus)
% Create a partition of sets, such that one integer point (xbar) is removed and
%   Input:
%       B: (3xN)-cell array: Strategy subset
%       xbar (n x 1) Vector
%       n_nus (N x 1) Vector
%   Output
%       B_list: (1x2n)-cell array with each cell containing a (3xN) strategy subset 

global FEAS_TOL

B_list = cell(1,2*sum(n_nus));
assert(pointfeasible(B,xbar,n_nus),'Error: xbar is not in this set');
k = 1;

for nu=1:size(n_nus,1)
    for i=1:n_nus(nu,1)
         B_new1 = B;
         B_new2 = B;
         ind = getFullIndex(nu,i,n_nus);
         B_new1{3,nu}(i,1) = xbar(ind)+1;
         B_new2{3,nu}(i,2) = xbar(ind)-1;
         assert(~pointfeasible(B_new1,xbar,n_nus),'Error in removexbarbranch: not branched out!');
         assert(~pointfeasible(B_new2,xbar,n_nus),'Error in removexbarbranch: not branched out!');
         if (B_new1{3,nu}(i,1)<=B_new1{3,nu}(i,2)-FEAS_TOL) && ~setempty(B_new1, n_nus)
             B_list{k}   = B_new1;
         end
         if (B_new2{3,nu}(i,1)<=B_new2{3,nu}(i,2)-FEAS_TOL) && ~setempty(B_new2, n_nus)
             B_list{k+1} = B_new2;
         end
         B{3,nu}(i,1) = xbar(ind);
         B{3,nu}(i,2) = xbar(ind);
         k = k+2;
    end
end
assert(size(B_list,1)==1,"B_list in removexbarbranch wrong");
end

