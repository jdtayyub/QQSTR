function [ mbr ] = mbr3d( point, bp )
%MBR Returns minimum bounding cubic coords for various body parts given
%    point of center from skeletal data
%   INPUT
%    point- x,y,z coord of the body part
%    bp- body part - {hand, head}
%   OUTPUT
%    mbr - x,y,z,w,h,d of bounding rectangle

switch bp
  case 'hand'
    cubeSize = 150;
  case 'head'
    cubeSize = 200;
end

% ALL DIM
mbr = [point(:,1), point(:,2), point(:,3)];
mbr(:,4) = cubeSize; 
mbr(:,5) = cubeSize;
mbr(:,6) = cubeSize;

% JUST X Y W H
% mbr = [point(:,1), point(:,2)];
% mbr(:,4) = cubeSize; 
% mbr(:,5) = cubeSize;


end

