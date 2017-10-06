function [ output_args ] = paulTest( train, test, labelsTrain, labelsTest )
%PAULTEST Summary of this function goes here
%   Detailed explanation goes here
uLabelsTrain = unique(labelsTrain);
uLabelsTest = unique(labelsTest);

for c = 1:size(uLabelsTrain)
  labelsTrain(strcmp(labelsTrain,uLabelsTrain(c))) = {c};
end

for c = 1:size(uLabelsTest)
  labelsTest(strcmp(labelsTest,uLabelsTest(c))) = {c};
end

labelsTrain = cell2mat(labelsTrain);
labelsTest = cell2mat(labelsTest);

model = svmtrain(labelsTrain,train, '-t 1 -d 2 -g 0.7 -q 1 ');
[predicted_label, accuracy, decision_values] = svmpredict(labelsTest, test, model, '-q 1');
TP = predicted_label == labelsTest;
acc = size(TP(TP==1),1)/size(labelsTest,1)

end

