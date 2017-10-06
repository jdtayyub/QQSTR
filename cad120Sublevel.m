function [ qsr, subLabels ] = cad120sublevel( root_dir )
%CAD120MAIN Function to processs the CAD120 dataset to extract videos and
%           annotations and to process them to get QSRs of Sublevel
%           activities
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


load('newDist&Labels.mat');
load('AllnewQSR&Labels.mat');
subLabels = {};
subQsr = {};
subDist = {};
subFrames = {};

vids = [root_dir  'RGBD_images'];
annot = [root_dir  'annotations'];
count = 1;

subjects = dir(vids);

for f = 1: length(subjects)
  if((subjects(f).isdir == 1) && (~strcmp(subjects(f).name, '.')) && (~strcmp(subjects(f).name, '..')))
    
    activities = dir([vids '/' subjects(f).name]);
    
    for a = 1: length(activities)
      if((activities(a).isdir == 1) && (~strcmp(activities(a).name, '.')) && (~strcmp(activities(a).name, '..')))
        
        subAct = [annot '/' subjects(f).name(1:9) 'annotations/'  activities(a).name '/labeling.txt']; 
        text = textscan(fopen(subAct),'%f,%f,%f,%s');
        numbers = [text{1} text{2} text{3}]; %[VideoId FrameStart FrameEnd]
        act = regexp(text{4},'([^ ,:]*)','tokens');
        for i = 1 : size(act,1)
          subact(i,1) = act{i}{1};
        end
%         subact = subact'; %[sub activity labels]
        
        
        instances = dir([vids '/' subjects(f).name '/' activities(a).name]);
        
        for in = 1: length(instances)
          if((instances(in).isdir == 1) && (~strcmp(instances(in).name, '.')) && (~strcmp(instances(in).name, '..')))
          
            singleSubActs = numbers(find(numbers == str2num(instances(in).name)),:);
            singleSubActsLabels = subact(find(numbers == str2num(instances(in).name)),:);
            
            for i=1 : size(singleSubActs,1)
              subLabels = [subLabels; singleSubActsLabels{i}];
              subQsr = [subQsr; [qsr{count}(:,1) qsr{count}(:,singleSubActs(i,2)+1:singleSubActs(i,3)+1)] ];
              subDist = [subDist; [distances{count}(:,1) distances{count}(:,singleSubActs(i,2)+1:singleSubActs(i,3)+1)]];
              subFrames = [subFrames; {num2str(singleSubActs(i,2)) num2str(singleSubActs(i,3)) singleSubActsLabels{i} subjects(f).name activities(a).name instances(in).name}];
            end
            
            count = count + 1;
          end
        end
      end
    end
  end
end


end

