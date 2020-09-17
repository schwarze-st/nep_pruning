% Testscript
global OPT_TOL FEAS_TOL;
OPT_TOL = 10^(-5);
FEAS_TOL = 10^(-5);

% Test getter functions
x = [1,2,3,4,3,3,2,4,6,8,0,4,2,1]';
n_nus = [4,4,3,3]';
assert(all([6,8,0]' == getPlayersVector(x,3,n_nus)),'Error in getPlayersVector');
assert(all([4,2,1]' == getPlayersVector(x,4,n_nus)),'Error in getPlayersVector');
assert(all([1,2,3,4,3,3,2,4,4,2,1]' == getOpponentsVector(x,3,n_nus)),'Error in getPlayersVector');
assert(all([1,2,3,4,3,3,2,4,6,8,0]' == getOpponentsVector(x,4,n_nus)),'Error in getPlayersVector');
assert(all([3,3,2,4,6,8,0,4,2,1]' == getOpponentsVector(x,1,n_nus)),'Error in getPlayersVector');
assert(all([1,1,1,1,3,3,2,4,6,8,0,4,2,1]' == setPlayersVector(x,[1,1,1,1]',1,n_nus)),'Error in setPlayersVector');
assert(all([1,2,3,4,3,3,2,4,0,8,6,4,2,1]' == setPlayersVector(x,[0,8,6]',3,n_nus)),'Error in setPlayersVector');
clear x n_nus;

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
assert(strcmp(result.status,'OPTIMAL'), 'Error in Gurobi setup');
model.rhs = -b;
result = gurobi(model, params);
assert(~strcmp(result.status,'OPTIMAL'), 'Error in Gurobi setup');
clear model;

% Test instance from Sagratella2016, Example3
Omega = {zeros(0,1),zeros(0,1);zeros(1,0),zeros(1,0);[-1 2],[-1 2]};
Gf = {-1,-3/4;14/16,1;1/2,0};

% Test function isdiscreteNE
assert(isdiscreteNE([1;1],Omega,Gf,2,[1;1]),'Error in isdiscreteNE');
assert(isdiscreteNE([2;2],Omega,Gf,2,[1;1]),'Error in isdiscreteNE');
assert(isdiscreteNE([-1;-1],Omega,Gf,2,[1;1]),'Error in isdiscreteNE');
assert(~isdiscreteNE([0;0],Omega,Gf,2,[1;1]),'Error in isdiscreteNE');
assert(~isdiscreteNE([-1;1],Omega,Gf,2,[1;1]),'Error in isdiscreteNE');

% Test getRandomNEP
clear all
N = 2;
n_nus = [5,5]';
m_nus = [10,10]';
lb = -5;
ub = 5;
% clear all
% load('rg22.mat')
[Omega,Gf] = getRandomNEP(N,lb,ub,n_nus,m_nus);
% clear all
save('IntegerPrograms/rg25_2');
% branchingmethod(Omega,Gf)


