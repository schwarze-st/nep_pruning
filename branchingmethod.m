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
%                    in each column. Describes the nu-th players goalfunction
%                    1/2* x_nu'*C*x_nu + (C*x_-nu + b)'x_nu
%    Output: intNE: (n x p)-matrix containing Nash equilibrium points in
%                   columns

L = {Omega};
n = size(Goalfs{1,1},1)+size(Goalfs{1,1},2);
N = size(Omega,2);
n_nus = zeros(N,1);
intNE = zeros(n,0);
klk = zeros(n,0);
for i=1:N
    n_nus(i,1) = size(Goalfs{1,i},1);
end

while ~isempty(L)
   Y = L{1};
   L(1)=[];
   [xbar,yempty] = gaussseidel(Y,Goalfs,n_nus);
   if ~yempty
       B = prunebranch(Y, Goalfs, n_nus, xbar);
       if max(abs(round(xbar)-xbar))<10^(-5)
          klk = [klk,xbar];
          if isdiscreteNE(xbar,Omega,Goalfs,N,n_nus)
              disp('Found discrete NE');
              intNE = [intNE,xbar];  %#ok<AGROW>
          end
          % Excluding xbar from feasible set
          disp('remove integer point');
          B_list = removexbarbranch(B{1},xbar,n_nus);
          B = [B_list,B(2:end)];
       else
           % Branching step towards integer solution
           if pointfeasible(B{1},xbar,n_nus)
               disp('Branch to integers');
               [B_int] = integralitybranch(B{1},xbar,n_nus);
               B = [B_int,B(2:end)];
           end
       end
       L = [L,B];
   end
end
size(klk,2)
%assert(size(unique(transpose(klk),'rows'),1)==size(klk,2),'Integer Point processes two times');
end

