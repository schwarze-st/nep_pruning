function A = addCells(A,B,e)
% Add nonempty cells from B to A
if nargin<3
    e=10000;
end
toappend = find(~cellfun('isempty',B));
countnew = size(toappend,2);
slots = find(cellfun('isempty',A),max([1,countnew]));
while countnew>size(slots,2)
   E = cell(1,e);
   A = [A,E];
   slots = find(cellfun('isempty',A),countnew);
end
for j=1:size(toappend,2)
   A{slots(j)} = B{toappend(j)};
end
end

