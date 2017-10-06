function [ output_args ] = displayEverything3D( input_args )

close all

path = '/usr/not-backed-up/CAD_120/CAD_120/RGBD_images/Subject1_rgbd_images/making_cereal/1204142055';
skeleton = '/usr/not-backed-up/CAD_120/CAD_120/annotations/Subject1_annotations/making_cereal/1204142055.txt';
objectTrack = '/usr/not-backed-up/CAD_120/CAD_120/annotations/Subject1_annotations/making_cereal/1204142055_obj';
autoObjectTrack = '/home/cserv1_a/soc_msc/sc12jbmt/Documents/CAD120AR/3D/3D Tests/objectTracks/subject1-making_cereal-1204142055.csv';

autoOT = csvread(autoObjectTrack);

images = dir(path);


MonitorPos = get(0,'MonitorPositions');
figure('Position',MonitorPos(1,:));

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

xD =1:3:45;
yD =2:3:45;
zD =3:3:45;

xmax = max(max(skel3D(:,xD)));
xmin = min(min(skel3D(:,xD)));

ymax = max(max(skel3D(:,yD)));
ymin = min(min(skel3D(:,yD)));

zmax = max(max(skel3D(:,zD)));
zmin = min(min(skel3D(:,zD)));

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
for i = 1 : size(rgbImage, 1)
  im = imread([path , '/RGB_' , num2str(i) , '.png']);
  %   hold on;
  
  subplot(1,2,2);
  imshow(im);
  
  
  text(0,-10,['Frame:' num2str(i)]);
  % draw skeleton points
  %   m(1)=plot(skel2D(i,1:2:29),skel2D(i,2:2:30),'r.','MarkerSize',10);
  %   n(1)=plot(skel2D(i,23:2:25),skel2D(i,24:2:26),'b.','MarkerSize',15); %draw hand points in blue
  
  % draw hands MBRs
  t(1) = rectangle('Position',mbr([skel2D(i,23) skel2D(i,24)], 'hand'));
  s(1) = rectangle('Position',mbr([skel2D(i,25) skel2D(i,26)], 'hand'));
  set(t,'edgecolor','r');
  set(s,'edgecolor','r');
  
  
  % draw object MBRs
  for j = 1: size(rectangles, 1)
    p(j) = rectangle('Position',[rectangles{j}(i,1) rectangles{j}(i,2) abs(rectangles{j}(i,1)-rectangles{j}(i,3)) abs(rectangles{j}(i,2)-rectangles{j}(i,4))]);
  end
  %   hold off;
  
  
  
  
  
  %%%%%%%%%%3d%%%%%%%%%%%%
  subplot(1,2,1);
  
  Pose3D =  reshape(skel3D(i,:),3,15)';
  scatter3(Pose3D(:,1),Pose3D(:,2),Pose3D(:,3))
  hold on
  h(1) = plot3(Pose3D([2 4 6],1),Pose3D([2 4 6],2),Pose3D([2 4 6],3),'b');
  h(2) = plot3(Pose3D([6 7 13],1),Pose3D([6 7 13],2),Pose3D([6 7 13],3),'g');
  h(3) = plot3(Pose3D([4 5 12],1),Pose3D([4 5 12],2),Pose3D([4 5 12],3),'r');
  
  %%%Plot Object%%%%%%%%%%
  h(4) = scatter3(autoOT(i,1),autoOT(i,2),autoOT(i,3),'m');
  h(5) = drawCuboid(autoOT(i,1:6));
  h(6) = drawCuboid(autoOT(i,7:12));
  h(7) = drawCuboid(autoOT(i,13:18));
  
  axis equal;
  xlabel('x');ylabel('y');zlabel('z')
  axis([xmin xmax ymin ymax zmin zmax+1000])
  az = 0;el = 90;view(az, el);
  
  pause(0.04);
  delete(t);delete(s);delete(p);delete(h);%delete(m);delete(n);
  hold off
end


end

%-265.2,445.3,1771.2