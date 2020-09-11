function flag = pointfeasible(Y,x,n_nus)
% Checks feasibility of xbar for the continuous NEP
%   Input:
%       Y (3 x N) cell-array: strategy subset
%       x (n x 1) vector
%       n_nus (n x 1) vector
%   Output:
%       flag logical
global FEAS_TOL

flag = true;
for nu=1:size(n_nus,1)
    xnu = getPlayersVector(x,nu,n_nus);
    log1 = all(Y{1,nu}*xnu<=Y{2,nu}+FEAS_TOL);
    log2 = all(xnu >= Y{3,nu}(:,1)-FEAS_TOL);
    log3 = all(xnu <= Y{3,nu}(:,2)+FEAS_TOL);
    if ~all([log1,log2,log3])
        flag = false;
    end
end
end

