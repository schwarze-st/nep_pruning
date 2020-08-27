function [B_list] = removexbarbranch(B, xbar, n_nus)
% Create a partition of sets, such that one integer point (xbar) is removed and
% all others from B are preserved
B_list = {};
for nu=1:N
 for i=1:n_nus(nu,1)
     B_new1 = B;
     B_new2 = B;
     ind = getFullIndex(nu,i,n_nus);
     B_new1{3,nu}(i,1) = xbar(ind)+1;
     B_new2{3,nu}(i,2) = xbar(ind)-1;
     B{3,nu}(i,1) = xbar(ind);
     B{3,nu}(i,2) = xbar(ind);
     B_list = [B_list, B_new1, B_new2];
 end
end
end

