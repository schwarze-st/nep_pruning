global EQ O T N_ITER P_REQ G_CALLS G_TIME N_I EQS;
% set test bed (folder name in 'IntegerPrograms')
testbed = 'TestBedConvex';

% read instances
S = dir(append('IntegerPrograms/',testbed,'/*.mat'));
Names = {S.name};
n_inst = size(Names,2);
EQ = zeros(n_inst,1);
EQS = cell(n_inst,1);
O = zeros(n_inst,3);
T = zeros(n_inst,3);
N_ITER = zeros(n_inst,1);
G_CALLS = zeros(n_inst,4);
G_TIME = zeros(n_inst,4);


for i=1:n_inst
    N_I=i;
    disp(i); 
    name = append('IntegerPrograms/',testbed,'/',Names{i});
    load(name);
    conv = zeros(N,1);
    for j=1:N
        E = eig(Gf{2,j});
        conv(j,1) = (min(E)>=0);
    end
    branch_and_bound(Omega,Gf,conv);
end

save(append('results/',testbed));