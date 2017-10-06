function objectStore(objImgs,type)
%%%Function to store all mask cutouts of the objects from dataset into their
%%%respective type folders. Function will also take rgb sections of images
%%%and compute the corresponding mask of the object.

%create necessary directories for objects if they do not already exist
scale = 100; % resize all images of objects to this size mask to maintain equality when averaging and such
global param
objsPath = [param.root_path 'RGBD_images/objectMasks'];
if ~isdir(objsPath)
  mkdir(objsPath);
end
objsPathType = [param.root_path 'RGBD_images/objectMasks/' cell2mat(type)];
if ~isdir(objsPathType)
  mkdir(objsPathType);
end


%store object masks in directory for each frame
frames = size(objImgs,1);
for f = 1 : frames
  im = objImgs{f};
  gIm = rgb2gray(im);
  mask = true(size(gIm));
  bw = activecontour(gIm, mask, 300, 'edge');
  box = false(max(size(bw)));
  cenx = round((size(box,1) - size(bw,1))/2);
  ceny = round((size(box,2) - size(bw,2))/2);
  if cenx == 0
    cenx = 1;
  end
  if ceny == 0
    ceny = 1;
  end
  box(cenx:cenx+size(bw,1)-1, ceny:ceny+size(bw,2)-1) = bw;
  finIm = imresize(box,[scale NaN]);
  %Get last file number
  num = 1;
  objDir = dir(objsPathType);
  files = {objDir.name};
  if size(files,2) > 2  
    num = max(cell2mat(cellfun(@str2num, cellfun(@(x) x(4:end-4), files, 'UniformOutput', false), 'UniformOutput', false))) +1;  
  end
  
  imwrite(finIm,[objsPathType '/img' num2str(num) '.jpg']);
end

end