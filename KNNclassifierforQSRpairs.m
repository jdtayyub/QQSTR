function  KNNclassifierforQSRpairs()
  %KNNclassifierforQSRpairs Uses a KNN classifier to classify the QSR
  %generated which are pairs for example DC PO PC CD etc... Training is
  %done and classified using a 1 vs all technique
  %   INPUT: 
  %     data.mat - is the variables containing the labels and compressed qsr 
  %   OUTPUT:
  %     A confusion matrix of all predcition



load('data.mat')

labelSvm = labelFixforSvm(labels,10);

% [ qsr, labels ] = cad120main('/usr/not-backed-up/CAD_120/CAD_120/');
[pairwiseHist] = multiQSRHist( qsr );

featureSet  = pairwiseHist;


predictions = {};

K = 1;
TP = 0;FP=0;
% TPRate = [];FPRate=[];
Classes = unique(labels);

%Train all Classes on SVM and build each class model
models = {};
for c = 1: length(Classes)

  % Randomly Remove Negative to balance +ve and -ve ratio.
  negEgIdx = find(strcmp(labelSvm(:,c),'negative'));
  posEgIdx = find(~strcmp(labelSvm(:,c),'negative'));
  randIdx = randi(size(negEgIdx,1),size(labelSvm(:,c),1) - size(negEgIdx,1),1);
  purgeLabels = [labelSvm(posEgIdx,c) ; labelSvm(negEgIdx(randIdx),c)];
  purgeFeatures = [featureSet(posEgIdx,:) ; featureSet(negEgIdx(randIdx),:)];

  models{c} =  svmtrain(purgeFeatures ,purgeLabels, 'kernel_function', 'polynomial');
  
end


for c = 1:length(Classes)
%   labelSVM = double(strcmp(labels,Classes(c)));
  predictions_temp = [];
  
  % Randomly Remove Negative to balance +ve and -ve ratio.
  negEgIdx = find(strcmp(labelSvm(:,c),'negative'));
  posEgIdx = find(~strcmp(labelSvm(:,c),'negative'));
  randIdx = randi(size(negEgIdx,1),size(labelSvm(:,c),1) - size(negEgIdx,1),1);
  purgeLabels = [labelSvm(posEgIdx,c) ; labelSvm(negEgIdx(randIdx),c)];
  purgeFeatures = [featureSet(posEgIdx,:) ; featureSet(negEgIdx(randIdx),:)];
  
  for i = 1:size(featureSet,1);
    
  %% SVM Classification
    
   
    featureTrainIns = setdiff([1:size(purgeFeatures,1)],i);
    
    model = svmtrain(purgeFeatures(featureTrainIns,:),purgeLabels(featureTrainIns,c),'kernel_function','polynomial');
    classpredict = svmclassify(model, purgeFeatures(i,:));
    conf = svmConfidenceValue(model, purgeFeatures(i,:));
    
    
    %Classify using all other models of classes prebuilt and obtain
    %confidence measure 
    for rc = 1 : length(Classes)
      if(rc ~= c)
        classpredict = [classpredict; svmclassify(models{rc}, purgeFeatures(i,:))];
        conf = [conf ; svmConfidenceValue(models{rc}, purgeFeatures(i,:))];
      end
    end
    
%    [itrfin] = multisvm( featureSet(featureTrainIns,:),labels(featureTrainIns,:),featureSet(i,:));
    
%     predictions_temp = [predictions_temp; classpredict];
    
    if strcmp(purgeLabels(i),classpredict(i)) && ~strcmp(classpredict(i),'negative')
      TP = TP+1;
    else
      FP = FP+1;
    end

  end
  
  predictions{c} = predictions_temp;
  confMatrix = confusionmat(labels, predictions{c})
end
disp(TP)

confMatrix = confusionmat(labels, predictions)
end

function Confidence = svmConfidenceValue(svm_struct, dataInstance) 

% A function to compute the distance of the dataPoint or an instance from
% the defined svm modal in svm_struct.
%   INPUT
%     svm_struct - The svm modal 
%     dataInstance - A single instance
%   Output
%     f - Confidence score


  sv = svm_struct.SupportVectors;
  alphaHat = svm_struct.Alpha;
  bias = svm_struct.Bias;
  kfun = svm_struct.KernelFunction;
  kfunargs = svm_struct.KernelFunctionArgs;
  f = kfun(sv,dataInstance,kfunargs{:})'*alphaHat(:) + bias;
  
  Confidence = f*-1;


end
