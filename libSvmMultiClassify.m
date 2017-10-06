function [ output_args ] = libSvmMultiClassify( input_args )
%LIBSVMMULTICLASSIFY Summary of this function goes here
%   Detailed explanation goes here


% load('AllnewQSR&Labels.mat') %loads labels and pairwiseHist

% load('fullTrackQsr&Dist');

% load('AllsubQsr&Dist&Labels.mat') %loads labels and pairwiseHist
% qsr = subQsr;
% labels = subLabels;

load('globalSmoothQsr&Labels.mat');


% labelSvm = labelFixforSvm(labels,10);
uLabels = unique(labels);
predictions = [];

%Reorder labels according to the paper's order -> Reaching, Moving, Pouring, Eating, Drinking, Opening, Placing, Closing, Scrubbing, null
% rlabels(1) = uLabels(10); rlabels(2) = uLabels(5); rlabels(3) = uLabels(9); rlabels(4) = uLabels(4); rlabels(5) = uLabels(3); 
% rlabels(6) = uLabels(7); rlabels(7) = uLabels(8); rlabels(8) = uLabels(2); rlabels(9) = uLabels(1); rlabels(10) = uLabels(6);
% uLabels = rlabels'; 

%Reorder labels according to the paper's order -> Reaching, Moving, Pouring, Eating, Drinking, Opening, Placing, Closing, Scrubbing, null
rlabels(1) = uLabels(4); rlabels(2) = uLabels(9); rlabels(3) = uLabels(5); rlabels(4) = uLabels(7); rlabels(5) = uLabels(10); 
rlabels(6) = uLabels(6); rlabels(7) = uLabels(2); rlabels(8) = uLabels(8); rlabels(9) = uLabels(1); rlabels(10) = uLabels(3);
uLabels = rlabels';

for c = 1:size(uLabels)
  labels(strcmp(labels,uLabels(c))) = {c};
end

% Get Labels
labels = cell2mat(labels);

% Get Features
% [featureSet] = multiQSRHist( qsr );
[featureSet] = multiQSRHistMultiRelationBin( qsr );

%Remove zero columns
featureSet( :, ~any(featureSet,1) ) = [];

%Normalize Features
%   for j = 1 : size(featureSetMRMR,1)
%     featureSetMRMR(j,:) = (featureSet(j,:) - mean(featureSet)) ./ std(featureSet);
%   end

  for j = 1 : size(featureSet,2)
    featureSet(:,j) = (featureSet(:,j) - min(featureSet(:,j))) ./ (max(featureSet(:,j))-min(featureSet(:,j)));
  end

% TP = 0;
% for i = 1:size(featureSet,1);
%
%   %% SVM Classification
%
%     featureTrainIns = setdiff([1:size(featureSet,1)],i);
%
%     model = svmtrain(labels(featureTrainIns),featureSet(featureTrainIns,:), '-t 0');
%     [predicted_label, accuracy, decision_values] = svmpredict(labels(i), featureSet(i,:), model)
%
%  if(predicted_label == labels(i))
%   TP = TP + 1;
%  end
%
% end


% Use MRMR
res = [];
for x =1:2:399
  disp(x)
%     x = 150;
  f = mrmr_mid_d(featureSet, labels, x);
  featureSetMRMR = featureSet(:,f);
  
 
  TP = 0;
  for i = 1:size(featureSetMRMR,1);
    
    % SVM Classification
    
    featureTrainIns = setdiff([1:size(featureSetMRMR,1)],i);
    
    model = svmtrain(labels(featureTrainIns),featureSetMRMR(featureTrainIns,:), '-t 1 -d 2 -g 0.7 -q 1 ');
    [predicted_label, accuracy, decision_values] = svmpredict(labels(i), featureSetMRMR(i,:), model, '-q 1');
    predictions = [predictions; predicted_label];
    
    
    if(predicted_label == labels(i))
      TP = TP + 1;
    end
    
    
    
  end
  disp(( TP/i ) * 100);
  res = [res; ( TP/i ) * 100];
end

% confMatrix = confusionmat(labels, predictions)
% computeScores(confMatrix, uLabels); %displays all scores

end