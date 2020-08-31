% Test instance from Sagratella2016, Example3
Omega = {zeros(0,1),zeros(0,1);zeros(1,0),zeros(1,0);[-1 2],[-50 20]};
Gf = {-1,-3/4;14/16,1;1/2,0};


%branchingmethod(Omega,Gf);

% Second Test instance
Q1 = [2,0;0,2];
C1 = [-1,0;0,1];
A1 = -[1,1];
b1 = -2;
bnds1 = [0,5;0,5];
Q2 = [2,0;0,4];
C2 = zeros(2,2);
A2 = [-1,-3;3,-1];
b2 = [-27,21]';
bnds2 = [0,10;0,10];

Omega = {A1,A2;b1,b2;bnds1,bnds2};
Gf = {C1,C2;Q1,Q2;zeros(2,1),zeros(2,1)};

branchingmethod(Omega,Gf)