function [ qsrFrames ] = qsrFrameCount( qsr )
%QSRFRAMECOUNT Converts the qsr format from [object rcc rcc rcc ...] to [object rcc frames rcc frames ...]
%   Input - qsr
%   Output - qsrFrames in the counter format




tempFrames = {};
qsrFrames = {};


for i = 1 : size(qsr, 1)
  for j = 1 : size(qsr{i},1)
    
    rel = qsr{i}(j,2);
    lastFrame = 2;
    tempFrames{1} = qsr{i}(j,1);
    for k = 2: size(qsr{i},2)
      
      if(rel ~= qsr{i}(j,k))
        
        tempFrames = [tempFrames qsr{i}(j,k-1)];
        tempFrames = [tempFrames k - lastFrame];
        lastFrame = k;
        rel = qsr{i}(j,k);
        
      end
      
      if(k == size(qsr{i},2))
        tempFrames = [tempFrames qsr{i}(j,k-1)];
        tempFrames = [tempFrames k - lastFrame + 1];
      end
      
      
      
    end
    
    qsrFrames{i,j} = tempFrames;
    tempFrames = {};
    
  end
  
end


%Optional Smooting, Require Threshold
threshold = 4;
flag = true;

for i = 1 : size(qsrFrames, 1)
  for j = 1 : size(qsrFrames, 2)
    while flag == true
      
      for k = 2 : 2 : size(qsrFrames{i,j}, 2) - 1
        
        if((cell2mat(qsrFrames{i,j}(k+1)) < threshold) && (size(qsrFrames{i,j},2) > 3))
          
          if(k ~= 2)
            qsrFrames{i,j}(k-1) = num2cell(cell2mat(qsrFrames{i,j}(k-1)) + cell2mat(qsrFrames{i,j}(k+1))); % Merge the relation with the previous relation
          else
            qsrFrames{i,j}(k+3) = num2cell(cell2mat(qsrFrames{i,j}(k+3)) + cell2mat(qsrFrames{i,j}(k+1))); % Merge the relation with the next relation
          end
          qsrFrames{i,j}(k) = num2cell(0); qsrFrames{i,j}(k+1) = num2cell(0); % Remove entry by replacing with zero and removing all zeros at end
          
          %Remove zero entries
          newRow = cell2mat(qsrFrames{i,j});
          newRow(newRow == 0) = []; %Bug as it could end up as 1 50 1 100 etc. where two relations would go next to each other
          qsrFrames{i,j} = num2cell(newRow);
          break;
          
        end
        
        if(k == size(qsrFrames{i,j}, 2) - 1)
          flag = false;
        end
        
      end
      
    end
    flag = true;
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Merge and Remove Repetitions
for i = 1 : size(qsrFrames, 1)
  for j = 1 : size(qsrFrames, 2)
    qsrFrames{i,j} = mergeRepetitionsQSR(qsrFrames{i,j});
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

