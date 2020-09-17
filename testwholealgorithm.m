global EQ O T N_ITER P_REQ G_CALLS G_TIME N_I;

% read instances
S = dir('IntegerPrograms/*.mat');
Names = {S.name};
n_inst = size(Names,2);
EQ = zeros(n_inst,1);
O = zeros(n_inst,3);
T = zeros(n_inst,3);
N_ITER = zeros(n_inst,1);
G_CALLS = zeros(n_inst,4);
G_TIME = zeros(n_inst,4);

for i=1:2
    N_I=i;
    load(append('IntegerPrograms/',Names{i}));
    branchingmethod(Omega,Gf);
end