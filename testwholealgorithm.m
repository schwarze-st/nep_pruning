global EQ O T N_ITER P_REQ G_CALLS G_TIME N_I;

% read instances
S = dir('IntegerPrograms/TestSet1/*.mat');
Names = {S.name};
n_inst = size(Names,2);
EQ = zeros(n_inst,1);
O = zeros(n_inst,3);
T = zeros(n_inst,3);
N_ITER = zeros(n_inst,1);
G_CALLS = zeros(n_inst,4);
G_TIME = zeros(n_inst,4);

global N_I

for i=27:n_inst
    N_I=i;
    name = append('IntegerPrograms/TestSet1/',Names{i})
    load(name);
    branchingmethod(Omega,Gf);
end

save('results1_last4')