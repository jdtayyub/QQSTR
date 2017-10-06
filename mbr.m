function [ mbr ] = mbr( point, bp )
%MBR Returns minimum bounding rectangle coords for various body parts given
%    point of center from skeletal data
%   INPUT
%    point- x,y coord of the body part
%    bp- body part - {hand, head}
%   OUTPUT
%    mbr - x,y,w,h of bounding rectangle

switch bp
  case 'hand'
    recSize = 40;
  case 'head'
    recSize = 60;
end


mbr = [point(:,1)-recSize/2, point(:,2)-recSize/2];
mbr(:,3) = recSize; 
mbr(:,4) = recSize;

end

