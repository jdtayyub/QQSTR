function [ output_args ] = displaySkeleton( dimension )
%DISPLAYSKELETON Summary of this function goes here
%   Detailed explanation goes here

if(dimension == 2) 
  plot(skel2D(i,1:2:29),skel2D(i,2:2:30),'r.','MarkerSize',10)
  plot(skel2D(i,23),skel2D(i,24),'b.','MarkerSize',10)
else
  plot3(skel3D(i,1:3:43),skel3D(i,2:3:44),skel3D(i,3:3:45),'r.','MarkerSize',10);
end

end

