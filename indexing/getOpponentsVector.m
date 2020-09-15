function [xminusnu] = getOpponentsVector(x, nu, n_nus)
%returns the vector of all variables, excepts the ones controlled by player nu
%   Input:
%       x: (n x 1)-vector of all vars
%       nu: integer number of player
%       n_nus: (N x 1)-vector with number of vars for each player
%   Output:
%       xminusnu: ((n-n_nu) x 1) vector

xminusnu = zeros((sum(n_nus)-n_nus(nu)),1);

k=1;
l=1;
for mu=1:size(n_nus,1)
    for i=1:n_nus(mu) 
        if ~(mu==nu)
            xminusnu(k)=x(l);
            k=k+1;
        end
        l=l+1;
    end
end
end

