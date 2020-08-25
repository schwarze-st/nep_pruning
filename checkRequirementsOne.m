function flag = checkRequirementsOne(goalfnu, Y, xbar, nu, i)
%Checks, if the requirements of Corollary 3.10.(i) are fulfilled
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

flag = true;
Qi = goalfnu{2,1}(i,:);
Ci = goalfnu{1,1}(i,:);
bi = goalfnu{3,1}(i,1);
Fnuibar = Qi*getPlayersVector(xbar)+Ci*getOpponentsVector(xbar)+bi;
logi = zeros(N,1);
for mu=1:N
    if mu==nu:
        
    else
        xmu = getPlayersVector(xbar, mu, n_nus);
        activeconstr =  abs(Y{1,mu}*xmu-Y{2,mu})<10^(-4);
        activelbnds = abs(xbar-Y{3,mu}(:,1))<10^(-4);
        activeubnds = abs(xbar-Y{3,mu}(:,2))<10^(-4);
        I = eye(n_nu(mu,1));
        gradlbs = I(:,activelbnds);
        gradubs = -I(:,activeubnds);
        gradcons = transpose(Y{1,mu}(activeconstr,:));
        model.A = sparse([gradcons,gradlbs,gradubs]);
        model.rhs = -Fnuibar;
        model.sense = '=';
        model.vtype = 'C';
        %TODO set lower bound on zero
        result = gurobi(model);
        clear model;
        if result.status == 'OPTIMAL':
            logi(mu,1)=1;
        end        
    end
end
if Fnuibar >= 0
    
    


end

