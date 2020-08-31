function [xbar,flag_empty] = gaussseidel(Y,Goalfs,n_nus)
% Gauss-Seidel Procedure to calculate continuous Nash-equilibrium for (NEP) 
%   Input:
%       Y (3xN) cell-array: Strategy subset 
%                A (m_nu x n_nu)-matrix,
%                b (m_nu x 1)-vector,
%                bnd (n_nu x 2)-matrix,
%                    describe linear contrained strategy set of player nu
%       Goalfs: (3 x N)-cell array containing N cells with:
%                C (n_nu x n-n_nu)-matrix,
%                Q (n_nu x n_nu)-matrix,
%                b (n_nu x 1)-vector.
%                    deccribe the nu-th players goalfunction
%                    1/2* x_nu'*C*x_nu + (C*x_-nu + b)'x_nu
%    Output: 
%       xbar: continuous Nash-equilibrium of the game (if it
%           converged)
%       flag-empty: logical: returns true, if Y is an empty set

xbar = ones(sum(n_nus),1);
xbarnew = zeros(sum(n_nus),1);
iter = 1;
flag_empty = false;

while max(abs(xbar-xbarnew))>10^(-4)
    xbar = xbarnew;
    if iter>100
        disp('Gauss Seidel terminated without convergence');
        break;
    end
    for nu=1:size(n_nus,1)
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
        if strcmp(result.status,'INFEASIBLE')
            flag_empty = true;
            xbar=xbarnew;
            break
        else
            xbarnew = setPlayersVector(xbarnew,result.x,nu,n_nus);
        end
        clear model
    end
    iter = iter+1;
end
end

