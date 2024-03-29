function [intNE] = branch_and_bound(Omega,Obj,conv)
% Computes the complete set of non-forced discrete Nash equilibria in this game
%    Input:  Omega (3 x N)-cell array containing N cells with: 
%                A (m_nu x n_nu)-matrix,
%                b (m_nu x 1)-vector,
%                bnd (n_nu x 2)-matrix,
%                    describe linear contrained strategy set of player nu
%            Obj: (3 x N)-cell array containing N cells with:
%                C (n_nu x n-n_nu)-matrix,
%                Q (n_nu x n_nu)-matrix,
%                b (n_nu x 1)-vector.
%                    in each column. Describes the nu-th players objective
%                    function
%                    1/2* x_nu'*Q*x_nu + (C*x_-nu + b)'x_nu
%            conv: (N x 1)-matrix, logical
%                    conv(i)=1, if objective function of player i is convex
%                    w.r.t. her variables
%    Output: intNE: (n x p)-matrix containing Nash equilibrium points in
%                   columns

global OPT_TOL FEAS_TOL; 
global EQ EQS O T N_I G_CALLS G_TIME N_ITER;
OPT_TOL = 10^(-5);
FEAS_TOL = 10^(-5);
t0 = tic;

n = size(Obj{1,1},1)+size(Obj{1,1},2);
N = size(Obj,2);
n_nus = zeros(N,1);
for i=1:N
    n_nus(i,1) = size(Obj{1,i},1);
end
L = cell(1,100);
L{1} = Omega;
intNE = zeros(n,0);

while ~all(cellfun('isempty',L))
   if toc(t0)>3600
       break
   end
   N_ITER(N_I) = N_ITER(N_I)+1;
   % take one Element from list
   ind = find(~cellfun('isempty',L),1);
   Y = L{ind};
   L{ind}= zeros(0,0); 
   [xbar,yempty] = gaussseidel(Y,Obj,n_nus,conv);
   if ~yempty
       if max(abs(round(xbar)-xbar))<FEAS_TOL
          G_CALLS(N_I,2) = G_CALLS(N_I,2)+1;
          t_NE = tic;
          isNE = isdiscreteNE(xbar,Omega,Obj,N,n_nus,conv);
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
       else
           B_int = integralitybranch(Y,xbar,n_nus);
           L = addCells(L,B_int);
       end
       
   end
end
O(N_I,3) = G_CALLS(N_I,2);
T(N_I,3) = toc(t0);
EQ(N_I) = size(intNE,2);
EQS{N_I} = intNE;
end

