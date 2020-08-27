function z = getPlayersGfval(goalf, nu, n_nus, x)
%Value of Goalfunction for player nu in x

xnu = getPlayersVector(x, nu, n_nus);
xminusnu = getOpponentsVector(x, nu, n_nus);
z = xnu'*goalf(1)*xminusnu + 0.5*xnu'*goalf(2) + goalf(3)*xnu;
end

