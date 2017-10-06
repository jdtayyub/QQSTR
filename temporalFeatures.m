function [ tFeatures, tFeaturesNoObj ] = temporalFeatures( qsrF )
%TEMPORALFEATURES Summary of this function goes here
%   INPUT
%     qsrF - qsr in the format [object rcc frames rcc frames ...]
%   OUTPUT
%     tFeatures - Temporal duration features of pairwise qsr relations


histBins = [121 122 123 131 132 133 211 212 213 311 312 313 231 232 233 321 322 323];
histBinsCount = zeros(1,size(histBins,2));
% tFeatures = zeros(size(qsrF,1), size(histBins,2)*size(qsrF{1},1));
tFeaturesHistList = [];
tFeatures = [];

tFeaturesNoObj = [];
timeHist = [];

rel = [];

ratios = [];
meanStdRatios = [];

for i = 1: size(qsrF,1)
  
  for j = 1: size(qsrF,2)
  
    cR = cell2mat(qsrF{i,j});
    
    for k = 2: 2 : size(qsrF{i,j},2)-3 
      
        rel(k/2) = cR(k)*10+cR(k+2);
        ratio = cR(k+3) / cR(k+1);  
        
        ratios = [ratios;[ cR(k+3) cR(k+1)  ratio]];%Capture all ratios for clustering later
        
        %Discretizing based on guessed ranges which could be learned But
        %now just experimented
        if(ratio < 0.35 ) % 0.25
            rel(k/2) = rel(k/2)*10 + 1;%short
        elseif(ratio > 2.25) % 2.25
            rel(k/2) = rel(k/2)*10 + 3;%long
        else
            rel(k/2) = rel(k/2)*10 + 2;%equal
        end
        
        %%%%%OTher discretizing options below%%%%%%%%%%%%%
      
    end
    
    for k =1 : size(histBins,2)
      histBinsCount(k) = histBinsCount(k) + size(find(rel == histBins(k)),2);
    end
    tFeaturesHistList = [tFeaturesHistList histBinsCount];
    
    %%%Add on to ignore object sectioning%%
    timeHist = [timeHist;histBinsCount];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    histBinsCount = zeros(1,size(histBins,2));
    rel=[];
    
  end

  tFeatures = [tFeatures; tFeaturesHistList];
  tFeaturesHistList = [];
  
  if(size(ratios,1) == 0)
    meanStdRatios = [meanStdRatios; [mean(ratios,1) std(ratios,0,1)]]; % Adding the std and mean to give some increase to accuracy
  else
    meanStdRatios = [meanStdRatios; zeros(1,size(meanStdRatios,2))]; % Adding the std and mean to give some increase to accuracy 0s if no ratio exists
  end
  ratios = [];
  
  %%%Add on to ignore object sectioning%%
  tFeaturesNoObj = [tFeaturesNoObj;sum(timeHist)];
  timeHist = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end


tFeatures = [tFeatures meanStdRatios]; % Adding std and mean to give some increase to accuracy

end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        
%         %Discretizing based on guessed ranges which could be learned But
%         %now just experimented
%         if(cR(k+3) < 15 ) % 0.25
%             rel(k/2) = rel(k/2)*10 + 1;%short
%         elseif(cR(k+3) > 30) % 2.25
%             rel(k/2) = rel(k/2)*10 + 3;%long
%         else
%             rel(k/2) = rel(k/2)*10 + 2;%equal
%         end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

        %Discretizing based on learned ranges through clustering all points
        %into three distinct clusters and learning the following model
        %  Short Cluster centroid  48.4286  298.5635
        %  Equal Cluster centroid  46.1549   46.7009 
        %  Long Cluster centroid   300.3353   50.4251
%         clusters = [48.4286  298.5635; 46.1549   46.7009; 300.3353   50.4251];
%         euclDist(1) = norm([cR(k+3) cR(k+1)] - clusters(1,:));
%         euclDist(2) = norm([cR(k+3) cR(k+1)] - clusters(2,:));
%         euclDist(3) = norm([cR(k+3) cR(k+1)] - clusters(3,:));
%         [~, class] = min(euclDist);
%         rel(k/2) = rel(k/2)*10 + class;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %Discretizing based on learned ratios through clustering all ratio points
        %into three distinct clusters and learning the following model
        %  Short Cluster centroid ratio 1.2720
        %  Equal Cluster centroid ratio 9.1052
        %  Long Cluster centroid  ratio 27.6801
%         clusters = [1.2720 ; 4.1052 ; 12.6801];
%         euclDist(1) = norm(ratio - clusters(1,:));
%         euclDist(2) = norm(ratio - clusters(2,:));
%         euclDist(3) = norm(ratio - clusters(3,:));
%         [~, class] = min(euclDist);
%         rel(k/2) = rel(k/2)*10 + class;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Discretizing based on learned full frame numbers through
        %clustering all second frame numbers into three distinct clusters 
        %and learning the following model
        %  Short Cluster centroid ratio 35.3675
        %  Equal Cluster centroid ratio 142.3045
        %  Long Cluster centroid  ratio 377.5000
%         clusters = [35.3675 ; 142.3045 ; 377.5000];
%         euclDist(1) = norm(cR(k+3) - clusters(1,:));
%         euclDist(2) = norm(cR(k+3) - clusters(2,:));
%         euclDist(3) = norm(cR(k+3) - clusters(3,:));
%         [~, class] = min(euclDist);
%         rel(k/2) = rel(k/2)*10 + class;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%