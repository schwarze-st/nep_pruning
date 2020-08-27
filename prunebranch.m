function [B] = prunebranch(Y, Goalfs, n_nus, xbar)
%Returns a list of disjunct sets containing all Nash equilibria of the game   

N = size(Y,2);
B = {Y};
for nu=1:N
    for i=1:n_nus(nu,1)
       [flagi,flagii] = checkRequirements();
       if flagi
           C = {};
           for p=1:length(B)
               % Einfügen: wenn xnui auf lower bound ist, dann...
               A = B{p}{1,nu};
               b = B{p}{2,nu};
               J = find(A(:,i)<0);
               for j=1:size(J,1)
                   A = [A;-A(J(j),:)];
                   b = [b;-ceil(b(J(j),1)-abs(A(J(j),i)))];
                   for k=1:j-1
                       A = [A;A(J(k),:)];
                       b = [b;ceil(b(J(j),1)-abs(A(J(j),i)))+1];
                   end
                   C = {C,{A;b;B{p}{3,nu}}};
               end
           end
           B=C;
       end
       if flagii
           C = {};
           for p=1:length(B)
               % Einfügen, wenn xnui auf upper bound ist, dann...
               A = B{p}{1,nu};
               b = B{p}{2,nu};
               J = find(A(:,i)>0);
               for j=1:size(J,1)
                   A = [A;-A(J(j),:)];
                   b = [b;-ceil(b(J(j),1)-abs(A(J(j),i)))];
                   for k=1:j-1
                       A = [A;A(J(k),:)];
                       b = [b;ceil(b(J(j),1)-abs(A(J(j),i)))+1];
                   end
                   C = {C,{A;b;B{p}{3,nu}}};
               end  
           end
           B=C;          
       end
    end
end
end

