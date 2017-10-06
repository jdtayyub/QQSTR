function [featListed,featAllObj, featAllObjGen] = objectFeatures(qsr)
%%Function responsible for computing information about the objects in the
%%videos such as object types available and object number available
%%FeatListed is a single list with labels-object configuration format. Also
%%includes the obj number 
%%featAllObj is the simple feature where each obj has a binary tag or
%%number of that object or 0 as indication of present or absent in that
%%video
%%featAllObjGen keeps unique objs and stored counts on how many of those
%%objs are present in the scene

load('cad120VidPaths.mat');
global param
objectsList = {};
%Get objects per video
for i = 1 : size(qsr,1)
  path = [param.root_path 'annotations/' vidPaths{i}(1:end-12) '/activityLabel.txt'];
  vidId = vidPaths{i}(end-10:end-1);
  
  %%%Find number of object in this video
  vec = qsr{i}(:,2);
  pairs = size(vec(vec~=0),1);
  for k = 2 : 100
    numObjs = sum(1:k-1) ;
    if numObjs == pairs
      numObjs = k;
      break
    end
  end
  numObjs = numObjs - 2; % -2 to get remove the two hands which are implicity included in our qsr representation
  
  str = '';
  for j = 1 : numObjs
    str = [str '%s '];
  end
  text = textscan(fopen(path),['%s %s %s ' str],'Delimiter',',');
  objs = cat(2,text{:});
  
  %%%Find objects in video with vidid
  mat = str2mat(objs(:,1));
  for l = 1 : size(mat,1)
    if strcmp(mat(l,:),vidId)
      idx = l;
      break;
    end
  end
  
  
  for j =4 : size(objs,2)
    objectsList = [objectsList; objs(idx,j)];
  end
  
  %%%Store which video contains which object in objectList
  idxs{i,1} = [size(objectsList,1)-numObjs+1 size(objectsList,1) ]; 
  
end

objList = unique(objectsList);
objListGen = {};
for i = 1 : size(objList,1) 
  objListGen = [objListGen; objList{i}(3:end)];
end
objListGen = unique(objListGen);


%Create combs of objs then label them as the feature

numObjs = size(objList,1);

combs = {};
for i = 1: numObjs
  combs = [combs; combnk(1:numObjs,i)];
end

combs = {};
count = 0;

%feat All Obj Mult simply creates a feature for each of identified objects
%in the objList and depending on the data, each feature is populated with 1
%or 0 with whether the obj is present of not.
featAllObj = zeros(size(qsr,1),size(objList,1));
featAllObjGen = zeros(size(qsr,1),size(objListGen,1));

for i = 1 : numObjs
  count = count + 1;
  combs{count,1} = i;
  sizeCombs = size(combs,1)-1;
  for j=1 : sizeCombs
    comb = cat(2,combs{j},i);
    count = count + 1;
    combs{count,1} = comb;
  end
end

featListed = zeros(size(qsr,1),2);
for f = 1 : size(qsr,1)
  if idxs{f}(1) == idxs{f}(2)
    objs = objectsList([idxs{f}(1)]);
  else
    objs = objectsList([idxs{f}(1): idxs{f}(2)]);
  end
  
  %Num of Objects in video
  featListed(f,2) = size(objs,1);
  
  objIdx = [];
  objIdxGen = [];
  for i =1 : size(objs,1)
    objIdx(i) =  find(cellfun('length',regexp(objList,objs(i))) == 1);
    idx = find(cellfun('length',regexp(objListGen,objs{i}(3:end))) == 1);
    if size(idx,1) > 1
      for j =1 :size(idx,1)
        if size(objs{i}(3:end),2) == size(objListGen{idx(j)},2)
          objIdxGen(i) = idx(j);
          break;
        else
          disp('ERROR');
        end
      end
    else
      objIdxGen(i) = idx;
    end
    %%%Add to featAllObj which stores 1 or 0 depending on present or not
    featAllObj(f,objIdx(i)) = 1; %%% Need to aggregate 1:box , 2:box to just box with 2 counts
    featAllObjGen(f,objIdxGen(i)) = featAllObjGen(f,objIdxGen(i)) + 1; 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  end
  
  
  for i = 1 : size(combs,1)
    if isequal(sort(combs{i}), sort(objIdx))
      %the object types -> label
      featListed(f,1) = i;
      break;
    end
  end
  
end



end
