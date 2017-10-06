function [ points ] = getBlockPoints( block )
%GETBLOCKPOINTS Return 8 (x,y,z) points of the input block from point,w,h,d
%               format
%
%   INPUT
%     block - block given in format (x,y,z,w,h,d)
%   OUTPUT
%     points - points returns as a 8x3 matrix in the format:
%              [x1 y1 z1; x2 y2 z2; x3 y3 z3; x4 y4 z4; x5 y5 z5; x6 y6 z6; x7 y7 z7; x8 y8 z8]

points = zeros(8,3);

points(1,:) = block(1:3); % x
points(2,:) = [block(1) + block(4); block(2) ; block(3)]; % x+w , y, z
points(3,:) = [block(1) + block(4); block(2) + block(5); block(3)]; % x+w, y+h, z
points(4,:) = [block(1); block(2) + block(5) ; block(3)]; % x, y+h, z

points(5,:) = [block(1); block(2) + block(5);  block(3) + block(6)]; % x, y+h, z+d
points(6,:) = [block(1) + block(4); block(2) + block(5); block(3) + block(6)]; % x+w, y+h, z+d
points(7,:) = [block(1) + block(4); block(2); block(3) + block(6)]; % x+w, y, z+d
points(8,:) = [block(1); block(2); block(3) + block(6)];% x, y, z+d


end

