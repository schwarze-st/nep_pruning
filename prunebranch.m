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

N = size(Y,2);
B = {Y};
for nu=1:N
    for i=1:n_nus(nu,1)
       [flagi,flagii] = checkRequirements(Goalfs(:,nu),Y,n_nus,xbar,nu,i);
       if flagi
           for p=1:size(B,2)
               if (B{p}{3,nu}(i,2)-B{p}{3,nu}(i,1))<10^(-5)
                   if p==1
                       C = B(p);
                   else
                       C = [C,B(p)];
                   end
               else
                   A = B{p}{1,nu};
                   b = B{p}{2,nu};
                   bnds1 = B{p}{3,nu};
                   bnds2 = B{p}{3,nu};
                   bnds2(i,1) = bnds2(i,1)+1;
                   bnds1(i,2) = bnds1(i,1);
                   if p==1
                       C = {A;b;bnds1};
                   else
                       C = [C,{A;b;bnds1}];
                   end
                   J = find(A(:,i)<0);
                   for j=1:size(J,1)
                       A = [A;-A(J(j),:)];
                       b = [b;-ceil(b(J(j),1)-abs(A(J(j),i)))];
                       for k=1:j-1
                           A = [A;A(J(k),:)];
                           b = [b;ceil(b(J(j),1)-abs(A(J(j),i)))+1];
                       end
                       C = [C,{A;b;bnds2}];
                   end
               end
           end
           B=C;
       end
       if flagii
           for p=1:size(B,2)
               if (B{p}{3,nu}(i,2)-B{p}{3,nu}(i,1))<10^(-5)
                   if p==1
                       C = B(p);
                   else
                       C = [C,B(p)];
                   end
               else
                   A = B{p}{1,nu};
                   b = B{p}{2,nu};
                   bnds1 = B{p}{3,nu};
                   bnds2 = B{p}{3,nu};
                   bnds2(i,2) = bnds2(i,2)-1;
                   bnds1(i,1) = bnds1(i,2);
                   if p==1
                        C = {A;b;bnds1};
                   else
                        C = [C,{A;b;bnds1}];
                   end
                   J = find(A(:,i)>0);
                   for j=1:size(J,1)
                       A = [A;-A(J(j),:)];
                       b = [b;-ceil(b(J(j),1)-abs(A(J(j),i)))];
                       for k=1:j-1
                           A = [A;A(J(k),:)];
                           b = [b;ceil(b(J(j),1)-abs(A(J(j),i)))+1];
                       end
                       C = [C,{A;b;bnds2}];
                   end
               end
           end
           B=C;          
       end
    end
end
end

