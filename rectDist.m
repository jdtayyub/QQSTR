function [ dist ] = rectDist( rec1, rec2 )
%RECTDIST Calculates the distance between the obvious two nearest edges of
%         two rectangles
%   INPUT
%     rec1 - rec1 in terms of x,y,w,h
%     rec2 - rec2 in terms of x,y,w,h
%   OUTPUT
%     dist - distance between edges of rec1 and rec2

p1 = getRecPoints(rec1);
p2 = getRecPoints(rec2);

xRec1 = [p1(1) p1(3)]; 
yRec1 = [p1(2) p1(4)]; 


xRec2 = [p2(1) p2(3)]; 
yRec2 = [p2(1) p2(3)];

distX = [xRec1 - xRec2(1) ; xRec1 - xRec2(2)];
distY = [yRec1 - yRec2(1) ; yRec1 - yRec2(2)];

end

