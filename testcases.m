% Testscript
disp('Test getPlayersVector');
x = [1,2,3,4,3,3,2,4,6,8,0,4,2,1]';
n_nus = [4,4,3,3]';
assert(all([6,8,0]' == getPlayersVector(x,3,n_nus)),'Error in getPlayersVector');
assert(all([4,2,1]' == getPlayersVector(x,4,n_nus)),'Error in getPlayersVector');
disp('Test getOpponentsVector');
assert(all([1,2,3,4,3,3,2,4,4,2,1]' == getOpponentsVector(x,3,n_nus)),'Error in getPlayersVector');
assert(all([1,2,3,4,3,3,2,4,6,8,0]' == getOpponentsVector(x,4,n_nus)),'Error in getPlayersVector');
assert(all([3,3,2,4,6,8,0,4,2,1]' == getOpponentsVector(x,1,n_nus)),'Error in getPlayersVector');

% Test gurobi
a = [1,1,2,3,4,5]';
b = [1,2,3,3,4,5.5]';
activelbnds = abs(a-b)<10^(-4);
I = eye(6);
A = I(:,activelbnds);
b = [1,0,0,0.5,0,0]';
params.OutputFlag = 0;
model.A = sparse(A);
model.rhs = b;
model.sense = '=';
model.vtype = 'C';
model.lb = zeros(size(A,2),1);
result = gurobi(model, params);
if strcmp(result.status,'OPTIMAL')
    disp('Optimally solved');
end
model.rhs = -b;
result = gurobi(model, params);
if strcmp(result.status,'OPTIMAL')
    disp('Optimally solved');
end

