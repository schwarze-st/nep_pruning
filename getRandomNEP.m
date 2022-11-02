function [Omega,Gf] = getRandomNEP(N, lb, ub, n_nus, m_nus, convex)
% Generates Objective functions and polyhedral feasible sets for an N
% player Nash equilibrium problem 
Omega = cell([3,N]);
Gf = cell([3,N]);

for nu=1:N
    % generate random polyhedral feasible sets
    n = n_nus(nu);
    m = m_nus(nu);
    A = zeros(m,n);
    b = zeros(m,1);
    nonz_count = randi([2 n_nus(nu)],m_nus(nu),1);
    u = ub*0.5; 
    for k=1:m
        nonz_ind = randperm(n,nonz_count(k));
        nonz_val = max(2,round(1.5*randn(nonz_count(k),1))+5);
        for l=1:nonz_count(k)
            if rand(1)<0.5
                nonz_val(l) = -nonz_val(l);  
            end
            A(k,nonz_ind(l)) = nonz_val(l);
        end
        b(k) = round(norm(nonz_val,2)*(0.75*(nonz_count(k)*ub^2)^(0.5)));
    end
    Omega{1,nu}=A;
    Omega{2,nu}=b;
    Omega{3,nu}=[ones(n,1)*lb,ones(n,1)*ub];
    % generate objective function
    Q = 2*(rand(n)-0.5);
    C = 2*(rand(n,sum(n_nus)-n)-0.5);
    b = 2*(rand(n,1)-0.5);
    for i=1:n
        if rand(1)>0.5
            b(i)=0;
        end
        for j=1:sum(n_nus)-n
            if rand(1)>0.5
                C(i,j)=0;
            end
        end
        if convex == 0
            Q(i,i) = abs(Q(i,i));
        end
    end
    Gf{1,nu}= C;
    if convex ==0
        Gf{2,nu}= 0.5*Q+0.5*Q';
    else
        Gf{2,nu}= transpose(Q)*Q;
    end
    Gf{3,nu}= b;
end
end

