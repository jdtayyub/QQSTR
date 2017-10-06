function [ qsrA ] = smoothRelations( qsrA, threshold )
%COMPRESSRELATIONS Removes repeated relations in the frame to give the 
%   INPUT
%     qsr - qsr relations for each object pair for all frame in format
%           objectPair x [objectPair identifier [frameRelations ]]
%     threshold - defined the number of frames that the relation should hold
%                 before it is considered as changing
%   OUTPUT
%     compressQsr - compressed qsr with 0 in place of repeated relations.

for v = 1:size(qsrA,1)
  qsr = qsrA{v};

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
          if j~=2
            qsr(i,j) = 0;
          end
        end

      else
        qsr(i,j) = 0;
      end

    end

    prev = 0;
    threshold = temp;
  end

  qsrNew = qsr;
  for i = 1:size(qsr,1)
    indNNZ = find(qsr(i,1:end)~=0);
    if size(indNNZ,2) ~= 1
      for k = 2:length(indNNZ)-1
        qsrNew(i,indNNZ(k):indNNZ(k+1))=qsr(i,indNNZ(k));
      end

      qsrNew(i,indNNZ(end):end)=qsr(i,indNNZ(end));
    end
  end

  qsrA{v} = qsrNew;
end

end

