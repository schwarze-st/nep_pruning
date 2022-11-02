function [A,b] = getRandomPolytope(n,m,bnd)
%getRandomPolytope generates a random polytope with integer coefficients
%   all inequalities are shrinking the box [-bnd,bnd]*n without causing
%   inconsistency

A = zeros(m,n);
b = zeros(m,1);
nonz_count = randi([2 n],m,1);
for k=1:m
    nonz_ind = randperm(n,nonz_count(k));
    %nonz_val = max(2,round(1.5*randn(nonz_count(k),1))+5);
    nonz_val = rand(nonz_count,1)*2-1;
    for l=1:nonz_count(k)
    %    if rand(1)<0.5
    %        nonz_val(l) = -nonz_val(l);  
    %    end
        A(k,nonz_ind(l)) = nonz_val(l);   
    end
    %b(k) = round(norm(nonz_val,2)*(0.75*(nonz_count(k)*ub^2)^(0.5)));
    b(k) = bnd*norm(nonz_val,2);
A = round(A,3);
b = round(b,3);
outputArg2 = inputArg2;
end

