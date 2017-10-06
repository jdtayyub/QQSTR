function [ skel2D skel3D ] = parseSkeleton( path, frames )
%PARSESKELETON Pasrses the Cornell skeleton file
%   INPUT
%     path - path of the .txt file containing skeleton tracks
%     frames - number of frames for that video
%   OUTPUT
%     skel2D - a frameNumber x 30 matrix giving x,y positions of all 15
%              joints
%     skel3D - a frameNumber x 45 matrix giving x,y,z posiitons of all 15
%              joints

%Get Skeleton Matrix
skelData = dlmread(path, ',',[0 0 frames-1 170]); %Import everything into a matrix except last line which is an END
skel2D = [];
skel3D = [];

for i = 1 : size(skelData, 1)
  step = 12; %location of x pos in the file
  for j = 1 : 15
    x3D = skelData(i, step);
    y3D = skelData(i, step+1);
    z3D = skelData(i, step+2);
    skel3D(i, 3*j-2) = x3D;
    skel3D(i, 3*j-1) = y3D;
    skel3D(i, 3*j) = z3D;
    
    x2D = (156.8584456124928*2) + (0.0976862095248*3) * x3D - (0.0006444357104*3) * y3D + (0.0015715946682*3) * z3D;
    y2D = (125.5357201011431*2) + (0.0002153447766*3) * x3D - (0.1184874093530*3) * y3D - (0.0022134485957*3) * z3D;
    skel2D(i,2*j-1) = x2D;
    skel2D(i,2*j) = y2D;
    if(j < 11)
      step = step + 14; %location of x pos in the file
    else
      step = step + 4; %location of x pos in the file for last 4 joints as it doesnt have oritentation info.
    end
  end
  

end


end

