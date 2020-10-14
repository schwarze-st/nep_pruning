S = dir('IntegerPrograms/TestSet1/*.mat');
Names = {S.name};
Nam = {};

n_inst = 30;
lammin = zeros(n_inst,1);
lammax = zeros(n_inst,1);
lbs = zeros(n_inst,1);
ubs = zeros(n_inst,1);
ms = zeros(n_inst,1);
B_size = zeros(n_inst,1);



for i=1:n_inst
    Nam{i} = append('$R',Names{i}(3:end-4),'$');
    load(append('IntegerPrograms/TestSet1/',Names{i}));
    for j=1:size(Gf,2)
        Q = Gf{2,j};
        E = eig(Q);
        if j == 1
            lammin(i)=min(E);
            lammax(i)=max(E);
        else
            lammin(i) = min([lammin(i);min(E)]);
            lammax(i) = max([lammax(i);max(E)]);
        end
    end
    lbs(i)=lb;
    ubs(i)=ub;
    ms(i) = m_nus(1);
    B_size(i) = (2*ub+1)^(n_nus(1))^(N);
end

all_data = [lammin, lammax, lbs, ubs, ms, B_size];

input = struct();
input.data = all_data;
input.tableRowLabels = Nam;
input.tableColLabels = {'$\lambda_{\min}$','$\lambda_{\max}$','lb','ub','m','Boxsize'};
input.tableCaption = 'Properties of random instances.';
input.tableLabel = 'Pprop';
input.dataFormat = {'%.4f',2,'%.0f',4};
input.tableBorders = 0;
input.booktabs = 0;

latexTable(input);