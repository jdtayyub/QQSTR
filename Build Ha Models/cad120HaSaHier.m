function [ hier ] = cad120HaSaHier( root_dir )
%CREATETWOLEVELHIER Read the ground truth data and create a hierarchy
%showing each high level activity Ha with its constituating sub level
%activities sequence Sas. 

hier = {};
subLabels = {};

vids = [root_dir  'RGBD_images'];
annot = [root_dir  'annotations'];
count = 1;

subjects = dir(vids);

for f = 1: length(subjects)
  if((subjects(f).isdir == 1) && (~strcmp(subjects(f).name, '.')) && (~strcmp(subjects(f).name, '..')))
    subNum = f - 3;
    activities = dir([vids '/' subjects(f).name]);
    
    for a = 1: length(activities)
      if((activities(a).isdir == 1) && (~strcmp(activities(a).name, '.')) && (~strcmp(activities(a).name, '..')))
        
        acNum = a - 2; 
        hier{1,acNum} = activities(a).name;
        
        subAct = [annot '/' subjects(f).name(1:9) 'annotations/'  activities(a).name '/labeling.txt']; 
        text = textscan(fopen(subAct),'%f,%f,%f,%s');
        numbers = [text{1} text{2} text{3}]; %[VideoId FrameStart FrameEnd]
        act = regexp(text{4},'([^ ,:]*)','tokens');
        for i = 1 : size(act,1)
          subact(i,1) = act{i}{1};
        end
        
        instances = dir([vids '/' subjects(f).name '/' activities(a).name]);
        acts = {};
        for in = 1: length(instances)
          if((instances(in).isdir == 1) && (~strcmp(instances(in).name, '.')) && (~strcmp(instances(in).name, '..')))
          
            singleSubActs = numbers(find(numbers == str2num(instances(in).name)),:);
            singleSubActsLabels = subact(find(numbers == str2num(instances(in).name)),:);
            
            acts{in-2} =  singleSubActsLabels;
            
            count = count + 1;
          end
        end
        hier{subNum+1,acNum} =  acts;
        singleSubActs = [];
        singleSubActsLabels = {};
      end
    end
  end
end




end

