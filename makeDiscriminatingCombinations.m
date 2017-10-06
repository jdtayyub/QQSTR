function [ comb ] = makeDiscriminatingCombinations( len, maxNum )
%MAKERCC3COMBINATIONS Creates combinations of numbers of length len where no two adjacent numbers are the same
%   INPUT
%     len - length of the combinations such as pairs 1 2 would be length 2
%     .. triples 2 3 1 would be length 3
%           etc
%     maxNum - specifies the maximum number that should be in combinations.
%              For example, length 4 and maxNum 3 would only produce
%              combinations that have 1,2,3 and nothing else. 
%   OUTPUT
%     comb - all changes in RCC combinations possible.


combNum = 0;
for i = 1: len
  if(i==1)
    combNum = len;
  else
    combNum = combNum * (len-1);
  end
end

comb = zeros(combNum, len);
options = linspace(1,len,len);

col = combNum/len;
colOnward = col/(len-1); 

for i = 1: len
  
  if(i == 1)
    for j =1 : len
      comb(((col*j)-col)+1:col*j,i) = j;
    end
  else
    
    
    for j=1 : combNum/colOnward
      
      option = setdiff(options,comb(colOnward*j,i-1));
      
      index = mod(j,len-1);
      if(index == 0)
        index = size(option,2);
      end
      
      comb(((colOnward*j)-colOnward)+1:colOnward*j,i) = option(index);
    
    end
    
    col = colOnward;
    colOnward = col/(len-1);
    
  end
  
  
end

%Removing Stuff containing the undesired numbers that exceed the max number

for i = maxNum+1 : len
  [r c] = find(comb==i);
  comb = removerows(comb,'ind',r);
end
  
end

