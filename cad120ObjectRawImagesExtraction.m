function [ output_args ] = cad120ObjectRawImagesExtraction( input_args )
%CAD120OBJECTRAWIMAGESEXTRACTION Summary of this function goes here
%   Detailed explanation goes here

global param
param.root_path = '/usr/not-backed-up/CAD_120/CAD_120/';

vids = [param.root_path  'RGBD_images'];
annot = [param.root_path  'annotations'];

subjects = dir(vids);

for f = 1: length(subjects)
  if((subjects(f).isdir == 1) && (~strcmp(subjects(f).name, '.')) && (~strcmp(subjects(f).name, '..')))
    
    activities = dir([vids '/' subjects(f).name]);
    
    for a = 1: length(activities)
      if((activities(a).isdir == 1) && (~strcmp(activities(a).name, '.')) && (~strcmp(activities(a).name, '..')))
        
        instances = dir([vids '/' subjects(f).name '/' activities(a).name]);
        
        for in = 1: length(instances)
          if((instances(in).isdir == 1) && (~strcmp(instances(in).name, '.')) && (~strcmp(instances(in).name, '..')))
            
            images = dir([vids '/' subjects(f).name '/' activities(a).name '/' instances(in).name]);
            numOfFrames = (size(images,1) - 2) / 2;
            
            %Get object rectangles
            rectangles = {};
            count = 1;
            while exist([annot '/' subjects(f).name(1:9) 'annotations/'  activities(a).name '/' instances(in).name '_obj' num2str(count) '.txt'])
              objectTrack = [annot '/' subjects(f).name(1:9) 'annotations/'  activities(a).name '/' instances(in).name '_obj' num2str(count) '.txt'];
              objData = dlmread(objectTrack);
              rectangles = [rectangles ; [objData(1:numOfFrames,3:4)...
                abs(objData(1:numOfFrames,3)-objData(1:numOfFrames,5))...
                abs(objData(1:numOfFrames,4)-objData(1:numOfFrames,6))]];
              count = count + 1;
            end
            rectangles = interpolateObjectTracks(rectangles);
            numOfObjs = size(rectangles,1);
            
            %Get object labels
            objInfopath = [param.root_path 'annotations/' subjects(f).name(1:9) 'annotations/' activities(a).name '/activityLabel.txt'];
            str = '';
            for j = 1 : numOfObjs
              str = [str '%s '];
            end
            text = textscan(fopen(objInfopath),['%s %s %s ' str],'Delimiter',',');
            objs = cat(2,text{:});
            
            %%%Find objects in video with vidid
            objectsList = cell(numOfObjs,1);
            mat = str2mat(objs(:,1));
            for l = 1 : size(mat,1)
              if strcmp(mat(l,:),instances(in).name)
                idx = l;
                break;
              end
            end
            for j =4 : size(objs,2)
              objectsList{j-3} = objs{idx,j}(3:end);
            end
            
            %Get all RGB only on Cornell
            obj= cell(numOfFrames,numOfObjs);
            for i = 1 : numOfFrames
              imPath = [vids '/' subjects(f).name '/' activities(a).name '/' instances(in).name '/RGB_' num2str(i) '.png'];
              im = imread(imPath);
              %%%
              for objNum = 1 : numOfObjs
                obj{i,objNum} = imcrop(im,rectangles{objNum}(i,:));
              end
              %%%
            end
            
            %%%For each object Get prototype
            for objNum = 1 : numOfObjs
              objectStore(obj(:,objNum),objectsList(objNum));
              %objProt = objectPrototypeExtraction(obj(:,objNum),'contour');
            end
            
          end
        end
      end
    end
  end
end

end

