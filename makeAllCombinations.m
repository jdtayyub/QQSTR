function [ combs,disComb ] = makeAllCombinations( len, maxNo , distinct )
%MAKEALLCOMBINATIONS Summary of this function goes here
%   Detailed explanation goes here

% Calculate all Combination with repetition
combs = [];
sizeCombs = maxNo ^ len;
combs = dec2base(0:sizeCombs-1,maxNo);



% Calculate all Combination without repetition
flag = 0;
disComb = [];
for i = 1: size(combs)
  for j = 1: size(combs(i,:),2) - 1
    if(combs(i,j) == combs(i,j+1))
      flag = 1;
      break;
    end
  end
  if flag == 1
    flag = 0;
  else
    disComb = [disComb; combs(i,:)];
  end
end


end

