function xbar = gaussseidel(Y,Goalfs, n_nus)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

xbar = zeros(sum(n_nus),1);
xbarnew = zeros(sum(n_nus),1);
iter = 1;

while max(abs(xbar-xbarnew))>10^(-4)
    xbar = xbarnew;
    if iter>100
        disp('Gauss Seidel terminated without convergence');
        break;
    end
    for nu=1:N
        xminusnu = getOpponentsVector(xbarnew, nu, n_nus);
        
        model.Q = sparse(0.5*Goalfs{2,nu});
        model.obj = Goalfs{1,nu}*xminusnu+Goalfs{3,nu};
        model.A = sparse(Y{1,nu});
        model.rhs = Y{2,nu};
        model.sense = '<';
        model.lb = Y{3,nu}(:,1);
        model.ub = Y{3,nu}(:,2);
        model.vtype = 'C';
        params.OutputFlag = 0;
        result = gurobi(model,params);
        result.x;
        xbarnew = setPlayersVector(xbarnew,result.x,nu,n_nus);
        clear model
    end
    iter = iter+1;
end
end

