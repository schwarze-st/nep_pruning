function [xminusnu] = getOpponentsVector(x, nu, n_nus)
%returns the vector of all variables, excepts the ones controlled by player nu
%   x: (n x 1)-vector of all vars
%   nu: integer number of player
%   n_nus: (N x 1)-vector with number of vars for each player
lower = 1;
iter = 1;
while iter<nu
    lower = lower + n_nus(iter,1);
    iter = iter + 1;
end
upper = lower+n_nus(nu,1)-1;
xminusnu = [x(1:lower-1,1);x(upper+1:end,1)];
end

