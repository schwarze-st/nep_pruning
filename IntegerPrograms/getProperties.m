%% get Properties of a testbed
% This script also calculates the cardinality of Omega (number of feasible
% strategies/points) and saves it as 'fp'

S = dir(append('IntegerPrograms/',testbed,'/*t'));
Names = {S.name};
Nam = {};

n_inst = size(S,1);
lammin = zeros(n_inst,1);
lammax = zeros(n_inst,1);
convexplayers = zeros(n_inst,1);
nonconvexplayers = zeros(n_inst,1);
lbs = zeros(n_inst,1);
ubs = zeros(n_inst,1);
ms = zeros(n_inst,1);
density_cons = zeros(n_inst,1);
B_size = zeros(n_inst,1);
b_size = zeros(n_inst,1);
fp = zeros(n_inst,1);




for i=1:n_inst
    Nam{i} = append('$R',Names{i}(3:end-4),'$');
    load(append('IntegerPrograms/',testbed,'/',Names{i}));
    disp(Names{i});
    N_i = size(Gf,2);
    for j=1:N_i
        E = eig(Gf{2,j});
        if min(E)<0
            nonconvexplayers(i) = nonconvexplayers(i) + 1;
        else
            convexplayers(i) = convexplayers(i) + 1;
        end
        if j == 1
            lammin(i) = min(E);
            lammax(i) = max(E);
        else
            lammin(i) = min([lammin(i);min(E)]);
            lammax(i) = max([lammax(i);max(E)]);
        end
        A_j = Omega{1,j};
        density_cons(i) = density_cons(i) + 1/N_i * size(nonzeros(A_j),1)/(size(A_j,1)*size(A_j,2));
    end
    lbs(i)=lb;
    ubs(i)=ub;
    ms(i) = m_nus(1);
    name = append('IntegerPrograms/',testbed,'/',Names{i}); 
    load(name);
    
    % handle variable number of arguments with transformation from
    % cell-array into comma-separated list
    assert(all(n_nus == ones(size(n_nus))*mean(n_nus)),'Can not calculate number of feasible points with this method, all players must have the same number of variables');
    cellM = cell([1,n_nus(1,1)]); % all players have the same number of variables
    for j=1:n_nus(1,1)
        cellM{1,j}=[lb:ub];
    end
    % combinations gets N arguments
    f_vec = combinations(cellM{1,:});
    % calculate number of feasible points
    fp(i,1) = getFeasiblePoints(Omega,f_vec,m_nus);
    [p,~] = size(f_vec);
    b_size(i,1) = p^N; 
    B_size(i) = (2*ub+1)^(n_nus(1))^(N);
end

%all_data = [lammin, density_cons, lbs, ubs, ms, fp];

%% generate LaTeX table
% Latex table with properties of all instances
all_data = [lammin, nonconvexplayers, ms, density_cons, fp]; % add/rm column

input = struct();
input.data = all_data;
input.tableRowLabels = Nam;
input.tableColLabels = {'$\lambda_{\min}$','No. Nonconv','m','density','Size'}; % add/rm column
input.tableCaption = 'Properties of random instances.';
input.tableLabel = 'Pprop';
input.dataFormat = {'%.4f',1,'%.0f',2,'%.4f',1,'%.0f',1}; % add/rm column
input.tableBorders = 0;
input.booktabs = 0;

latexTable(input);