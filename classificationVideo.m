function [ output_args ] = classificationVideo( input_args )
close all
impath = '/usr/not-backed-up/CAD_120/CAD_120/RGBD_images';

load('QSR&Labels.mat');
load('predictions95.mat');


MonitorPos = get(0,'MonitorPositions');
fig = figure('Position',MonitorPos(1,:));


 %Print Labels
  labels = unique(labels);
  for i = 1: size(labels,1)
    ind = find(labels{i}=='_');
    p1 = labels{i}(1:ind-1);
    p2 = labels{i}(ind+1:end);
    labels{i} = [p1 '\_' p2];
  end
%Arrange predictions in the same form as the subplots
% predictions = p;
% ps = zeros(10,12);
% for a = 1: 10
%   ps(a,:) = [p(a,a+1,a+2) p(a,a+1,a+2) p(a,a+1,a+2) p(a,a+1,a+2)];
% end

rImage = zeros(480,640,3);
rImage(:,:,1) = 255;

gImage = zeros(480,640,3);
gImage(:,:,2) = 255;


falsePosInd = [99;32;81;115;22;24];
%Get Max Frame Size
maxFrame = 0;
for i = 1 : size(qsr,1)
  maxFrame = max(size(qsr{i},2),maxFrame);
end

axis off;
% figure('position',[0 0 2000 1000]);
countImSav = 1;
for frame = 1 : 10:  maxFrame+10

  count = 1;
  subjects = dir(impath);
  %   for s = 3: length(subjects)
  %     activities = dir([impath '/' subjects(s).name]);
  activities = dir([impath '/' subjects(4).name]);
  for a = 3: length(activities)
    for s = 4: length(subjects)
      instances = dir([impath '/' subjects(s).name '/' activities(a).name]);
      for in = 3: 5
        images = dir([impath '/' subjects(s).name '/' activities(a).name '/' instances(in).name '/*.png']);
        
        %Get RGB only on Cornell
        image = [impath '/' subjects(s).name '/' activities(a).name '/' instances(in).name '/RGB_' num2str(frame) '.png' ];
        
        if(exist(image))
          %             subplot(10,12,count);
          
          subaxis(10,12,count, 'Spacing', 0.003, 'Padding', 0, 'Margin', 0,'MarginLeft',0.1, 'MarginTop', 0.05);
          
          imshow(image);
          count = count + 1;
        else
          image = [impath '/' subjects(s).name '/' activities(a).name '/' instances(in).name '/RGB_' num2str(size(images,1)/2) '.png' ];
          image = imread(image);
          if (isempty(find(falsePosInd == count)))
            image(:,:,1) = 0;
            image(:,:,3) = 0;
            subaxis(10,12,count, 'Spacing', 0.003, 'Padding', 0, 'Margin', 0,'MarginLeft',0.1, 'MarginTop', 0.05);
            imshow(image);
%             hold on
%             imshow(imread('tick.png')); %green
            
          else
            image(:,:,2) = 0;
            image(:,:,3) = 0;
            subaxis(10,12,count, 'Spacing', 0.003, 'Padding', 0, 'Margin', 0,'MarginLeft',0.1, 'MarginTop', 0.05);
            imshow(image);
%             imshow(imread('cross.png')); %red
          end
          count = count + 1;
        end
        
        
      end
    end
  end
  %   end
  
  
 
  
  
%   pos = -4300;
%   for lab = 1: size(labels,1)
%     text(-9300,pos, labels{lab},'FontSize',15);
%     pos = pos + 500;
%   end
  
  %draw Seperation Lines
%   annotation(fig,'line',[0.324147721944329 0.324147721944329], [0.994121413411985 0.00201207243460777],'LineWidth',4);
%   annotation(fig,'line',[0.549617450545557 0.549617450545557], [0.994121413411985 0.00201207243460777],'LineWidth',4);
%   annotation(fig,'line',[0.77560909981484 0.77560909981484], [0.994121413411985 0.00201207243460777],'LineWidth',4);
  
  %SUBJECT LABELS
%   text(-7500,-4550,'Subject 1','FontSize',18)
%   text(-5200,-4550,'Subject 2','FontSize',18)
%   text(-2900,-4550,'Subject 3','FontSize',18)
%   text(-700,-4550,'Subject 4','FontSize',18)
%   

  pause(.1)
%   export_fig(['/home/cserv1_a/soc_msc/sc12jbmt/Documents/CAD120AR/3D/Images/' num2str(countImSav) '.tif'])
%   export_fig(['/home/cserv1_a/soc_msc/sc12jbmt/Documents/CAD120AR/3D/Images/' num2str(countImSav) '.png'])
%   imwrite(f,['/home/cserv1_a/soc_msc/sc12jbmt/Documents/CAD120AR/3D/Images/' num2str(countImSav) '.png'],'XResolution',1920,'YResolution',1080)
%   print(fig, '-r300', '-dpng', ['/home/cserv1_a/soc_msc/sc12jbmt/Documents/CAD120AR/3D/Images/' num2str(countImSav) '.png'])
  print(fig, '-r200', '-djpeg90', ['/home/cserv1_a/soc_msc/sc12jbmt/Documents/CAD120AR/3D/Images/' num2str(countImSav) '.jpg'])
  countImSav = countImSav+1;
end


end

