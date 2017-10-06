function [ multiHist,multiHistNoObj,multiHistNoObjSimple,multiHistNoObjGen, multiHistNoObjLetterHist ] ...
          = multiQSRHistMultiRelationBin( qsr, distances, labels )
%PAIRWISEQSRHIST Feature creator, in form of histogram counting the
%                occurances of multiple relations INCLUDING SIMILAR RELATIONS in the videos
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

multiHistNoObj = [];
relHist = [];
timeHist = [];
distFeat = [];


% load('combsOf3s&4s.mat');
smoothingThreshold = 8;

singleHistRelations = mapComb2RCC(makeAllCombinations(1,3));

doubleHistRelations = mapComb2RCC(makeAllCombinations(2,3));
doubleHistRelations = doubleHistRelations(:,1)*10 + doubleHistRelations(:,2);

triplesHistRelations = mapComb2RCC(makeAllCombinations(3,3));
triplesHistRelations = triplesHistRelations(:,1)*100 + (triplesHistRelations(:,2)*10 + triplesHistRelations(:,3));

foursHistRelations = mapComb2RCC(makeAllCombinations(4,3));
foursHistRelations = foursHistRelations(:,1)*1000 + (foursHistRelations(:,2)*100 + (foursHistRelations(:,3)*10 + foursHistRelations(:,4)));

histBins = [singleHistRelations' doubleHistRelations' triplesHistRelations' foursHistRelations'];

histBinsCount = zeros(1,size(histBins,2));

multiHist = zeros(size(qsr,1), size(histBins,2)*size(qsr{1},1));
s = 1;
e = size(histBins,2);

cRpairs = []; cRtriples = []; cRfours = [];
for i = 1:size(qsr,1)
 
  for j = 1: size(qsr{i},1)
    
    cR = qsr{i}(j,:); %!! CAUTION: Qsr must be converted and compressed already globally at this stage !!  
    
    
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
    
    %%%Add on to ignore object sectioning%%
    relHist = [relHist ; histBinsCount];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    histBinsCount = zeros(1,size(histBins,2));
  end
  
  %%%Add on to ignore object sectioning%%
  multiHistNoObj = [multiHistNoObj ; sum(relHist)];
  relHist = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  s = 1;
  e = size(histBins,2);
  
  
end
% %
  param.featuresSetLabels = ones(1,size(multiHist,2)); %%%Labelling the kind of feature , 1 for rcc, 2 for temp and 3 for dist

% % 
   [tRPairs, timeHist] = temporalFeatures(qsrFrameCount(qsr));
   multiHist = [multiHist tRPairs];
   
   %%%Add on to ignore object sectioning%%
   multiHistNoObj = [multiHistNoObj  timeHist];
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   param.featuresSetLabels = [param.featuresSetLabels ones(1,size(tRPairs,2))*2];
% %     

   [dRPairs, distFeat] = distanceFeatures(distances, labels);
   
   %%%Add on to ignore object sectioning%%
   multiHistNoObj = [multiHistNoObj  distFeat];
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   multiHist = [multiHist dRPairs];
   param.featuresSetLabels = [param.featuresSetLabels ones(1,size(dRPairs,2))*3];
   
   %%%Add Object information exclusively
   [a,b,c] = objectFeatures(qsr);
   multiHistNoObj = [multiHistNoObj a];
   multiHistNoObjSimple = [multiHistNoObj b];
   multiHistNoObjGen = [multiHistNoObj c];
   
   [letterHist] = objectFeaturesLetterHist(qsr);
   multiHistNoObjLetterHist = [multiHistNoObj letterHist];
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
end

