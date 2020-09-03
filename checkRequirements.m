function [flagi,flagii] = checkRequirements(goalfnu, Y, n_nus, xbar, nu, i)
%Checks, if the requirements of Pruning Theorem for (i)/(ii) are fulfilled
%   Input:
%       goalfnu: (3 x 1)-cell vector with goalfunction:
%       Y: (3xN)-cell array: strategy subset
%       xbar: (n x 1)-vector
%       nu:     integer -Playernr.
%       i:      integer -Players-index of variable
%   Output:
%       flagi:  logical -Requirements for case (i) are fulfilled
%       flagii: logical -Requirements for case (ii) are fulfilled

% Calculate Fnuibar
Ci = goalfnu{1,1}(i,:);
Qi = goalfnu{2,1}(i,:);
bi = goalfnu{3,1}(i,1);
Fnuibar = Qi*getPlayersVector(xbar,nu,n_nus)+Ci*getOpponentsVector(xbar,nu,n_nus)+bi;

% Check if case (i)/(ii) is fulfilled
flagi = false;
flagii= false;
logi = zeros(size(n_nus,1),1);
logii = zeros(size(n_nus,1),1);
for mu=1:size(n_nus,1)
    xmu = getPlayersVector(xbar, mu, n_nus);
    activeconstr = abs(Y{1,mu}*xmu-Y{2,mu})<FEAS_TOL;
    activelbnds = abs(xmu-Y{3,mu}(:,1))<FEAS_TOL;
    activeubnds = abs(xmu-Y{3,mu}(:,2))<FEAS_TOL;
    I = eye(n_nus(mu,1));
    gradlbs = I(:,activelbnds);
    gradubs = -I(:,activeubnds);
    gradcons = transpose(Y{1,mu}(activeconstr,:));
    if mu==nu
        gradFnuibar = Qi';
    else
        lower = sum(n_nus(1:mu-1,1))+1;
        if nu<mu
            lower = lower - n_nus(nu,1);
        end
        upper = lower + n_nus(mu,1) -1;
        gradFnuibar = Ci(1,lower:upper)';
    end
    model.A = sparse([gradcons,gradlbs,gradubs]);
    model.sense = '=';
    model.vtype = 'C';
    model.lb = zeros(size([gradcons,gradlbs,gradubs],2),1);
    params.OutputFlag = 0;
    if Fnuibar>=0
        model.rhs = gradFnuibar;
        result = gurobi(model,params);
        if strcmp(result.status,'OPTIMAL')
            logi(mu,1)=1;
        end
    end
    if Fnuibar<=0
        model.rhs = -gradFnuibar;
        result = gurobi(model,params);
        if strcmp(result.status,'OPTIMAL')
            logii(mu,1)=1;
        end
    end   
    clear model;
end
if all(logi==1)
    flagi = true;
end
if all(logii==1)
    flagii = true;
end
end
