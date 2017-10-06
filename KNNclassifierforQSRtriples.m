function [ confMat ] = KNNclassifierforQSRtriples( input_args )
  %KNNclassifierforQSRtriples Uses a KNN classifier to classify the QSR
  %generated which are pairs + triples for example DC PO PC CD etc and DCP PODP etc... Training is
  %done and classified using a 1 vs all technique
  %   INPUT: 
  %     data.mat - is the variables containing the labels and compressed qsr 
  %   OUTPUT:
  %     A confusion matrix of all predcition
load('data.mat')

% [ qsr, labels ] = cad120main('/usr/not-backed-up/CAD_120/CAD_120/');
[triplesHist] = triplesQSRHist( qsr );

features  = triplesHist;


predictions = {};

K = 1;
TP = 0;FP=0;
% TPRate = [];FPRate=[];
for i = 1:size(features,1);
  featureTrainIns = setdiff([1:size(features,1)],i);
  mdl = ClassificationKNN.fit(features(featureTrainIns,:),labels(featureTrainIns,:),'NumNeighbors',K);
  classpredict = predict(mdl,features(i,:));
  
  predictions = [predictions; classpredict];
  
%   if strcmp(labels(i,:),classpredict)
%     TP = TP+1;  
%   else
%     FP = FP+1;
%   end

end

confMatrix = confusionmat(labels, predictions)
computeScores(confMatrix, labels); %displays all scores

end

