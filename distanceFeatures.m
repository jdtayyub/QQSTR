function [ dFeatures, dFeaturesNoObj ] = distanceFeatures(distances, labels)
%DISTANEFEATURES Creates various Features out of distances
%   INPUT
%     dist - distances at each frame of pairs of objects and body parts - 
%     Load Below
%   OUTPUT
%     dFeatures - features of size M X N where M is the number of videos
%     and N is the number of various features. 


% load('newDist&Labels.mat');
% load('fullTrackQsr&Dist');

% load('feat3Dgc&d'); %12JUN

% load('3D Tests/extracted features/feat3Dgc&dV5.mat');%TODAY

% load('yaniSmoothDist&LabelsV2.mat');

% load('subQsr&Dist&Labels.mat')
% distances = subDist;
% labels = subLabels;

dFeatures = [];
tempFeature = [];

dFeaturesNoObj= [];
distFeat = [];

for i = 1 : size(distances,1)
  for j = 1 : size(distances{i},1)
    
    distances{i}(j,2:end) = smoothDist(smoothDist(distances{i}(j,2:end)))';
    meanD = mean(distances{i}(j,2:end)); %%%%%%%%%%%%%%
    modeD = mode(distances{i}(j,2:end)); %%%%%%%%%%%%%%
    medianD = median(distances{i}(j,2:end)); %%%%%%%%%%%%%%
    geoMeanD = geomean(distances{i}(j,2:end)); %%%%%%%%%%%%%%
%     harmeanD = harmmean(distances{i}(j,2:end)); 
    iqrD = iqr(distances{i}(j,2:end)); %%%%%%%%%%%%%%
%     madD = mad(distances{i}(j,2:end)); 
    
    
    
    stdD  = std(distances{i}(j,2:end)); %%%%%%%%%%%%%%
    skewD = skewness(distances{i}(j,2:end)); %%%%%%%%%%%%%%
    if isnan(skewD)
      skewD = 0;
    end
    kurtosisD = kurtosis(distances{i}(j,2:end)); %%%%%%%%%%%%%%
    if isnan(kurtosisD)
      kurtosisD = 0;
    end
%     gradients = gradient(distances{i}(j,2:end));
%     meanG = mean(gradients);
%     modeG = mode(gradients);
%     medianG = median(gradients);
  


    dist = abs( min(distances{i}(j,2:end)) - max(distances{i}(j,2:end)) );
    direct = 1;
    [~,minI] = min(distances{i}(j,2:end));
    [~,maxI] = max(distances{i}(j,2:end));
    if(minI > maxI)
      dist = -1 * dist; %%%%%%%%%%%%%%
      direct = 0;  %%%%%%%%%%%%%%
    end
    
    base = abs(maxI - minI);
    height = abs(dist);
%     angle = atand(height/base); 
%     
%     if isnan(angle)
%       angle = 0;
%     end
%     

%%% Get local minima and maxima and the angle between them
    dpS = distances{i}(j,2:end);
    dpSG = std(gradient(dpS)); %%%%%%%%%%%%%%
%     dpSGG = std(gradient(dpSG));
%
%     plot(datapointsSmoothed);
%  
%     hold on; 
%     [pks,locs] = findpeaks(datapointsSmoothed);
%     scatter(locs,pks,'g','filled')
%     
%     DataInv = 1.01*max(datapointsSmoothed) - datapointsSmoothed;
%     [Minima,MinIdx] = findpeaks(DataInv);
%     Minima = datapointsSmoothed(MinIdx);
%     scatter(MinIdx,Minima,'r')
    distNormHist = hist((dpS - 0) / ( 2000 - 0 ),10);

    
    
    tempFeature = [tempFeature meanD stdD skewD kurtosisD dist direct];% modeD medianD];%dpSG dpSGG];% angle]; % geoMeanD harmeanD iqrD madD zscoreD]; % Feature would be in format [mean1 std1 mean2 std2 mean3 std3 ...] where 1 2 3 are object kinds
    
    distFeat = [distFeat; meanD stdD skewD kurtosisD];
    
  end
  
  %%%Add on to ignore object sectioning%%
  d = distances{i}(:,2:end);
  idx = find(d(:,1)==0);
  d(idx,:) = [];
  distNoObj = mean(d);
  dist = abs( min(distNoObj) - max(distNoObj) );
  direct = 1;
  [~,minI] = min(distNoObj);
  [~,maxI] = max(distNoObj);
  if(minI > maxI)
    dist = -1 * dist; %%%%%%%%%%%%%%
    direct = 0;  %%%%%%%%%%%%%%
  end
  distFeat = mean(distFeat);
  distFeat = [distFeat dist direct];
  
  dFeaturesNoObj = [dFeaturesNoObj;  distFeat];
  distFeat = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  dFeatures = [dFeatures;tempFeature];
  tempFeature = [];

end

end

