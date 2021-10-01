S = dir('IntegerPrograms/TestSet1/*.mat');
Names = {S.name};
[~,k] = size(Names);
fp = zeros(k,1);
b_size = zeros(k,1);

for i=1:k

    name = append('IntegerPrograms/TestSet1/',Names{i}); 
    load(name);
    
    % handle variable number of arguments with transformation from
    % cell-array into comma-separated list
    cellM = cell([1,n_nus(1,1)]);
    for j=1:n_nus(1,1)
        cellM{1,j}=[lb:ub];
    end
    % combinations gets N arguments
    f_vec = combinations(cellM{1,:});
    % calculate number of feasible points
    fp(i,1) = getFeasiblePoints(Omega,f_vec,m_nus);
    [p,~] = size(f_vec);
    b_size(i,1) = p^N; 
end
