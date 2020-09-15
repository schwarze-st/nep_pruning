function [B] = prunebranch(Y, Goalfs, n_nus, xbar)
%Returns a list of disjunct sets containing all Nash equilibria of the game
%   Input:
%       Y: (3xN)-cell array
%           B(1,nu): A^nu (m_nu x n_nu) Matrix
%           B(2,nu): b^nu (m_nu x 1) Vector
%           B(3,nu): bnd^nu (n_nu x 2) Matrix
%       Goalfs: (3 x N)-cell array containing N cells with:
%           C (n_nu x n-n_nu)-matrix,
%           Q (n_nu x n_nu)-matrix,
%           b (n_nu x 1)-vector.
%               describe the nu-th players goalfunction
%               1/2* x_nu'*C*x_nu + (C*x_-nu + b)'x_nu
%       xbar (n x 1) Vector
%       n_nus (N x 1) Vector
%   Output:
%       B: (1 x p)-cell array, with each cell containing a (3xN)-cell array
%       of type Y.

global FEAS_TOL
N = size(n_nus,1);
B = {Y};

assert(iscell(Y),'Y has wrong input type');
assert(iscell(Goalfs),'Goalfs has wrong input type');
assert(all(size(Goalfs)==[3,N]),'Goalfs has wrong size');
assert(all(size(Y)==[3,N+1]),'Y has wrong size');


for nu=1:N
    for i=1:n_nus(nu)
       if (((Y{3,nu}(i,2)-Y{3,nu}(i,1))<FEAS_TOL)||(Y{1,N+1}(nu,i)==1 || Y{2,N+1}(nu,i)==1))
           % If (nu,i) is already fixed on a value -> Do nothing
       else
           [flagi,flagii] = checkRequirements(Goalfs(:,nu),Y,n_nus,xbar,nu,i);
           if flagi
               C = cell(1,0);
               for p=1:size(B,2)
                   B{p}{1,N+1}(nu,i)=1;
                   B_plus = B{p};
                   B_plus{3,nu}(i,2) = B_plus{3,nu}(i,1);
                   B{p}{3,nu}(i,1) = B{p}{3,nu}(i,1)+1;
                   C = [C,{B_plus}];
                   A = B{p}{1,nu};
                   b = B{p}{2,nu};
                   [J,lbactive,~] = getJ(B_plus,A,b,xbar,nu,i,n_nus,'-');
                   for j=1:size(J,1)
                       alpha = -A(J(j),:);
                       rhs = floor(-(b(J(j))+A(J(j),i)));
                       B_plus = B{p};
                       B_plus{1,nu} = [A;alpha];
                       B_plus{2,nu} = [b;rhs];
                       B{p}{1,nu} = [A;-alpha];
                       B{p}{2,nu} = [b;-(rhs+1)];
                       A = B{p}{1,nu};
                       b = B{p}{2,nu};
                       if and(~lbactive,and(j==1,p==1))
                           C = [{B_plus},C];
                       else
                           C = [C,{B_plus}];
                       end
                   end
               end
               B=C;
           end
           if flagii
               C = cell(1,0);
               for p=1:size(B,2)
                   B{p}{2,N+1}(nu,i)=1;
                   B_plus = B{p};
                   B_plus{3,nu}(i,1) = B_plus{3,nu}(i,2);
                   B{p}{3,nu}(i,2) = B{p}{3,nu}(i,2)-1;
                   C = [C,{B_plus}];
                   A = B{p}{1,nu};
                   b = B{p}{2,nu};
                   [J,~,ubactive] = getJ(B_plus,A,b,xbar,nu,i,n_nus,'+');
                   for j=1:size(J,1)
                       alpha = -A(J(j),:);
                       rhs = floor(-(b(J(j))+A(J(j),i)));
                       B_plus = B{p};
                       B_plus{1,nu} = [A;alpha];
                       B_plus{2,nu} = [b;rhs];
                       B{p}{1,nu} = [A;-alpha];
                       B{p}{2,nu} = [b;-(rhs+1)];
                       A = B{p}{1,nu};
                       b = B{p}{2,nu};
                       if and(~ubactive,and(j==1,p==1))
                           C = [{B_plus},C];
                       else
                           C = [C,{B_plus}];
                       end
                   end
               end
               B=C;
           end
       end
    end
end
end

