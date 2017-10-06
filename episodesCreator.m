function [ episodes ] = episodesCreator( qsr )
%EPISODESCREATOR Creating a function to format QSRs in episode format
%                Format each cell : [objectCombination {Relation starFrame endFrame}...]
%     INPUT
%       qsr- Traditional QSR cell file


rel = [1 2 3];
tempFrames = {};
episodes = {};

flg = false;

for i = 1 : size(qsr, 1)
  for j = 1 : size(qsr{i},1)
    
    rel = 0;
    for k = 2: size(qsr{i},2)

      if(rel ~= qsr{i}(j,k))
          tempFrames = [tempFrames k-1];
          tempFrames = [tempFrames qsr{i}(j,k)];
          tempFrames = [tempFrames k];
          rel = qsr{i}(j,k);
      end

      if(k == size(qsr{i},2))
        tempFrames = [tempFrames k];
      end

    end

    tempFrames{1} = qsr{i}(j,1);
    episodes{i,j} = tempFrames;
    tempFrames = {};
      
  end
        
end


end

