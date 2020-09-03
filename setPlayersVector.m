function xnew = setPlayersVector(x, xnu, nu, n_nus)
% Set the variables of player nu on the values in xnu
%   Input:
%       x   (n x 1) vector
%       xnu (n_nu x 1) vector
%       nu  (int)
%       n_nus (N x 1) vector
%   Output:
%       xnew (n x 1) vector

assert(size(xnu,1)==n_nus(nu,1),'Players vector has wrong size');
xnew = x;
firstindex = sum(n_nus(1:nu-1,1))+1;
lastindex = firstindex+n_nus(nu,1)-1;
xnew(firstindex:lastindex,1) = xnu;
end

