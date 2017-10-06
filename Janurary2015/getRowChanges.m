function [ interactions ] = getRowChanges( row )
%GETROWCHANGES takes a row of qsrs and return the number of interactions or
%changes 
%   Detailed explanation goes here
interactions = 0;
curr = row(2);
for i = 3:size(row,2)
  if(curr == row(i))
  else
    interactions = interactions + 1;
    curr = row(i);
  end
end

end

