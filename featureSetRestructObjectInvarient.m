function [ featureSet ] = featureSetRestructObjectInvarient( fS )
%FEATURESETRESTRUCTOBJECTINVARIENT This function will restructure the
%featrure set to align all object pair features and add them together. The
%resulting feature would represent the overall interaction counts regarless
%of the type of object pair 1-2 , 2-3 or etc. 

%%%%%%DOES NOT WORK FOR DISTANCE FEATURES%%%%%%%%%%%%% THEY CANNOT SIMPLY
%%%%%%BE ADDED TOGETHER %%%%%%%%%%%%% FLAUED FUNCTION %%%%%%%

%   Detailed explanation goes here
featureSet = [];
stemp = [];
ttemp = [];
dtemp = [];

spatial = fS(:,1:2520);
temporal = fS(:,2521:2520 + 378);
dist = fS(:,2520 + 378 + 1 : 2520 + 378 + 546);
for x = 1: size(fS,1)

  for i = 1:120:2520
    stemp = [stemp;spatial(x, i: i+119)];
  end
  stemp = sum(stemp);

  for i = 1:18:378
    ttemp = [ttemp;temporal(x, i: i+17)];
  end
  ttemp = sum(ttemp);

  for i = 1:6:546
    dtemp = [dtemp;dist(x, i: i+5)];
  end
  dtemp = sum(dtemp);
  
  featureSet = [featureSet; [stemp ttemp dtemp]];
  
  
  stemp = [];
  ttemp = [];
  dtemp = [];

  
end


end

