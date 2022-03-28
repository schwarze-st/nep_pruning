function [xbar,flag_empty] = gaussseidel(Y,Obj,n_nus,conv)
% Gauss-Seidel Procedure to calculate continuous Nash-equilibrium for (NEP) 
%   Input:
%       Y (3xN) cell-array: Strategy subset 
%       Obj: (3 x N) cell-array: Objective functions
%       n_nus: (Nx1)-vector
%    Output: 
%       xbar: continuous Nash-equilibrium of the game (if it
%           converged)
%       flag-empty: logical: returns true, if Y is an empty set

global N_I G_CALLS G_TIME;

xbar = ones(sum(n_nus),1);
xbarnew = zeros(sum(n_nus),1);
iter = 1;
flag_empty = false;

while max(abs(xbar-xbarnew))>10^(-2)
    xbar = xbarnew;
    if iter>100
        disp('Gauss Seidel terminated without convergence');
        break;
    end
    for nu=1:size(n_nus,1)
        xminusnu = getOpponentsVector(xbarnew, nu, n_nus);
        model.Q = sparse(0.5*Obj{2,nu});
        model.obj = Obj{1,nu}*xminusnu+Obj{3,nu};
        model.A = sparse(Y{1,nu});
        model.rhs = Y{2,nu};
        model.sense = '<';
        model.lb = Y{3,nu}(:,1);
        model.ub = Y{3,nu}(:,2);
        model.vtype = 'C';
        if iter>1
            model.pstart = getPlayersVector(xbar,nu,n_nus);
        end
        params.OutputFlag = 0;
        if conv(nu)==0
            params.NonConvex = 2; % Achtung, hier wird eingestellt, dass die Zf nichtkonvex ist
        end
        %params.BarConvTol = 10^(-8);
        t_s = tic;
        result = gurobi(model,params);
        G_CALLS(N_I,1) = G_CALLS(N_I,1)+1;
        G_TIME(N_I,1) = G_TIME(N_I,1) + toc(t_s); 
        if (strcmp(result.status,'INFEASIBLE')||strcmp(result.status,'INF_OR_UNBD'))
            flag_empty = true;
            xbar=xbarnew;
            break
        else
            assert(strcmp(result.status,'OPTIMAL'),'Error: Gauss-Seidl Iteration not Infeasible nor Optimal');
            xbarnew = setPlayersVector(xbarnew,result.x,nu,n_nus);
        end
    end
    iter = iter+1;
end
if ~flag_empty
    assert(pointfeasible(Y,xbar,n_nus),'Error: Gauss-Seidel Procedure produced infeasible point');
end
end

