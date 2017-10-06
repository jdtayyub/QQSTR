function [ labelsBinary ] = labelFixforSvm( labels, numOfClasses )
%LABELFIXFORSVM Summary of this function goes here
%   Detailed explanation goes here

labelsBinary = {};
tempLabels = labels;

for i = 1 : size(labels,1)
  
  if(i ~= 1)
    if(strcmp(labels{i},labels{i-1}))
      continue;
    end
  end
  
  for j = 1: size(labels,1)

    if(~strcmp(labels{i},labels{j}))
      
      tempLabels{j} = 'negative';

    end
    
  end
  
  labelsBinary = [labelsBinary tempLabels];
  tempLabels = labels;
end

labelsBinary = labelsBinary(:,1:numOfClasses); % take the first 10 classes

end

