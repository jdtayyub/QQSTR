function [ featureSet ] = libSvmMultiClassify4Fold( qsr, distances , labels)
global param

%LIBSVMMULTICLASSIFY Summary of this function goes here
%   Detailed explanation goes here
% binning Option - for local pass 1 for global pass 2 

% load('AllnewQSR&Labels.mat') %loads labels and pairwiseHist
% load('fullTrackQsr&Dist');

%load('globalSmoothQsr&Labels.mat');
% load('feat2Dgc&d'); %12JUN

% load('3D Tests/extracted features/feat3Dgc&dV5.mat'); %today

% load('AllsubQsr&Dist&Labels.mat') %loads labels and pairwiseHist
% load('globalCompressedAllsubQsr&Dist&Labels.mat') %loads labels and pairwiseHist
% qsr = subQsr;
% labels = subLabels;
% subFolds = [1 295;296 616;617 892;893 1191];
subFolds = [1 31;32 62;63 93;94 124];

% labelSvm = labelFixforSvm(labels,10);
uLabels = unique(labels);
predictions = [];

%Reorder labels according to the paper's order -> Reaching, Moving, Pouring, Eating, Drinking, Opening, Placing, Closing, Scrubbing, null
% rlabels(1) = uLabels(10); rlabels(2) = uLabels(5); rlabels(3) = uLabels(9); rlabels(4) = uLabels(4); rlabels(5) = uLabels(3); 
% rlabels(6) = uLabels(7); rlabels(7) = uLabels(8); rlabels(8) = uLabels(2); rlabels(9) = uLabels(1); rlabels(10) = uLabels(6);
% uLabels = rlabels'; 
% 
% %Reorder labels according to the paper's order -> Reaching, Moving, Pouring, Eating, Drinking, Opening, Placing, Closing, Scrubbing, null
rlabels(1) = uLabels(4); rlabels(2) = uLabels(9); rlabels(3) = uLabels(5); rlabels(4) = uLabels(7); rlabels(5) = uLabels(10); 
rlabels(6) = uLabels(6); rlabels(7) = uLabels(2); rlabels(8) = uLabels(8); rlabels(9) = uLabels(1); rlabels(10) = uLabels(3);
uLabels = rlabels'; 

for c = 1:size(uLabels)
  labels(strcmp(labels,uLabels(c))) = {c};
end

% Get Labels
labels = cell2mat(labels);

% % Get Features
if(param.binningOption == 1)
  [featureSet] = multiQSRHist( qsr , distances, labels ); % REQUIRES REGULAR RCC
elseif(param.binningOption == 2)
  [featureSet, featureSetNoObj,featureSetNoObjSimple,featureSetNoObjGen, featureSetNoObjLetterHist] = ...
                            multiQSRHistMultiRelationBin( qsr , distances , labels ); % REQUIRES GLOBALLY COMPRESSED RCC
end

if(param.objectInvariant == 1)
  featureSet = featureSetNoObj;
elseif param.objectInvariant == 2
  featureSet = featureSetNoObjSimple;
elseif  param.objectInvariant == 3
  featureSet = featureSetNoObjGen;
elseif param.objectInvariant == 4
  featureSet = featureSetNoObjLetterHist;
end

if(param.removeDist == 1)
  featureSet = featureSet(:,1:2394);%16758 with full QSR rep , 2394 with just 3 pairs
end


% if(param.aggregateFeatureforObjectPairs == 1)
%   featureSet = featureSetRestructObjectInvarient(featureSet);
% end

%Remove zero columns
param.featuresSetLabels(~any(featureSet,1) ) = [];%%%  ??? 
featureSet( :, ~any(featureSet,1) ) = [];


%Normalize Features%%%%%%%%%%%%%%%%%%%
%   for j = 1 : size(featureSetMRMR,1)
%     featureSetMRMR(j,:) = (featureSet(j,:) - mean(featureSet)) ./ std(featureSet);
%   end


% temp  =  featureSet(:,[135]);
% featureSet(:,[135]) = [];
if param.normalizeFeatures == 1
  for j = 1 : size(featureSet,2)
    featureSet(:,j) = (featureSet(:,j) - min(featureSet(:,j))) ./ (max(featureSet(:,j))-min(featureSet(:,j)));
  end
end
% featureSet = [featureSet temp];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end