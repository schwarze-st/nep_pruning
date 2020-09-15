function flag = setempty(Y, n_nus)
% Looks if the strategy set, defined by Y is non-empty
%   Input:
%       Y (3 x N) cell-array: strategy subset
%       n_nus (n x 1) vector
%   Output:
%       logical: flag true, if Y is empty

flag = false;
for nu=1:size(n_nus,1)
    model.A = sparse(Y{1,nu});
    model.rhs = Y{2,nu};
    model.sense = '<';
    model.lb = Y{3,nu}(:,1);
    model.ub = Y{3,nu}(:,2);
    model.vtype = 'C';
    params.OutputFlag = 0;
    result = gurobi(model,params);
    if (strcmp(result.status,'INFEASIBLE')||strcmp(result.status,'INF_OR_UNBD'))
        flag = true;
        break
    end
end
end