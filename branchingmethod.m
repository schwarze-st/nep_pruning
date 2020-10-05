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
global EQ O T N_I G_CALLS G_TIME N_ITER;
OPT_TOL = 10^(-5);
FEAS_TOL = 10^(-5);
t0 = tic;

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

while ~all(cellfun('isempty',L))
   if toc(t0)>10800
       break
   end
   N_ITER(N_I) = N_ITER(N_I)+1;
   ind = find(~cellfun('isempty',L),1);
   Y = L{ind};
   L{ind}= zeros(0,0);
   [xbar,yempty] = gaussseidel(Y,Goalfs,n_nus);
   if ~yempty
       B = prunebranch(Y, Goalfs, n_nus, xbar);
       if max(abs(round(xbar)-xbar))<FEAS_TOL
          G_CALLS(N_I,2) = G_CALLS(N_I,2)+1;
          t_NE = tic;
          isNE = isdiscreteNE(xbar,Omega,Goalfs,N,n_nus);
          G_TIME(N_I,2) = G_TIME(N_I,2)+toc(t_NE);
          if isNE
              disp('Found discrete NE');
              intNE = [intNE,xbar];  %#ok<AGROW>
              if O(N_I,1)==0
                  O(N_I,1) = G_CALLS(N_I,2);
                  T(N_I,1) = toc(t0);
              else
                  O(N_I,2) = G_CALLS(N_I,2);
                  T(N_I,2) = toc(t0);
              end
              
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
O(N_I,3) = G_CALLS(N_I,2);
T(N_I,3) = toc(t0);
EQ(N_I) = size(intNE,2);
end

