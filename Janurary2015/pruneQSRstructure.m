function [ qsrNew ] = pruneQSRstructure( s , op)
%PRUNEQSRSTRUCTURE Function cuts down the qsr structure to remove object
%pairs based on the size needed. The logic is simply cutting last Total
%Size - SIZE objects. 

% op : 1 -> simply keep only first s pairs of objects
% op : 2 -> keep most interactive locally s pairs of objects
% op : 3 -> randomly remove all but s pairs of objects

load('rawQSRDISTgtSameOrder');


switch op
  case 1
  
    for i=1:size(qsr,1)
      qsrNew{i,1} = qsr{i}(1:3,:); 
    end

  case 2
    
    for i=1:size(qsr,1)
      if size(qsr{i},1) > s
        
        temp = [];
        for j = 1: size(qsr{i},1)
          temp(j) = getRowChanges(qsr{i}(j,:));
        end
        
        [~, index] = sort(temp,'descend');
        qsrNew{i,1} = qsr{i}(index(1:s),:);
      
      else
        qsrNew{i,1} = qsr{i}(1:3,:);
      end
    end
    
  case 3
    
    
    for i=1:size(qsr,1)
      if size(qsr{i},1) > s
        rowIdx = [];
        ts = [1:size(qsr{i},1)];
        for j = 1 : size(qsr{i},1) - s
          idx = randi(size(ts,2),1);
          rowIdx(j) = ts(idx);
          ts = ts(ts~=ts(idx));
        end
                       
        qsrNew{i,1} = qsr{i}(ts,:); 
      else
        qsrNew{i,1} = qsr{i}(1:3,:); 
      end
    end

end

