function [B] = prunebranch(Y, Obj, n_nus, xbar)
%Returns a list of disjunct sets containing all Nash equilibria of the game
%   Input:
%       Y: (3xN)-cell array
%           B(1,nu): A^nu (m_nu x n_nu) Matrix
%           B(2,nu): b^nu (m_nu x 1) Vector
%           B(3,nu): bnd^nu (n_nu x 2) Matrix
%       Obj: (3 x N)-cell array containing N cells with:
%           C (n_nu x n-n_nu)-matrix,
%           Q (n_nu x n_nu)-matrix,
%           b (n_nu x 1)-vector.
%               describe the nu-th players objective function
%               1/2* x_nu'*C*x_nu + (C*x_-nu + b)'x_nu
%       xbar (n x 1) Vector
%       n_nus (N x 1) Vector
%   Output:
%       B: (1 x p)-cell array, with each cell containing a (3xN)-cell array
%       of type Y.

global FEAS_TOL
global N_I G_TIME G_CALLS;
e = 1000;
N = size(n_nus,1);
B = cell(1,e);
B{1} = Y;

assert(iscell(Y),'Y has wrong input type');
assert(iscell(Obj),'Goalfs has wrong input type');
assert(all(size(Obj)==[3,N]),'Goalfs has wrong size');
assert(all(size(Y)==[3,N+1]),'Y has wrong size');


for nu=1:N
    for i=1:n_nus(nu)
       if (((Y{3,nu}(i,2)-Y{3,nu}(i,1))<FEAS_TOL)||(Y{1,N+1}(nu,i)==1 || Y{2,N+1}(nu,i)==1))
           % If (nu,i) is already fixed on a value -> Do nothing
       else
           t_r = tic;
           [flagi,flagii] = checkRequirements(Obj(:,nu),Y,n_nus,xbar,nu,i);
           G_CALLS(N_I,3) = G_CALLS(N_I,3)+1;
           G_TIME(N_I,3) = G_TIME(N_I,3)+toc(t_r);
           if flagi
               P = find(~cellfun('isempty',B));
               for p=1:size(P,2)
                   B0 = B{P(p)};
                   B{P(p)} = zeros(0,0);
                   B0{1,N+1}(nu,i)=1;
                   B_plus = B0;
                   B_plus{3,nu}(i,2) = B_plus{3,nu}(i,1);
                   B0{3,nu}(i,1) = B0{3,nu}(i,1)+1;
                   B = addCells(B,{B_plus},e);
                   A = B0{1,nu};
                   b = B0{2,nu};
                   [J,lbactive,~] = getJ(B_plus,A,b,xbar,nu,i,n_nus,'-');
                   for j=1:size(J,1)
                       alpha = -A(J(j),:);
                       rhs = -(b(J(j))+A(J(j),i)+1);
                       B_plus = B0;
                       B_plus{1,nu} = [A;alpha];
                       B_plus{2,nu} = [b;rhs];
                       B0{1,nu} = [A;-alpha];
                       B0{2,nu} = [b;-(rhs+1)];
                       A = B0{1,nu};
                       b = B0{2,nu};
                       if p==1 && j==1 && ~lbactive 
                           B_plus1 = B{1};
                           B{1} = zeros(0,0);
                           t_se = tic;
                           se = setempty(B_plus1,n_nus);
                           G_CALLS(N_I,4) = G_CALLS(N_I,4)+1;
                           G_TIME(N_I,4) = G_TIME(N_I,4)+toc(t_se);
                           if ~se
                               B = addCells(B,{B_plus,B_plus1},e);
                           else
                               B = addCells(B,{B_plus},e);
                           end
                       else
                           t_se = tic;
                           se = setempty(B_plus,n_nus);
                           G_CALLS(N_I,4) = G_CALLS(N_I,4)+1;
                           G_TIME(N_I,4) = G_TIME(N_I,4)+toc(t_se);
                           if ~se
                               B = addCells(B,{B_plus},e);
                           end
                       end
                   end
               end
           end
           if flagii
               P = find(~cellfun('isempty',B));
               for p=1:size(P,2)
                   B0 = B{P(p)};
                   B{P(p)} = zeros(0,0);
                   B0{2,N+1}(nu,i)=1;
                   B_plus = B0;
                   B_plus{3,nu}(i,1) = B_plus{3,nu}(i,2);
                   B0{3,nu}(i,2) = B0{3,nu}(i,2)-1;
                   B = addCells(B,{B_plus},e);
                   A = B0{1,nu};
                   b = B0{2,nu};
                   [J,~,ubactive] = getJ(B_plus,A,b,xbar,nu,i,n_nus,'+');
                   for j=1:size(J,1)
                       alpha = -A(J(j),:);
                       rhs = -(b(J(j))-A(J(j),i)+1);
                       B_plus = B0;
                       B_plus{1,nu} = [A;alpha];
                       B_plus{2,nu} = [b;rhs];
                       B0{1,nu} = [A;-alpha];
                       B0{2,nu} = [b;-(rhs+1)];
                       A = B0{1,nu};
                       b = B0{2,nu};
                       if p==1 && j==1 && ~ubactive
                           B_plus1 = B{1};
                           B{1} = zeros(0,0);
                           t_se = tic;
                           se = setempty(B_plus1,n_nus);
                           G_CALLS(N_I,4) = G_CALLS(N_I,4)+1;
                           G_TIME(N_I,4) = G_TIME(N_I,4)+toc(t_se);
                           if ~se
                               B = addCells(B,{B_plus,B_plus1},e);
                           else
                               B = addCells(B,{B_plus},e);
                           end
                       else
                           t_se = tic;
                           se = setempty(B_plus,n_nus);
                           G_CALLS(N_I,4) = G_CALLS(N_I,4)+1;
                           G_TIME(N_I,4) = G_TIME(N_I,4)+toc(t_se);
                           if ~se
                                B = addCells(B,{B_plus},e);
                           end
                       end
                   end
               end
           end
       end
    end
end
end

