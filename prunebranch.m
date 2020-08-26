function [B] = prunebranch(xbar,Y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

N = size(Y,2);
B = {B}
for nu=1:N
    n_nu = size(Y(1,1),2)
    for i=1:n_nu
       if %TODO check if Fnui convex and corollary fulfilled
           C = {}
           for k=1:length(B)
               %TODO determine J
               for j=1:length(J)
                   %TODO split up B by the inequlities in J
                   % add this set to C
               end
           end
           B=C;
       elseif %TODO check if Fnui concave and corollary fulfilled
           for k=1:length(B)
               %TODO determine J
               for j=1:length(J)
                   %TODO split up B by the inequlities in J
                   % add this set to C
               end
           end
           B=C;           
       end
    end
end
end

