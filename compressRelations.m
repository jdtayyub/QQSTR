function [ qsr ] = compressRelations( qsr, threshold )
%COMPRESSRELATIONS Removes repeated relations in the frame to give the 
%   INPUT
%     qsr - qsr relations for each object pair for all frame in format
%           objectPair x [objectPair identifier [frameRelations ]]
%     threshold - defined the number of frames that the relation should hold
%                 before it is considered as changing
%   OUTPUT
%     compressQsr - compressed qsr with 0 in place of repeated relations.

prev = 0;
temp = threshold;

for i = 1:size(qsr,1)
  
  for j = 2: size(qsr,2)
    
    if(qsr(i,j) ~= prev)
      
      holding = 1;
      if(threshold+j <= size(qsr,2))
      
        for k = j : j+threshold

          if(qsr(i,k) == qsr(i,j))
            continue
          else
            holding = 0;
          end

        end
        
      else
        threshold = size(qsr,2);
        holding = 0;
      end
      
      if(holding == 1) 
        prev = qsr(i,j);
      else
        qsr(i,j) = 0;
      end
      
    else
      qsr(i,j) = 0;
    end
    
  end

  prev = 0;
  threshold = temp;
end


end

