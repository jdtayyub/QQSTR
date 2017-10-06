function [ points ] = getCubePoints( cub )
%GETBLOCKPOINTS Return 8 (x,y) points of the centroid input cube from point,w,h,d
%               format
%
%   INPUT
%     rec - rec given in format (x,y,z,w,h,d)
%   OUTPUT
%     points - points returns as a 8x3 matrix in the format:
%              [x1 y1 z1 ; x2 y2 z2 ; x3 y3 z3 ; x4 y4 z4 ; x5 y5 z5 ; x6 y6 z6 ; x7 y7 z7 ; x8 y8 z8 ]

points = zeros(8,3);

x = cub(1); y = cub(2); z = cub(3); w = cub(4); h = cub(5); d = cub(6);


points(1,:) = [x - w/2  y - h/2  z - d/2]; 
points(2,:) = [x + w/2  y - h/2  z - d/2]; 
points(3,:) = [x + w/2  y + h/2  z - d/2]; 
points(4,:) = [x - w/2  y + h/2  z - d/2]; 

points(5,:) = [x - w/2  y - h/2  z + d/2]; 
points(6,:) = [x + w/2  y - h/2  z + d/2]; 
points(7,:) = [x + w/2  y + h/2  z + d/2]; 
points(8,:) = [x - w/2  y + h/2  z + d/2]; 


end

