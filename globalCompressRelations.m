function [ cQsr ] = globalCompressRelations( qsr )
%GLOBALCOMPRESSRELATIONS Globally compress relation keeping in regards
%other object pair relation in scene.
%   Input - qsr
%   Output - cQSR: compressed version of the qsr ready for descriptive
%   featuring of video


cQsr = {};
for i = 1:size(qsr,1)
  vid = qsr{i};
  cVid = vid(:,1);
  for j=2:size(vid,2)
    diff = cVid(:,end) == vid(:,j);
    if size(find(diff == 0),1) > 0
      cVid = [cVid vid(:,j)];
    end
  end
  cQsr = [cQsr; cVid];
end

end

