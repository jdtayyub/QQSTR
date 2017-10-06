function [ eQsr ] = extendQSRs( qsr, distances, labels )
%EXTENDQSRS Takes the DCs in input qsr and converts them into either near,
%middle or far based on corresponding distances clustering.

%   Detailed explanation goes here


load('rawQSRDISTgtSameOrder.mat');

%learn Distance clusters

%retrieve all DC distances
eQsr = {};
rawD = [];

for i = 1 : size(qsr,1)
  objPairRowsQsr = qsr{i}(:,1);
  currQsr = qsr{i}(:,2:end);
  
  objPairRowsDist = distances{i}(:,1);    
  currDist = distances{i}(:,2:end);    
    
  idx = [];
  for j = 1: size(objPairRowsQsr,1)
    idx = [idx ; find(objPairRowsDist == objPairRowsQsr(j))];
  end
   
  currDistFil= currDist(idx,:);
  
  onesIdx = find(currQsr == 1); % look for all DC
  corrDist = currDistFil(onesIdx);
  
  rawD = [rawD;corrDist];
  
end

%cluster distances and find centroids for future classification

[idx c] = kmeans(rawD,3);

%label clusters % 4 is NEAR , 5 is Mid, 6 is FAR
clabels = zeros(3,1);
[~,i] = min(c);  
clabels(i) = 4;
[~,i] = max(c)
clabels(i) = 6;
clabels(clabels == 0) = 5;

%classifcation
for i = 1 : size(qsr,1)
  objPairRowsQsr = qsr{i}(:,1);
  currQsr = qsr{i}(:,2:end);
  
  objPairRowsDist = distances{i}(:,1);    
  currDist = distances{i}(:,2:end);   
  
  idx = [];
  for j = 1: size(objPairRowsQsr,1)
    idx = [idx ; find(objPairRowsDist == objPairRowsQsr(j))];
  end
   
  currDistFil= currDist(idx,:);
  onesIdx = find(currQsr == 1); % look for all DC
  corrDist = currDistFil(onesIdx);
  
  for j = 1 : size(onesIdx,1)
    [mini,cIdx] = min(abs(c - corrDist(j)));
    currQsr(onesIdx(j)) = clabels(cIdx);    
  end
  currQsr = [objPairRowsQsr  currQsr];
  
  eQsr = [eQsr; currQsr];
end


end

