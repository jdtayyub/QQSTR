function [ output_args ] = objectPrototypeExtraction( seq , featType)
%OBJECTPROTOTYPEEXTRACTION Takes in a sequence iamges of a single object
%from f1 to fn and returns a prototype of that object such as mean contours
%   seq is a column of object images at each frame in a video.
%   featType is a string of which type of feature to extract 'contour'
%   'sift' etc
global param
switch featType
  case 'contour'
    objPath = '/usr/not-backed-up/CAD_120/CAD_120/RGBD_images/objectMasks/book';
    d = dir(objPath);
    sumImage = double(imread([objPath '/' d(3).name])); %Initialize in first image
    for f = 4 : size(d,1)
      rgbImage = imread([objPath '/' d(f).name]);
      sumImage = sumImage + double(rgbImage);
    end
    meanImage = sumImage / size(d,1)-2;
    
    %Get contour
    meanImage(meanImage<0)  = 0; % get rid of neg values
    meanImage = mat2gray(meanImage); % convert to gray scale
    bw = im2bw(meanImage,0.5); % threshold at 0.5 intensity
    [B,L,N,A] = bwboundaries(bw,8,'noholes'); % Get contour
    [v idx] = max(cell2mat(cellfun(@size,B,'uni',false)));% get largest contour
    idx = idx(1);
    boundary = B{idx};
    plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
    axis([0 size(bw,1) 0 size(bw,1)])
    
    disp('tada');
    
  case 'sift'
    
  case 'hsvHist'
    
end

end


% conts = cell(size(seq,1),1);
% for i =1 : size(seq,1)
%   im = seq{i};
%   gIm = rgb2gray(im);
%   mask = true(size(gIm));
%   bw = activecontour(gIm, mask, 300, 'edge');
%   [B,L,N,A] = bwboundaries(bw,8,'noholes'); % extract contour lines
%   [v idx] = max(cell2mat(cellfun(@size,B,'uni',false))); % get largest contour
%   idx = idx(1);
%   conts(i) = B(idx);
%   boundary = conts{i};
%   plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
%   pause(0.02);
% end
