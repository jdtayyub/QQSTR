function [ points ] = getRecPoints( rec )
%GETBLOCKPOINTS Return 4 (x,y) points of the input rec from point,w,h
%               format
%
%   INPUT
%     rec - rec given in format (x,y,w,h)
%   OUTPUT
%     points - points returns as a 4x2 matrix in the format:
%              [x1 y1 ; x2 y2 ; x3 y3 ; x4 y4]

points = zeros(4,2);

points(1,:) = rec(1:2); % x
points(2,:) = [rec(1) + rec(3); rec(2)]; % x+w , y
points(3,:) = [rec(1) + rec(3); rec(2) + rec(4)]; % x+w, y+h
points(4,:) = [rec(1); rec(2) + rec(4)]; % x, y+h

end

