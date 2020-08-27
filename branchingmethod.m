function [intNE] = branchingmethod(Omega,Goalfs)
% Computes the complete set of all discrete Nash equilibria in this game
%    Input:  Omega (3 x N)-cell array containing N cells with: 
%                A (m_nu x n_nu)-matrix,
%                b (m_nu x 1)-vector,
%                bnd (n_nu x 2)-matrix,
%                    describe linear contrained strategy set of player nu
%            Goalfs: (3 x N)-cell array containing N cells with:
%                C (n_nu x n-n_nu)-matrix,
%                Q (n_nu x n_nu)-matrix,
%                b (n_nu x 1)-vector.
%                    deccribe the nu-th players goalfunction
%                    1/2* x_nu'*C*x_nu + (C*x_-nu + b)'x_nu
%    Output: intNE: (p x n)-matrix containing p Nash equilibrium points, one in

L = Omega;
n = size(Goalfs(1,1),1)+size(Goalfs(1,1),2);
N = size(Omega,2);
n_nus = zeros(N,1);
intNE = zeros(n,0);
for i=1:N
    n_nus(i,1) = size(Omega(1,1),2);
end

while ~isempty(L)
   Y = L(1);
   L = L(2:end);
   xbar = gaussseidel(Y,Goalfs);
   B = prunebranch(xbar, Y);
   if round(xbar)==xbar
      if isdiscreteNE(xbar,Omega,Goalfs)
          intNE = [intNE;xbar];  %#ok<AGROW>
      end
      % Excluding xbar from feasible set      
      B_list = removexbarbranch(B(1),xbar,n_nus);
      B = [B_list,B(2:end)];
   else
       % Branching step towards integer solution
       [B_1,B_2] = integralitybranch(B(1),xbar,n_nus);
       B = [B_1,B_2,B(2:end)];
   end
end

end

