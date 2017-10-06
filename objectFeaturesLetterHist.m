function [feature] = objectFeaturesLetterHist(qsr)
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
    objectsList = [objectsList; {objs{idx,j}(3:end)}];
  end
  
  %%%Store which video contains which object in objectList
  idxs{i,1} = [size(objectsList,1)-numObjs+1 size(objectsList,1) ];
  
end

objList = unique(objectsList);

%%%create letter histograms for each video
chars = ['A':'Z' 'a':'z'];
lettersHistBins = {};
for i = 1 : size(chars,2)
  lettersHistBins{i} = chars(i);
end
lettersHistCount = zeros(size(qsr,1),size(lettersHistBins,2));

for f = 1 : size(qsr,1)
  if idxs{f}(1) == idxs{f}(2)
    objs = objectsList([idxs{f}(1)]);
  else
    objs = objectsList([idxs{f}(1): idxs{f}(2)]);
  end
  
  for i = 1 : size(objs,1)%Go through all objects
    charObj = objs{i};
    for j = 1 : size(charObj,2)
      
      %Capitalization of first letter to improve discriminiability
%       if j == 1 
%         charObj(j) = upper(charObj(j));
%       end
      
      idx = find(ismember(lettersHistBins,charObj(j)));
      lettersHistCount(f,idx) = lettersHistCount(f,idx) + 1; 
    end
  end 
end
feature = lettersHistCount;

end