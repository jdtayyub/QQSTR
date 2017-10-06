function [ output_args ] = KNNclassifierforQSRmulti( qsr, grouping )
  %KNNclassifierforQSRmulti Uses a KNN classifier to classify the QSR
  %generated which are pairs + triples or more for example DC PO PC CD etc and DCP PODP etc... Training is
  %done and classified using a 1 vs all technique
  %   INPUT: 
  %     data.mat - is the variables containing the labels and compressed qsr 
  %     grouping - an integer defining the grouping required for learning
  %     such as 2 for pairs, 3 for pairs + triples, 4 for pairs + triples +
  %     fours etc.
  %   OUTPUT:
  %     A confusion matrix of all predcition
load('QSR&Labels.mat')

% [ qsr, labels ] = cad120main('/usr/not-backed-up/CAD_120/CAD_120/');
[triplesHist] = multiQSRHist( qsr );

features  = triplesHist;

% Double Labels
% uLabels = unique(labels);
% 
% for c = 1:size(uLabels)
%   labels(strcmp(labels,uLabels(c))) = {c};
% end
% labels = cell2mat(labels);
% 
% res = [];
% for x = 1:124
% 
%   %MRMR
%   disp(x)
%   f = mrmr_mid_d(features, labels, x);
%   featuresMRMR = features(:,f);
%   
  
  predictions = {};
  K = 1;
  TP = 0;FP=0;
  % TPRate = [];FPRate=[];
  for i = 1:size(features,1);
    featureTrainIns = setdiff([1:size(features,1)],i);
    mdl = ClassificationKNN.fit(features(featureTrainIns,:),labels(featureTrainIns,:),'NumNeighbors',K); % Select classification Technique such as Tree , NaiveBayes
    classpredict = predict(mdl,features(i,:));

    predictions = [predictions; classpredict];

    if strcmp(labels(i,:),classpredict)
      TP = TP+1;  
    end
  %   else
  %     FP = FP+1;
  %   end

  end
  
% res = [res;TP] ; 
% % end

confMatrix = confusionmat(labels, predictions)
computeScores(confMatrix, labels); %displays all scores