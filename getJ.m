function [Jnew,lbactive,ubactive] = getJ(B_plus,A,b,xbar,nu,i,n_nus,sign)
% changes the order of J, such that the first box contains xbar
%   Input:
%       B_plus (3 x N) cell-array: strategy subset
%       A (m_nu x n_nu) matrix
%       b (m_nu x 1) vector
%       xbar (n x 1) vector
%       nu  (int)
%       i   (int)
%       n_nu (n x 1) vector
%       sign: string
%   Output:
%       J_new (? x 1) vector (?: Number of active constrs)
%       lbactive (logical)
%       ubactive (logical)

assert(strcmp(sign,'+')|strcmp(sign,'-'),'Sign must be "+" or "-"');
if strcmp(sign,'-')
    J = find(A(:,i)<0);
elseif strcmp(sign,'+')
    J = find(A(:,i)>0);
end
xbarnu = getPlayersVector(xbar,nu,n_nus);
Jnew = zeros(size(J,1),1);
if ~isempty(J)
    Jnew(1,1) = J(1,1);
    for k=2:size(J,1)
        new = (b(J(k))-A(J(k),:)*xbarnu)/abs(A(J(k),i));
        old = (b(Jnew(1))-A(Jnew(1),:)*xbarnu)/abs(A(Jnew(1),i));
        if new < old
            Jnew(2:k,1)=Jnew(1:k-1,1);
            Jnew(1,1)=J(k);
        else
            Jnew(k,1)=J(k,1);
        end
    end
end
lbactive = xbarnu(i)<=B_plus{3,nu}(i,1)+10^(-4);
ubactive = xbarnu(i)>=B_plus{3,nu}(i,2)-10^(-4);


