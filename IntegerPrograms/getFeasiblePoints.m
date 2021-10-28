function [number] = getFeasiblePoints(Omega, possible_vectors, m_nus)
%getFeasiblePoints determine number of feasible points brute-force
%   Detailed explanation goes here

[~,N] = size(Omega);
f_points = zeros(N,1);
for i=1:N
    A = Omega{1,i};
    b = Omega{2,i};
    logical = sum(bsxfun(@le,A*(possible_vectors'),b),1);
    f_points(i,1) = sum(bsxfun(@eq,logical,m_nus(i,1)));
end 
number = prod(f_points,'all');
end

