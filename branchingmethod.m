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

global OPT_TOL FEAS_TOL;
OPT_TOL = 10^(-5);
FEAS_TOL = 10^(-5);

n = size(Goalfs{1,1},1)+size(Goalfs{1,1},2);
N = size(Goalfs,2);
n_nus = zeros(N,1);
for i=1:N
    n_nus(i,1) = size(Goalfs{1,i},1);
end
tmp = cell(3,1);
tmp{1} = zeros(N,max(n_nus));
tmp{2} = zeros(N,max(n_nus));
Omega = [Omega,tmp];
L = cell(1,10000);
L{1} = Omega;
intNE = zeros(n,0);
klk = 0;

while ~all(cellfun('isempty',L))
   ind = find(~cellfun('isempty',L),1);
   Y = L{ind};
   L{ind}= zeros(0,0);
   [xbar,yempty] = gaussseidel(Y,Goalfs,n_nus);
   if ~yempty
       B = prunebranch(Y, Goalfs, n_nus, xbar);
       if max(abs(round(xbar)-xbar))<FEAS_TOL
          klk = klk+1;
          if isdiscreteNE(xbar,Omega,Goalfs,N,n_nus)
              disp('Found discrete NE');
              intNE = [intNE,xbar];  %#ok<AGROW>
          end
          % Excluding xbar from feasible set
          B_list = removexbarbranch(B{1},xbar,n_nus);
          B{1} = zeros(0,0);
          B = addCells(B,B_list,1000);
       else
           % if not branched out by pruningprocedure: Branching step towards integer solution
           if pointfeasible(B{1},xbar,n_nus)
               B_int = integralitybranch(B{1},xbar,n_nus);
               B{1} = zeros(0,0);
               B = addCells(B,B_int);
           end
       end
       L = addCells(L,B);
   end
end
klk
end

