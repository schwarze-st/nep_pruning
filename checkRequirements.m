function [flagi,flagii] = checkRequirements(goalfnu, Y, xbar, nu, i)
%Checks, if the requirements of Pruning Theorem for (i)/(ii) are fulfilled
%   Input:
%       goalfnu: (3 x 1)-cell vector containing 3 cells with:
%            C (n_nu x n-n_nu)-matrix,
%            Q (n_nu x n_nu)-matrix,
%            b (n_nu x 1)-vector.
%                deccribe the nu-th players goalfunction
%                1/2* x_nu'*Q*x_nu + (C*x_-nu + b)'x_nu
%       Y: strategy subset of Omega
%       xbar: (n x 1)-vector
%       nu:     integer -Playernr.
%       i:      integer -Players-index of variable
%   Output:
%       flagi:  logical -Requirements for case (i) are fulfilled
%       flagii: logical -Requirements for case (ii) are fulfilled

% Calculate Fnuibar
Qi = goalfnu{2,1}(i,:);
Ci = goalfnu{1,1}(i,:);
bi = goalfnu{3,1}(i,1);
Fnuibar = Qi*getPlayersVector(xbar)+Ci*getOpponentsVector(xbar)+bi;

% Check if case (i) is fulfilled
flagi = false;
flagii= false;
logi = zeros(N,1);
logii = zeros(N,1);
for mu=1:N
    xmu = getPlayersVector(xbar, mu, n_nus);
    activeconstr =  abs(Y{1,mu}*xmu-Y{2,mu})<10^(-4);
    activelbnds = abs(xbar-Y{3,mu}(:,1))<10^(-4);
    activeubnds = abs(xbar-Y{3,mu}(:,2))<10^(-4);
    I = eye(n_nu(mu,1));
    gradlbs = I(:,activelbnds);
    gradubs = -I(:,activeubnds);       
    if mu==nu
        gradcons = transpose(Y{2,mu}(activeconstr,:));
        gradFnuibar = Qi';
    else
        gradcons = transpose(Y{1,mu}(activeconstr,:));    
        gradFnuibar = Ci';
    end
    model.A = sparse([gradcons,gradlbs,gradubs]);
    model.sense = '=';
    model.vtype = 'C';
    model.lb = zeros(size(A,2),1);
    params.OutputFlag = 0;
    if Fnuibar>=0
        model.rhs = -gradFnuibar;
        result = gurobi(model,params);
        if strcmp(result.status,'OPTIMAL')
            logi(mu,1)=1;
        end
    end
    if Fnuibar<=0
        model.rhs = gradFnuibar;
        result = gurobi(model,params);
        if strcmp(result.status,'OPTIMAL')
            logii(mu,1)=1;
        end
    end   
    clear model;
end
if and(logi==ones(N,1),Fnuibar>=0)
    flagi = true;
end
if and(logii==ones(N,1),Fnuibar<=0)
    flagii = true;
end
end


