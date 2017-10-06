function proper4FoldCrossValidation
%LIBSVMMULTICLASSIFY Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%LOADING%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('globalSmoothQsr&Labels.mat'); %Yesterday

% load('feat3Dgc&d.mat'); %Today
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subFolds = [1 31;32 62;63 93;94 124];
uLabels = unique(labels);
predictions = [];
% %Reorder labels according to the paper's order -> Reaching, Moving, Pouring, Eating, Drinking, Opening, Placing, Closing, Scrubbing, null
rlabels(1) = uLabels(4); rlabels(2) = uLabels(9); rlabels(3) = uLabels(5); rlabels(4) = uLabels(7); rlabels(5) = uLabels(10); 
rlabels(6) = uLabels(6); rlabels(7) = uLabels(2); rlabels(8) = uLabels(8); rlabels(9) = uLabels(1); rlabels(10) = uLabels(3);
uLabels = rlabels'; 

for c = 1:size(uLabels)
  labels(strcmp(labels,uLabels(c))) = {c};
end

% Get Labels
labels = cell2mat(labels);

%%%%%%%LOADING%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('tempFeat2.mat');%yesterday

% load('comuputedfeats3D.mat'); %today
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxNoFS = 201;
ACC = [];
finalACC = []; 
for i=1:size(subFolds,1)
  featureTest = featureSet(subFolds(i,1):subFolds(i,2),:);
  featureTrainIns = setdiff([1:size(featureSet,1)],subFolds(i,1):subFolds(i,2));
  featureTrain = featureSet(featureTrainIns,:);
  
  bestFeatures = [];
  %FEATURE SELECTION
  for j= setdiff(1:size(subFolds,1),i)
%     disp(['Fold: ' num2str(i) ' fsFold: ' num2str(j)])
    fsTest = featureSet(subFolds(j,1):subFolds(j,2),:); %fs : Feature Selection
    fsTrainIns = setdiff([1:size(featureSet,1)],[subFolds(i,1):subFolds(i,2) subFolds(j,1):subFolds(j,2)]);
    fsTrain = featureSet(fsTrainIns,:);
    
    predictions = [];
    ACC{i,j} = zeros(1,maxNoFS);
    fs = mrmr_mid_d(fsTrain, labels(fsTrainIns), maxNoFS);
    
    for x = 1:maxNoFS
      disp(['Fold: ' num2str(i) ' fsFold: ' num2str(j) ' fsNum: ' num2str(x)])
      
%       fs = mrmr_mid_d(fsTrain, labels(fsTrainIns), x);
      fsTrainAfter = featureSet(:,fs(1:x)); 
      
      %Test Feature Set
      model = svmtrain(labels(fsTrainIns),fsTrainAfter(fsTrainIns,:), '-t 1 -d 2 -g 0.7 -q 1 ');
      [predicted_label, accuracy, decision_values] = svmpredict(labels(subFolds(j,1):subFolds(j,2)), fsTrainAfter(subFolds(j,1):subFolds(j,2),:), model, '-q 1');
      %predictions = [predictions; predicted_label];
      temp = predicted_label == labels(subFolds(j,1):subFolds(j,2));
      ACC{i,j}(x) =  size(temp(temp==1),1)/size(fsTest,1);  
%       disp(ACC(x));
    end
    
    
    [MaxACC,MaxMRMR] = max(ACC{i,j});
    bestFeatures = [bestFeatures fs(1:MaxMRMR)];
%     MaxfsIns = mrmr_mid_d(fsTrain,labels(fsTrainIns),MaxMRMR);
%     bestFeatures = [bestFeatures MaxfsIns];
    
  end
  
    % Choose unique among all 3 fold
    finalbestFeaturesIns = unique(bestFeatures); %Maybe we shouldnt Loose order of features
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %       Get the indexes of all elements excluding duplicates
%       [~, idxs, ~] = unique(bestFeatures, 'last'); % Or 'first'
% %       Resort indexes and apply for input vector
%       finalbestFeaturesIns = bestFeatures(sort(idxs));
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    finalfeatureTrain = featureTrain(:,finalbestFeaturesIns);
    finalfeatureTest = featureTest(:,finalbestFeaturesIns);
    
    model = svmtrain(labels(featureTrainIns),finalfeatureTrain, '-t 1 -d 2 -g 0.7 -q 1 ');
    [predicted_label_final] = svmpredict(labels(subFolds(i,1):subFolds(i,2)), finalfeatureTest, model, '-q 1');
    %predictions_final = [predictions_final; predicted_label_final];
    tempFinal = predicted_label_final == labels(subFolds(i,1):subFolds(i,2));
    finalACC(i) =  size(tempFinal(tempFinal==1),1)/size(featureTest,1);
end

%save('results.mat','ACC','finalACC')

% Use MRMR
% res = [];
% for x=80:120
%   disp(x)
% %     x = 80;
%   
%   f = mrmr_mid_d(featureSet, labels, x);
%   featureSetMRMR = featureSet(:,f);
%   
%  
%   TP = 0;
%   for i = 1:size(subFolds,1);
%     
%     % SVM Classification
%     featureTrainIns = setdiff([1:size(featureSetMRMR,1)],subFolds(i,1):subFolds(i,2));
%     
%     model = svmtrain(labels(featureTrainIns),featureSetMRMR(featureTrainIns,:), '-t 1 -d 2 -g 0.7 -q 1 ');
%     [predicted_label, accuracy, decision_values] = svmpredict(labels(subFolds(i,1):subFolds(i,2)), featureSetMRMR(subFolds(i,1):subFolds(i,2),:), model, '-q 1');
%     predictions = [predictions; predicted_label];
%     
%     
%     temp = predicted_label == labels(subFolds(i,1):subFolds(i,2));
%     
%     TP = TP + size(temp(temp==1),1);
%   end
%   
%   
%   disp(( TP/124 ) * 100);
%   res = [res; ( TP/124 ) * 100];
% end

% confMatrix = confusionmat(labels, predictions)
% computeScores(confMatrix, uLabels); %displays all scores

end