% This file creates two latex-tables from the rsults file.
% To run this script, you have to load the result-file for the test bed and
% the Properties of the the test bed with 'getProperties.m'

Nam = {};
%pdata = zeros(size(Names,2),5);
for i=1:size(Names,2)
    Nam{i} = append('$R',Names{i}(3:end-4),'$');
    if T(i,2)==0 && T(i,1)>0 && T(i,3)<3600
        %load(Names{i});
        %pdata(i,1) = 
        T(i,2)=T(i,1);
        O(i,2)=O(i,1);
    end
end

explored = O(:,3)./fp ;
all_results = [EQ,T,O,explored]; % add/rm cols

tsum = sum(G_TIME,2);
G_TIME = G_TIME./tsum;
G_TIME = [G_TIME, tsum, tsum./T(:,3)];



% for i=1:size(Names,2)
%     G_TIME(i,1:end-1) = G_TIME(i,1:end-1)./G_TIME(i,end) * 100;
% end

input = struct();
input.data = all_results;
input.tableRowLabels = Nam;
input.tableColLabels = {'EQ','$t_1$','$t_2$','$t_3$','$O_1$','$O_2$','$O_3$','$O_3$/Size'}; % add/rm cols
input.tableCaption = 'Nash equilibria.';
input.tableLabel = 'Nasheq';
input.dataFormat = {'%.0f',1,'%.2f',3,'%.0f',3,'%.5f',1}; % add/rm cols
input.tableBorders = 0;
input.booktabs = 0;

input2 = struct();
input2.data = G_TIME;
input2.tableRowLabels = Nam;
input2.tableColLabels = {'$GT_{gs}$','$GT_{isNE}$','$GT_{req}$','$GT_{emp}$','$GT_{tot}$','$GT_{%}$'};
input2.tableCaption = 'Gurobi runtime.';
input2.tableLabel = 'Gruntime';
input2.dataFormat = {'%.2f'};
input2.tableBorders = 0;
input2.booktabs = 0;

% input3 = struct();
% input3.tableRowLabels = Nam;
% input3.tableColLabels = {'$\lambda_{\min}$','$\lambda_{\max}$','m',};


latexTable(input);
latexTable(input2);