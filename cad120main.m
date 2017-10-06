function [ qsr, distances, labels ] = cad120main( root_dir )
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
global objects;
objects = {};

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
            skel = [skel; skel3D]; %Raw Skeleton
            
            
            %Get object rectangles
            rectangles = {};
            count = 1;
            while exist([annot '/' subjects(f).name(1:9) 'annotations/'  activities(a).name '/' instances(in).name '_obj' num2str(count) '.txt'])
              objectTrack = [annot '/' subjects(f).name(1:9) 'annotations/'  activities(a).name '/' instances(in).name '_obj' num2str(count) '.txt'];
              objData = dlmread(objectTrack);
              %             rectangles = [rectangles; objData(1:size(rgbImage, 1),3:6)];
              rectangles = [rectangles ; [objData(1:size(rgbImage, 1),3:4)...
                abs(objData(1:size(rgbImage, 1),3)-objData(1:size(rgbImage, 1),5))...
                abs(objData(1:size(rgbImage, 1),4)-objData(1:size(rgbImage, 1),6))]];
              count = count + 1;
            end
            rectangles = interpolateObjectTracks(rectangles);
            %obj = [obj; rectangles]; %Raw Objects Rectangle
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%DRAW FRAMES%%%%%%%%%%%%%%%%%%%%%%%
            %             hold on;
            %             for k = 1 : numFrames
            %               im = imread([vids '/' subjects(f).name '/' activities(a).name '/' instances(in).name '/' 'RGB_' num2str(k) '.png']);
            %               imshow(im);
            %               for l = 1 : size(rectangles,2)
            %                 r = rectangle('Position', rectangles{l}(k,:));
            %                 set(r,'edgecolor','y')
            %                 set(r,'LineWidth',4)
            %               end
            %               rH = mbr([skel2D(:,23) skel2D(:,24)], 'hand');
            %               lH = mbr([skel2D(:,25) skel2D(:,26)], 'hand');
            %
            %
            %               r = rectangle('Position', lH(k,:));
            %               set(r,'edgecolor','r')
            %               set(r,'LineWidth',4)
            %
            %               text(lH(k,1),lH(k,2)-10, 'Left Hand','color','r')
            %               text(rectangles{l}(k,1),rectangles{l}(k,2)-10, 'Microwave','color','y')
            %               pause(0.01);
            % %               waitforbuttonpress;
            
            %             end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            %get qsr for object relations passing in (right hand, left hand, object rectangle)
            qsr = [qsr; getQSR(mbr([skel2D(:,23) skel2D(:,24)], 'hand'), mbr([skel2D(:,25) skel2D(:,26)], 'hand'), rectangles{:})];
            labels = [labels; activities(a).name];
            vidId = [vidId;instances(in).name];
            
            %Get all qsr and extend DC into Near Mid Far based on
            %clustering of all DCs distances between object pairs into three clusters. Use corresponding
            %distances to compute discrete classes.
            
            %get distances for objects  passing in (right hand, left hand, object point)
            centerPoint = {};
            for k = 1:size(rectangles,1)
              centerPoint = [centerPoint ;[rectangles{k}(:,1)+rectangles{k}(:,3)/2 rectangles{k}(:,2)+rectangles{k}(:,4)/2]];
            end
            
            %           dist = [dist; getDistances([skel2D(:,23) skel2D(:,24)], [skel2D(:,25) skel2D(:,26)], centerPoint)];
            
            distances = [distances; getDistances(...
              [skel2D(:,25) skel2D(:,26)], ... %Right Hand
              [skel2D(:,23) skel2D(:,24)], ... %Left Hand
              centerPoint{:},...                %Object
              [skel2D(:,1) skel2D(:,2)], ...   %Head
              [skel2D(:,3) skel2D(:,4)], ...   %Neck
              [skel2D(:,5) skel2D(:,6)], ...   %Torso
              [skel2D(:,7) skel2D(:,8)], ...   %Left Shoulder
              [skel2D(:,11) skel2D(:,12)], ... %Right Shoulder
              [skel2D(:,15) skel2D(:,16)], ... %Left Hip
              [skel2D(:,17) skel2D(:,18)] ... %Right Hip
              )];
            
            %            sizes = 40*ones(size(skel2D(:,24),1),1);
            %            distCir = [distCir; getCircleDistances([skel2D(:,23) skel2D(:,24) sizes sizes], ... %Left Hand
            %                                             [skel2D(:,25) skel2D(:,26) sizes sizes], ... %Right Hand
            %                                             rectangles{:})];                   %Object
            
            %            distRect = [distRect; getRectDistances([skel2D(:,23) skel2D(:,24) sizes sizes], ... %Left Hand
            %                                             [skel2D(:,25) skel2D(:,26) sizes sizes], ... %Right Hand
            %                                             rectangles{:})]
            
            
          end
        end
      end
    end
  end
end


end

