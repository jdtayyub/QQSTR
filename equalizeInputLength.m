function [ eqIn ] = equalizeInputLength( in )
%EQUALIZEQSRINPUT Equalizez all input to have the same dimensionality by
%adding zeros to missing entries.
%   Detailed explanation goes here



max = 0;
for i = 1:size(in,1)
  if(size(in{i},1)>max)
    max = size(in{i},1);
    index = i;
  end
end

mat = {};
objCol = in{index}(:,1); 

for i = 1:size(in,1)
  mat{i} = zeros(max,size(in{i},2));
  mat{i}(:,1) = objCol;
  
  
  for j = 1:size(in{i},1)
    mat{i}(mat{i}(:,1) == in{i}(j,1), 2:end) = in{i}(j,2:end);     
  end
  
end

eqIn = mat';

end

