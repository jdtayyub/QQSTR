function [ rccComb ] = mapComb2RCC( comb )
%MAPCOMB2RCC maps generated combinations to the rcc corresponding number in
%our system . for eg 2 is po so all 0s are mapped to 2 and all 1s are
%mapped to 3 etc.
%   Detailed explanation goes here


for i = 1 : size(comb,1)
  for j = 1: size(comb,2)
    
    rccComb(i,j) = str2num(comb(i,j)) + 1;
    
  end
end


end

