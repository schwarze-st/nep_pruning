global EQ O T N_ITER P_REQ G_CALLS G_TIME N_I;

% read instances
S = dir('IntegerPrograms/TestSet5/*.mat');
Names = {S.name};
n_inst = size(Names,2);
EQ = zeros(n_inst,1);
O = zeros(n_inst,3);
T = zeros(n_inst,3);
N_ITER = zeros(n_inst,1);
G_CALLS = zeros(n_inst,4);
G_TIME = zeros(n_inst,4);


for i=1:n_inst
    N_I=i;
    disp(i); 
    name = append('IntegerPrograms/TestSet5/',Names{i});
    load(name);
    conv = zeros(N,1);
    for j=1:N
        E = eig(Gf{2,j});
        conv(j,1) = (min(E)>=0);
    end
    branchingmethod(Omega,Gf,conv);
end

save('resultsNC');