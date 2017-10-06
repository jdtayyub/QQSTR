function [ pairwiseHist ] = pairwiseQSRHist( qsr )
%PAIRWISEQSRHIST Feature creator, in form of histogram counting the
%                occurances of pairwise relations in the videos
%   INPUT
%     qsr - Spatial Relations strings of all dataset.
%   OUTPUT
%     pairwiseHist - Histograms of each video showing counts of the pairwise relations
      

smoothingThreshold = 8;

histBins = [12 13 21 31 23 32];
histBinsCount = zeros(1,6);

pairwiseHist = zeros(size(qsr,1), size(histBins,2)*size(qsr{1},1));
s = 1;
e = size(histBins,2);

for i = 1:size(qsr,1)
 
  for j = 1: size(qsr{i},1)
    
    cR = compressRelations(qsr{i},smoothingThreshold);%Threshold 5 frames temporal consistancy required before judging relational change
    cR = cR(j,:);
    cR(cR == 0) = [];
    
    for l = 2:size(cR,2)-1
      cRpairs(l-1) = cR(l)*10+cR(l+1);
    end
    
    for k = 1: size(histBins,2)
      histBinsCount(k) = histBinsCount(k) + size(find(cRpairs == histBins(k)),2);
    end
    pairwiseHist(i, s:e) = histBinsCount;
    s = s + size(histBins,2);
    e = e + size(histBins,2);
    histBinsCount = zeros(1,6);
  end
  
  s = 1;
  e = size(histBins,2);
  
  
end



end

