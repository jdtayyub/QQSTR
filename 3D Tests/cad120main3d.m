function [ qsr,distances, labels ] = cad120main3d( root_dir )
%CAD120MAIN Function to processs the CAD120 dataset to extract videos and
%           annotations and to process them to get QSRs
%   INPUT
%     root_dir - Main CAD120 directory
%

%   Joint number -> Joint name
%      1 -> HEAD
%      2 -> NECK
%      3 -> TORSO
%      4 -> LEFT_SHOULDER
%      5 -> LEFT_ELBOW
%      6 -> RIGHT_SHOULDER
%      7 -> RIGHT_ELBOW
%      8 -> LEFT_HIP
%      9 -> LEFT_KNEE
%     10 -> RIGHT_HIP
%     11 -> RIGHT_KNEE
%     12 -> LEFT_HAND
%     13 -> RIGHT_HAND
%     14 -> LEFT_FOOT
%     15 -> RIGHT_FOOT

qsr = {};
distances = {};
distCir = {};
distRect = {};
labels = {};
skel = {};
obj = {};
vidId = [];

vids = [root_dir  'RGBD_images'];
annot = [root_dir  'annotations'];

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
            
            %Get all RGB only on Cornell
            rgbImage = [];
            for i = 3 : size(images,1)
              if(strcmp(images(i).name(1:3), 'RGB') == 1)
                rgbImage = [rgbImage; cellstr(images(i).name)];
              end
            end
            
            numFrames = size(rgbImage, 1);
            
            %Get Skeleton
            skeleton = [annot '/' subjects(f).name(1:9) 'annotations/'  activities(a).name '/' instances(in).name '.txt'];
            [skel2D skel3D] = parseSkeleton(skeleton, numFrames);
            %skel = [skel; skel2D]; %Raw Skeleton
            
            
            %Get object rectangles
            cubes = {};
            objTracks = csvread(['3D Tests/objectTracks/s' subjects(f).name(2:8) '-' activities(a).name '-' instances(in).name '.csv']);
            for i = 1: 6 :size(objTracks,2)
%              cubes = [cubes; objTracks(:,i:i+5)]; %ALL DIMENSIONS
               objTracks(:,i+3:i+5) = repmat(max(objTracks(:,i+3:i+5)),size(objTracks(:,i+3:i+5),1),1); % MEAN sized objects Fixed BB
               cubes = [cubes; objTracks(:,i:i+5)]; %ALL DIMENSIONS
%             cubes = [cubes; objTracks(:,[i i+1 i+3 i+4])]; %JUST X Y W H
            end
            %rectangles = interpolateObjectTracks(rectangles);
            
            
            %get qsr for object relations passing in (right hand, left hand, object rectangle)
            qsr = [qsr; getQSR3d(mbr3d([skel3D(:,34) skel3D(:,35) skel3D(:,36)], 'hand'), mbr3d([skel3D(:,37) skel3D(:,38) skel3D(:,39)], 'hand'), cubes{:})]; %ALL DIMENSIONS
%             qsr = [qsr; getQSR3d( ...
%                         mbr3d([skel3D(:,34) skel3D(:,35) skel3D(:,36)], 'hand'),... % right Hand
%                         mbr3d([skel3D(:,37) skel3D(:,38) skel3D(:,39)], 'hand'),... % left hand
%                         mbr3d([skel3D(:,1) skel3D(:,2) skel3D(:,3)],'head'), ...   %Head
%                         mbr3d([skel3D(:,4) skel3D(:,5) skel3D(:,6)], 'hand'), ...   %Neck
%                         mbr3d([skel3D(:,7) skel3D(:,8) skel3D(:,9)], 'head'), ...   %Torso
%                         mbr3d([skel3D(:,10) skel3D(:,11) skel3D(:,12)], 'hand'), ...   %Left Shoulder
%                         mbr3d([skel3D(:,16) skel3D(:,17) skel3D(:,18)], 'hand'), ... %Right Shoulder
%                         mbr3d([skel3D(:,22) skel3D(:,23) skel3D(:,24)], 'hand'), ... %Left Hip
%                         mbr3d([skel3D(:,28) skel3D(:,29) skel3D(:,30)], 'hand'), ... %Right Hip
%                         cubes{:})]; %ALL DIMENSIONS + BPs
%             qsr = [qsr; getQSR(mbr3d([skel3D(:,34) skel3D(:,35)], 'hand'), mbr3d([skel3D(:,37) skel3D(:,38)], 'hand'), cubes{:})]; %JUST X Y
            labels = [labels; activities(a).name];
            vidId = [vidId;instances(in).name];
            
            %get distances for objects  passing in (right hand, left hand, object point)
            centerPoint = {};
            for k = 1:size(cubes,1)
              centerPoint = [centerPoint ;[cubes{k}(:,1) cubes{k}(:,2) cubes{k}(:,3)]];% ALL DIMENSIONS
%               centerPoint = [centerPoint ;[cubes{k}(:,1) cubes{k}(:,2) ]];%JUST X Y W H
            end
            
            
            
            
            % ALL DIMENSIONS
            
            distances =  [distances; getDistances([skel3D(:,1) skel3D(:,2) skel3D(:,3)], ...   %Head
                    [skel3D(:,4) skel3D(:,5) skel3D(:,6)], ...   %Neck
                    [skel3D(:,7) skel3D(:,8) skel3D(:,9)], ...   %Torso
                    [skel3D(:,10) skel3D(:,11) skel3D(:,12)], ...   %Left Shoulder
                    [skel3D(:,16) skel3D(:,17) skel3D(:,18)], ... %Right Shoulder
                    [skel3D(:,22) skel3D(:,23) skel3D(:,24)], ... %Left Hip
                    [skel3D(:,28) skel3D(:,29) skel3D(:,30)], ... %Right Hip
                    [skel3D(:,34) skel3D(:,35) skel3D(:,36)], ... %Left Hand
                    [skel3D(:,37) skel3D(:,38) skel3D(:,39)], ... %Right Hand
                    centerPoint{:})];                %Object
            

            %JUST X Y W H
%             distances =  [distances; getDistances([skel3D(:,1) skel3D(:,2) ], ...   %Head
%                     [skel3D(:,4) skel3D(:,5) ], ...   %Neck
%                     [skel3D(:,7) skel3D(:,8) ], ...   %Torso
%                     [skel3D(:,10) skel3D(:,11) ], ...   %Left Shoulder
%                     [skel3D(:,16) skel3D(:,17) ], ... %Right Shoulder
%                     [skel3D(:,22) skel3D(:,23) ], ... %Left Hip
%                     [skel3D(:,28) skel3D(:,29) ], ... %Right Hip
%                     [skel3D(:,34) skel3D(:,35) ], ... %Left Hand
%                     [skel3D(:,37) skel3D(:,38) ], ... %Right Hand
%                     centerPoint{:})];                %Object
            
            
          end
        end
      end
    end
  end
end


end

