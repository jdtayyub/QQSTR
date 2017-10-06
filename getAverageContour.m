function [aC] = getAverageContour(cF)
% Takes a bunch of contours for each frames, gets their sizes and removes
% noisy too small or too large contour, equalizes the sizes for the
% remaining contours and computes and average contour representative of the
% many conoutours for many frames. cF contour per frames cell array where
% each cell is a contour in that frame.

sizes = cell2mat(cellfun(@size,cF,'uni',false));
sizes = sizes(:,1);
uL = mean(sizes) + 2*std(sizes);%upper limit
lL = mean(sizes) + 2*std(sizes);%lower limit
ncF = cF(find(sizes<uL && sizes>lL));

%equalize length by taking the smallest value and removing points from
%others to achieve that value


end