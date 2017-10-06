function [ output_args ] = cad120main3dExperiment
global param

param.binningOption = 2;% last arg defines binning option of 1 for local and 2 for global
param.smoothingThreshold = 0;
param.numOfFeatures = 201;
%param.SVM = '-t 1 -d 2 -g 0.7 -q 1 '; % before svm optim
% param.SVM = '-t 1 -d 1 -g 0.8 -q 1'; % before svm futher optim
param.SVM = '-s 0 -t 1 -d 1 -g 0.8 -c 1 -q 1';% 75.81

addpath(genpath('/home/cserv1_a/soc_msc/sc12jbmt/Documents/CAD120AR/3D/libsvm-3.17'))
addpath(genpath('/home/cserv1_a/soc_msc/sc12jbmt/Documents/CAD120AR/3D/MRMR'))
addpath('/home/cserv1_a/soc_msc/sc12jbmt/Documents/CAD120AR/3D')

%   [ qsr, distances, labels ] = cad120main3d('/usr/not-backed-up/CAD_120/CAD_120/');
load('rawQSRDIST.mat');
% load('rawQSRDISTAllParts.mat');
%  load('rawQSRDISTFixedBBMean.mat');
qsr = equalizeInputLength(qsr);
distances = equalizeInputLength(distances);


%% Smooth
% qsr = smoothRelations(qsr,param.smoothingThreshold );
% qsr = smoothRelationsWithMatlabSmooth(qsr,param.smoothingThreshold );

%% Globally Compress 
qsr = globalCompressRelations(qsr);

disp('Feature Extraction')
%% Feature Extraction
featureSet = libSvmMultiClassify4Fold(qsr, distances, labels);

disp('Classifying')
%% Classification

[finalACC, ACC] = proper4FoldCrossValidationChangeMethods3D(qsr, distances, labels, featureSet);


% results = [];
% for s = 0 
%   for t =  1 : 3
%     for d = 1 : 8
%       for g = [0.0001:0.25:0.99 0.99]% 
%         for c = 1
%           param.SVM = ['-s ' num2str(s) ' -t ' num2str(t) ' -d ' num2str(d) ' -g ' num2str(g) ' -c ' num2str(c) ' -q 1 '];
%           [finalACC, ACC] = proper4FoldCrossValidationChangeMethods3D(qsr, distances, labels, featureSet);
%           results = [results; [s t d g c finalACC]];
%           save('SVMResultsHands.mat','results')
%           disp(['ACC ' num2str(finalACC) '   SVM PARAM: ' param.SVM]);
%         end
%       end
%     end
%   end
% end

% results = [];
% for s = 0 
%   for t =  1
%     for d = 1:2
%       for g = [0.0004:0.05:0.99 0.99]% 
%         for c = 1
%           param.SVM = ['-s ' num2str(s) ' -t ' num2str(t) ' -d ' num2str(d) ' -g ' num2str(g) ' -c ' num2str(c) ' -q 1 '];
%           [finalACC, ACC] = proper4FoldCrossValidationChangeMethods3D(qsr, distances, labels, featureSet);
%           results = [results; [s t d g c finalACC]];
%           save('SVMResultsHandsGamma.mat','results')
%           disp(['ACC ' num2str(finalACC) '   SVM PARAM: ' param.SVM]);
%         end
%       end
%     end
%   end
% end


disp(param)
end

%%VISUALIZATION of Smmothing
%  subplot(1,2,1);imagesc(qsr{20}(:,2:end));subplot(1,2,2);imagesc(qsrA{20}(:,2:end))