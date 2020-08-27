function [B_lower,B_upper] = integralitybranch(B,xbar,n_nus)
% take one non-integer value in xbar and divide B in two sets to force integrality   

logic = find(abs(xbar-round(xbar))<10^(-5));
ind = logic(1);
[p_ind,p_i] = getPlayersindex(ind,n_nus);
B_lower = B;
B_upper = B;
B_lower{3,p_ind}(p_i,2) = floor(xbar(ind));
B_upper{3,p_ind}(p_i,1) = ceil(xbar(ind));
end

