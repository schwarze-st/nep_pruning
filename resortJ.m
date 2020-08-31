function Jnew = resortJ(J,A,b,xbarnu,i)
%
Jnew = zeros(size(J,1),1);
Jnew(1,1)=J(1,1)
for k=2:size(J,1)
    new = (A(J(k),:)*xbarnu-b(J(k)))/abs(A(J(k),i);
    old = (A(Jnew(1),:)*xbarnu-b(Jnew(1)))/abs(A(Jnew(1),i);
    if new < old
        Jnew(2:k,1)=Jnew(1:k-1,1);
        Jnew(1,1)=J(k);
    else
        Jnew(k,1)=J(k,1);
end

