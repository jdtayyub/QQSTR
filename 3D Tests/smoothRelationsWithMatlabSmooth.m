function [ qsrA ] = smoothRelationsWithMatlabSmooth( qsrA, threshold )
global param
%COMPRESSRELATIONS Removes repeated relations in the frame to give the 
%   INPUT
%     qsr - qsr relations for each object pair for all frame in format
%           objectPair x [objectPair identifier [frameRelations ]]
%     threshold - defined the number of frames that the relation should hold
%                 before it is considered as changing
%   OUTPUT
%     compressQsr - compressed qsr with 0 in place of repeated relations.

for v = 1:size(qsrA,1)

  for i = 1:size(qsrA{v},1)
    qsrRow = qsrA{v}(i,2:end);
    qsrRowS= round(smooth(qsrRow,param.smoothingThreshold))';
    
    qsrA{v}(i,2:end) = qsrRowS;
    
%      imagesc([qsrRow; qsrRowS])
  end


%   qsrA{v} = qsrNew;
end

end

