function [ output_args ] = cad120main2dExperiment( input_args )

global param

param.root_path = '/usr/not-backed-up/CAD_120/CAD_120/';
param.binningOption = 2;% last arg defines binning option of 1 for local and 2 for global best 2
param.smoothingThreshold = 7;%best 7
param.numOfFeatures = 50;%best 201
param.SVM = '-s 0 -t 1 -d 2 -g 0.7500 -c 1 -q 1  '; % before svm optim
param.aggregateFeatureforObjectPairs =2;% aggregating option. 1 for aggregate feature space without object pair seperation, 2 for no aggregation of feature space best 2
param.objectInvariant = 4;% PROPER obejct invariance by just adding historgrams and 0: for None 
                          % 1: list feature, labels for every comb
                          % 2: Binary bitmap of object presence
                          % 3: Binary extended to capture number of instances
                          % 4: Letter Histogramming
                          
param.normalizeFeatures = 1;% Normalize all features from 0-1 in individually . 1 for yes 0 for no
% param.SVM = '-t 1 -d 1 -g 0.8 -q 1';

%%%%JAN%%%%
param.removeDist = 0;% 1 for true and removing


addpath(genpath('/home/cserv1_a/soc_msc/sc12jbmt/Documents/CAD120AR/3D/libsvm-3.17'))
addpath(genpath('/home/cserv1_a/soc_msc/sc12jbmt/Documents/CAD120AR/3D/MRMR'))


% [ qsr, distances, labels ] = cad120main(root_path);

% %  load('rawQSRDISTgtExtended.mat'); %%% extended by adding more qsr
% ,along with 1 2 3 also added 4 5. Changed need to be made in
% multQSRHistMultiRelationBin function to account for the added qsrs.

load('rawQSRDISTgtSameOrder.mat'); %%%BEST%%%

% load('rawQSRDISTgtJan-3.mat'); %%%% ALREADY EQUALIZED TO 3 so COMMENT THE
% NEXT EQUALIZATION LINELINE

qsr = equalizeInputLength(qsr);
distances = equalizeInputLength(distances);
% 
% 
% %% Smooth
qsr = smoothRelations(qsr,param.smoothingThreshold );
% 
% %% Globally Compress 
if(param.binningOption == 2)
  qsr = globalCompressRelations(qsr);
end
% 
% load('newDist&Labels.mat');
% load('globalSmoothQsr&Labels.mat');


disp('Feature Extraction')
%% Feature Extraction
featureSet = libSvmMultiClassify4Fold(qsr, distances, labels);

disp('Classifying')
%% Classification
% % 
[finalACC, ACC] = proper4FoldCrossValidationChangeMethods2D(qsr, distances, labels, featureSet);
disp(['ACC ' num2str(finalACC) '   SVM PARAM: ' param.SVM]);

% results = [];
% for s = 0 
%   for t =  1 %: 3
%     for d = 1 : 4
%       for g = [0.0001:0.25:0.99 0.99]% 
%         for c = 1
%           param.SVM = ['-s ' num2str(s) ' -t ' num2str(t) ' -d ' num2str(d) ' -g ' num2str(g) ' -c ' num2str(c) ' -q 1 '];
%           [finalACC, ACC] = proper4FoldCrossValidationChangeMethods2D(qsr, distances, labels, featureSet);
%           results = [results; [s t d g c finalACC]];
%           save('SVMResultsHands2Dextended.mat','results')
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

