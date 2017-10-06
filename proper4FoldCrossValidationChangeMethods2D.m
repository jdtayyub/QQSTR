function [finalACC, ACC] = proper4FoldCrossValidationChangeMethods2D(qsr, distances, labels, featureSet)
%LIBSVMMULTICLASSIFY Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%LOADING%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('globalSmoothQsr&Labels.mat'); %Yesterday

% load('feat2Dgc&d.mat'); %12JUN
% load('3D Tests/extracted features/feat3Dgc&dV5.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global param

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
% load('tempFeat2.mat');%yesterday

% load('comuputedfeats2D.mat'); %12JUn
% load('3D Tests/extracted features/extractedfeat3Dgc&dV5.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxNoFS = param.numOfFeatures;
ACC = [];
finalACC = []; 
predictions = [];
for i=1:size(subFolds,1)
  featureTest = featureSet(subFolds(i,1):subFolds(i,2),:);
  featureTrainIns = setdiff([1:size(featureSet,1)],subFolds(i,1):subFolds(i,2));
  featureTrain = featureSet(featureTrainIns,:);
  
  bestFeatures = [];
  intersectFeatures = {};
  AllFeaturesInFS = [];
   
  %FEATURE SELECTION
  for j= setdiff(1:size(subFolds,1),i)
%     disp(['Fold: ' num2str(i) ' fsFold: ' num2str(j)])
    fsTest = featureSet(subFolds(j,1):subFolds(j,2),:); %fs : Feature Selection
    fsTrainIns = setdiff([1:size(featureSet,1)],[subFolds(i,1):subFolds(i,2) subFolds(j,1):subFolds(j,2)]);
    fsTrain = featureSet(fsTrainIns,:);
    
   
    ACC{i,j} = zeros(1,maxNoFS);
    tic
    fs = mrmr_mid_d(fsTrain, labels(fsTrainIns), maxNoFS);
    toc
    disp(['Fold: ' num2str(i) ' fsFold: ' num2str(j)])
    for x = 1:1:maxNoFS
%       disp(['Fold: ' num2str(i) ' fsFold: ' num2str(j) ' fsNum: ' num2str(x)])
      fsTrainAfter = featureSet(:,fs(1:x)); 
      
      %Test Feature Set
      model = svmtrain(labels(fsTrainIns),fsTrainAfter(fsTrainIns,:), param.SVM);
      [predicted_label, accuracy, decision_values] = svmpredict(labels(subFolds(j,1):subFolds(j,2)), fsTrainAfter(subFolds(j,1):subFolds(j,2),:), model, '-q 1');
      temp = predicted_label == labels(subFolds(j,1):subFolds(j,2));
      ACC{i,j}(x) =  size(temp(temp==1),1)/size(fsTest,1);  
%       disp(ACC(x));
    end
    
    
    
    
    % NEW Method of getting last max value
    [MaxACC,MaxMRMR] = max(ACC{i,j});
%     maxInd = find(ACC{i,j} == MaxACC);
%     MaxMaxMRMR = max(maxInd);
%     MaxfsIns = mrmr_mid_d(fsTrain,labels(fsTrainIns),MaxMaxMRMR);
    bestFeatures = [bestFeatures fs(1:MaxMRMR)];
    intersectFeatures = [intersectFeatures; fs(1:MaxMRMR)];
%     AllFeaturesInFS = [AllFeaturesInFS fs];
  end
  
    % Choose unique among all 3 fold based on max Accuracy
    finalbestFeaturesIns = unique(bestFeatures); %Maybe we shouldnt Loose order of features
%     finalbestFeaturesIns = unique(AllFeaturesInFS);
    
    
%     finalIntersectFeaturesIns = intersect(intersect(intersectFeatures{1,:},intersectFeatures{2,:}),intersectFeatures{3,:});
%     finalbestFeaturesIns = finalIntersectFeaturesIns;
    
    finalfeatureTrain = featureTrain(:,finalbestFeaturesIns);
    finalfeatureTest = featureTest(:,finalbestFeaturesIns);
    
    model = svmtrain(labels(featureTrainIns),finalfeatureTrain, param.SVM);
    [predicted_label_final] = svmpredict(labels(subFolds(i,1):subFolds(i,2)), finalfeatureTest, model, '-q 1');
    tempFinal = predicted_label_final == labels(subFolds(i,1):subFolds(i,2));
    finalACC(i) =  size(tempFinal(tempFinal==1),1)/size(featureTest,1);
    predictions = [predictions; predicted_label_final];
end

% save('results.mat','ACC','finalACC')
% confMatrix = confusionmat(labels, predictions);
% [ tp, p, r, meanF1, acc ] = computeScores(confMatrix, uLabels);
% confMatFix;
mean(finalACC)




% scatter(1:length(ACC{1,2}),ACC{1,2})
% hold on
% scatter(1:length(ACC{1,2}),ACC{1,3},'r')
% scatter(1:length(ACC{1,2}),ACC{1,4},'g')
%   
% figure
% scatter(1:length(ACC{1,2}),ACC{2,1})
% hold on
% scatter(1:length(ACC{1,2}),ACC{2,3},'r')
% scatter(1:length(ACC{1,2}),ACC{2,4},'g')
% 
% figure
% scatter(1:length(ACC{1,2}),ACC{3,1})
% hold on
% scatter(1:length(ACC{1,2}),ACC{3,2},'r')
% scatter(1:length(ACC{1,2}),ACC{3,4},'g')
% 
% figure
% scatter(1:length(ACC{1,2}),ACC{4,1})
% hold on
% scatter(1:length(ACC{1,2}),ACC{4,2},'r')
% scatter(1:length(ACC{1,2}),ACC{4,3},'g')
end