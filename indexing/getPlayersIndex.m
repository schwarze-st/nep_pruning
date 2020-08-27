function [p_ind,i] = getPlayersIndex(ind,n_nus)
%Get playernumber and index of a players variable
%   Input: ind (int) index in term of all vars
%          n_nus (Nx1)-matrix specifies number of vars for each player
p_ind = 1;
while sum(n_nus(1:p_ind),1) < ind
   p_ind = p_ind+1;
end
i = ind-sum(n_nus(1:(p_ind-1)));
end

