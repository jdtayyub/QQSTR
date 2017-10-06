function [ smoothList ] = smoothDist( list )
%SMOOTH Summary of this function goes here
%   Detailed explanation goes here

smoothList = list;

smoothList(3:size(smoothList,1) - 4) = 0;

for i = 3: size(list,1) - 2
  
 smoothList(i) = (list(i-2) + list(i-1) + list(i) + list(i+1) + list(i+2)) / 5;
 
end

end

