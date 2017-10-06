function [ multiHist ] = multiQSRHist( qsr, distances, labels )
%PAIRWISEQSRHIST Feature creator, in form of histogram counting the
%                occurances of multiple relations in the videos
%   INPUT
%     qsr - Spatial Relations strings of all dataset.
%     grouping - an integer defining the grouping required for learning
%     such as 2 for pairs, 3 for pairs + triples, 4 for pairs + triples +
%     fours etc.
%   OUTPUT
%     triplesHist - Histograms of each video showing counts of the triples
%     relations 
      
global param;
param.featuresSetLabels = [];

smoothingThreshold = 8;

triplesHistRelations = makeDiscriminatingCombinations(3,3);
triplesHistRelations = triplesHistRelations(:,1)*100 + (triplesHistRelations(:,2)*10 + triplesHistRelations(:,3));

foursHistRelations = makeDiscriminatingCombinations(4,3);
foursHistRelations = foursHistRelations(:,1)*1000 + (foursHistRelations(:,2)*100 + (foursHistRelations(:,3)*10 + foursHistRelations(:,4)));

histBins = [1 2 3 12 13 21 31 23 32 ];
histBins = [histBins triplesHistRelations' foursHistRelations'];

histBinsCount = zeros(1,size(histBins,2));

multiHist = zeros(size(qsr,1), size(histBins,2)*size(qsr{1},1));
s = 1;
e = size(histBins,2);

cRpairs = []; cRtriples = []; cRfours = [];
for i = 1:size(qsr,1)
 
  for j = 1: size(qsr{i},1)
    
    cR = compressRelations(qsr{i},smoothingThreshold);%Threshold 8 frames temporal consistancy required before judging relational change
    cR = cR(j,:);
    cR(cR == 0) = [];
    
    for l = 2:size(cR,2)-1
      cRpairs(l-1) = cR(l)*10+cR(l+1);
      
      if(l+1 <= size(cR,2)-1)
        cRtriples(l-1) = cR(l)*100 + (cR(l+1) * 10 + cR(l+2));
      end
      
      if(l+2 <= size(cR,2)-1)
        cRfours(l-1) = cR(l)*1000 + (cR(l+1)*100 + (cR(l+2) * 10 + cR(l+3)));
      end
      
    end
    
 
    
    cRPairsTriples = [cR(2:end) cRpairs cRtriples cRfours]; % Add or Remove here to change feature vector cR(2:end) cRpairs cRtriples cRfours
%      cRPairsTriples = [];   
    for k = 1: size(histBins,2)
      histBinsCount(k) = histBinsCount(k) + size(find(cRPairsTriples == histBins(k)),2);
    end
    multiHist(i, s:e) = histBinsCount;
    s = s + size(histBins,2);
    e = e + size(histBins,2);
    histBinsCount = zeros(1,size(histBins,2));
  end
  
  s = 1;
  e = size(histBins,2);
  
  
end
 param.featuresSetLabels = ones(1,size(multiHist,2));

% 
   tRPairs = temporalFeatures(qsrFrameCount(qsr));
   multiHist = [multiHist tRPairs];
    param.featuresSetLabels = [param.featuresSetLabels ones(1,size(tRPairs,2))*2];
    
   dRPairs = distanceFeatures(distances, labels);
   multiHist = [multiHist dRPairs];
    param.featuresSetLabels = [param.featuresSetLabels ones(1,size(tRPairs,2))*2];

end

