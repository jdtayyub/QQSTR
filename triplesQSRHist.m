function [ triplesHist ] = triplesQSRHist( qsr )
%PAIRWISEQSRHIST Feature creator, in form of histogram counting the
%                occurances of pairwise relations in the videos
%   INPUT
%     qsr - Spatial Relations strings of all dataset.
%   OUTPUT
%     triplesHist - Histograms of each video showing counts of the triples
%     relations 
      

smoothingThreshold = 8;

triplesHistRelations = makeDiscriminatingCombinations(3,3);
triplesHistRelations = triplesHistRelations(:,1)*100 + (triplesHistRelations(:,2)*10 + triplesHistRelations(:,3));

histBins = [1 2 3 12 13 21 31 23 32 ];
histBins = [histBins triplesHistRelations'];
histBinsCount = zeros(1,size(histBins,2));

triplesHist = zeros(size(qsr,1), size(histBins,2)*size(qsr{1},1));
s = 1;
e = size(histBins,2);

for i = 1:size(qsr,1)
 
  for j = 1: size(qsr{i},1)
    
    cR = compressRelations(qsr{i},smoothingThreshold);%Threshold 5 frames temporal consistancy required before judging relational change
    cR = cR(j,:);
    cR(cR == 0) = [];
        
    for l = 2:size(cR,2)-1
      cRpairs(l-1) = cR(l)*10+cR(l+1);
      if(l+1 <= size(cR,2)-1)
        cRtriples(l-1) = cR(l)*100 + (cR(l+1) * 10 + cR(l+2));
      end
    end
    
    cRPairsTriples = [cR(2:end) cRpairs cRtriples];
        
    for k = 1: size(histBins,2)
      histBinsCount(k) = histBinsCount(k) + size(find(cRPairsTriples == histBins(k)),2);
    end
    triplesHist(i, s:e) = histBinsCount;
    s = s + size(histBins,2);
    e = e + size(histBins,2);
    histBinsCount = zeros(1,size(histBins,2));
  end
  
  s = 1;
  e = size(histBins,2);
  
  
end



end

