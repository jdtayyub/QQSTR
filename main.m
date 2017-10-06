function [ qsr ] = main( path, annotation )
%MAIN Main function to handle Cornell Dataset read
%   INPUT
%     path - RGB image path of the file
clear all;
MonitorPos = get(0,'MonitorPositions');
fig = figure('Position',MonitorPos(1,:));

path = '/usr/not-backed-up/CAD_120/CAD_120/RGBD_images/Subject1_rgbd_images/arranging_objects/0510175411';
skeleton = '/usr/not-backed-up/CAD_120/CAD_120/annotations/Subject1_annotations/arranging_objects/0510175411.txt';
objectTrack = '/usr/not-backed-up/CAD_120/CAD_120/annotations/Subject1_annotations/arranging_objects/0510175411_obj';

rcc = {'Disconnect', 'Parttially Overlap', 'Part Of'};
load('rawQSRDISTgt.mat');
%vid 32
qsr = qsr{32};
dist = distances{32};


%vid 32 TEMPORALs

tempo1 = {88 'DC:PO - Short'; 93 'PO:DC - Equal'; 100 'DC:PO - Long'; 121 'PO:DC - Long'};
tempo2 = {46 'DC:PO - Equal'; 118 'PO:P - Short'; 121 'P:PO - Long'; 179 'PO:DC - Equal'; 247 'DC:PO - Short'; 251 'PO:DC - Long'};
tempo3 = {121 'DC:PO - Equal'};

t1 = '';t2 = ''; t3 = '';

images = dir(path);

%Get all RGB only on Cornell
rgbImage = [];
for i = 3 : size(images,1)
  if(strcmp(images(i).name(1:3), 'RGB') == 1)
    rgbImage = [rgbImage; cellstr(images(i).name)];
  end
end

numFrames = size(rgbImage, 1);

%Get Skeleton
[skel2D skel3D] = parseSkeleton(skeleton, numFrames);




%Get object rectangles
count = 1;
rectangles = {};
while exist([objectTrack num2str(count) '.txt'])
  objData = dlmread([objectTrack num2str(count) '.txt']);
  rectangles = [rectangles ; objData(1:size(rgbImage, 1),3:6)];
  count = count + 1;
end
rectangles = interpolateObjectTracks(rectangles);

%get qsr for object relations passing in (right hand, left hand, object rectangle)
% qsr = getQSR(mbr([skel2D(:,23) skel2D(:,24)], 'hand'), mbr([skel2D(:,25) skel2D(:,26)], 'hand'), rectangles);


%Looping through all RGB images For Visualization
for i = 30 : size(rgbImage, 1)
  
  subaxis(1,2,1, 'Spacing', 0.003, 'Padding', 0, 'Margin', 0)
  
  im = imread([path , '/RGB_' , num2str(i) , '.png']);
  %   hold on;
  
  imshow(im);
  hold on;
  text(0,-10,['Frame:' num2str(i)]);
  text(200, -50, 'QUALITATIVE FEATURES');
  % draw skeleton points
  %   m(1)=plot(skel2D(i,1:2:29),skel2D(i,2:2:30),'r.','MarkerSize',10);
  %   n(1)=plot(skel2D(i,23:2:25),skel2D(i,24:2:26),'b.','MarkerSize',15); %draw hand points in blue
  
  % draw hands MBRs
  t(1) = rectangle('Position',mbr([skel2D(i,23) skel2D(i,24)], 'hand'));
  s(1) = rectangle('Position',mbr([skel2D(i,25) skel2D(i,26)], 'hand'));
  set(t,'edgecolor','r');
  set(s,'edgecolor','r');
  
  
  %show skel
  Pose2D =  reshape(skel2D(i,:),2,15)';
  x = scatter(Pose2D(:,1),Pose2D(:,2),'y');
  
  h(1) = plot(Pose2D([12 5 4 2 6 7 13],1),Pose2D([12 5 4 2 6 7 13],2),'g','LineWidth',3);
  h(2) = plot(Pose2D([1 2 3 10 11 ],1),Pose2D([1 2 3 10 11 ],2),'g','LineWidth',3);
  h(3) = plot(Pose2D([3 8 9 ],1),Pose2D([3 8 9 ],2),'g','LineWidth',3);
    
  % draw object MBRs
  for j = 1: size(rectangles, 1)
    p(j) = rectangle('Position',[rectangles{j}(i,1) rectangles{j}(i,2) abs(rectangles{j}(i,1)-rectangles{j}(i,3)) abs(rectangles{j}(i,2)-rectangles{j}(i,4))]);
  end
  
  %line between obj and hands
  midPx = rectangles{1}(i,1) + abs(rectangles{1}(i,1) - rectangles{1}(i,3))/2;
  midPy = rectangles{1}(i,2) + abs(rectangles{1}(i,2) - rectangles{1}(i,4))/2;
  h(4) = plot([Pose2D(12,1); midPx; Pose2D(13,1); Pose2D(12,1)] ,[Pose2D([12],2); midPy; Pose2D(13,2); Pose2D([12],2)],'r','LineWidth',2);

  
  
  %TEXT
  text(0,500,'ELEMENT PAIR'); text(200,500,'RCC RELATION');
  text(0,530,'HandR - HandL'); text(200,530,rcc(qsr(1,i+1)));
  text(0,560,'HandR - Object'); text(200,560,rcc(qsr(2,i+1)));
  text(0,590,'HandL - Object'); text(200,590,rcc(qsr(3,i+1)));
  
  
   text(400,500,'TEMPORAL RELATION');
   if(isempty(find(cell2mat(tempo1(:,1))==i+1))) && (isempty(t1))
    text(400,530,'-');
   else
     ind = find(cell2mat(tempo1(:,1))==i+1)
     if ~isempty(ind)
       text(400,530,tempo1(ind,2));
       t1 = tempo1(ind,2);
     else
       text(400,530,t1);
     end
   end
   
   if(isempty(find(cell2mat(tempo2(:,1))==i+1))) && (isempty(t2))
    text(400,560,'-');
   else
     ind = find(cell2mat(tempo2(:,1))==i+1)
     if ~isempty(ind)
       text(400,560,tempo2(ind,2));
       t2 = tempo2(ind,2);
     else
       text(400,560,t2);
     end
   end
   
   if(isempty(find(cell2mat(tempo3(:,1))==i+1))) && (isempty(t3))
    text(400,590,'-');
   else
     ind = find(cell2mat(tempo3(:,1))==i+1)
     if ~isempty(ind)
       text(400,590,tempo3(ind,2));
       t3 = tempo3(ind,2);
     else
       text(400,590,t3);
     end
   end
  
  
  
  hold off;
  
  subaxis(1,2,2, 'Spacing', 0.003, 'Padding', 0, 'Margin', 0)
  
    im = imread([path , '/RGB_' , num2str(i) , '.png']);
  %   hold on;
  
  imshow(im);
  hold on;
  text(0,-10,['Frame:' num2str(i)]);
  text(200, -50, 'QUANTITATIVE FEATURES');
  % draw skeleton points
  %   m(1)=plot(skel2D(i,1:2:29),skel2D(i,2:2:30),'r.','MarkerSize',10);
  %   n(1)=plot(skel2D(i,23:2:25),skel2D(i,24:2:26),'b.','MarkerSize',15); %draw hand points in blue
  
  % draw hands MBRs
  u(1) = rectangle('Position',mbr([skel2D(i,23) skel2D(i,24)], 'hand'));
  v(1) = rectangle('Position',mbr([skel2D(i,25) skel2D(i,26)], 'hand'));
  set(u,'edgecolor','r');
  set(v,'edgecolor','r');
  
  
  %show skel
  Pose2D =  reshape(skel2D(i,:),2,15)';
  y = scatter(Pose2D(:,1),Pose2D(:,2),'y');
  
  l(1) = plot(Pose2D([12 5 4 2 6 7 13],1),Pose2D([12 5 4 2 6 7 13],2),'g','LineWidth',3);
  l(2) = plot(Pose2D([1 2 3 10 11 ],1),Pose2D([1 2 3 10 11 ],2),'g','LineWidth',3);
  l(3) = plot(Pose2D([3 8 9 ],1),Pose2D([3 8 9 ],2),'g','LineWidth',3);
  
  
  
  % draw object MBRs
  for j = 1: size(rectangles, 1)
    w(j) = rectangle('Position',[rectangles{j}(i,1) rectangles{j}(i,2) abs(rectangles{j}(i,1)-rectangles{j}(i,3)) abs(rectangles{j}(i,2)-rectangles{j}(i,4))]);
  end
 
  
  
  %line between obj and hands
  midPx = rectangles{1}(i,1) + abs(rectangles{1}(i,1) - rectangles{1}(i,3))/2;
  midPy = rectangles{1}(i,2) + abs(rectangles{1}(i,2) - rectangles{1}(i,4))/2;
  
  l(4) = plot([Pose2D([12 4 12 1 12 6 12 7 12 13 12],1) ;midPx] ,[Pose2D([12 4 12 1 12 6 12 7 12 13 12],2);midPy],'r','LineWidth',2);
   l(5) = plot([Pose2D([12 4 1 4 6 4 7 4 13 4],1) ;midPx] ,[Pose2D([12 4 1 4 6 4 7 4 13  4],2);midPy],'r','LineWidth',2);
   l(6) = plot([Pose2D([12 1 5 1 2 1 6 1 13 1],1) ;midPx] ,[Pose2D([12 1 5 1 2 1 6 1 13 1],2);midPy],'r','LineWidth',2);
    l(7) = plot([Pose2D([12 2 5 2 13 2],1) ;midPx] ,[Pose2D([12 2 5 2 13 2],2);midPy],'r','LineWidth',2);
        l(8) = plot([Pose2D([13 5 13 2 13],1) ;midPx] ,[Pose2D([13 5 13 2 13],2);midPy],'r','LineWidth',2);
  
        
        text(0,500,'ELEMENT PAIR'); text(200,500,'EUCLIDEAN DISTANCES');
  text(0,530,'HandR - HandL'); text(200,530,num2str(dist(43,i+1)));
  text(0,560,'HandR - Object'); text(200,560,num2str(dist(45,i+1)));
  text(0,590,'HandL - Object'); text(200,590,num2str(dist(44,i+1)));
  text(0,620,'HandL - ShoulderR'); text(200,620,num2str(dist(33,i+1)));
  text(0,650,'HandL - Head'); text(200,650,num2str(dist(7,i+1)));
  text(0,680,'...');
        
        
        
   
   hold off;
  
  waitforbuttonpress;
  
  %write text 
    %TEXT
  
  print(fig, '-r200', '-djpeg90', ['/home/cserv1_a/soc_msc/sc12jbmt/Documents/CAD120AR/3D/Images2/' num2str(i) '.jpg'])
  
  delete(u);delete(v);delete(y);delete(l);delete(w);%delete(m);delete(n);
  
  
  
  
  
end


end

%-265.2,445.3,1771.2