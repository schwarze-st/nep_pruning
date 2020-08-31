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

assert(iscell(Y),'Y has wrong input type');
assert(iscell(Goalfs),'Goalfs has wrong input type');
assert(all(size(Goalfs)==[3,size(n_nus,1)]),'Goalfs has wrong size');
assert(all(size(Y)==[3,size(n_nus,1)]),'Y has wrong size');

N = size(Y,2);
B = {Y};
for nu=1:N
    for i=1:n_nus(nu,1)
       if (Y{3,nu}(i,2)-Y{3,nu}(i,1))<10^(-5)
           % If (nu,i) is already fixed on a value -> Do nothing
       else
           [flagi,flagii] = checkRequirements(Goalfs(:,nu),Y,n_nus,xbar,nu,i);
           if flagi
               for p=1:size(B,2)
                   % First set: B_plus on lower bound
                   B_plus = B{p};
                   B_plus{3,nu}(i,2) = B_plus{3,nu}(i,1);
                   B{p}{3,nu}(i,1) = B_plus{3,nu}(i,1)+1;
                   assert(all(size(B_plus)==[3,size(n_nus,1)]),"strategy subset has false dimensions");
                   if p==1
                       C = {B_plus};
                   else
                       C = [C,{B_plus}];
                   end
                   A = B{p}{1,nu};
                   b = B{p}{2,nu};
                   J = find(A(:,i)<0);
                   xbarnu = getPlayersVector(xbar,nu,n_nus);
                   boundactive = xbarnu(i)<=B_plus{3,nu}(i,1)+10^(-4);
                   if ~boundactive
                       J = resortJ(J,A,b,xbarnu,i);
                   end
                   for j=1:size(J,1)
                       B_plus = B{p};
                       B_plus{1,nu} = [A;-A(J(j),:)];
                       B_plus{2,nu} = [b;floor(-(b(J(j),1)+abs(A(J(j),i))))];
                       B{p}{1,nu} = [A;A(J(j),:)];
                       B{p}{2,nu} = [b;-(floor(-(b(J(j),1)+abs(A(J(j),i))))+1)];
                       A = B{p}{1,nu};
                       b = B{p}{2,nu};
                       assert(all(size(B_plus)==[3,size(n_nus,1)]),"strategy subset has false dimensions");
                       if and(~boundactive,and(j==1,p==1))
                           C = [{B_plus},C];
                       else
                           C = [C,{B_plus}];
                       end
                   end
               end
               B=C;
           end
           if flagii
               for p=1:size(B,2)
                   % First set: B_plus on upper bound
                   B_plus = B{p};
                   B_plus{3,nu}(i,1) = B_plus{3,nu}(i,2);
                   B{p}{3,nu}(i,2) = B_plus{3,nu}(i,2)-1;
                   assert(all(size(B_plus)==[3,size(n_nus,1)]),"strategy subset has false dimensions");
                   if p==1
                       C = {B_plus};
                   else
                       C = [C,{B_plus}];
                   end
                   A = B{p}{1,nu};
                   b = B{p}{2,nu};
                   J = find(A(:,i)>0);
                   xbarnu = getPlayersVector(xbar,nu,n_nus);
                   boundactive = xbarnu(i)>=B_plus{3,nu}(i,2)-10^(-4);
                   if ~boundactive
                       J = resortJ(J,A,b,xbarnu,i);
                   end
                   for j=1:size(J,1)
                       B_plus = B{p};
                       B_plus{1,nu} = [A;-A(J(j),:)];
                       B_plus{2,nu} = [b;floor(-(b(J(j),1)+abs(A(J(j),i))))];
                       B{p}{1,nu} = [A;A(J(j),:)];
                       B{p}{2,nu} = [b;-(floor(-(b(J(j),1)+abs(A(J(j),i))))+1)];
                       A = B{p}{1,nu};
                       b = B{p}{2,nu};
                       assert(all(size(B_plus)==[3,size(n_nus,1)]),"strategy subset has false dimensions");
                       if and(~boundactive,and(j==1,p==1))
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

