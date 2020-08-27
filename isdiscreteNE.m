function [flag] = isdiscreteNE(xbar, Omega, Goalfs, N, n_nus)
% proofs, if xbar is a discrete Nash equilibrium of the game

flag = true;
for nu=1:N
    xnu = getPlayersVector(xbar, nu, n_nus);
    xminusnu = getOpponentsVector(xbar, nu, n_nus);
    z = xnu'*Goalfs{1,nu}*xminusnu + 0.5*xnu'*Goalfs{2,nu}*xnu + Goalfs{3,nu}*xnu;
    
    model.Q = sparse(0.5*Goalfs{2,nu});
    model.obj = Goalfs{1,nu}*xminusnu+Goalfs{3,nu};
    model.A = sparse(Omega{1,nu});
    model.rhs = Omega{2,nu};
    model.sense = '<';
    model.lb = Omega{3,nu}(:,1);
    model.ub = Omega{3,nu}(:,2);
    model.vtype = 'I';
    params.OutputFlag = 0;
    result = gurobi(model,params);
    result.x;
    if abs(result.objval-z)>10^(-4)
        flag = false;
        break;
    end
    clear model
end

