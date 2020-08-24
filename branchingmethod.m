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
for i=1:N
    n_nus(i,1) = size(Omega(1,1),2);
end

while ~isempty(L)
   Y = L(1);
   if length(L)>1
       L = L(2:end);
   else
       L = {};
   end
   xbar = getcontNE(Y,Goalfs);
   B = prunebranch(xbar, Y);
   if round(xbar)==xbar
      if isdiscreteNE(xbar,Omega,Goalfs)
          intNE = [intNE;xbar];
      end
      % Excluding xbar from feasible set      
      B_1 = B(1);
      B = B(2:end);
      for nu=1:N
         for i=1:n_nus(nu,1)
             B_new1 = B_1;
             B_new2 = B_1;
             ind = getFullIndex(nu,i,n_nus);
             B_new1{3,nu}(i,1) = xbar(ind)+1;
             B_new2{3,nu}(i,2) = xbar(ind)-1;
             B_1{3,nu}(i,1) = xbar(ind);
             B_1{3,nu}(i,2) = xbar(ind);
             B = [B, B_new1, B_new2];
         end
      end
   else
       % Branching step towards integer solution
       logic = find(xbar~=round(xbar));
       ind = logic(1);
       [p_ind,p_i] = getPlayersindex(ind,n_nus);
       B_1 = B(1);
       B_2 = B(1);
       B_1{3,p_ind}(p_i,2) = floor(xbar(ind));
       B_2{3,p_ind}(p_i,1) = ceil(xbar(ind));
       B = [B_1,B_2,B(2:end)];
   end
end

end

